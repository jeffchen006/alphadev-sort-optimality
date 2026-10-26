#!/usr/bin/env python3
"""Write the final report after all planned batches finish."""
from collections import Counter
import json
from pathlib import Path
import re

names={
 'net':'net10_safe_batch.log','repeat':'repeat_batch.log',
 'refresh':'refresh_batch.log','nonlattice':'nonlattice10_batch.log',
 'tail':'refresh_tail_batch.log','selected':'sat_selected_batch.log',
 'deep':'tail_deep_batch.log','accel':'tail_deep_accel_batch.log'}
stats={}
for key,name in names.items():
    p=Path('logs')/name
    if not p.exists() or not p.read_text().rstrip().endswith('BATCH COMPLETE'):
        raise SystemExit('PENDING '+str(p))
    records=[json.loads(s) for s in p.read_text().splitlines() if s.startswith('{')]
    stats[key]=records[-1] if records else dict(total=0,counts={})

passed=[]
for fn in sorted(Path('programs').glob('*.s')):
    judge=Path('logs')/(fn.stem+'.judge.log')
    if not judge.exists() or not judge.read_text().startswith('PASS '):
        continue
    text=fn.read_text()
    model=re.search(r'model=(\w+)',text).group(1)
    code=[line.split('#',1)[0].strip() for line in text.splitlines()]
    counts=Counter(line.split()[0] for line in code if line)
    length=sum(counts.values())-counts['out']
    passed.append((fn,judge,model,length,counts))

found=[r for r in passed if (r[2]=='out' and r[3]<=31) or (r[2]=='mem' and r[3]<=41)]
lines=[]
for fn,judge,model,length,counts in found:
    lines.append('FOUND %s %s=%d strict PASS (%s)'%
                 (fn,'k' if model=='out' else 'L',length,judge))
lines.append('A program meets the target. See the FOUND lines above.' if found else
             'No program with core k <= 31 has passed the strict judge.')
lines+=['',
 'The best verified reference core has k=32 and memory length 42. It comes',
 'from worker w6. This matches AlphaDev\'s length. It is not a w2 discovery.',
 '',
 'All paths below are relative to this worker folder. Main searches target',
 'ten comparisons and core length at most 31.',
 '',
 '| Family | Cases | Method and limit | Recorded results |',
 '| --- | ---: | --- | --- |']
def status(s):
    return ', '.join('%s %s'%(k,format(v,',')) for k,v in s['counts'].items())
rows=[
 ('Ten-comparator networks','net','Conservative DAG routing, 30 million nodes'),
 ('Repeat one earlier comparison','repeat','DAG routing, 3 million nodes'),
 ('Add a comparison among earlier terms','refresh','DAG routing, 100,000 nodes'),
 ('Two refreshes in eight-comparison seeds','nonlattice','462 DAG cases at 300,000 nodes; 462 SAT cases at 20,000 conflicts'),
 ('Add a final comparison','tail','SAT, 5,000 conflicts'),
 ('Retry limited final-comparison cases','deep','SAT, 20,000 conflicts'),
 ('Selected cases, including reused results','selected','SAT, 20,000 conflicts')]
for label,key,method in rows:
    s=stats[key]
    n=s.get('total',s.get('done',0))
    lines.append('| %s | %s | %s | %s |'%(label,format(n,','),method,status(s)))
lines+=['',
 'The selected SAT row overlaps the other rows. The deeper pass retries',
 'limited or failed broad cases. These are not additional distinct counts.',
 'Six extra workers helped finish pending deep cases after the broad batches',
 'ended. Completed results were reused. At most eight solver processes ran',
 'at the same time.',
 '',
 'After the retries, all 2,212 final-comparison cases returned UNSAT in the',
 'stated finite-pool SAT model. No unresolved limit or error remains in that',
 'family at the 20,000-conflict retry budget.',
 '',
 'Network search:',
 '',
 '- Generated 486,474 network sequences with the supplied network generator.',
 '  It omits redundant comparators and keeps one order of adjacent disjoint',
 '  comparators. Input renaming reduced these to 21,162 value skeletons.',
 '- Each generated skeleton has 20 distinct non-input terms among its',
 '  comparison operands and final outputs.',
 '- The conservative router returned NONE on all 21,162 skeletons. It made',
 '  202,390,388 recursive calls. No case reached the node or time limit.',
 '- The original router also returned NONE on this set. The final network',
 '  result uses the more conservative open-requirement bound.',
 '- Source sequences: `networks10.txt`. Source mapping:',
 '  `network_manifest.json`. Corrected generation counts:',
 '  `logs/network_counts_corrected.json`.',
 '',
 'Routing model and limits:',
 '',
 '- A value column records a value for each test input order. A skeleton',
 '  fixes the comparison operand columns. The DAG router searches moves,',
 '  conditional moves, register reuse, and free output times.',
 '- Routing uses the 120 distinct input orders. NONE is a search result for',
 '  that representation and skeleton. It is not a general sort5 lower bound.',
 '- The repeat and broad refresh batches span the original and conservative',
 '  router versions. LIMIT and TIMEOUT leave those cases unresolved.',
 '- Equivalent operand pairs can reproduce the same conditional move masks.',
 '  The flag router maps opcodes to the selected pair. This includes binary',
 '  lt/gt predicates represented with lt/eq outcomes.',
 '- The SAT router uses a fixed value pool for each case. It permits at most',
 '  two copies of each value column. It has no fixed total register limit.',
 '  Its UNSAT results apply only to this pool and copy restriction.',
 '- Later SAT jobs add value conservation and bounds on instruction times.',
 '  A value must remain live until its output is recorded. A comparison',
 '  must follow creation of its required operand columns.',
 '- A free-copy relaxation enumerates subsets of value columns. It ignores',
 '  copy costs and supplies a lower bound on conditional moves. That bound',
 '  limits the number of counted moves in the real routing query.',
 '- Glucose 4 and CaDiCaL 1.9.5 solve the SAT queries. Each log names its',
 '  solver when that field is available. New constraints passed the known',
 '  33-instruction control and both strict judges.',
 '- The older eight-comparison seed is the supplied position33 program.',
 '  The newer seed is `../w6/candidates/c8c_len32_c29288.s`. Each produced',
 '  462 ten-comparison skeletons with two predicate refreshes.',
 '- The new seed\'s 462 SAT cases all returned UNSAT. The selected initial',
 '  SAT batch contained 694 cases, including reused new-seed results.',
 '- All upper-bound candidates require the strict judge. Only a PASS on all',
 '  541 weak orders and arbitrary scratch state counts as a verified result.',
 '',
 'Strict judge PASS files:',
 '',
 '| Program | Model | Length | Judge log |',
 '| --- | --- | ---: | --- |']
for fn,judge,model,length,counts in passed:
    lines.append('| [%s](%s) | %s | %s=%d | [%s](%s) |'%
                 (fn,fn,model,'k' if model=='out' else 'L',length,judge,judge))
lines+=['',
 'Controls, failed tests, and dead ends:',
 '',
 '- The 33-instruction controls have 10 comparisons, 18 conditional moves,',
 '  and 5 copies. Their memory conversions have length 43. They validate',
 '  routing and decoding. They do not improve the known bound.',
 '- The SAT reconstruction `programs/sat_w6_control32.s` and its `_mem.s`',
 '  conversion failed on ties. The first counterexample was `[0,0,1,0,0]`.',
 '  Both failed files and their judge logs are retained.',
 '- `src/repair_ties.py` keeps register operands and comparison instructions',
 '  fixed. An SMT query selects strict or inclusive conditions on all 541',
 '  weak orders. The repaired 32-instruction reconstruction passed both',
 '  strict judges. A repair still needs those independent checks.',
 '- The independent concrete simulator checked control_c10_k33 and',
 '  control_flags_k33 in both models. It used all 541 weak orders, three',
 '  initial flag states, and three uniform scratch values. Each file passed',
 '  4,869 cases. This finite check does not',
 '  replace strict verification. Log: `logs/independent_check.log`.',
 '- A maximum-clique extension did not reduce the first 3,000,000-call',
 '  routing benchmark and ran more slowly. Main batches do not use it.',
 '- The 27-term control SAT query returned UNSAT at k=31 without fixed',
 '  instructions. It used 12,434 conflicts. Log: `logs/sat_target31.log`.',
 '- The same control pool returned UNSAT at k=32 with no fixed instructions.',
 '  It used 8,551 conflicts. Log: `logs/c10_competitive32.log`.',
 '- One broad tail job stopped with an IndentationError while loading a',
 '  source update. Its clean 20,000-conflict retry returned UNSAT. The',
 '  retry log is `logs/tail_deep_accel/vc14_tail_137.log`.',
 '',
 'Files and reproduction:',
 '',
 '- `RUNS.md` gives build, search, verification, and tie-repair commands.',
 '- `logs/final_batch_stats.json` records final summaries. Individual logs are in',
 '  `logs/net10_safe/`, `logs/repeat/`, `logs/refresh/`,',
 '  `logs/nonlattice10/`, `logs/refresh_tail/`, `logs/tail_deep/`,',
 '  `logs/tail_deep_accel/`, and `logs/sat_selected/`.',
 '- Search processes used `nice -n 10`. All writes stayed in this worker',
 '  folder.',
 '']
Path('RESULTS.md').write_text('\n'.join(lines))
Path('logs/final_batch_stats.json').write_text(json.dumps(stats,indent=2)+'\n')
print('REPORT WRITTEN PASS_FILES=%d TARGET_FILES=%d'%(len(passed),len(found)))
