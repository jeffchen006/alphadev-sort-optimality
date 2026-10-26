"""Record completed round-3 observations without treating limits as negatives."""
import json
from pathlib import Path
import re

jobs = []
for path in sorted(Path('round3/artifacts').glob('*.json')):
    obj = json.loads(path.read_text())
    if not isinstance(obj,dict) or 'command' not in obj:
        continue
    row = dict(obj)
    row['name'] = path.stem
    lines = Path(row['log']).read_text().splitlines()
    statuses = []
    for line in lines:
        try:
            entry = json.loads(line)
        except (ValueError,TypeError):
            continue
        if isinstance(entry,dict) and 'status' in entry:
            statuses.append(entry)
    row['solver_status'] = statuses[-1] if statuses else None
    if row['exit'] == 124:
        row['result'] = 'UNKNOWN (wall limit)'
    elif row['solver_status']:
        row['result'] = row['solver_status']['status']
    else:
        row['result'] = 'completed' if row['exit'] == 0 else f'exit {row["exit"]}'
    jobs.append(row)

inventory = json.loads(Path('round3/artifacts/zero_mov_inventory.json').read_text())
audit = json.loads(Path('round3/artifacts/mined_judge_ledger.json').read_text())
assert len(audit) == 6 and all(r['out_pass'] and r['mem_pass'] for r in audit)
deletions = []
for row in audit:
    source = Path(row['source'])
    candidates = []
    for p in Path('round3/candidates').glob(source.stem+'_del*.s'):
        header = p.read_text().splitlines()[0]
        fail = int(re.search(r'weak_fail=(\d+)',header)[1])
        error = int(re.search(r'weak_error_sum=(\d+)',header)[1])
        candidates.append((error,fail,str(p)))
    assert len(candidates) == 24
    error,fail,path = min(candidates)
    deletions.append({'source':str(source),'tried':len(candidates),
                      'best_error_sum':error,'best_failed_orders':fail,'best_file':path})

nearlog = Path('round3/logs/near14_scoreone.log').read_text()
neighbours = [{'index':int(n),'error_sum':int(e),'failed_orders':int(f),'file':p}
              for n,e,f,p in re.findall(r'NEIGHBOUR index=(\d+) error=(\d+) fail=(\d+) hash=\w+ file=(\S+)',nearlog)]
two = Path('round3/logs/near14_two.log').read_text()
assert 'tried=65593152' in two and 'hit=0' in two
assert not Path('round3/artifacts/FOUND_PENDING').exists(), 'Validate and report FOUND first'
summary = {'inventory':inventory,'deletions':deletions,'neighbours':neighbours,
           'jobs':jobs,'strict_ledger':audit}
Path('round3/artifacts/final_summary.json').write_text(json.dumps(summary,indent=2))

report = ['', '## Round 3 completion', '',
          'No strict PASS with k <= 31 was found. The best correct core remains k=32. Its memory version has 42 instructions.', '',
          'The saved-program scan read 12,669 assembly files. It found seven files with k=32 and no core mov. Input and scratch renaming reduced them to six instruction sequences. These counts concern saved assembly files. The scan did not read the large raw text collections. All six retained sequences passed the strict out and memory judges.', '',
          'The comparison analyzer maps the six sequences to three known fingerprints: 215cbe6f0d1c7837, 23f00ca3e09530d3, and de052e5a1c75d83. The last two fingerprints were already in the round-1 collection. Their retained round-1 representatives used mov. The mined sequences show implementations with no mov for those structures. No new comparison structure is claimed. Log: [round3/logs/analyze_nomov.log](round3/logs/analyze_nomov.log).', '',
          'Deleting each of the 24 conditional moves in each retained sequence gave 144 failing k=31 programs in the independent evaluator. The best deletion fails 27 weak orders and has an output-error sum of 45. The strict judge also rejects that deletion. Log: [round3/logs/nomov_4c02da04dce39b74_del27_out_judge.log](round3/logs/nomov_4c02da04dce39b74_del27_out_judge.log).', '',
          '| Core with no mov | Deletions | Best output-error sum | Failed weak orders for that deletion |',
          '|---|---:|---:|---:|']
for row in deletions:
    report.append(f'| [{Path(row["source"]).name}]({row["source"]}) | 24 | {row["best_error_sum"]} | {row["best_failed_orders"]} |')
report += ['', 'The near-miss scan tested 11,736 single-instruction replacements. It retained seven operand-column fingerprints with output-error sums at most 60. A fingerprint is a 64-bit search identifier. It is not a proof of structural equivalence. The best still fails 14 weak orders. The two-instruction scan tested 65,593,152 replacements. Of these, 1,294 passed the 32-entry case filter. None passed all 541 weak orders in the conservative evaluator. The smallest output-error sum remained 18. Logs: [one change](round3/logs/near14_scoreone.log), [two changes](round3/logs/near14_two.log).', '',
          'The replacement alphabet contains mov, cmp, and all four supported conditional moves. It contains every distinct source/destination pair over the used registers and one fresh scratch register. Comparison counts stay between seven and eight. The two-change scan changes two different instruction positions. These are bounded search observations. The conservative evaluator can reject a valid program when it loses a relation between scratch values.', '',
          'The rank-value encoder reduced the first six-change query from 29,648 variables and 202,297 clauses to 7,086 variables and 61,580 clauses. The two encoders agreed on 12 fixed-program controls. Four symbolic controls also matched their concrete executions on their 11 encoded cases. The fixed k=32 control passed the strict judge. The fixed 14-case failure returned UNSAT. These checks validate tested behavior. They do not establish an encoder correctness proof.', '',
          '| Solver job | Result | Wall seconds | Log |',
          '|---|---|---:|---|']
report[-3:-3] = ['', 'A separate analysis identifies the near miss\'s failure path. Let a and b be the sorted values from input cells P0 and P4. Let c, d, and e be the sorted values from input cells P1, P2, and P3. The independent check finds exactly these failures: a < c, b > e, and original P2 > c. Eight failing orders have distinct inputs. Six have ties. The merge needs a copy of c in P2 on this path. The prefix instead retains original P2. The case list is [round3/artifacts/near14_analysis.json](round3/artifacts/near14_analysis.json).', '',
    'This analysis led to a new prefix query. It seeks an 11-instruction triple sort with two minimum copies, one middle value, and one maximum value. The first query keeps the original three comparison positions and result registers. It returned UNSAT in 3.92 seconds with five registers. The broader queries allow all instruction classes and result registers. They permit three or four comparisons. All 13 weak orders of three inputs are encoded. The 12-instruction control returned SAT. These results apply only to the stated register bounds and encoding.', '']
for row in jobs:
    if not any('satrep.py' in arg or 'source_slots_sat.py' in arg or
               'triple_copy.py' in arg or 'triple_free.py' in arg for arg in row['command']):
        continue
    report.append(f'| {row["name"]} | {row["result"]} | {row["seconds"]:.2f} | [log]({row["log"]}) |')
report += ['', 'UNSAT applies only to the stated register bound, instruction positions, edit bound, and encoded initial state. The source queries keep write destinations fixed. Their one internal no-op chooses the deleted instruction. The edit count includes that deletion. The typed queries keep comparison positions fixed. The full queries can also change instruction classes and destinations. Queries marked UNKNOWN reached their wall limit. They give no exclusion.', '',
          'The rank queries also test a fresh scratch register, a free 16-instruction suffix, and repairs of the 27-order deletion failure. Most repair queries require a syntactic change to at least one comparison. The 16-instruction suffix keeps the first 15 instructions fixed and has no edit bound. Comparison positions remain fixed in that query. Three further queries keep the output positions fixed. One of those queries permits up to nine comparisons.', '',
          'All bounded jobs used nice level 19. At most two search or compiler jobs ran together. A 0.20-second analysis check briefly overlapped two searches. The process tree remained pinned to two cores. Each bounded job had an address-space limit of 2,800 MiB. No fixed-structure routing was rerun. The full job arguments and limits are in [round3/artifacts/final_summary.json](round3/artifacts/final_summary.json).', '',
          'Every new strict PASS file and byte-identical retained copy:', '',
          '| Tested out file | Retained out copy | Strict memory file | Judge logs |',
          '|---|---|---|---|']
unionlog = Path('round3/logs/union31.log')
if unionlog.exists():
    lines = unionlog.read_text().splitlines()
    summaries = [line for line in lines if line.startswith('SUMMARY ')]
    assert summaries, 'The final stochastic run did not finish'
    summary['union_search'] = dict(re.findall(r'(\w+)=([^ ]+)',summaries[-1]))
    Path('round3/artifacts/final_summary.json').write_text(json.dumps(summary,indent=2))
    report[-4:-4] = ['', 'The final stochastic run scores the union of failed weak orders. It breaks equal output-error counts by overlap between failing cases. It permits seven to nine comparisons. It uses all 541 weak orders, and its register bound includes one fresh scratch register. Its completed counters are `'+summaries[-1]+'`. Log: [round3/logs/union31.log](round3/logs/union31.log). This is a search observation, not an exclusion.', '']
for row in audit:
    report.append(f'| [out]({row["source"]}) | [{Path(row["retained"]).name}]({row["retained"]}) | [mem]({row["memory"]}) | [out]({row["out_log"]}), [mem]({row["mem_log"]}) |')
report += ['', 'The two additional strict out controls are [control32.s](round3/candidates/control32.s) ([judge log](round3/logs/control32_judge.log)) and [rank_control32.s](round3/candidates/rank_control32.s) ([judge log](round3/logs/rank_control32_judge.log)). Each has k=32. None of the PASS files meets the requested length.', '']
controls = json.loads(Path('round3/artifacts/duplicate_min_control_ledger.json').read_text())
assert all(row['pass'] for row in controls)
summary['duplicate_min_control'] = controls
summary['near_miss_analysis'] = json.loads(Path('round3/artifacts/near14_analysis.json').read_text())
summary['bounded_jobs'] = len(jobs)
summary['solver_queries'] = sum(any('satrep.py' in arg or 'source_slots_sat.py' in arg or
    'triple_copy.py' in arg or 'triple_free.py' in arg for arg in row['command']) for row in jobs)
Path('round3/artifacts/final_summary.json').write_text(json.dumps(summary,indent=2))
report += ['The duplicate-minimum repair also passed at k=32. It inserts `mov P2, P1` before the merge. The [out control](round3/verified/duplicate_min_control32.s) and [memory control](round3/verified_mem/duplicate_min_control32.s) passed their strict judges. Logs: [out](round3/logs/duplicate_min_control32_out_judge.log), [mem](round3/logs/duplicate_min_control32_mem_judge.log). This confirms the tested repair with one extra instruction. It does not meet the target.', '']
with Path('RESULTS.md').open('a') as f:
    f.write('\n'.join(report))
print(json.dumps({'strict_out_and_mem':len(audit),'deletions':144,
                  'bounded_jobs':len(jobs),'solver_queries':summary['solver_queries']}),flush=True)
