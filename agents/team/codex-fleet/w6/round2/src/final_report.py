"""Append completed round-2 observations and the strict PASS ledger."""
from collections import Counter
import hashlib
import json
from pathlib import Path
import re

def summary(name):
    lines = [s for s in Path(f'round2/logs/{name}.log').read_text().splitlines()
             if s.startswith('SUMMARY ')]
    assert lines, name
    return dict(re.findall(r'(\w+)=([^ ]+)', lines[-1]))

searches = {name: summary(name) for name in ('n32a', 'b31a', 'n32b', 'f31a', 'e31a')}
assert all(row['best'] in ('32', '999') for row in searches.values())
repairs = json.loads(Path('round2/artifacts/repair_batch.json').read_text())
assert len(repairs) == 43
assert all('COMPLETE_NO_HIT' in row['summary'][0] for row in repairs)
repair_counts = {}
for mode in (0, 1):
    rows = [row for row in repairs if row['mode'] == mode]
    totals = Counter()
    for row in rows:
        totals.update({k: int(v) for k, v in re.findall(r'(tried|filtered|groups)=(\d+)', row['summary'][0])})
    if mode == 0:
        totals['tried'] += 147883008
        totals['groups'] += 14812
    repair_counts[mode] = dict(totals)

memory = json.loads(Path('round2/artifacts/memory_judges.json').read_text())
files = sorted(Path('round2/verified').glob('*.s'))
assert len(memory) == len(files)
assert all(row['pass'] for row in memory)
ledger = []
groups = Counter()
for row in memory:
    source, mem = Path(row['source']), Path(row['path'])
    out_log = Path('round2/logs')/(source.stem+'_judge.log')
    tested = re.search(r'^PASS (\S+)', out_log.read_text()).group(1)
    assert source.read_bytes() == Path(tested).read_bytes()
    assert hashlib.sha256(source.read_bytes()).hexdigest() == row['out_sha256']
    assert hashlib.sha256(mem.read_bytes()).hexdigest() == row['mem_sha256']
    assert 'PASS ' in Path(row['log']).read_text()
    ops = Counter(s.split()[0] for s in source.read_text().splitlines()
                  if s and not s.startswith(('#', 'out')))
    assert sum(ops.values()) == 32 and ops['cmp'] == 8
    groups[ops['mov']] += 1
    ledger.append({**row, 'tested_out': tested, 'out_judge_log': str(out_log),
                   'mov': ops['mov'], 'cmov': 24-ops['mov']})
Path('round2/artifacts/final_verified_ledger.json').write_text(json.dumps(ledger, indent=2))
selected = json.loads(Path('round2/artifacts/selected_routing.json').read_text())
assert len(selected) == 6
assert not any(row.get('strict_out_pass') for row in selected)
assert all('FOUND' not in result for row in selected for result in row['result'])
Path('round2/artifacts/final_summary.json').write_text(json.dumps({
    'searches': searches, 'repair_counts': repair_counts,
    'new_verified_structures': len(files), 'mov_distribution': dict(groups),
    'selected_routing': selected}, indent=2))

report = ['', '## Round 2 completion', '',
          'No strict PASS with core k <= 31 was found. The best correct core remains k=32. Its memory form has 42 instructions.', '',
          f'This round added **{len(files)}** comparison-operand fingerprints. Together with the 18 original fingerprints, the retained collection has **{len(files)+18}** representatives. Every new representative passed the strict out and memory judges. Each uses eight comparisons. These fingerprints also distinguish comparison order. They do not establish that the representatives are different sorting algorithms.', '',
          '| Core mov instructions | New representatives | Core conditional moves |',
          '|---:|---:|---:|']
for mov, count in sorted(groups.items()):
    report.append(f'| {mov} | {count} | {24-mov} |')
report += ['', 'The new core with no mov instruction is [round2/verified/c8_215cbe6f0d1c7837.s](round2/verified/c8_215cbe6f0d1c7837.s). It has eight comparisons and 24 conditional moves. Its [memory form](round2/verified_mem/c8_215cbe6f0d1c7837.s) adds five loads and five stores. Both strict judge logs report PASS. It does not meet the requested 41-instruction total.', '',
           '| Search | Proposals | Accepted | Correct visits | Best k | CPU seconds |',
           '|---|---:|---:|---:|---:|---:|']
for name, row in searches.items():
    best = 'none' if row['best'] == '999' else row['best']
    report.append(f'| {name} | {int(row["iterations"]):,} | {int(row["accepted"]):,} | {int(row["correct_visits"]):,} | {best} | {float(row["cpu"]):.1f} |')
report += ['', 'Search proposals include early rejections. Correct visits can repeat. n32b changes comparison groups together and uses input-renaming-normalized visit costs. f31a scores all 541 weak orders and retains better failing seeds. e31a also adds a search cost of 20 to the two prior near-miss comparison signatures. This cost is a search heuristic. It is not a program restriction or a correctness check.', '',
           'The best retained k=31 failure is [round2/candidates/near14_frozen.s](round2/candidates/near14_frozen.s). The independent simulator reports 14 failed weak orders and an output-error sum of 18. The strict judge reports FAIL. For input `[0,1,2,1,3]`, the program returns `[0,1,2,2,3]` instead of `[0,1,1,2,3]`. See [the judge log](round2/logs/near14_frozen_judge.log).', '',
           'The comparison structure of this 14-case failure differs from the 30-case failure. Both distinguish all 120 strict input orders. Routing completed with NONE at K=31 for the 30-case structure after 24,102,570 calls and for the 14-case structure after 24,478,546 calls. These results concern those fixed value structures only.', '',
           'The 14-case condition-only query kept every source and destination fixed. It allowed all conditional-move conditions to change. It returned UNSAT on its 16 encoded cases in 0.35 seconds. The 30-case source repair, with at most three changes and fixed write destinations, returned UNSAT in 4.60 seconds. The separate unrestricted three-instruction repair had a 90-second cap and produced no final solver status. No exclusion is claimed for that incomplete query.', '',
           '| Completed repair pattern | Representatives | Enumerated candidates | Passed case filter |',
           '|---|---:|---:|---:|']
for mode in (0, 1):
    label = 'Delete + two cmp operand changes + one cmov change' if mode == 0 else 'Delete + one cmp change + two write-source changes'
    report.append(f'| {label} | 22 | {repair_counts[mode]["tried"]:,} | {repair_counts[mode]["filtered"]:,} |')
report += ['', 'The repair counts concern the stated register alphabet and edit patterns. One fresh scratch register is available. The filter uses 32 weak orders. Its conservative handling of unknown scratch values can reject valid programs. Thus these counts are observations from a bounded search, not a general impossibility result.', '',
           'The final selected routing runs were:', '']
for row in selected:
    status = row['result'][0] if row['result'] else f'No final status; process exit {row["returncode"]}'
    report.append(f'- `{Path(row["source"]).name}`: `{status}`. [Log]({row["log"]}).')
report += ['', 'A node LIMIT or a wall-time limit is incomplete. No negative result is claimed for those runs. The completed zero-mov routing run returned NONE at K=31 after 32,930,695 calls. No old round-1 structure was rerouted in this round.', '',
           'All searches and compiler jobs used nice level 19. At most two CPU jobs ran at once. The repair dispatcher ran its added near-miss jobs in sequence. It did not add a third CPU job. All writes stayed inside w6.', '',
           'The final ledger records hashes, counts, and judge logs: [round2/artifacts/final_verified_ledger.json](round2/artifacts/final_verified_ledger.json). Retained out files are byte-identical to their tested out sources. The complete search summary is [round2/artifacts/final_summary.json](round2/artifacts/final_summary.json).', '',
           '### Every new strict PASS file and retained copy', '',
           'The two solver controls also passed: [source_control32.s](round2/candidates/source_control32.s), [log](round2/logs/source_control_judge.log); [slots_control32.s](round2/candidates/slots_control32.s), [log](round2/logs/slots_control32_judge.log).', '',
           '| Retained out copy | Tested out file | Memory file | Judge logs |',
           '|---|---|---|---|']
for row in ledger:
    name = Path(row['source']).stem
    report.append(f'| [{name}]({row["source"]}) | [out]({row["tested_out"]}) | [mem]({row["path"]}) | [out]({row["out_judge_log"]}), [mem]({row["log"]}) |')
with Path('RESULTS.md').open('a') as output:
    output.write('\n'.join(report)+'\n')
print(json.dumps({'new_strict_out_and_mem': len(ledger), 'mov_distribution': dict(groups),
                  'repair_counts': repair_counts}, indent=2))
