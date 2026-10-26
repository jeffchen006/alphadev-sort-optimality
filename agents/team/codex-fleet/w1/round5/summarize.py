"""Write a measured round 5 ledger. Append its report once on request."""
import argparse
import hashlib
import json
from pathlib import Path
import re

HERE=Path(__file__).resolve().parent
WORK=HERE.parent


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--append',action='store_true')
    args=ap.parse_args()
    raw={}
    for stem in ['raw_sorted','raw_unsorted','raw_sorted_distinct','raw_unsorted_distinct']:
        path=HERE/(stem+'.json')
        if path.exists():
            row=json.loads(path.read_text())
            raw[stem]={k:v for k,v in row.items() if k!='bestrows'}
    sat={}
    for path in HERE.glob('*.json'):
        if path.stem in raw or path.stem in ['summary','jobs','passes','rank_dag12_control']:
            continue
        row=json.loads(path.read_text())
        if isinstance(row,dict) and 'status' in row and 'cpu' in row:
            sat[path.stem]=row
    resources={}
    for path in HERE.glob('*.resources'):
        text=path.read_text()
        match=re.search(r'Maximum resident set size \(kbytes\): (\d+)',text)
        if match:
            resources[path.stem]={'max_rss_kib':int(match[1])}
    passes=json.loads((HERE/'passes.json').read_text()) if (HERE/'passes.json').exists() else []
    result={'raw':raw,'sat':sat,'resources':resources,'passes':passes,
            'source_sha256':{p.name:hashlib.sha256(p.read_bytes()).hexdigest()
                             for p in HERE.iterdir() if p.suffix in ['.py','.cpp']}}
    (HERE/'summary.json').write_text(json.dumps(result,indent=2)+'\n')
    found=any(row['k']<=31 for row in passes)
    lines=['# Round 5: purpose and method','',
           'Search new rank and merge designs. No earlier 32-instruction base was',
           'used. '+('A core with `k <= 31` passed the strict judge.' if found else 'No core with `k <= 31` was found.'),
           '',
           'The constructed sort3-plus-sort2 prefix costs 15 instructions. It leaves',
           '16 instructions for a merge. The alternate sort3-only prefix costs 11',
           'instructions. It leaves 20 instructions for the two single inputs.',
           'The suffix searches choose register sources, destinations, opcodes,',
           'comparison positions, and output positions. They can change intermediate',
           'values. See [round5/METHODS.md](round5/METHODS.md) for the exact families.',
           '', '# Round 5: completed rank-chain searches','',
           'Each output has an independent accumulator. It can start at any original',
           'entry for free. Conditional moves read the original entries. These entries',
           'remain available for free. This family does not share intermediate values.',
           '', '| Input lists | Cases | Comparison orders | Functional orders | Minimum conditional moves |',
           '| --- | ---: | ---: | ---: | ---: |']
    for name in ['raw_sorted','raw_sorted_distinct','raw_unsorted','raw_unsorted_distinct']:
        if name not in raw:
            continue
        row=raw[name]
        if not row['complete']:
            continue
        label='Sorted pair + sorted triple' if row['groups']==[2,3] else 'Two single inputs + sorted triple'
        label+='; distinct' if row['strict'] else '; ties included'
        lines.append(f"| {label} | {row['cases']} | {row['orders']:,} | {row['functional_orders']:,} | {row['best'] if row['best'] is not None else 'No plan'} |")
    lines += ['',
              'For the sorted pair and triple, all 120 functional orders need 12',
              'conditional moves. The six comparisons therefore give a merge cost of',
              'at least 18 instructions, even before physical copy costs. With the',
              '15-instruction prefix, this restricted design needs at least 33 core',
              'instructions. The other 600 orders have no complete independent-chain',
              'plan. This is a finite family result, not a general sorting bound.',
              '', '# Round 5: shared values and merge schedules','',
              'The shared selection search gives copies and retained operands for free.',
              'Its ten gates can share earlier results. The register searches use eight',
              'registers. The triple-only prefix permits one fresh register.',
              'The binary merge design compares',
              'both pair entries with the triple middle. Those flags select the operands',
              'for two insertion comparisons. The triple-only prefix also permits the',
              'pair comparison and its writes to share work with the merge.',
              '', '| Search | Status | Cases in final formula | CPU seconds | Conflicts |',
              '| --- | --- | ---: | ---: | ---: |']
    for stem,row in sorted(sat.items()):
        lines.append(f"| `{stem}` | {row['status']} | {row.get('cases','?')} | {row['cpu']:.3f} | {row.get('stats',{}).get('conflicts','?'):,} |")
    lines += ['',
              '`UNSAT` is a completed solver result for the stated finite encoding.',
              '`UNKNOWN` means a CPU limit or interruption. It is not a negative result.',
              '`SAT_DAG` is an abstract selection plan, not a verified executable program.',
              'Every executable candidate must pass the shared strict judge.',
              '']
    if 'rank_dag10_fixed' in sat and sat['rank_dag10_fixed']['status']=='UNSAT':
        lines += ['The fixed raw order `(a,c), (a,d), (a,e), (b,e), (b,d), (b,c)`',
                  'has no plan with ten or fewer shared selection gates. This completed',
                  'solver result uses all ten strict interleavings. Thus six comparisons',
                  'plus at most ten selection gates cannot give a 16-instruction merge',
                  'for this order, even when copies are free.','']
    if 'rank_dag10_batch' in sat:
        row=sat['rank_dag10_batch']
        lines += [f"The rank-order batch records {row['counts']['UNSAT']} completed UNSAT "
                  f"{'order' if row['counts']['UNSAT']==1 else 'orders'}, "
                  f"{row['counts']['SAT_DAG']} abstract plans, and {row['counts']['UNKNOWN']} unknown orders.",
                  'It queries all 720 orders directly. It does not infer untested results',
                  'from value reversal. Each completed order and each bounded attempt is',
                  'listed in `round5/rank_dag10_batch.json`.','']
        if row.get('cpu_is_last_completed_checkpoint'):
            lines += ['The incremental rank-order run was interrupted. Its CPU entry is',
                      'the last saved checkpoint, not a final resource measurement.','']
    if 'rank_dag10_units' in sat:
        row=sat['rank_dag10_units']
        lines += [f"The separate fixed-order formulas record {row['counts']['UNSAT']} distinct "
                  f"completed UNSAT orders, including the earlier fixed-order result.",
                  f"Within the 120 best independent-chain orders, {row['best_counts']['UNSAT']} "
                  f"are closed and {row['best_counts']['UNKNOWN']} remain unknown.",
                  'The formulas keep every earlier value for free. They check all ten',
                  'strict interleavings with ten selection gates. A completed negative',
                  'therefore excludes a 16-instruction six-comparison merge for that',
                  'order, even before physical copy costs. The complete order ledger is',
                  '`round5/rank_dag10_units.json`.','']
    if 'binary16_shapes' in sat:
        row=sat['binary16_shapes']
        lines += [f"The comparison-position batch completed {row['completed_unsat']} UNSAT tests "
                  f"out of {row['placements']}. The other {row['unknown']} tests are unknown.",
                  'Its first comparison is at instruction zero. The other three',
                  'comparisons can occupy all 455 possible position triples. Every',
                  'write opcode and operand remains free. The per-position ledger is',
                  '`round5/binary16_shapes.json`.','']
    if 'binary16_c4' in sat and sat['binary16_c4'].get('cpu_is_last_completed_progress_record'):
        lines += ['The combined binary16 search was interrupted to prioritize the',
                  'comparison-position batch. Its CPU entry is the last completed',
                  'progress record, not a final resource measurement. It remains unknown.','']
    lines += ['# Round 5: verification and resources','']
    if (HERE/'forward_check.log').exists():
        lines += ['The independent C++ forward search matched all 3,600 cost entries through',
                  'cost 4: 720 orders times five outputs. An absent column costs at least',
                  '5. These bounded entries also give a global lower bound of 12',
                  'conditional moves for the independent-chain family. The scalar',
                  'audit replayed 2,640 finite output-chain witnesses on all 76 weak orders.',
                  'The encoding controls checked a constructed merge, incorrect outputs,',
                  '288 random transition-value pairs, a 12-gate shared plan, and the four',
                  'binary comparison predicates. They also checked condition normalization',
                  'on strict raw comparisons and fresh-register guards on 50 weak orders.',
                  'See [round5/check_encoding.log](round5/check_encoding.log)',
                  'and [round5/forward_check.log](round5/forward_check.log).','']
        lines += ['The final ledger audit checked coverage counts and the current hashes',
                  'of both strict-PASS files. Its result is in',
                  '[round5/audit.json](round5/audit.json).','']
    lines += ['Every new program with a shared strict PASS is listed below. Controls',
              'validate the search. They do not establish a shorter sorter.','']
    for row in passes:
        lines += [f"- [{row['out']}]({row['out']}): `k={row['k']}`, out.",
                  f"- [{row['mem']}]({row['mem']}): `L={row['length_mem']}`, memory."]
    if (HERE/'control34_judge_out.log').exists():
        lines += ['','The constructed control received these judge results:','','```text',
                  (HERE/'control34_judge_out.log').read_text().strip(),
                  (HERE/'control34_judge_mem.log').read_text().strip(),'```']
    maxrss=max((r['max_rss_kib'] for r in resources.values()),default=0)
    lines += ['',
              f'The largest measured resident memory was {maxrss:,} KiB. SAT search jobs used',
              'a 2,800 MiB address-space limit. All CPU jobs ran sequentially under',
              '`nice -n 19` on CPU 68. The commands and source hashes are in',
              '[round5/jobs.json](round5/jobs.json). The complete result ledger is',
              '[round5/summary.json](round5/summary.json).',
              '', '# Round 5: limits and conclusion','',
              'The completed chain result excludes shared intermediate values. The',
              'shared selection model omits physical copy costs. The register model',
              'uses the stated prefix, comparison count, and register count. Fixed',
              'binary predicates exclude other comparison orders and merge decisions.',
              'Timed searches remain unknown. No general lower bound is claimed.',
              '',
              f"The smallest verified core from this worker has {min([32]+[row['k'] for row in passes])} instructions.",
              f"Its memory form has {10+min([32]+[row['k'] for row in passes])} instructions.",
              '',
              'Run `nice -n 19 python3 round5/run_jobs.py finite` for the completed',
              'finite searches and controls. The `binary`, `triple`, `rankfixed`,',
              '`rankbatch`, `rankunits`, and `shapes` phases are separate search entry points. The unrestricted',
              'merge and all-order shared-value searches were run directly. Their',
              'exact arguments are retained in their result JSON files.','']
    report='\n'.join(lines)
    (HERE/'REPORT.md').write_text(report)
    if args.append:
        existing=(WORK/'RESULTS.md').read_text()
        assert '# Round 5: purpose and method' not in existing,'round 5 already appended'
        with (WORK/'RESULTS.md').open('a') as f:
            f.write('\n\n'+report)
    print(json.dumps({'rank_runs':len(raw),'sat_runs':len(sat),'strict_program_pairs':len(passes),
                      'max_rss_kib':maxrss},indent=2))


if __name__=='__main__':
    main()
