#!/usr/bin/env python3
from pathlib import Path
import re,json,collections,datetime

def status(name):
 p=Path('logs')/(name+'.log')
 if not p.exists():return 'not run'
 s=p.read_text();rs=re.findall(r'RESULT it=\d+ (\S+) time=([0-9.]+)',s)
 if rs:
  st,sec=rs[-1];return f'{st}, {sec} s'
 if 'STOPPED:' in s:return 'stopped without a solver result'
 return 'pending' if 'ENC ' in s else 'no solver result'

def routing(pattern,kind):
 records={};calls=0
 for p in Path('logs').glob(pattern):
  s=p.read_text();m=re.search(r'RESULT (\w+) K=31 calls=(\d+)',s)
  if not m:continue
  calls+=int(m[2]);key=p.name.replace('_retry_k31','_k31').replace('_final_k31','_k31')
  priority=1 if '_retry_' in p.name or '_final_' in p.name else 0
  if key not in records or priority>records[key][0]:records[key]=(priority,m[1])
 return {'distinct':len(records),'status':dict(collections.Counter(x[1] for x in records.values())),'recorded_calls':calls}

mix=routing('*.mixed','mixed');phase=routing('*.phase','phase')
reg=json.loads(Path('logs/judge_registry.json').read_text())
passes=sorted(((p,r) for p,r in reg.items() if r['status']=='PASS'),key=lambda pr:(pr[1]['length'],pr[0]))
fails=sorted(p for p,r in reg.items() if r['status']=='FAIL')
rows=[]
for p,r in passes:
 text=Path(p).read_text();c=sum(l.startswith('cmp ') for l in text.splitlines())
 rows.append(f"| `{p}` | {r['model']} | {r['length']} | {c} |")
pass_table='\n'.join(rows)
fixed='\n'.join(f'| {i} | {24 if i in [1,5] else 32} | {status(f"prefix{i}_k31")} |' for i in range(6))
selected=[
 ('Input-origin SAT, mixed rule 10, tree 5, 60 permutations','origin_mixed10_sat31'),
 ('Input-origin SAT, mixed rule 6, tree 5, 60 permutations','origin_mixed6_sat31'),
 ('Fixed prefix, fixed partner operand, six tree choices per history, 120 permutations','union_phase_prefix_k31'),
 ('Free prefix implementation, fixed partner operand, six tree choices per history, 120 permutations','union_phase_full_k31'),
 ('Free prefix implementation, original orientation, six tree choices per history, 120 permutations','union_max_k31'),
 ('Mixed rule 10, original orientation, six tree choices per history, 120 permutations','union_m10_k31'),
]
satrows='\n'.join(f'| {label} | {status(name)} |' for label,name in selected)
extra=[('Early unrestricted SAT, trees 1 and 5','fj1_sat31, fj5_sat31'),('Unrestricted paired copies, trees 1 and 5','full1_flag_paired_k31, full5_exact_paired_k31'),('One-hot values, trees 1 and 5','full1_onehot_k31, full5_onehot_k31'),('Four free comparisons after the fixed prefix','prefix_dynamic_k31'),('Free copies, 24 conditional moves','freecopy5_g24'),('Fixed prefix, k=36, exact operands, all permutations','prefix5_k36'),('Mixed flag sequences, rules 6, 10 and 12','mixed6_flag_sat31, mixed10_flag_sat31, mixed12_flag_sat31')]
extra_rows='\n'.join(f'| {label} | '+ '; '.join(f'{name}: {status(name)}' for name in names.split(', '))+' |' for label,names in extra)
summary={'mixed':mix,'fixed_partner_orientation':phase,'strict_pass_files':len(passes),'strict_fail_files':len(fails),'sat':{name:status(name) for _,name in selected}}
Path('logs/final_summary.json').write_text(json.dumps(summary,indent=2)+'\n')
report=f'''# Worker w3 results

No program with core k <= 31 passed the strict judge.

## Purpose

Find a branchless sort5 program with seven comparisons and at most 31 core instructions.
The shortest verified seven-comparison reference from this work has k=53.
Its memory version has 63 instructions. It does not improve the known k=32 result.

## Terms

- Core k counts register mov, cmp, and conditional-move instructions.
- A skeleton specifies the comparison operands or their flag results on each test order.
- A residual tree specifies the last four comparisons after the first three comparisons.
- UNSAT means the SAT solver found no assignment in the stated search model.
- NONE means the routing search completed without a program in the stated model.
- LIMIT and TIMEOUT give no negative bound.
- PASS means the reference judge accepted the file with --strict.

## Method

`src/trees.py` enumerated depth-four sorting trees after the Ford–Johnson prefix.
The known relations are a < b < d and c < d. The fifth value e is free.
There are 15 possible strict orders and six residual tree shapes.
Every shape first compares b with e. Each shape has one path that finishes after three more comparisons.

The search tested four rules that select the third comparison from the pair minima or the pair maxima.
The selection can depend on the first two comparison results.
Rule 12 uses the first result. Rule 10 uses the second result.
Rule 6 selects minima when exactly one result is less-than.
Rule 8 selects minima when both results are less-than.
`sk/third_choice_orbits.json` records the 16 truth tables under input-flag flips and min/max complementation.

The generators tested three operand-orientation rules and twelve ways to pad an early finishing path.
The last orientation rule keeps the partner value in the first operand when a comparison contains that partner.
This rule is stored in `sk/phase/`.
`sk/comparison_partitions.json` records comparison split sizes.
After two fixed disjoint pair comparisons, only the two-minima and two-maxima comparisons leave at most 16 orders in each branch.
This is a counting result for that prefix.

`src/ssa_sat.py` implements the SAT models.
Each data instruction creates one value node. A conditional move can consume an existing register value.
Later instructions cannot read a consumed value. Outputs can select any earlier value.
The decoder records each selected output when that value is created.
The model includes all four I1 conditional moves.
The model does not read uninitialized scratch registers.

The input-origin encoding tracks which input supplies a register value.
It links test orders that have the same comparison history.
The tree-choice model can select one of six residual trees separately for each of eight initial histories.
It therefore covers 6^8 profile combinations for each stated prefix and orientation rule.

`src/dagx.cpp`, `src/dag_reference.py`, and `src/rsat.py` are local copies of the d1-skeleton tools.
`src/dag_relaxed.cpp` makes register copies free and uses the 15 residual orders.
`src/normalize.py` puts copies next to their consuming conditional moves.
`src/to_mem.py` adds five loads and converts output snapshots into five stores.
Searches used nice -n 10 and at most eight search workers.

## Results

### Routing searches at k=31

| Family | Distinct skeletons | Completed NONE | Unresolved call limits | Recorded calls |
| --- | ---: | ---: | ---: | ---: |
| Original orientation rules, constant maxima prefix | 90 | 0 | 90 | See `logs/batch_dag.log` |
| Mixed minima/maxima, original orientation rules | {mix['distinct']} | {mix['status'].get('NONE',0)} | {mix['status'].get('LIMIT',0)} | {mix['recorded_calls']:,} |
| Fixed partner operand, including mixed choices | {phase['distinct']} | {phase['status'].get('NONE',0)} | {phase['status'].get('LIMIT',0)} | {phase['recorded_calls']:,} |

The first 90 searches used a 3,000,000-call cap.
The mixed family first used a 1,500,000-call cap.
All 22 limited mixed cases then completed with a 100,000,000-call cap and a 300 s time limit.
The fixed partner operand family used 1,500,000 or 300,000 calls per first pass.
Four limited cases received a final extension with a 100,000,000-call cap and a 180 s time limit.
Their final status is in `logs/final_phase_retry.log`.
Recorded calls do not include work lost when a run was interrupted.

### Fixed-prefix SAT searches at k=31

The fixed prefix is `programs/prefix_fj.s`.
It has 3 comparisons, 8 conditional moves, and 4 copies: 15 instructions.
Its saved copies remain available to the solver.
These six runs use the original comparison orientation.
They allow the final flags to vary on paths that finish after six comparisons.

| Residual tree | Test permutations | Result |
| --- | ---: | --- |
{fixed}

### Broader SAT searches at k=31

These runs allow the solver to select comparison operands.
The paired-copy runs put each copy next to its consuming conditional move.

| Search model | Result |
| --- | --- |
{satrows}

### Other searches and dead ends

| Search | Result |
| --- | --- |
{extra_rows}

The rule-8 flag SAT run was stopped to redirect a CPU worker. It gave no solver result.
Conditional-move budget tests used 12 through 16 conditional moves.
Tree 1 returned UNSAT at 12; its 13–15 runs timed out.
Tree 4 returned UNSAT at 12, 13, 14, and 15.
The 16-move runs were stopped. See `logs/batch_gates.log` and the individual `gate*_g*_k31.log` files.

The residual routing search made copies free.
All twelve common-orientation residual variants returned NONE through 16 conditional moves.
At 17 conditional moves, ten returned NONE and two reached the call limit.
At 18 conditional moves, two returned NONE and ten reached the call limit.
Larger budgets reached call limits. This result only concerns the specified residual comparison operands.
See `logs/batch_residual.log` and `logs/batch_residual_more.log`.

Routing at k=40 for two original tree variants reached a 10,000,000-call cap without a program.
These runs do not establish a negative bound.
A greedy ordered-multiplexer construction produced long programs with 54 conditional moves.
The direct two-insertion construction reduced this to 30 conditional moves and 16 copies, with k=53.

One SAT control initially used a program with a different operand orientation.
That control returned UNSAT and is excluded from the search results.
A control with the matching orientation returned SAT.
The decoded control passed the strict judge.
The direct k=53 program also matched the later orientation model and passed its control check.

### Every strict PASS file

All paths are relative to this worker folder.
The k=32 programs and the length-42 memory program are controls based on the existing upper bound.
They are not new improvements.
For the out model, Length is core k. For the mem model, Length includes loads and stores.

| File | Model | Length | Comparisons |
| --- | --- | ---: | ---: |
{pass_table}

`logs/judge_registry.json` records all 23 complete program files.
It records {len(passes)} PASS files and {len(fails)} FAIL files.
The fixed prefix is a template, so it is not a complete sorting candidate.
The four failed files are:

'''+'\n'.join('- `'+p+'`' for p in fails)+'''

The failed files use strict cmovg as the complement of cmovl.
They fail on ties. The complementary inclusive condition cmovge produced the verified I1 versions.
All generated complete candidate files received a strict judge check.

## Limits

No target program was found.
The negative results apply to the stated skeletons, flag profiles, and register-initialization restrictions.
They do not exclude every seven-comparison program.
The routing searches and SAT searches use strict permutations as a relaxation.
The strict judge checks every reported PASS on all 541 weak orders and arbitrary scratch values and initial flags.
A search result is not a general optimality proof.

The remaining open choices include arbitrary operand orientations, different second input pairs after the first comparison, and other register programs outside these fixed profile families.
Every unresolved call limit and solver timeout remains unresolved.
'''
Path('RESULTS.md').write_text(report)
print(json.dumps(summary,indent=2))
