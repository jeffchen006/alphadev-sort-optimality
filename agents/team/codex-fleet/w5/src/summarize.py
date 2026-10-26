from pathlib import Path
from collections import Counter
import re,json

HERE=Path(__file__).resolve().parents[1]
def text(name):return (HERE/'logs'/name).read_text()
def total(name):return sum(map(int,re.findall(r'^DONE trials=(\d+)',text(name),re.M)))
walknames=['walk00','walk27repair','walk30']+[f'c8_walk{i}' for i in range(1,5)]
walks=[]
for name in walknames:
    s=text(name+'.log')
    tail=re.search(r'^WALK_DONE moves=(\d+) accepted=(\d+) unique=(\d+)',s,re.M)
    done=re.search(r'^DONE trials=(\d+).*seconds=([\d.]+)',s,re.M)
    if tail and done:walks.append(dict(name=name,moves=int(tail[1]),accepted=int(tail[2]),unique=int(tail[3]),trials=int(done[1]),seconds=float(done[2])))
stats={'walks':walks,'seed_delete_and_repair_trials':total('repair_v5_batch.log'),
       'seed_cmp_cmov_repair_trials':total('repair3_batch.log')}
(HERE/'analysis/summary.json').write_text(json.dumps(stats,indent=2)+'\n')
lines=['No program with k <= 31 was found.',
       '',
       'Strict PASS side result: a sort5 core with k=32 and 8 comparisons. Its memory version has 42 instructions.',
       '',
       'The first such result is `verified/walk30_delete_k32.s`: 8 cmp + 20 cmov + 4 mov.',
       'Other strict PASS forms are `verified/walk30_final.s` (8 cmp + 21 cmov + 3 mov)',
       'and `verified/palette_c8_k32.s` (8 cmp + 19 cmov + 5 mov).',
       '',
       '## Purpose',
       '',
       'Find a core with k<=31. The main search tried to remove a CMOV from correct programs.',
       'This run did not meet that target. The 8-comparison k=32 result improves the supplied 8-comparison k=33 example.',
       '',
       '## Terms',
       '',
       '- Core length k counts mov, cmp, and cmov. The out records have no cost.',
       '- A weak order is an input order that can include equal values. There are 541 weak orders for five inputs.',
       '- A mirror list obeys comparator[c-1-i] = (4-b,4-a) when comparator[i] = (a,b). This reflects both time and wires.',
       '- A palette is the finite set of value functions that a program computes.',
       '',
       '## Method',
       '',
       'All writes stayed in this folder. Search jobs used nice -n 10. At most eight search CPU cores ran at one time.',
       'The SIMD search filter used 16 concrete order tests, scratch value 7, and equal initial flags.',
       'This filter is a necessary-condition test. It can reject a program but cannot accept one.',
       'The independent full simulator used all 541 weak orders, unknown scratch values, and unknown initial flags.',
       'Every reported PASS file then passed shared/judge.py with --strict and its stated model.',
       '',
       'The independent simulator agreed with the supplied simulator on 20,000 random mutations.',
       'Of these mutations, both simulators accepted 3,984. See `logs/crosscheck.log`.',
       '',
       'Sources: all 26 files in d7-structure/fam32, the three upper_sort5_*k32 files, and sat_sort5_k32.s.',
       'The full source list is in `seeds/manifest.json`.',
       'The later search also used d4-evolve/codex/work/position33_valid.txt.',
       '',
       '## Result',
       '',
       '### CMOV value checks',
       '',
       'The 30 initial seeds contain 542 CMOV instructions. None is a no-op on all weak orders.',
       'One CMOV has a full result already held by another register: instruction 9, with zero-based numbering,',
       'in upper_sort5_I1_k32_out.s. It copies S3 into P2. The source S3 changes before later uses.',
       'The deletion search found no shorter program from this reuse.',
       'See `analysis/cmov_audit.json` and `src/audit.py`.',
       '',
       'The first 8-comparison k=32 result has 20 CMOV instructions. None has a full result already held',
       'by another register. It computes 24 distinct fully defined value functions, including the five inputs.',
       'One extra CMOV first writes a value that still depends on scratch data in some cases.',
       'A later CMOV removes that dependence. See `analysis/c8_k32_cmovs.json`.',
       '',
       'The last two comparisons in that program each use two operands that are not min/max expressions of the inputs.',
       'The check constructs the only possible Boolean min/max expression and tests it on all 541 weak orders.',
       'Counterexamples are in `analysis/c8_k32_comparison_terms.json`.',
       '',
       '### Exact bounded repairs',
       '',
       f'- The final seed scan tested {stats["seed_delete_and_repair_trials"]:,} candidates over 30 seeds. It tried every single deletion,',
       '  then every two deletions with one insertion at every gap. The insertion alphabet includes all six legal opcodes,',
       '  all used registers, one fresh register, and equal source/destination operands. No k<=31 candidate survived the filter.',
       f'- Deleting one CMOV, changing one CMP, and changing one surviving CMOV tested {stats["seed_cmp_cmov_repair_trials"]:,} candidates',
       '  over the 30 initial seeds. This scan used one fresh register and excluded self CMOVs. It found no k<=31 result.',
       '- The same CMP/CMOV repair on the first 8-comparison k=32 result tested 108,044,640 candidates.',
       '  The 16-case filter admitted 20,735. None passed the full simulator.',
       '- Deleting one CMOV and changing two surviving CMOVs in the first 8-comparison k=32 result tested 544,467,420 candidates.',
       '  The filter admitted 160. None passed the full simulator. Both shards of this scan include self CMOVs.',
       '',
       'The three-MOV form also failed 416,272,710 two-CMOV repair candidates and 86,822,400 CMP/CMOV repair candidates.',
       'Those scans include self CMOVs. See `logs/cmov3_lowmov.log` and `logs/repair3_lowmov.log`.',
       'The first eight-comparison k=32 result also failed the full two-delete/one-insert scan. See `logs/repair_v5_c8.log`.',
       '',
       '### Correct-program walks',
       '',
       'Each accepted state passed the independent full simulator. Only files listed in the PASS table received a reference-judge PASS.',
       'The distinct counts normalize scratch register names. They count instruction lists, not distinct sorting algorithms.',
       'Mutations include instruction changes, moves, swaps, two instruction changes, and suffix register exchanges.',
       'The walks check single deletions in every new state. Most runs also check complete two-delete/one-insert repairs at intervals.',
       '',
       '| Run | Proposals | Accepted transitions | Distinct states | Total candidate tests |',
       '|---|---:|---:|---:|---:|']
for r in walks:lines.append(f'| {r["name"]} | {r["moves"]:,} | {r["accepted"]:,} | {r["unique"]:,} | {r["trials"]:,} |')
lines += ['',
          'walk00 checked single deletions only. walk27repair checked a full repair after every 100 new states.',
          'walk30 started from the supplied k=33 program. It found k=32 by deleting instruction 24 from a mutated state.',
          'Its comparison histogram remained at eight comparisons. The four c8_walk runs started from that k=32 result.',
          '',
          '### Mirror restriction',
          '',
          'These runs restrict comparator lists to time-and-wire reflection symmetry. The final assembly can use different register routes',
          'on the two sides. This is a restriction on comparator structure, not literal instruction-by-instruction assembly symmetry.',
          'Only lists that sort all 32 Boolean inputs are accepted by the network walk.',
          'A separate enumeration confirmed the total list counts below. Each walk reached every accepted list in its space.',
          '',
          '| Comparisons | Lists tested by enumeration | Accepted lists | Distinct value/comparison circuits compiled | k<=31 result |',
          '|---:|---:|---:|---:|---|',
          '| 10 | 100,000 | 402 | 390 | None |',
          '| 11 | 200,000 | 4,018 | 3,878 | None |',
          '| 12 | 1,000,000 | 27,922 | 21,712 | None |',
          '',
          'The first compiler builds required results at their defining comparison. It can omit repeated results and use any available',
          'register whose value matches the desired result on the inactive flag cases. It can also use any matching source register.',
          'A later compiler permits delayed CMOVs. It tested the 10- and 11-comparison spaces again.',
          'That search visited 33,362,702 states and hit no state limit. It found no k<=31 route in its restricted palettes.',
          'At limit 32, the first compiler produced a strict PASS program from a 10-comparator list.',
          'Dead result removal reduced the emitted core to nine comparisons. This is `verified/mirror10_near_k32.s`.',
          '',
          '### Fixed palette route for the 8-comparison program',
          '',
          'The final route search used its 24 known value functions and its eight comparison operand functions.',
          'Only 15 non-input functions are direct comparison/output requirements. Other palette functions were optional.',
          'The search allowed CMOVs at later comparison blocks, arbitrary matching sources and destinations, and early outputs.',
          'It generates each value function at most once and preserves a needed comparison operand through its last comparison use.',
          'At k<=31 it visited 129,560 states and returned no route. It did not hit its state limit.',
          'At k<=32 it found a route after 325,116 states. That route has eight comparisons, 19 CMOVs, and five MOVs.',
          'Both its out and memory forms passed the reference judge. See `logs/palette_c8_31.log` and `logs/palette_c8_32.log`.',
          '',
          '### Reference-judge PASS files',
          '',
          'Every row below has a saved PASS output in logs/judge_<file stem>.log.',
          '',
          '| File | Model | Count |',
          '|---|---|---:|']
for p in sorted((HERE/'verified').glob('*.s')):
    log=HERE/'logs'/f'judge_{p.stem}.log'
    if not log.exists() or not log.read_text().startswith('PASS '):continue
    m=re.search(r' L=(\d+).*model=(\w+)',log.read_text().splitlines()[0])
    if m:lines.append(f'| [{p.name}](verified/{p.name}) | {m[2]} | {m[1]} |')
extra=set()
for p in (HERE/'logs').glob('*.log'):
    for path in re.findall(r'^PASS (.+?) \[relaxed\+strict\]',p.read_text(),re.M):
        if '/verified/' not in path and not path.startswith('verified/'):extra.add(path)
if extra:
    lines+=['','These identical source paths also received a direct reference-judge PASS:']
    for p in sorted(extra):lines.append(f'- `{p}`')
lines += ['',
          '## Limits',
          '',
          'These are bounded search results. They do not establish a lower bound for arbitrary programs.',
          'The correct-program walks are stochastic. The exact repair neighborhoods have the stated edit and register limits.',
          'The palette compilers do not consider arbitrary new conditional values, repeated value construction, or arbitrary comparison changes.',
          'The mirror result covers the stated comparator symmetry only.',
          '',
          '## Conclusion',
          '',
          'The target total length of 41 remains open in this run. The main useful result is a strict PASS sort5 core with eight comparisons',
          'and k=32, in several MOV/CMOV count forms. Its memory length equals 42.',
          'The complete scripts, seeds, candidate files, judge outputs, and search counts are in this folder.',
          '']
(HERE/'RESULTS.md').write_text('\n'.join(lines))
print('Wrote RESULTS.md with',len(walks),'completed walk runs')
