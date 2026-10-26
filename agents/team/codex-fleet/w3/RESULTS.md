# Worker w3 results

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
| Mixed minima/maxima, original orientation rules | 528 | 528 | 0 | 186,770,606 |
| Fixed partner operand, including mixed choices | 593 | 424 | 169 | 177,965,953 |

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
| 0 | 32 | UNSATISFIABLE, 73.4 s |
| 1 | 24 | UNSATISFIABLE, 46.4 s |
| 2 | 32 | UNSATISFIABLE, 41.1 s |
| 3 | 32 | UNSATISFIABLE, 61.7 s |
| 4 | 32 | UNSATISFIABLE, 58.8 s |
| 5 | 24 | UNSATISFIABLE, 98.2 s |

### Broader SAT searches at k=31

These runs allow the solver to select comparison operands.
The paired-copy runs put each copy next to its consuming conditional move.

| Search model | Result |
| --- | --- |
| Input-origin SAT, mixed rule 10, tree 5, 60 permutations | UNSATISFIABLE, 285.5 s |
| Input-origin SAT, mixed rule 6, tree 5, 60 permutations | UNSATISFIABLE, 395.6 s |
| Fixed prefix, fixed partner operand, six tree choices per history, 120 permutations | UNSATISFIABLE, 381.3 s |
| Free prefix implementation, fixed partner operand, six tree choices per history, 120 permutations | TIMEOUT, 607.9 s |
| Free prefix implementation, original orientation, six tree choices per history, 120 permutations | TIMEOUT, 609.0 s |
| Mixed rule 10, original orientation, six tree choices per history, 120 permutations | TIMEOUT, 608.5 s |

### Other searches and dead ends

| Search | Result |
| --- | --- |
| Early unrestricted SAT, trees 1 and 5 | fj1_sat31: TIMEOUT, 180.5 s; fj5_sat31: TIMEOUT, 180.4 s |
| Unrestricted paired copies, trees 1 and 5 | full1_flag_paired_k31: TIMEOUT, 601.3 s; full5_exact_paired_k31: TIMEOUT, 601.2 s |
| One-hot values, trees 1 and 5 | full1_onehot_k31: TIMEOUT, 603.2 s; full5_onehot_k31: TIMEOUT, 603.9 s |
| Four free comparisons after the fixed prefix | prefix_dynamic_k31: TIMEOUT, 602.8 s |
| Free copies, 24 conditional moves | freecopy5_g24: TIMEOUT, 301.6 s |
| Fixed prefix, k=36, exact operands, all permutations | prefix5_k36: TIMEOUT, 246.2 s |
| Mixed flag sequences, rules 6, 10 and 12 | mixed6_flag_sat31: TIMEOUT, 602.5 s; mixed10_flag_sat31: TIMEOUT, 602.5 s; mixed12_flag_sat31: TIMEOUT, 602.5 s |

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
| `programs/control_decoded.s` | out | 32 | 9 |
| `programs/gate_control32.s` | out | 32 | 9 |
| `programs/known32.s` | out | 32 | 9 |
| `programs/onehot_control32.s` | out | 32 | 9 |
| `programs/origin_control32.s` | out | 32 | 9 |
| `programs/paired32.s` | out | 32 | 9 |
| `programs/paired42_mem.s` | mem | 42 | 9 |
| `programs/construct_fj_k53.s` | out | 53 | 7 |
| `programs/union_phase_control53.s` | out | 53 | 7 |
| `programs/construct_fj_L63_mem.s` | mem | 63 | 7 |
| `programs/greedy84_inclusive.s` | out | 84 | 7 |
| `programs/greedy_t5_common_last_prefix_k84.s` | out | 84 | 7 |
| `programs/union_control84.s` | out | 84 | 7 |
| `programs/greedy_t5_common_last_prefix_k85.s` | out | 85 | 7 |
| `programs/greedy_t5_common_last_prefix_k86.s` | out | 86 | 7 |
| `programs/greedy_t5_common_last_prefix_k87.s` | out | 87 | 7 |
| `programs/greedy_t5_common_last_prefix_k88.s` | out | 88 | 7 |
| `programs/greedy_t5_common_last_prefix_k89.s` | out | 89 | 7 |
| `programs/greedy94_mem.s` | mem | 94 | 7 |

`logs/judge_registry.json` records all 23 complete program files.
It records 19 PASS files and 4 FAIL files.
The fixed prefix is a template, so it is not a complete sorting candidate.
The four failed files are:

- `programs/greedy_t5_common_last_k84.s`
- `programs/greedy_t5_common_last_k85.s`
- `programs/greedy_t5_common_last_k87.s`
- `programs/greedy_t5_common_last_k88.s`

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

## Round 2 (in progress)

Round 2 uses at most two CPU search jobs. Every search command runs with
`nice -n 19`. The process affinity is CPUs 72–73. All new files are in `round2/`.
The round-1 statement about eight workers does not describe round 2.

The new SAT encoding permits an independent operand reversal after each previous
comparison history. This includes reversals that depend on earlier results.
The second-pair family compares inputs (2,3) after one first-comparison result,
and inputs (2,4) after the other result. It keeps all five original inputs.
The routing batch also tests the original second pair with new operand reversals.
It excludes exact skeletons already present in round-1 directories.

The tree-choice extension can select minima or maxima for comparison 3 and choose
one of six residual trees separately on both branches. It has 72 choices per
history of the first two comparisons. This is a broader flag-profile model.
The model still excludes reads of uninitialized scratch registers.

A second SAT encoding uses a fixed physical-register count and a fixed number of
data instructions after each comparison. Values name their original input.
Values with the same comparison history share variables. The encoding permits
register reuse and requires a prior unconditional write before a scratch read.
These register and schedule limits are search restrictions.

New strict PASS controls (not target improvements):

- `round2/programs/orient_control53_i0.s`: out model, k=53, 7 comparisons.
- `round2/programs/complete_control53_i0.s`: out model, k=53, 7 comparisons.
- `round2/programs/physical_control53.s`: out model, k=53, 7 comparisons.

Each control has a recorded reference-judge PASS in its matching `round2/logs/`
`.log` file. Final counts and remaining limits will be appended after the runs.

The new variable-schedule model permits up to eight data slots after each
comparison. It counts at most 24 active slots across all seven comparisons.
Inactive slots preserve registers and have no instruction cost. This model tests
many schedules in one run. Its phase limit and register limit remain explicit.
`round2/programs/flexible_control53.s` is another strict PASS control at k=53.
Its control encoding inserts an inactive slot after each comparison phase.
The matching log records the reference-judge PASS.

`round2/src/count_prefix.py` checked all input-index pairs at the first two
prefix states. After input 0 < input 1, only pairs (2,3), (2,4), and (3,4)
split the 60 remaining strict orders within the five-comparison capacity.
After 0 < 1 and 2 < 3, only pairs (0,2) and (1,3) split the 30 orders within
four-comparison capacity. `round2/logs/prefix_count.json` gives every split.
These are finite counting checks on the stated prefix states.

## Round 2 final results

No program with core k <= 31 passed the strict judge in round 2. The runs below are complete. This final record supersedes the earlier progress counts.

### New routing searches at k=31

Each of 1,224 new exact value skeletons received a 400,000-call pass. That pass returned 1,021 NONE results and 203 call limits. Each of the 203 unresolved cases then received a 2,000,000-call pass with a 20 s time limit. No search returned FOUND.

| Second-pair family | Distinct skeletons | Final NONE | Final limits |
| --- | ---: | ---: | ---: |
| adaptive | 960 | 918 | 42 |
| fixed | 264 | 239 | 25 |

Total: **1157 NONE**, **67 unresolved**. The logs record 457,087,630 calls across both passes, including repeated work on extended cases.

The adaptive family covers all 16 minima/maxima truth tables for comparison 3. The fixed family covers rules 0, 6, 8, 10, and 12. Each family tests six residual trees and ten orientation patterns before duplicate removal. The patterns include reversals based on previous flags and two seeded random patterns.

`round2/logs/route_batch.jsonl` and `round2/logs/retry_routes_{0,1}.jsonl` contain every result. `round2/logs/unresolved_routes.txt` lists the remaining skeletons. `round2/logs/summary.json` records the counts in machine-readable form.

### SAT register-profile results at k=31

All rows in this table returned UNSATISFIABLE. The profile gives the number of data instructions after comparisons 1 through 7. The result applies to that register limit, schedule, exact operand family, and arbitrary operand reversal model.

| Run | Registers | Data profile | Seconds |
| --- | ---: | --- | ---: |
| `partial_profile_0` | 8 | 3,3,6,3,3,3,3 | 9.2 |
| `partial_profile_1` | 8 | 4,4,6,3,3,2,2 | 4.3 |
| `physical_R6_t5_m0_fixed` | 6 | 3,3,4,4,4,3,3 | 2.9 |
| `physical_R7_t1_m0_fixed` | 7 | 3,3,5,4,3,3,3 | 3.6 |
| `physical_R7_t5_m0_adapt` | 7 | 4,3,5,3,3,3,3 | 3.1 |
| `physical_R8_t1_m6_adapt` | 8 | 4,3,5,3,3,3,3 | 4.8 |
| `physical_R8_t5_m10_fixed` | 8 | 3,3,5,4,3,3,3 | 4.9 |
| `physical_R9_t5_m12_adapt` | 9 | 4,4,4,3,3,3,3 | 5.1 |
| `prefix_heavy_0` | 6 | 3,3,6,3,3,3,3 | 3.0 |
| `prefix_heavy_1` | 8 | 3,3,6,3,3,3,3 | 4.9 |
| `prefix_heavy_2` | 7 | 3,4,6,3,3,3,2 | 2.0 |
| `prefix_heavy_3` | 8 | 4,4,5,3,3,3,2 | 2.3 |
| `prefix_heavy_4` | 9 | 4,4,6,3,3,2,2 | 2.5 |
| `prefix_heavy_5` | 9 | 4,4,6,3,3,2,2 | 2.4 |
| `prefix_heavy_6` | 8 | 4,4,5,3,3,3,2 | 2.1 |
| `prefix_heavy_7` | 8 | 3,4,6,3,3,3,2 | 2.3 |

`partial_profile_0` and `partial_profile_1` permit conditional writes into scratch registers before any unconditional write. These models track a garbage origin. They do not permit that origin in comparison operands or outputs on the 120 tested strict orders. Other profile rows require unconditional initialization.

### SAT runs that reached time limits

| Run | Seconds |
| --- | ---: |
| `adaptive_extra_select_g19` | 125.1 |
| `adaptive_extra_select_g20` | 125.7 |
| `adaptive_extra_select_g21` | 246.4 |
| `adaptive_extra_select_g22` | 125.9 |
| `adaptive_t5_allorient_exact` | 185.4 |
| `complete_adaptive_mv5` | 247.2 |
| `complete_fixed_mv5` | 248.6 |
| `fixed_t5_allorient_exact` | 186.2 |
| `flex_R6_m0_fixed` | 153.0 |
| `flex_R8_m10_adapt` | 154.2 |
| `partial_flex_R8` | 127.5 |

The two `allorient_exact` runs test one residual tree with all history-dependent operand reversals. Exact operand constraints remain on early finishing paths. The `complete_*_mv5` runs allow 72 choices per initial two-comparison history: a minima/maxima choice and two independently selected residual trees. This gives 72^4 = 26,873,856 tree-profile combinations. These runs allow at most five copies. They do not establish a negative bound.

The `adaptive_extra_select_g*` runs fix a prefix that copies input 3, conditionally selects input 4 from the first flag, and compares input 2 with that selected value. The solver can add other data operations before comparison 2. These runs allow 19, 20, 21, or 22 conditional moves and at most 24 minus that count copies. They also permit six residual tree choices per initial three-comparison history. All allow arbitrary operand reversals after the fixed prefix.

The `flex_*` and `partial_flex_R8` runs permit at most eight data instructions after each comparison and at most 24 data instructions in total. SAT selects the schedule. The phase and register limits remain search restrictions. All three runs reached their time limits.

### Every new strict PASS file

All five new PASS files are controls with seven comparisons and core k=53. They are not target improvements.

| File | Model | Core k | Judge log |
| --- | --- | ---: | --- |
| `round2/programs/complete_control53_i0.s` | out | 53 | `round2/logs/complete_control53.log` |
| `round2/programs/flexible_control53.s` | out | 53 | `round2/logs/flexible_control53.log` |
| `round2/programs/orient_control53_i0.s` | out | 53 | `round2/logs/orient_control53.log` |
| `round2/programs/partial_control53.s` | out | 53 | `round2/logs/partial_control53.log` |
| `round2/programs/physical_control53.s` | out | 53 | `round2/logs/physical_control53.log` |

`round2/logs/judge_registry.json` stores the exact PASS lines. No new memory-model candidate was produced because no target out-model candidate passed. The round-1 PASS paths remain listed above.

### Limits and remaining choices

The negative results concern the listed exact skeletons and register profiles. They do not exclude all seven-comparison programs. The all-orientation tree-choice models and all three variable-schedule models remain unresolved. The routing limits are listed separately. Conditional scratch initialization remains open outside the two completed profiles.

Round 2 used at most two CPU search jobs with `nice -n 19`. The searches did not repeat the excluded c=8 controls, lattice searches, network classes, or completed round-1 routing skeletons.


## Round 3 (in progress)

Round 3 resumes only the 67 open round-2 routing cases and the 11 round-2 SAT timeouts. All new files are in `round3/`. The search driver permits one CPU job at a time, uses `nice -n 19`, pins the process tree to CPU 72, and sets a 2,900 MiB virtual-memory limit for each process.

Each open routing case receives up to 100,000,000 calls and 180 seconds. `round3/logs/routes.jsonl` records each result. Completed round-2 NONE cases are not repeated.

The SAT extensions keep the stated round-2 models and all 120 strict orders. New clauses forbid output snapshots before the flag history determines the input origin for that rank. The physical-register encoding also removes scratch-register name symmetry and unused-slot operand symmetry. Both encodings can fix one global operand orientation per comparison. These are search transformations, not a general lower-bound certificate. Controls and candidate programs receive the strict reference judge.

The planned new extra-select runs use 17, 18, or 23 conditional moves, with at most 24 minus that count copies. Each has seven comparisons and the same adaptive second-pair prefix as round 2.

### Round 3 routing closure

All **67** open round-2 routing cases returned **NONE at k=31**. The 42 adaptive cases and 25 fixed cases used 285,445,547 calls in this extension. The largest completed case used 12,482,342 calls. The extension took 745.745 seconds. No case reached its new call or time limit. Across the round-2 batch and these extensions, all 1,224 new round-2 exact skeletons now have a completed NONE result.

`round3/logs/routes.jsonl` contains every extension result. The matching `.route` files contain the routing-search output. This closes the stated fixed value skeletons only. It does not exclude all seven-comparison programs.

The four round-3 encoding controls passed the strict judge at k=53 with seven comparisons: `round3/programs/control_exact53_i0.s`, `round3/programs/control_union53_i0.s`, `round3/programs/control_flexible53.s`, and `round3/programs/control_partial53.s`. Their matching `.log` files contain the exact PASS lines. The first higher-limit extension, `fixed_t5_allorient_exact`, reached its 600-second solver limit and remains unresolved.

Further round-3 propagation constraints use these necessary conditions:

- Each of the seven comparison flags must control a conditional move before the next comparison replaces it. Otherwise that comparison has no effect, leaving at most six useful binary comparisons for 120 strict orders.
- Before an input origin is known from a comparison history, a register created earlier cannot supply that origin as a comparison operand. The tree-choice model enumerates permitted input pairs and adds the resulting operand-age bounds.
- When a tree choice is active, register origins agree across input orders with the same history. The implementation merges identical history classes across choices before adding guarded equalities.
- In the variable-schedule register model, an active instruction cannot copy a register to itself. Removing such an instruction preserves the 24-instruction upper budget. In the initialized-register models, the first meaningful data instruction copies an input into scratch. The conditional-initialization model keeps its broader first-instruction choices.

The later `register_sat_free.py` model makes comparison 7 operands free on histories that already identify one strict input order after comparison 6. On those histories, it computes the actual flag from the chosen register values. Scratch has a common +infinity origin in this relaxation. Its low and high conditional moves use complementary conditions `l` and `ge`. A candidate must still pass the strict judge for all weak orders and arbitrary scratch values. This model is an additional restricted search, not an unrestricted c=7 lower-bound model.

`adaptive_extra_select_g19` returned **UNSATISFIABLE** in round 3 after 347.020 seconds total, under its 600-second solver limit. It permits 19 conditional moves and at most five copies with the fixed adaptive prefix, six residual-tree choices per initial three-comparison history, arbitrary history-dependent operand reversal after the prefix, and free final comparisons on already finished paths. `round3/logs/adaptive_extra_select_g19.log` and `.solver` record the result. This closes that round-2 timeout in the stated initialized-value, paired-copy gate model. It does not exclude all seven-comparison programs.

All 11 round-2 SAT timeouts received round-3 extensions with a 600-second solver limit. `adaptive_extra_select_g19` returned UNSATISFIABLE. The other ten reached their solver limits and remain unresolved. The extensions used all 120 strict input orders. Their exact commands, elapsed times, and peak process RSS values are recorded in `round3/logs/sat.jsonl`. The new gate-budget tests follow these extensions.

## Round 3 final SAT results

No program with core k <= 31 passed the strict judge in round 3.

The batch covered 11 of the 11 round-2 SAT timeouts in 13 solver attempts. Final family results were `{'TIMEOUT': 10, 'UNSATISFIABLE': 1}`.

The table records solver results from the round-3 logs. A timeout remains unresolved. 
Every search used one CPU job, `nice -n 19`, and a per-process virtual-memory limit of 2,900 MiB.
The SAT extensions use all 120 strict input orders. The strict judge checks any decoded candidate separately.

| Run | Result | Configured limit (s) | Wall time (s) | Peak process RSS (KiB) |
| --- | --- | ---: | ---: | ---: |
| `control_exact53` | SATISFIABLE | 60 | 22.4 | 916492 |
| `control_union53` | SATISFIABLE | 60 | 25.0 | 1011220 |
| `control_flexible53` | SATISFIABLE | 60 | 16.2 | 760828 |
| `control_partial53` | SATISFIABLE | 60 | 16.4 | 759660 |
| `fixed_t5_allorient_exact` | TIMEOUT | 600 | 607.4 | 338896 |
| `adaptive_t5_allorient_exact` | TIMEOUT | 600 | 607.0 | 339232 |
| `flex_R6_m0_fixed` | TIMEOUT | 600 | 604.0 | 232616 |
| `flex_R8_m10_adapt` | TIMEOUT | 600 | 605.1 | 300964 |
| `partial_flex_R8` | TIMEOUT | 600 | 605.0 | 300560 |
| `complete_fixed_mv5` | TIMEOUT | 600 | 641.3 | 1209512 |
| `complete_adaptive_mv5` | TIMEOUT | 600 | 612.9 | 529264 |
| `adaptive_extra_select_g19` | UNSATISFIABLE | 600 | 347.0 | 299728 |
| `adaptive_extra_select_g20` | TIMEOUT | 600 | 608.5 | 319468 |
| `adaptive_extra_select_g21` | TIMEOUT | 600 | 608.5 | 339160 |
| `adaptive_extra_select_g22` | TIMEOUT | 600 | 610.7 | 359248 |
| `new_extra_select_g17` | UNSATISFIABLE | 600 | 108.7 | 263608 |
| `new_extra_select_g18` | UNSATISFIABLE | 600 | 217.6 | 281788 |
| `new_extra_select_g23` | TIMEOUT | 600 | 608.5 | 379892 |
| `control_routing53` | JUDGE_PASS | 60 | 1.8 | 14056 |
| `control_cadical53` | SATISFIABLE | 60 | 23.7 | 918940 |
| `retry_fixed_t5_cadical` | TIMEOUT | 300 | 306.8 | 468812 |
| `retry_flex_R6_cadical` | TIMEOUT | 300 | 304.1 | 232144 |
| `complete_one_select_g18` | UNSATISFIABLE | 300 | 284.3 | 397104 |
| `freecopy_complete_g18_fixed` | TIMEOUT | 300 | 308.2 | 344636 |
| `freecopy_complete_g18_adaptive` | UNSATISFIABLE | 300 | 176.1 | 344716 |
| `control_free_finished53` | SATISFIABLE | 60 | 15.8 | 760192 |
| `partial_free_finished_R8` | TIMEOUT | 300 | 308.4 | 300888 |
| `control_robust_finished53` | SATISFIABLE | 60 | 25.8 | 766688 |
| `partial_robust_finished_R8` | TIMEOUT | 300 | 305.4 | 304992 |

The round-3 encodings add necessary value-preservation constraints. Until output rank j is recorded, 
the input value for that rank must remain in some live register on every tested input order. 
The encodings also restrict each output to a conditional move that creates its value. 
A copy can use the earlier source value for its output snapshot. These clauses do not change the stated search model.

### Additional search models

- CaDiCaL retries use the fixed-pair exact-operand model and the six-register variable-schedule model. Each has a 300-second solver limit. The CaDiCaL process has a 1,800 MiB virtual-memory cap.
- The new fixed-prefix gate budgets are 17, 18, and 23 conditional moves, with at most 24 minus that count copies. Each has core k <= 31.
- `complete_one_select_g18` allows the third-comparison and residual-tree choices to vary in the adaptive-pair family. It has 18 conditional moves and at most six copies, so core k <= 31.
- The two `freecopy_complete_g18_*` runs allow 18 conditional moves with free copies. These are relaxations for their gate-count budgets. Their decoded programs can exceed k=31.
- If a free-copy run produces a program, `route_candidate.py` minimizes copies for its fixed conditional-move graph. It preserves the selected output nodes and runs the strict judge on the resulting register program.
- A new value skeleton from a free-copy candidate can receive a full k=31 routing search. The driver skips skeletons already present in earlier worker directories. `round3/logs/freecopy_routing.jsonl` records any such conditional follow-up; no file means no follow-up ran.
- `partial_free_finished_R8` permits arbitrary final operands on already finished strict-order histories. It uses eight registers, up to eight data slots per comparison phase, and at most 24 active data instructions. Scratch has a common +infinity origin in the search. Conditional writes before unconditional initialization are allowed.
- `partial_robust_finished_R8` adds a second final-flag case when a finished history compares scratch garbage. Both possible low/nonlow outcomes must give the required outputs. This is an additional restriction; it is not a complete arbitrary-garbage encoding.
- Both finished-history models use complementary `cmovl`/`cmovge` conditions and fixed remaining tree/mask profiles. These are search limits. Only a reference-judge PASS establishes candidate correctness.

### Every new strict PASS file

| File | Model | Core k | Comparisons | Judge log |
| --- | --- | ---: | ---: | --- |
| `round3/programs/control_cadical53_i0.s` | out | 53 | 7 | `round3/logs/control_cadical53.log` |
| `round3/programs/control_exact53_i0.s` | out | 53 | 7 | `round3/logs/control_exact53.log` |
| `round3/programs/control_flexible53.s` | out | 53 | 7 | `round3/logs/control_flexible53.log` |
| `round3/programs/control_free_finished53.s` | out | 53 | 7 | `round3/logs/control_free_finished53.log` |
| `round3/programs/control_partial53.s` | out | 53 | 7 | `round3/logs/control_partial53.log` |
| `round3/programs/control_robust_finished53.s` | out | 53 | 7 | `round3/logs/control_robust_finished53.log` |
| `round3/programs/control_routing53.s` | out | 53 | 7 | `round3/logs/control_routing53.log`, `round3/programs/control_routing53.judge.txt` |
| `round3/programs/control_union53_i0.s` | out | 53 | 7 | `round3/logs/control_union53.log` |
| `round3/programs/history_control53_i0.s` | out | 53 | 7 | `round3/logs/history_control53.log` |

`round3/logs/summary.json` records the routing counts, solver rows, and source hashes. 
`round3/logs/judge_registry.json` records the exact strict-judge PASS lines. 
The control programs verify encoding behavior and do not improve the known bound. 
No solver timeout establishes a negative bound. The completed routing results apply only to their exact skeletons.

## Round 3 final free-copy follow-up

The 18-gate adaptive free-copy model returned UNSATISFIABLE. One follow-up increased that budget to 19 conditional moves.
The follow-up allows free copies, arbitrary history-dependent operand reversal, and 72 third-comparison/residual-tree choices per initial two-comparison history. The prefix implementation is free.
`freecopy_complete_g19_adaptive` returned `TIMEOUT` with a 300-second solver limit. Total wall time was 316.290 seconds. Peak process RSS was 360044 KiB.
This is a gate-budget relaxation. Any decoded program has its real copy cost assigned and its new value skeleton considered at k=31. Earlier skeletons are skipped.
The result is recorded in `round3/logs/freecopy_complete_g19_adaptive.log` and `round3/logs/followup.jsonl`.

No additional strict PASS file was produced.

A timeout gives no negative bound. The result applies to the stated flag-profile family.
No program with core k <= 31 passed the strict judge in round 3.

## Round 3 final audit

The round-3 search batch is finished. No program with core k <= 31 passed the strict judge.

- All 67 inherited routing cases returned NONE. The extension used 285,445,547 calls. All 1,224 round-2 value skeletons now have a completed NONE result.
- The 11 inherited SAT cases received 13 attempts across two solvers. One case returned UNSATISFIABLE. Ten cases remain unresolved.
- Across the recorded SAT and control runs, five query families returned UNSATISFIABLE. There were 17 timeout attempts. Duplicate solver attempts account for two of those timeouts.
- Fifteen query families remain unresolved: ten inherited families and five new families. `round3/logs/unresolved_sat.json` lists the inherited families. `round3/logs/open_queries.json` lists all fifteen families.
- Nine control files passed the strict judge. Each has seven comparisons and core k=53. Every path and exact PASS line is recorded above and in `round3/logs/judge_registry.json`.

All search processes exited. No unfinished CNF file remains. The source hashes match the saved files. `round3/logs/audit.json` records the final counts. The observed peak process RSS was 1,209,512 KiB. Searches used one CPU job at a time with `nice -n 19`.

No timeout establishes a negative bound. The completed NONE and UNSATISFIABLE results apply only to their stated search models.

## Round 4: append-only insertion after sort4

No program with core k <= 31 passed the strict judge in this round.

### Purpose and scope

The new task was an insertion of the fifth value after a 20-instruction sort4 program.
The insertion budget was at most 11 instructions. The sort4 prefix cannot read P4.
The instruction count includes every comparison, copy, and conditional move.

w7 had no RESULTS.md when this round started. Its BRIEF.md named the nine-order
near miss. Its seeds/ directory already contained near31.s and repair32.s. Its
run.log recorded the strict-judge failure of that seed. Thus w7 had taken that
repair task. This worker used the insertion direction and did not repeat it.

### Method

The complete collection scan read
`agents/upper/runs/r4/s4k20_coll.txt.gz`.
It counted **1,477,893 programs** and **20,126 final-state classes**.
The classifier evaluates all 24 strict orders of four inputs. A class records
all written register columns, with duplicate columns retained, and the last
comparison flags. Register names do not affect the class. The classifier gives
all initial scratch registers one common value above the inputs. These are
classes for that test assignment, not classes of full arbitrary-garbage behavior.
See `round4/logs/classify_complete.log` and `round4/logs/raw_classes.tsv`.

The first classification attempt wrote many representative files and was stopped.
The complete pass disabled representative writes. It used 21.67 CPU seconds,
34.48 wall seconds, and a maximum process RSS of 9,592 KiB. The optional
input-renaming class merger was not run. It was no longer needed for the bound.

A common relaxation covers every class, so separate SAT runs per class were not
needed. The test fixes the first four inputs in increasing order. It places P4
in each of its five possible strict positions. The initial value pool contains
all four sorted inputs, P4, and a common scratch value above every input.
Copies are free. Values remain available after conditional moves. Every
conditional move can create a fresh register. Outputs can use any earlier value.
Thus the relaxation has no physical register limit. It also permits conditional
writes that retain scratch garbage on some of the five test inputs.

The relaxation covers an actual prefix as follows. Set every initial scratch
register to 5, and use distinct input ranks 0 through 4. This is one permitted
assignment under strict correctness. Because the prefix does not read P4, each
prefix register has one fixed input origin, or the scratch origin, across the
five insertion positions. The common value pool already contains every such
origin. The final prefix flag is constant across these five positions. Before
the first new comparison, a conditional move can therefore only copy a value or
leave it unchanged. Free copies cover those effects.

`round4/src/select_bound.py` first tests the number of conditional moves alone.
Each gate selects two earlier values. Its predicate can vary independently on
each of the five test inputs. No comparison must implement that predicate.
This is a further relaxation. Seven gates returned UNSATISFIABLE. An eight-gate
linear-insertion control returned SATISFIABLE. Its decoded circuit passed the
independent circuit evaluator. This circuit check is not a reference-judge PASS.

At least three new comparisons are needed to distinguish five insertion
positions. Within one comparison history, each register has a fixed input
origin. A comparison can split that history into at most two new histories.
Equality between copies is constant on that history. Thus two comparisons
cannot distinguish all five positions.

The only remaining budget at 11 instructions is therefore three comparisons,
eight conditional moves, and zero copies. `round4/src/insertion_sat.py` tests
this case with free copies and arbitrary comparison operands. It permits all
four I1 conditional moves. The first comparison must compare P4 with one of the
four sorted values. All four first pivots were tested. No value-reversal
symmetry is used in the final query, because the scratch relaxation has only a
high sentinel. Reversing comparison operands and complementing their predicates
is allowed. Swapping selector operands and complementing the selector predicate
is also allowed in the free-copy model.

The later encoding uses input origins instead of numeric ranks. It adds
necessary flag-history constraints: equal histories give equal origins, all
five final histories must differ, and one remaining binary comparison cannot
separate three positions. Positive controls test both encodings.

### Results

| Query | Solver | Result | Recorded solve time (s) |
| --- | --- | --- | ---: |
| Initial three-comparison, eight-gate model | Kissat | TIMEOUT | 120.085 |
| Seven gates, free predicates | Kissat | UNSATISFIABLE | 2.745 |
| Three comparisons, eight gates, first pivots 0 and 1 | Kissat | UNSATISFIABLE | 65.070 |
| First pivot 2, origin/history encoding | Kissat | UNSATISFIABLE | 2.664 |
| First pivot 3, origin/history encoding | Kissat | UNSATISFIABLE | 1.584 |
| Seven gates, free predicates | CaDiCaL | UNSATISFIABLE | 0.867 |
| All four pivots, origin/history encoding | CaDiCaL | UNSATISFIABLE | 5.393 |
| Seven gates, certificate run | CaDiCaL | UNSATISFIABLE | 2.367 |
| All four pivots, certificate run | CaDiCaL | UNSATISFIABLE | 14.723 |

The certificate-run times include certificate checking. The complete log set
contains eight UNSATISFIABLE attempts, three SATISFIABLE controls, and one timeout.
The two circuit/model families, not the repeated solver attempts, supply the
negative bounds. No timeout supplies a negative bound.

Both final UNSAT queries have retained CNF files and DRAT certificates. DRAT is
a format for checking the steps of a SAT solver's negative result. The separate
`drat-trim` checker returned **s VERIFIED** for both certificates:

- `round4/logs/select_bound7_cert.cnf`
- `round4/logs/select_bound7_cert.drat`
- `round4/logs/select_bound7_cert.drat_check`
- `round4/logs/ordered_all_c3g8_cert_i0.cnf`
- `round4/logs/ordered_all_c3g8_cert_i0.drat`
- `round4/logs/ordered_all_c3g8_cert_i0.drat_check`

The certificate runs used maximum process RSS values of 67,124 and 85,844 KiB.
The checks validate those CNF results. They do not by themselves validate every
step of the reduction from assembly programs to the CNF model.

Reproduction commands, run from this worker folder with one job at a time:

```sh
nice -n 19 taskset -c 72 python3 round4/src/select_bound.py --gates 7 --tag select_bound7_cert --solver cadical --timeout 120 --proof
nice -n 19 taskset -c 72 python3 round4/src/insertion_sat.py round4/classes/ordered_empty.s --tag ordered_all_c3g8_cert --comparisons 3 --data 8 --free-copies --all --ordered-first4 --ordered-normalize --origin --history --solver cadical --timeout 600 --proof
```

### Every new strict PASS file

All five files are controls. None improves k=32. For the memory model, Length
includes five loads and five stores. The other lengths are core k.

| File | Model | Length | Comparisons | Judge record |
| --- | --- | ---: | ---: | --- |
| `round4/programs/linear_control36.s` | out | 36 | 9 | `round4/logs/linear_control36.judge` |
| `round4/programs/real_control36_i0.s` | out | 36 | 9 | matching `.s.judge.txt` and `round4/logs/real_control36.log` |
| `round4/programs/linear_control46_mem.s` | mem | 46 | 9 | `round4/logs/linear_control46_mem.judge` |
| `round4/programs/binary_control49.s` | out | 49 | 8 | `round4/logs/binary_control49.judge` |
| `round4/programs/binary_origin_control49_i0.s` | out | 49 | 8 | matching `.s.judge.txt` and `round4/logs/binary_origin_control49.log` |

Each file has an exact reference-judge PASS with `--strict`. The binary control
uses the three insertion comparisons: P4 against the second sorted value,
against a first/third-value pivot, and against the fourth sorted value. It also
tests the origin/history encoding. `round4/logs/judge_registry.json` records every
exact PASS line. The two suffix-only `.s` files are templates, not complete
sorting candidates. `round4/logs/summary.json` records counts and source hashes.

### Limits and assumption tags

The SAT results exclude an **append-only insertion with at most 11 instructions**
in the stated relaxation. Since that relaxation gives more freedom than the
actual suffix, it covers all 20,126 final-state classes from the collection.
For this construction, sort4 k=20 plus an appended insertion therefore cannot
produce sort5 k<=31. The implied insertion lower bound is 12 instructions.

This is not a general sort5 optimality result. Instructions that use P4 before
the sort4 prefix ends are outside the result. Interleaving insertion work with
the sort4 instructions remains open. The result does not establish an actual
12-instruction insertion for a concrete prefix.

Assumption tags: G1-G4 define the target instruction set and correctness model.
The new restriction is an append-only prefix that never reads P4. The suffix
search has no A2/A7 physical register cap. It fixes neither an A4 value skeleton
nor an A8 value pool from a comparator network. Intermediate selectors and
comparison operands are free, including non-lattice values and partial scratch
values in the stated relaxation. These results do not contradict a listed
assumption. No general claim is made about arbitrary seven-comparison programs.

All CPU jobs used `nice -n 19`, CPU 72, and one job at a time. Solver processes
had a 2,900 MiB virtual-memory limit. All measured memory values were below
3 GB. All processes from the round have exited. No target candidate was found.

## Round 5: replace the last six sort4 instructions (in progress)

The fixed prefix now contains the first 14 register instructions of each
20-instruction sort4 program. Free `out` records do not count as instructions.
The remaining 17 instructions replace the six-instruction sort4 tail and add
11 insertion slots. The prefix never reads P4. The suffix can read P4 at any
slot. This is a new interleaving search; it does not repeat round 4.

`round5/src/classify_prefix.cpp` scanned all 1,477,893 collection programs.
It found 14,514 prefix-state classes after instruction 14. Each state key
retains duplicate register columns and the final comparison flags across all
24 strict orders of four inputs. The scan used one common high scratch value.
It used 24.61 wall seconds and peak RSS 7,080 KiB. The logs are
`round5/logs/classify.log` and `round5/logs/classify.time`.

`round5/src/merge_classes.py` merged these keys under input renaming, register
renaming, and final-flag reversal. It found 1,815 representative state classes:
198 with three prefix comparisons, and 1,617 with four prefix comparisons.
No value-order reversal is used. These are equivalence classes for the stated
strict-order relaxation, not for every weak order or scratch assignment.
`round5/logs/classes.json` stores all representative paths and multiplicities.
`round5/logs/raw_class_map.json` stores the class mapping.

`round5/src/interleave_sat.py` selects every suffix operand and instruction
phase. It permits all four conditional moves and unbounded new registers.
A copy creates a new value node. A conditional move consumes its default node.
Free outputs can record any historical value. This routing model excludes new
reads of untouched scratch registers. Existing scratch values from the fixed
prefix remain available. The strict search uses all 120 input permutations;
smaller test sets supply a relaxation for counterexample-guided search.
Optional history constraints require equal origin values on equal histories.

The fixed positive control decoded to `round5/programs/control36_i0.s`.
The reference judge returned:

```text
PASS /path/to/repo/agents/team/codex-fleet/w3/round5/programs/control36_i0.s [relaxed+strict] n=5 L=36 R=119 iset=I1 model=out
```

Its exact judge record is `round5/programs/control36_i0.s.judge.txt`.
It is an encoder control, not a target improvement.

All new CPU jobs run one at a time with `nice -n 19` and CPU 72 affinity.
The Python search drivers set a 2,900 MiB virtual-memory limit.
Limited searches remain unknown. Final search counts will be appended below.
Assumption tags: G1-G4; a fixed 14-instruction prefix is an explicit local
restriction related to A11. The free suffix has no A4 fixed value skeleton,
A8 term pool, or A2/A7 physical register cap. New reads of untouched scratch
registers remain outside the physical-routing search (A15).

### Round 5 encoding extensions and finite prefix checks

`round5/src/preflight.py` found 603 merged classes with a lost input value
on at least one strict four-input order. Those classes account for 213,484
collection programs. For a fixed prefix that never reads P4, no final sort5
output can be recorded before the prefix ends: every output position can hold
P4 on some insertion position. If the prefix then loses one of the other four
inputs, mov/cmp/cmov cannot recreate it. New scratch reads do not repair this
failure on the permitted assignment where every scratch value is above all
inputs. This finite check excludes those fixed prefixes, not all sort5 programs.
The 1,212 remaining classes all need at least four suffix comparisons on the
largest common initial-state group. See `round5/logs/preflight.json` and
`round5/logs/preflight_summary.json`.

The new `--preserve` constraints require each input value to remain in a live
register until a free output records it. The new `--scratch` model permits
unlimited fresh scratch defaults. It gives every initial scratch register the
same high sentinel. A conditional move with this default creates a fresh
register without a copy instruction. A persistent sentinel source models any
new untouched scratch read on that one permitted assignment. Other defaults
consume their physical value node as before. This is a relaxation of arbitrary
scratch behavior, not a restriction to initialized registers. Its negative
results can cover garbage-partial programs for the chosen fixed prefix. Its
SAT candidates still need the strict judge.

Two additional controls passed the strict reference judge:

- `round5/programs/preserve_control36_i0.s`: out model, k=36.
- `round5/programs/scratch_control37_i0.s`: out model, k=37. It uses two
  complementary conditional writes to initialize one new scratch register.

Each exact PASS line is in the matching `.s.judge.txt` file. The controls test
new encoding behavior. Neither control improves the known k=32 result.
The earlier physical-routing scratch restriction does not apply to queries
that set `--scratch`. Such queries do not rely on A15 scratch elimination.

### Round 5 checked selector bound for class 21

The independent class audit returned PASS. It checked every one of the 14,514
saved raw classes with explicit row permutations, rather than the byte-table
method used by the merger. It confirmed all 1,815 merged-class mappings and all
lost-input labels. There are 4,695 raw lost-input classes. Their multiplicities
sum to the same 213,484 collection programs. See
`round5/logs/prefix_audit.json` and `round5/logs/prefix_audit.log`.

`round5/src/gate_bound.py` adds a selector relaxation after the fixed prefix.
Every selector can have a separate, arbitrary predicate on each of the 120
strict input orders. Copies are free. Every historical value remains available.
The initial pool contains every current prefix register and a common high
scratch sentinel. A selector can therefore use a fresh scratch default.
The model has no physical register cap or fixed comparison skeleton.

The positive circuit control used the real 22-instruction suffix of the strict
k=36 control, with copies made free. Its 12-selector encoding returned SAT.
The independent circuit evaluator accepted all 120 outputs. This circuit check
is not an additional reference-judge PASS file.

For representative class 21 (`round5/classes/p37.s`), **eight selectors returned
UNSATISFIABLE**. The class covers 76,066 collection programs. The solver and
certificate check took 63.340 seconds in total. The separate `drat-trim` checker
returned `s VERIFIED`; its recorded verification time was 19.455 seconds.
The retained files are:

- `round5/logs/class21_gate8.cnf`
- `round5/logs/class21_gate8.drat`
- `round5/logs/class21_gate8.drat_check`
- `round5/logs/class21_gate8.log`

Thus this fixed-prefix class needs at least nine new conditional moves, even
with the stated free-copy/free-predicate relaxation. In a 17-instruction suffix,
this excludes four new comparisons plus at least five copies, and five new
comparisons plus at least four copies. It does not exclude every 17-instruction
suffix for this class. The certificate validates the CNF result; the reduction
from assembly programs to this relaxation still relies on the stated model.
Assumption tags: G1-G4, fixed-prefix restriction (A11). A4/A8 fixed skeleton and
term-pool restrictions are absent. The common-high scratch relaxation covers
arbitrary-scratch correct programs on one required assignment (no A15
scratch-elimination assumption).

## Round 5 final results

**No program with core k <= 31 passed the strict judge.** All round-5 search
jobs have exited. Limited searches remain unknown.

### Final class and bound checks

The scan covered 1,477,893 sort4 programs. It produced 14,514 raw states after
instruction 14 and 1,815 merged state classes. The independent mapping audit
accepted every saved raw state and every merger witness.

- **603 merged classes**, or **213,484 collection programs**, lose an input
  value before any instruction reads P4. The stated fixed prefixes cannot be
  completed into a correct sort5 program. There are 1,212 preserved-input
  classes left for the interleaving search.
- The checked eight-selector UNSAT result for class 21 transfers to **16 of
  those 1,212 classes**, covering **378,763 collection programs**. Each class
  needs at least nine new conditional moves in the free-copy/free-predicate
  relaxation. This is a data-instruction bound, not a k=31 exclusion.
- The transfer ignores duplicate register columns and the final prefix flags.
  It uses an explicit input renaming that maps each initial value pool into
  the checked class-21 pool. `round5/logs/gate_bound_transfer.json` records all
  16 witnesses. A separate direct simulation checked each pool inclusion on
  all 120 five-input permutations. It returned PASS in
  `round5/logs/gate_bound_transfer_audit.json`.

For each of the 16 covered classes, a 17-instruction completion can have only
these comparison/copy budgets. These are necessary budgets, not realizable
programs or completed exclusions.

| New comparisons | Maximum new copies (mov) |
| ---: | ---: |
| 4 | 4 |
| 5 | 3 |
| 6 | 2 |
| 7 | 1 |
| 8 | 0 |

At least four comparisons are needed by the initial-state counting check.
At least nine conditional moves are needed by the transferred selector bound.
The other 1,196 preserved-input classes have only the older, universal
8-conditional-move bound from round 4.

### Search counts and dead ends

CNF means conjunctive normal form, a format for Boolean constraints.
The solver logs contain **53 queries and 55 solver attempts**. Two queries
produced a partial-test SAT candidate and then received a new attempt with
counterexamples. The attempt counts are 46 TIMEOUT, 2 UNSATISFIABLE,
6 SATISFIABLE, and 1 invalid UNKNOWN. The two UNSAT results are the new
checked selector bound and a budget conflict with an existing bound.

| Search family | Scope | Final recorded outcomes |
| --- | --- | --- |
| `pilot` | 2 classes; 4 or 5 new comparisons; all 120 strict permutations | 4 timeouts, 60 s per solve |
| `cegis` | 8 classes; 4 or 5 new comparisons; 20 initial tests | 16 timeouts, 30 s per solve |
| `live_ordered` | class 21; 4 or 5 new comparisons; five initial insertion orders | 2 partial-test SAT candidates, both strict-judge FAIL; 2 later timeouts at 60 s |
| `structured` | class 21; exact copy budgets or fixed data schedules | 18 timeouts at 30 s; 1 derived budget UNSAT; 1 invalid query |
| `zero_copy_retry` | class 21; 4 new comparisons; zero copies; all 120 permutations | timeout at 120 s |
| `highcmp` | class 21; 6, 7, or 8 new comparisons; all 120 permutations | 3 timeouts at 45 s |
| `class21_gate8` | 8 selectors; free copies and predicates | UNSAT; DRAT checker returned `s VERIFIED` |
| `class21_gate9` | 9 selectors; same relaxation | timeout at 120 s |
| `class21_gate10` | 10 selectors; same relaxation | timeout at 90 s |
| Positive controls | 3 assembly encodings and 1 free-selector circuit | 4 SAT results; checks described above |

The free-schedule search selects every comparison operand, every conditional
move condition, every data operand, and the number of data instructions between
comparisons. It does not fix a comparison-value skeleton or a network term pool.
The fixed-schedule queries use these additional data profiles, where the first
entry counts data instructions before the first new comparison:

- Four new comparisons: `2,3,3,3,2`; `1,3,3,3,3`; `3,3,2,3,2`;
  `2,2,3,3,3`; `0,4,3,3,3`.
- Five new comparisons: `2,2,2,2,2,2`; `1,2,3,2,2,2`; `0,3,3,2,2,2`.

All eight fixed-schedule queries timed out. No result closes their remaining
feasible copy budgets. The new selector bound does close the earlier class-21
four-comparison/five-copy and five-comparison/four-copy subfamilies, despite
those physical-routing queries having timed out.

The two decoded k=31 candidates failed the strict judge. The independent
strict-permutation evaluator counted 96 and 106 failing permutations. They are:

- `round5/programs/live_ordered_cl21_p37_c4_i0.s`
- `round5/programs/live_ordered_cl21_p37_c5_i0.s`

Each candidate has its exact reference-judge FAIL in the matching
`.s.judge.txt` file. Neither candidate is a near solution or a FOUND result.

### Invalid query and correction

The first `structured_cl21_c4_mv0` CNF had an incorrect variable count.
A unit-only copy-count constraint returned a smaller variable count than the
existing encoding. The driver used that smaller count in the CNF header.
CaDiCaL rejected the file before search. Its error is retained in the matching
`_i0.solver` file. That UNKNOWN entry supplies no result.

The driver now keeps the maximum of the existing and returned variable counts.
`zero_copy_retry` ran the corrected model and reached its 120 s limit.
The invalid attempt is excluded from every negative claim.

### Every new strict PASS file

These are the three new assembly controls. Each has nine comparisons.
Their Length values are core k in the out model. None improves k=32.

| File | Model | Length | Exact judge record |
| --- | --- | ---: | --- |
| `round5/programs/control36_i0.s` | out | 36 | matching `.s.judge.txt` |
| `round5/programs/preserve_control36_i0.s` | out | 36 | matching `.s.judge.txt` |
| `round5/programs/scratch_control37_i0.s` | out | 37 | matching `.s.judge.txt` |

`round5/logs/judge_registry.json` records all five complete assembly files:
three PASS controls and two FAIL candidates. Suffix-only files are templates.
No target passed, so no target memory program was produced.

### Limits and retained records

The new exclusions concern fixed 14-instruction prefixes. The selector bounds
permit more freedom than an actual completion. A timeout excludes nothing.
The 1,212 preserved-input classes remain open at k=31. The largest tested
class has no completed physical-routing exclusion for its remaining feasible
budgets. The 9- and 10-selector queries also remain open.

Assumption tags: G1-G4 define the instruction and correctness model. The fixed
prefix is a local restriction related to A11. The free suffix has no A4 fixed
value skeleton, A8 comparator-network term pool, or A2/A7 physical register cap.
Scratch-enabled physical queries and the selector bounds use a common-high
scratch assignment as a relaxation. They require no A15 scratch-elimination
assumption. No listed assumption was contradicted. No
`ASSUMPTION CHALLENGED` finding was established.

Every CPU job ran with `nice -n 19`, CPU 72 affinity, and one CPU job at a time.
The search drivers used a 2,900 MiB virtual-memory limit. The largest observed
process RSS was 341,380 KiB. The largest recorded parent-plus-child RSS bound
was 583,808 KiB. All observed memory use was below the 3 GB job limit.

`round5/logs/query_registry.json` records every solver attempt.
`round5/logs/summary.json` records counts, memory observations, and hashes of
all final retained source files. The historical query logs show which encoding
features were enabled at each run. Only the completed `class21_gate8` DRAT
certificate is used as a new checked negative result. Partial certificates
from time-limited runs supply no negative bound.

Reproduction commands, run from this worker folder, one job at a time:

```sh
nice -n 19 taskset -c 72 python3 round5/src/gate_bound.py round5/classes/p37.s --gates 8 --tag class21_gate8_reproduce --timeout 120 --proof
nice -n 19 taskset -c 72 python3 round5/src/interleave_sat.py round5/classes/p37.s --tag interleave31_reproduce --comparisons 4 --all --history --preserve --scratch --minimum-gates 9 --timeout 120
```

The temporary uncompressed collection was removed after classification.
The original compressed collection remains unchanged. All round-5 queues are
finished. No program with core k <= 31 passed the strict judge in this round.

## Round 6 (in progress): longer Kissat runs and recomputation

This round resumes open round-5 queries. It does not repeat completed NONE or
UNSAT results. The first query gives the class-21 nine-selector relaxation a
1,200-second Kissat limit. A selector is one conditional move with a predicate
that can vary freely on each test. Copies remain free in this relaxation.
The next queries will test physical routing and seven-comparison prefix classes
with recomputation allowed. All new files are under `round6/`.

Every CPU search runs with `nice -n 19`, one CPU job at a time, CPU 72 affinity,
and a 2,900 MiB virtual-memory limit. A limited search remains unknown.
Assumption tags: G1-G4; the fixed prefix is a restriction related to A11.
The suffix does not use an A4 fixed comparison skeleton, an A8 term pool, or an
A2/A7 register limit. Common-high scratch values give a relaxation of arbitrary
scratch behavior, so the query does not require A15 scratch elimination.

### Round 6 checked selector bounds (first results)

The unchanged class-21 nine-selector query reached its 1,200-second Kissat limit.
It remains unknown in that encoding. The new output-selector ordering then
resolved both nine and ten selectors:

| Query | Result | Solve plus certificate-check seconds |
| --- | --- | ---: |
| `class21_gate9_sinks` | UNSATISFIABLE; certificate VERIFIED | 4.749 |
| `class21_gate10_sinks` | UNSATISFIABLE; certificate VERIFIED | 91.663 |

The output-selector transformation is stated in `round6/METHOD.md`. It uses
free predicates and free copies. It does not reorder physical assembly
instructions. A separate finite audit checked the saved 12-selector positive
circuit and a 26-selector circuit with fourteen outgoing output edges. Both
kept all 120 strict-order outputs. See `round6/logs/sink_transform_audit.json`.
The general reduction uses the rank-trace argument, not that finite check.

The new checked bound is **at least eleven suffix conditional moves** for
class 21 in this relaxation. The CNF and DRAT files have matching stems under
`round6/logs/`. Each `.drat_check` file contains `s VERIFIED`.
The old pool-inclusion witnesses transfer this bound to the same sixteen
classes covered by the round-5 eight-selector certificate. That transfer
ignores duplicate initial columns and final prefix flags, because copies and
predicates are free. It does not exclude k<=31 by itself.

Within a 17-instruction suffix, the eleven-selector bound leaves these necessary
budgets: four comparisons and at most two copies; five comparisons and at most
one copy; or six comparisons and no copies. Seven or more suffix comparisons
are excluded for these sixteen fixed prefixes by this bound and the total
instruction budget. The remaining budgets require routing checks.

The new repeated-comparison encoding control passed the strict judge:
`round6/programs/repeat_control37_i0.s`, out model, k=37, ten comparisons.
Its exact PASS is in the matching `.s.judge.txt` file. The two data-instruction
controls returned SAT and passed independent circuit evaluation. Those circuit
checks are not additional assembly PASS files. No target PASS was produced.

Assumption tags: G1-G4; fixed-prefix restriction related to A11. No A4 fixed
suffix skeleton, A8 network pool, or A2/A7 physical register cap applies. The
common-high scratch relaxation does not require A15 scratch elimination.
No listed assumption was contradicted.

### Round 6 data-instruction queries (in progress)

`class21_data13` reached its 1,200-second limit. It remains unknown. It counts
13 physical data instructions, makes selector predicates free, and retains
its original nine-selector minimum. It started before the eleven-selector
bound was available. The recorded peak Python and child RSS values were
56,788 and 66,940 KiB.

`class21_data13_no_output_reads` is a separate query. It uses the checked
minimum of eleven selectors and removes reads from selected output nodes.
The reduction keeps each output in place. It replaces an outgoing source by
the persistent high scratch value. It replaces an outgoing default by a new
high scratch register. A resulting self-cmov can become a same-cost mov.
No selected trace to another rank uses any removed edge. This is a reduction
for free selector predicates, not a change to the actual instruction model.
See `round6/METHOD.md` for the argument.

The positive `data_output_control19` query returned SAT in 0.097 seconds.
It includes four replaced output edges, copies, scratch defaults, and a
self-cmov replacement. The independent circuit evaluator checked output
values and physical node availability on all 120 strict permutations.
This is a circuit check, not an additional assembly strict-judge PASS.
The strengthened 13-instruction query is still running.

### Round 6 relaxed 13-instruction witness

`class21_data13_no_output_reads` returned **SATISFIABLE** in 761.921 seconds.
The independent circuit evaluator accepted every output and every physical
node-availability condition on all 120 strict permutations. The witness has
**13 conditional moves and zero copies**. Its peak Python and child RSS values
were 57,528 and 68,012 KiB.

The witness is `round6/logs/class21_data13_no_output_reads.graph.json`.
Its predicates are free, so it is not an I1 assembly program and has no
reference-judge PASS. This result leaves the 13-data-instruction relaxation
open. It supplies no k<=31 result.

A new fixed-data query will keep this witness's operation order, operands,
value columns, and output nodes. It will select four actual comparisons, their
schedule, and all I1 conditional-move conditions. If it returns UNSAT, that
result will concern only the fixed data circuit. A decoded assembly candidate
will receive the strict reference judge. The separate eleven-selector
free-copy query is currently running.

### Round 6 actual-comparison checks for the relaxed witness

The eleven-selector free-copy query reached its 1,200-second limit. It remains
unknown. The checked lower bound is still eleven conditional moves. The
12-selector positive circuit also mapped into the class-21 initial pool under
the existing input-renaming witness. Its fixed output-selector encoding returned
SAT in 0.065 seconds and passed independent circuit evaluation. See
`round6/logs/sink_reference12.log`.

The zero-copy 13-cmov witness then received two actual-comparison checks:

| Query | Scope | Result | Solve plus certificate-check seconds |
| --- | --- | --- | ---: |
| `reify_class21_data13` | fixed data order, operands, values, and outputs; four new comparisons | UNSAT; certificate VERIFIED | 4.841 |
| `reify_class21_free_order` | same data graph; any instruction order that respects dependencies and register availability | UNSAT; certificate VERIFIED | 205.316 |

Both queries selected the actual comparison operands, comparison schedule, and
all four I1 cmov conditions. The second query used a permutation of the thirteen
data tasks. The queries exclude only implementations of this fixed data graph.
They do not exclude another thirteen-cmov graph or another suffix budget.
Assumption tags: G1-G4, fixed data graph (A4), and fixed prefix related to A11.
There is no physical register cap (A2/A7). Common-high scratch remains a
relaxation; A15 scratch elimination is not required.

New assembly controls passed the strict judge:

- `round6/programs/repeat_capacity37_i0.s`: k=37, ten comparisons. It checks
  the new comparison-history capacity and origin-sharing clauses.
- `round6/programs/reify_control36.s`: k=36, nine comparisons. It checks the
  fixed-data actual-comparison encoding against the known control circuit.

Each exact PASS is in the matching `.s.judge.txt` file. These are controls,
not target improvements. The separate instruction-permutation control is
queued before the next broad routing solve. No k<=31 assembly candidate was
produced by the fixed-data checks.

### Round 6 queue correction and additional fixed-data limit

The first broad class-21 query with four new comparisons reached its
1,200-second solver limit. It remains unknown. Its 1,467.607-second total job
time also includes controls and the fixed-data checks. Its recorded maximum
process RSS was 473,404 KiB.

One attempt to start the five-comparison class-21 query had an indentation
error in the setup code. No solver started. The invalid log is retained as
`round6/logs/retry_cl21_p37_c5.failed1.log`. The queue journal keeps its nonzero
return code and empty result list. It supplies no result or negative bound.
The setup code was corrected and all new Python files passed compilation.
The resumed queue skips completed attempts and retries failed setup attempts.

The following new controls passed the strict judge. Each has a matching
`.s.judge.txt` file:

- `round6/programs/repeat_useful37_i0.s`: k=37, ten comparisons. It checks the
  minimum of four used suffix comparison results.
- `round6/programs/reify_order_control36.s`: k=36, nine comparisons. It checks
  the data-task permutation variables.
- `round6/programs/reify_weak_control36.s`: k=36, nine comparisons. Its encoding
  includes all 120 strict permutations and twenty sampled weak orders. The
  separate reference judge accepted all strict requirements.

A five-comparison fixed-data extension then tested a possible new k=32 seed.
Its budget would have been nine comparisons, twenty conditional moves, and
three copies. The query kept the same thirteen-cmov graph, allowed instruction
reordering, and prohibited comparisons with untouched scratch. It included
all 120 strict permutations and twenty weak orders.
`reify_class21_c5_seed32` returned UNSATISFIABLE in 343.465 seconds, including
certificate checking. Its `.drat_check` contains `s VERIFIED`. This closes that
fixed-graph, five-comparison, initialized-comparison subfamily. It does not
exclude every k=32 program with that budget, or every k<=31 completion.
Assumption tags: G1-G4, fixed data graph (A4), fixed prefix related to A11, and
an explicit prohibition on new untouched-scratch comparison operands (A15).
No new budget or assumption challenge was established.

### Round 6 memory and next data bound

`round6/programs/reify_release_control36.s` passed the strict reference judge
at k=36 with nine comparisons. Its matching `.s.judge.txt` records the PASS.
The local solver wrapper now releases its in-memory clause list after writing
the CNF file. The positive control confirms that decoding still works. Its
recorded Python and child peak RSS values were 366,244 and 159,564 KiB.

The five-new-comparison broad class-21 query reached its 1,200-second solver
limit. It remains unknown. Its 1,616.403-second total job time also includes
controls and the separate fixed-data seed query. The six-comparison broad
query is now running. The next data-only query will test twelve instructions,
with at least eleven selectors and the no-output-read reduction. It has a
1,200-second Kissat limit and retains a DRAT certificate if it returns UNSAT.
A limited run will remain unknown.

### Round 6 class-21 routing status and twelve-data timeout

`class21_data12_no_output_reads` reached its 1,200-second limit. It remains
unknown. Its Python and child peak RSS values were 53,252 and 64,872 KiB.
The free-condition thirteen-data witness remains the smallest physical data
circuit found in this round; twelve data instructions are not excluded.

All five inherited broad class-21 routing budgets received their new result:

- Four, five, and six new comparisons: each reached its 1,200-second solver
  limit. These three cases remain unknown.
- Seven and eight new comparisons: UNSATISFIABLE by the transferred minimum
  of eleven conditional moves. Their 17-instruction suffixes have only ten
  or nine data slots. These are derived budget conflicts, not new independent
  physical-routing lower-bound certificates.

The seven-comparison job's 1,206.836-second total time includes the separate
1,200-second twelve-data query. Its own budget-conflict solve was immediate.
The eight-comparison job took 8.140 seconds including encoding and setup.
The six-comparison job took 1,220.992 seconds including setup and its control.

The live checkpoint reports five completed routing budgets out of nineteen.
It records twenty-seven solver queries so far: thirteen SAT results, seven
UNSAT results, and seven timeouts. Five UNSAT certificates passed the separate
DRAT checker. Seven assembly controls passed the strict reference judge.
No k<=31 assembly candidate passed. `round6/logs/summary.json` and the matching
query and judge registries hold the checkpoint. The checked maximum process
RSS is 473,644 KiB. The recorded parent-plus-child RSS bound is 930,728 KiB.

The team status board was checked again. It reports no k<=31 candidate. The
remaining fourteen inherited routing budgets and four recomputation queries
stay in the serial queue. Each new solve has a 1,200-second limit.

### Round 6 comparison exclusion and equality-based recomputation

Later queries with at most eight total comparisons require a comparison
operand outside the min/max terms, unless the fixed prefix already supplies
one. This condition reuses the completed exclusion supplied in the brief
(E7, A12 scope). It is not a new independent exclusion of the lattice region.
`--no-cmp-escape` disables the condition for reproduction comparisons.

`cmp_escape_audit` passed ten property-encoding fixtures in numeric-rank and
input-origin modes. The fixtures include lattice columns, a non-lattice partner
column, scratch, and the comparison columns of the already verified seven-
comparison reference. It also accepted 500 generated min/max columns.
`round6/logs/cmp_escape_audit.json` records the checks. This property audit
produced no assembly candidate or additional strict-judge PASS.

The repeated-comparison family now permits all six permutations of less,
equal, and greater on the strict test rows. The original sign-only family
permitted two permutations. Comparing max(a,b) with a can recover the old
binary decision through equality; it needs the larger family. The optional
`--repeat-mode sign` retains the earlier restriction. Weak orders use the
actual instruction semantics and final strict judge; the state-match condition
itself uses only strict test rows.

The new control `round6/programs/repeat_state_control37_i0.s` passed the strict
reference judge at k=37 with ten comparisons. Its matching `.s.judge.txt`
records the exact PASS. The inserted comparison maps old less/greater states
to new greater/equal states. The finite flag-column check found the permutation
`[2,0,1]` and rejected identity and sign reversal. The extra comparison's flags
are replaced before any data instruction uses them, so the full control keeps
its known sorting behavior.

The checkpoint now records nine completed inherited routing budgets out of
nineteen: seven timeouts and two derived budget conflicts. It has thirty-two
search/control queries: fourteen SAT, seven UNSAT, and eleven TIMEOUT results.
Five UNSAT certificates passed the independent checker. Eight assembly
controls passed the strict reference judge. No k<=31 assembly candidate passed.
Peak process RSS is 475,408 KiB. All CPU searches still use one core and nice 19.
No listed assumption was contradicted.

### Round 6 separate graph and execution orders (queued)

The inherited retry queue has completed twelve of nineteen logical cases.
The completed new broad routing cases still have no k<=31 strict PASS.
The two class-21 budget conflicts are derived from the checked eleven-cmov
bound. Completed limited routing cases remain unknown.

The next preflight adds a different encoding of the open twelve-data bound.
It labels the free-predicate selector graph with outputs last, but gives the
physical instructions a separate execution order. A selector either consumes
a parent register after its other users or pays one mov to copy its default.
Fresh common-high scratch remains available. Initial duplicate registers stay
distinct. This change keeps early output snapshots and removes graph-label
symmetry without forcing the physical outputs to execute last.

Three positive data controls and one forced double-consumption conflict run
first. Then the queue tests twelve selectors with no copy and eleven selectors
with at most one copy. Each new bound query has a 1,200-second Kissat limit and
requests a DRAT certificate. A relaxed data witness will receive a separate
actual-comparison search at k=31. No outcome is claimed here. The method and
its copy-accounting argument are in `round6/METHOD.md`.
Assumption scope: fixed fourteen-instruction prefix (related to A11); free
per-test conditions and the all-high scratch relaxation of G3. No lattice,
fixed register-count, or scratch-elimination assumption is added.
