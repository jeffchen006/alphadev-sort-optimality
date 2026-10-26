No program with core k <= 31 has passed the strict judge.

This worker searches 8-comparison structures. All files below are in this worker folder. Search batches use at most 6 CPU cores and run with nice level 10. Verification batches use at most 8 processes. No file outside this folder was changed.

## Terms

A weak order describes the input value order, including ties. There are 541 weak orders for five inputs. A value column gives one register value for each tested order. A flag function gives the result of one comparison for each tested order.

SAT means Boolean satisfiability. The SAT search asks whether instruction choices can satisfy all encoded cases. A DAG is a directed acyclic graph. The routing search uses a DAG to describe conditional value selection and register copies.

## Verified programs

The following judge results are available. These programs do not meet the target.

- `candidates/seed33.s`: supplied seed, core 33, 8 cmp, 18 cmov, 7 mov. Strict out PASS in `logs/seed33.judge`.
- `candidates/seed_rerouted33.s`: a routing recovered by the adapted DAG search, core 33. Strict out PASS in `logs/seed_rerouted33.judge`.
- `candidates/seed33_mem.s`: seed in the memory model, total 43. Strict mem PASS in `logs/seed33_mem.judge`.
- `candidates/seed_rerouted33_mem.s`: recovered routing in the memory model, total 43. Strict mem PASS in `logs/seed_rerouted33_mem.judge`.

Judge commands:

```sh
python3 /path/to/repo/shared/judge.py candidates/seed33.s --strict --model out
python3 /path/to/repo/shared/judge.py candidates/seed_rerouted33.s --strict --model out
python3 /path/to/repo/shared/judge.py candidates/seed33_mem.s --strict --model mem
python3 /path/to/repo/shared/judge.py candidates/seed_rerouted33_mem.s --strict --model mem
```

## Methods and completed searches

### Exact routing with a fixed prefix

`src/merge_dag.cpp` adapts d1-skeleton's `dagx.cpp`. It accepts existing register value columns in `INITIAL` and earlier comparison flags in `HISTORY`. It charges only instructions after the prefix. Initial registers can contain the same column in distinct physical registers. The search uses the 120 strict permutations. A candidate still needs the strict judge on all weak orders.

The seed prefix has 15 instructions: 4 cmp, 8 cmov, 3 mov. Its merge has 18 instructions: 4 cmp, 10 cmov, 4 mov. A core of 31 needs a merge of 16 if this prefix is fixed.

Results for the seed's fixed comparison operand columns:

| Fixed prefix length | Suffix comparisons | Suffix budget | Search result | Nodes |
|---|---:|---:|---|---:|
| 15 | 4 | 16 | NONE | 24,336 |
| 15 | 4 | 17 | NONE | 207,151 |
| 15 | 4 | 18 | recovered routing | 2,277 |
| 12 | 5 | 19 | NONE | 183,479 |
| 8 | 6 | 23 | NONE | 617,155 |

Logs: `logs/merge_seed{16,17,18}.log`, `logs/prefix12_k19.log`, `logs/prefix8_k23.log`.

These are restricted routing results. They do not establish a lower bound for all 8-comparison programs. The adapted search starts with a comparison; it does not use the prefix's last flags before that comparison.

### Sort2 + sort3: merge decision trees

`src/merge_trees.py` enumerates 104 comparison trees that sort the 10 possible interleavings of two sorted groups of lengths 2 and 3 in at most four comparisons. The chosen operand columns follow original group identities on each branch. Finished branches use an equal-operand comparison as padding.

All 104 trees returned NONE at merge budget 16. All 104 returned NONE at merge budget 17. Logs: `logs/merges16.jsonl`, `logs/merges17.jsonl`.

The chosen comparison operands and padding restrict this search. Another pair of operands can produce the same flags at less cost.

### Sort2 + sort3: conditional permutations

`src/perm_search.cpp` searches four stages. Each stage compares two of five physical values and applies a permutation when the comparison is greater. The input state contains all 10 strict interleavings. After each stage, the number of distinct physical states must fit the number of remaining binary comparisons. Each stage must reduce that number. The final physical state can be any fixed order because outputs are free snapshots.

The cost of one conditional permutation is the number of moved positions plus the number of nontrivial cycles. This includes a move to save one value per cycle. This cost does not credit any saved value from earlier stages.

| Sum of permutation costs, excluding cmp | Completed paths |
|---:|---:|
| 13 | 0 |
| 14 | 2 |
| 16 | 8 |
| 18 | 22 |
| 28, enough for every permutation | 32 |

`src/perm_route.py` turns all 32 paths into fixed comparison operand columns and searches for lower routing costs with the seed's retained values. Every path returned NONE at merge budgets 16 and 17. Logs: `logs/perm_route16.jsonl`, `logs/perm_route17.jsonl`.

Limits: this model keeps five physical values and applies permutations. It excludes intermediate duplication, free output followed by value loss, and comparisons against additional saved registers. The search results are not a general lower bound.

### Conditional permutations with a shorter fixed prefix

`src/prefix_perms.py` repeats routing for all 32 conditional-permutation structures while allowing the routing search to rebuild more of the preparation. Every search below completed and returned NONE. The fixed comparison operand columns remain a restriction.

| Fixed prefix length | Suffix budget | Total core budget | Configurations | Total nodes |
|---:|---:|---:|---:|---:|
| 12 | 19 | 31 | 32 | 739,546 |
| 12 | 20 | 32 | 32 | 5,571,332 |
| 8 | 23 | 31 | 32 | 2,921,104 |
| 8 | 24 | 32 | 32 | 18,135,582 |

Logs: `logs/prefix12_perms_k{19,20}.jsonl`, `logs/prefix8_perms_k{23,24}.jsonl`.

### Sort4 + binary insertion

`src/insertion.py` enumerates all 12 five-comparison ascending sort4 networks. Each comparator retains either original operand in its scratch register, giving 32 retained-value choices per network. A prefix costs 20 instructions. Insertion has 6 binary comparison trees of depth at most 3. Four padding choices give 24 fixed operand structures.

There are 384 prefixes and 24 insertion structures: 9,216 configurations. All returned NONE at insertion budget 11, which gives core 31. All returned NONE at insertion budget 12, which gives core 32. Logs: `logs/insertion11.jsonl`, `logs/insertion12.jsonl`.

Four AlphaDev sort4 output programs were also used as prefixes. Their register cores have lengths 20, 20, 20, and 22. All 96 configurations returned NONE at total core budgets 31 and 32. Logs: `logs/alpha_insert31.jsonl`, `logs/alpha_insert32.jsonl`.

Limits: comparison operands follow selected binary trees. Prefix instructions remain fixed. The routing search does not change the sort4 computation.

### Order two sorted pairs, then insert

`src/pair_trees.py` sorts two pairs, then orders both pairs by their larger values. The prefix costs 15 instructions and uses 3 comparisons. Its remaining values have 15 possible strict orders.

The search enumerates 6 sorting trees of depth at most 4 and 6,286 trees of depth at most 5. Three choices pad each finished branch: equal operands, a known ascending pair, or the reverse pair.

- 7 total comparisons: 18 configurations. All returned NONE at suffix budgets 16 and 17.
- 8 total comparisons: 18,858 configurations. All returned NONE at suffix budgets 16 and 17.

Logs: `logs/pairs{4,5}_k{16,17}.jsonl`. The same fixed-operand and fixed-prefix limits apply.

### SAT window search

`src/window.py` uses Z3 to select instructions, registers, and output snapshots. A window replacement must preserve outputs outside the window. Outputs inside the window can use any replacement snapshot. A scratch register must have an unconditional definition before any read. Packed bit planes encode test cases. Counterexample-guided synthesis starts with sampled strict permutations, checks each candidate on all 541 weak orders, and adds failing cases.

`src/run_windows.py` searched every window of widths 4 through 8 in the 33-instruction seed. Each replacement removes one instruction and preserves the number of comparisons in the window. Each query has a 25-second solver budget. Results for 140 windows:

| Window width | UNSAT | Time limit / unknown |
|---:|---:|---:|
| 4 | 30 | 0 |
| 5 | 28 | 1 |
| 6 | 24 | 4 |
| 7 | 2 | 25 |
| 8 | 0 | 26 |

No candidate was produced. Log: `logs/windows_small.jsonl`.

Additional queries:

- Window [14,25), remove one instruction: unknown after 60 seconds.
- Window [19,26), remove one instruction, preserve live register values and flags, start with 32 cases: UNSAT after 52.67 seconds.
- Window [15,33), remove two instructions, preserve the seed's four flag functions but allow different comparison operands: unknown after 120 seconds.

Logs: `logs/window14_25.log`, `logs/equiv19_26.log`, `logs/seed_flags31.log`. UNSAT applies only to each encoded window and register set. Unknown does not exclude a replacement.

### Whole-core routing limits

The unmodified routing search tested the seed's eight fixed comparison operand columns:

- Core 31: no candidate in 10,000,088 nodes, 36.2 seconds. Node limit reached.
- Core 32: no candidate in 150,000,103 nodes, 332,904 completed DAG leaves, 608.9 seconds. Node limit reached.

Logs: `logs/seed31.dag`, `logs/seed32.dag`. Both searches are incomplete.

## Stochastic search and repair

`src/mcmc8.c` adapts the supplied stochastic instruction search. It enforces exactly 8 comparisons and uses 31 instruction slots. Three runs can change the full program. Three keep the 15-instruction sort2 + sort3 prefix. Each restart removes two non-comparison instructions from the correct seed. Programs can contain fewer than 31 instructions if a slot becomes empty.

Each run used 300 CPU seconds. The six runs made 471,506,944 loop iterations in total. These are mutation attempts; invalid proposals can be rejected before simulation. No correct program was found.

| Prefix kept | Temperature | Seed | Iterations | Best sum of wrong output values over 541 cases |
|---:|---:|---:|---:|---:|
| 0 | 12 | 103 | 55,672,832 | 78 |
| 0 | 1 | 101 | 65,896,448 | 75 |
| 0 | 4 | 102 | 61,411,328 | 53 |
| 15 | 12 | 106 | 100,646,912 | 57 |
| 15 | 1 | 104 | 97,566,720 | 52 |
| 15 | 4 | 105 | 90,312,704 | 39 |

All six best failing programs and three saved snapshots were submitted to the strict judge. Every one failed. Logs: `logs/check_*.judge`. The closest snapshot is `candidates/snapshots/mcmc105_score39.s`. Only output 1 is wrong. It fails on 39 weak orders, including 12 strict permutations. For example, the judge reports input `[1,1,0,0,0]` and output `[0,1,0,1,1]`; the correct output is `[0,0,0,1,1]`.

Two saved comparison structures distinguish all 120 strict permutations. Their fixed-operand routing searches returned NONE at merge budgets 16 and 17. Logs: `logs/mcmc104_k{16,17}.log`, `logs/mcmc105_k{16,17}.log`.

Repair results for the 39-error snapshot:

- Replace [24,31) with 7 instructions: unknown after 120 seconds.
- The same window with fixed flag functions: unknown after 120 seconds.
- Replace [27,31) with 4 instructions: UNSAT on 32 cases, 3.18 seconds.
- Replace [28,31) with 4 instructions, allowing core 32: UNSAT on 32 cases, 2.92 seconds.
- Insert one move or conditional move from instruction 15 onward and record a new output 1: no repair. Each candidate first had to compute the correct output-1 column on all 541 cases. Surviving candidates would also need to preserve the other outputs. None survived.

Logs: `logs/repair105_{free,fixed,tail31,tail32}.log`, `logs/one_repair105.log`. These results restrict only the stated windows and instruction choices.

## Encoding checks

`src/check_window.py` fixes every instruction in the whole seed merge. The encoding accepts the correct output snapshots on all 541 weak orders. When output 2 is forced to the final minimum register, the encoding returns UNSAT. Log: `logs/window_encoding_control.log`. This is a control test, not a proof that the encoding is complete.

All 32 conditional-permutation control programs pass the strict out judge. Their cores range from 33 to 39. This checks that the enumerated strict-input merge paths also work with ties and arbitrary initial scratch values and flags. Logs: `logs/permutation_controls.jsonl`, `logs/control_p*.judge`.

Every additional PASS path is listed below. These are longer control programs, not target results.

| PASS file | Core k |
|---|---:|
| `candidates/permutation_controls/p000.s` | 38 |
| `candidates/permutation_controls/p001.s` | 37 |
| `candidates/permutation_controls/p002.s` | 37 |
| `candidates/permutation_controls/p003.s` | 36 |
| `candidates/permutation_controls/p004.s` | 34 |
| `candidates/permutation_controls/p005.s` | 33 |
| `candidates/permutation_controls/p006.s` | 35 |
| `candidates/permutation_controls/p007.s` | 34 |
| `candidates/permutation_controls/p008.s` | 38 |
| `candidates/permutation_controls/p009.s` | 37 |
| `candidates/permutation_controls/p010.s` | 37 |
| `candidates/permutation_controls/p011.s` | 36 |
| `candidates/permutation_controls/p012.s` | 38 |
| `candidates/permutation_controls/p013.s` | 37 |
| `candidates/permutation_controls/p014.s` | 39 |
| `candidates/permutation_controls/p015.s` | 38 |
| `candidates/permutation_controls/p016.s` | 33 |
| `candidates/permutation_controls/p017.s` | 34 |
| `candidates/permutation_controls/p018.s` | 34 |
| `candidates/permutation_controls/p019.s` | 35 |
| `candidates/permutation_controls/p020.s` | 36 |
| `candidates/permutation_controls/p021.s` | 37 |
| `candidates/permutation_controls/p022.s` | 37 |
| `candidates/permutation_controls/p023.s` | 38 |
| `candidates/permutation_controls/p024.s` | 37 |
| `candidates/permutation_controls/p025.s` | 38 |
| `candidates/permutation_controls/p026.s` | 38 |
| `candidates/permutation_controls/p027.s` | 39 |
| `candidates/permutation_controls/p028.s` | 36 |
| `candidates/permutation_controls/p029.s` | 37 |
| `candidates/permutation_controls/p030.s` | 37 |
| `candidates/permutation_controls/p031.s` | 38 |

## Limits and next directions

No completed search covers all 8-comparison programs. The largest exact routing searches reached a node limit. Many SAT windows reached a time limit. Fixed operand columns can exclude a cheaper pair of comparison operands with the same flags. Fixed prefixes can exclude savings that combine preparation and merging.

The main unresolved direction is comparison synthesis that can choose any available register, together with a larger window that crosses the pair/triple preparation and merge. Another direction is a decision structure that duplicates values and then discards them after an early output. The conditional-permutation search excludes that behavior.

## Round 2: free comparison operands across preparation and merge

Final status: all round-2 jobs have ended. No target program has passed the strict judge. The final audit covers 51 target queries: 20 restricted UNSAT results and 31 unknown results.

The resource statements above describe round 1. Round 2 uses at most two CPU jobs. Every search and judge command runs with `nice -n 19`. The observed CPU affinity is `{74, 75}`. No files outside this worker folder are changed.

### New encoding

`round2/src/window_cnf.py` builds a Boolean SAT formula directly. It uses PySAT and single-threaded CaDiCaL 1.9.5. Comparison operands can select any register, including the same register twice. Every conditional move can choose l, le, g, or ge. Outputs can select a value at any write snapshot. A fixed suffix need only produce the right outputs; it need not reproduce the seed's intermediate registers.

Each register has three value bits and a defined bit for each tested weak order. A conditional move can initialize scratch data on only those orders where it executes. Thus two complementary conditional moves can initialize scratch data. The round-1 requirement for a prior unconditional move is removed.

Window indices start at zero. The interval [a,b) includes a and excludes b.

Limits: comparisons on undefined values are excluded, except `cmp R,R`. Conditional moves need known flags. The register set is finite and stated by each seed and the `--extra` option. These limits can exclude valid strict programs. No global lower bound follows from this encoding.

The free mode chooses every instruction. The cmp mode fixes comparison positions. The class mode also fixes mov versus conditional-move positions. The dest mode also fixes write destinations. Both comparison operands remain free in every search mode. A deletion template does not bound the number of changed sources or comparison operands.

### Initial encoding controls

- A fixed palette seed across window [8,32) was accepted on all 541 weak orders. Its strict out judge passed: `round2/candidates/control_palette.s`, log `round2/logs/control_palette.judge`.
- A fixed seed with conditional scratch initialization was accepted on all 541 weak orders: `round2/candidates/control_condinit.s`. Its strict out judge passed.
- A fixed correct program with the minimum output forced to the initial P0 returned UNSAT on all 541 weak orders. Log: `round2/logs/control_negative.log`.

These controls test the encoding. They do not establish its completeness. All accepted programs still require the strict judge.

### Completed round-2 checks and first searches

The conditional-initialization control passed the strict out judge. Log: `round2/logs/control_condinit.judge`.

After formula simplification, both fixed controls again passed the strict out judge. PASS paths: `round2/candidates/controls_00.s` and `round2/candidates/controls_01.s`. Logs: `round2/logs/controls_00.judge` and `round2/logs/controls_01.judge`.

A further positive control fixes instruction classes, write destinations, and output snapshots across [8,32), but leaves comparison operands, move sources, and conditional-move conditions free. It recovered the original k=32 palette program on all 541 weak orders in 7.846 seconds. The strict judge passed `round2/candidates/controls_03.s`. Log: `round2/logs/controls_03.judge`. It made no instruction changes. This checks recovery of a known solution with free operands; it is not a new shorter program. The revised forced-wrong-output control also returned UNSAT. Control details: `round2/logs/controls_summary.json`.

Two unrestricted instruction-window searches each reached a 600-second limit on their first eight strict input orders:

| Seed | Window | Replacement length | Window cmp count | SAT conflicts | Result |
|---|---:|---:|---:|---:|---|
| `palette_c8_k32.s` | [8,32) | 23 | 6 | 2,733,561 | unknown |
| `c8c_len32_c29288.s` | [9,32) | 22 | 6 | 2,713,594 | unknown |

Logs: `round2/logs/free_palette_8_32.log`, `round2/logs/free_c8c_9_32.log`. Every instruction and output snapshot was free inside the stated finite register set. These runs produced no candidate and establish no exclusion.

The crossing batch tested five k=32 seeds and four non-cmp deletions per seed. Its windows have widths 12, 16, 17, or 18. Every window crosses preparation and merge. Instruction classes, write destinations, and output snapshots were fixed. Comparison operands, move sources, and conditional-move conditions were free. All 20 queries returned UNSAT on their initial sets of 16 strict input orders. The whole batch took 6.194 seconds. This excludes only these restricted templates. Task definitions and results: `round2/logs/crossing_tasks.json`, `round2/logs/crossing_summary.json`.

### Wider templates with free output snapshots

The templates batch tested the same five seeds and four non-cmp deletions per seed. Windows [8,32) and [9,32) rebuild the rest of the program. The replacements have 23 or 22 instructions. They keep instruction classes and write destinations. Both comparison operands, all move sources, all conditional-move conditions, and all five output snapshots are free.

All 20 queries reached their 120-second limits on the initial 12 strict input orders. No query produced a candidate. Total SAT conflicts: 28,063,845. Total recorded CPU time: 2,391.746 seconds. Batch wall time: 1,205.136 seconds. The largest recorded process resident set was 71,588 KiB. These are unknown results, not exclusions.

The queries normalize cmp operand order because each window ends the program. The four conditional-move conditions remain free, so a reversed comparison can reverse every later condition up to the next comparison. Writes from a register to itself are excluded. Search phases prefer the seed, including its original output snapshots; phases do not add constraints. The phase heuristic was improved during the batch. The constraints and query budgets did not change.

Definitions and results: `round2/logs/templates_tasks.json`, `round2/logs/templates_summary.json`. Reproduction command: `nice -n 19 python3 round2/src/run_batch.py templates`.

The output-time option has a further fixed positive control on all 541 weak orders. Strict out PASS path: `round2/candidates/control_times.s`. Judge log: `round2/logs/control_times.judge`.

### Binary-case starting set

The binary batch starts with all 31 canonical weak orders with at most two distinct values. This reduces the value part of the Boolean formula to one bit. It does not assume that correctness on binary inputs implies correctness on general inputs. Every synthesized witness is checked on all 541 weak orders. Failing orders are added to the SAT formula.

This batch used one additional scratch register. Two windows chose every instruction, with six comparisons in the window. Three narrower windows preserved only instruction classes. Their write destinations were free. All comparison operands and output snapshots were free in every query. The batch used CaDiCaL 1.9.5, CaDiCaL 3.0, and Glucose 4. Results are given below.

All five binary-start queries ended at their 300-second limits. Four produced no model. The low-mov seed query produced a model on all 31 binary orders in 0.607 seconds. The simulator then counted 108 failures among the full 541 weak orders. The query added 12 failing orders and reached its limit on 43 orders. The strict judge rejected `round2/candidates/binary_03_near.s`. Its counterexample is `[0,0,1,2,2] -> [0,0,2,2,2]`, with expected output `[0,0,1,2,2]`.

This near miss is the two-mov seed with its late `mov S1,P0` deleted. Its core contains 8 cmp, 22 conditional moves, and 1 mov. The simulator accepts its 31 binary input orders. Inference: ties in those orders hide the missing copy. It is not a correct sort5 program. The failure count is worse than the round-1 39-order near miss.

The binary batch used 1,489.515 recorded CPU seconds and 901.684 wall seconds. Its largest recorded process resident set was 136,236 KiB. Results: `round2/logs/binary_summary.json`. Failed-candidate judge log: `round2/logs/binary_03.judge`.

### Expanded tail and counterexample batch size

Two follow-up queries use the low-mov seed across [8,32). Both remove the late copy at original instruction 25. Each replacement has 23 instructions. Instruction classes remain fixed. All comparison operands, write destinations, move sources, conditions, and output snapshots are free. Each query has one additional scratch register. Thus the final two comparison operands can also change.

Both start with the 31 binary orders and the 12 counterexamples from the prior query. Both found a model on these 43 orders in about 1.2 seconds. The simulator counted 135 failing weak orders. One query added 12 counterexamples and reached a 600-second limit on 55 orders. The other added one counterexample and reached a 300-second limit on 44 orders. Neither produced a second model.

Both retained programs failed the strict judge:

- `round2/candidates/tailfree_00_near.s`: `round2/logs/tailfree_00.judge`.
- `round2/candidates/tailone_00_near.s`: `round2/logs/tailone_00.judge`.

Both judge logs give `[0,0,1,2,1] -> [0,0,0,1,2]`, with expected output `[0,0,1,1,2]`. These are failed candidates. Results: `round2/logs/tailfree_summary.json`, `round2/logs/tailone_summary.json`. The exact 12-case starting list is `round2/logs/binary03_cex.json`.

The memory translation of the free-operand positive control passed the strict memory judge at total length 42. PASS path: `round2/verified/control32_mem.s`. Judge log: `round2/logs/control32_mem.judge`. Its source register program is `round2/candidates/controls_03.s`, which also passed the strict judge. This control matches the known length and does not meet the target.

### Direct searches on larger case sets

These two queries used one additional scratch register. Instruction classes remained fixed. Comparison operands, write destinations, move sources, conditional-move conditions, and output snapshots were free. Both windows cross preparation and merge and extend to the end of the program.

| Seed | Window | Initial orders | Registers | Boolean variables | Clauses | Result | Seconds |
|---|---:|---:|---:|---:|---:|---|---:|
| `c8c_len32_c29288.s` | [9,32) | 181, at most three distinct values | 10 | 166,259 | 1,019,208 | unknown | 300.063 |
| `c8_2dfea391c9fdd3bb.s` | [8,32) | all 541 | 9 | 534,621 | 3,252,872 | unknown | 302.884 |

Neither query produced a model. Results: `round2/logs/dense_summary.json`. The first query used Glucose 4. The second used CaDiCaL 3.0.

### Final encoding check

The final audit corrected output decoding in the fixed-output modes. The decoder now selects a witness from the requested output set. This change does not change the SAT constraints. Completed UNSAT queries never use the decoder, so their results are unaffected. The free-output searches are also unaffected.

A further control inserts `mov P0,P0` at instruction index 16 in the k=32 palette seed. It then removes that instruction across [8,33), while fixing the output locations after the deletion. The solver accepted the remaining program on all 541 orders. The strict judge passed the resulting k=32 program. This checks output-time offsets after a deletion with the corrected decoder. The padded k=33 input fixture also passed the strict judge.

Logs: `round2/logs/deletion_control_00.log`, `round2/logs/deletion_control_00.judge`, `round2/logs/control_padded33.judge`.

### Round-2 final result and limits

No k<=31 program passed the strict judge. The strongest new completed exclusion covers 20 templates with fixed instruction classes, write destinations, and output locations. Their comparison operands, sources, and conditions were free. The broader queries reached time limits. No global lower bound is claimed.

The audit records 51 target queries, 20 restricted UNSAT results, and 31 unknown results. The solvers recorded 46,360,382 SAT conflicts. Conflicts are solver events, not counts of distinct programs. Recorded CPU time for 49 queries is 5,388.881 seconds. The first two queries did not record CPU time. The largest recorded process resident set is 1,023,052 KiB. All search and judge jobs have ended. Searches used at most two single-threaded CPU jobs at nice level 19.

The finite register sets, instruction-class restrictions, defined-value semantics, and optional output-location restrictions limit these results. Comparisons on undefined data, other than a register compared with itself, remain excluded. The searches do not cover all programs in the unbounded-register model.

The machine-readable audit is `round2/logs/final_audit.json`. It contains all query scopes, final statuses, strict-judge outputs, and file hashes. Re-run only the audit with `nice -n 19 python3 round2/src/audit_round2.py`. This command does not repeat searches.

### Every round-2 strict PASS file

| Program | Model | Instruction count | Judge log |
|---|---|---:|---|
| `round2/verified/control32_mem.s` | mem | 42 | `round2/logs/control32_mem.judge` |
| `round2/candidates/control_condinit.s` | out | 32 | `round2/logs/control_condinit.judge` |
| `round2/seeds/control_padded33.s` | out | 33 | `round2/logs/control_padded33.judge` |
| `round2/candidates/control_palette.s` | out | 32 | `round2/logs/control_palette.judge` |
| `round2/candidates/control_times.s` | out | 32 | `round2/logs/control_times.judge` |
| `round2/candidates/controls_00.s` | out | 32 | `round2/logs/controls_00.judge` |
| `round2/candidates/controls_01.s` | out | 32 | `round2/logs/controls_01.judge` |
| `round2/candidates/controls_03.s` | out | 32 | `round2/logs/controls_03.judge` |
| `round2/candidates/deletion_control_00.s` | out | 32 | `round2/logs/deletion_control_00.judge` |

## Round 3: longer Kissat windows and new w6 seeds

This round resumes the 31 unknown round-2 queries. It does not rerun the 20 completed UNSAT queries. All query limits are 50% longer: 180, 450, or 900 seconds. The case selections, random seeds, register bounds, instruction restrictions, and output options match the prior queries. Kissat replaces the prior solver. Per-variable phase hints are unavailable in the external Kissat interface; they impose no constraints.

`round3/src/kissat_window.py` imports the unchanged round-2 encoder. It writes its exact clauses to DIMACS, runs Kissat, and checks every SAT model against the emitted clauses. Candidate programs still require the strict judge. `round3/src/run_serial.py` runs one SAT job at a time. Each query has a 2,800 MiB address-space limit. The wrapper also stops a job if the combined measured Python and Kissat resident set exceeds 2,850,000 KiB. Search jobs run at nice level 19. The first affinity check returned {74,75}. Each SAT job is single-threaded, and queries run one at a time. The task list is `round3/logs/retry_tasks.json`. Results accumulate in `round3/logs/retry_summary.json`.

Controls:

- `round3/candidates/control32.s`: fixed k=32 seed, strict out PASS. Log: `round3/logs/control_32.judge`.
- `round3/candidates/control_symbolic.s`: recovered k=32 seed with free comparison operands, sources, and conditions across [8,32), all 541 cases, fixed write destinations and output locations. Strict out PASS. Log: `round3/logs/control_symbolic.judge`. Kissat used 23.953 CPU seconds.
- The fixed seed with the minimum output forced to the initial P0 returned UNSAT. Log: `round3/logs/control_negative.log`.

These are encoding and solver controls. They do not meet the target.

The new-seed inventory contains 22 k=32, c=8 programs copied from w6. It excludes the byte-identical seeds already in round 2. Six programs have no core mov. Provenance and hashes: `round3/logs/variants.json`. The proposed crossing-window batch contains 270 deletion templates. Each permits free comparison operands, move sources, and conditional-move conditions. It retains write destinations and output locations. These templates have not yet run.

Status: the longer retry batch is running. A time limit remains unknown. No new target PASS is claimed.

### Round-3 retry progress

The first 20 longer template retries reached their 180-second limits. The first four binary-start retries also reached their 450-second limits. Kissat produced no instruction model in these 24 queries. These results remain unknown. The saved records are in `round3/logs/retry_summary.json`.

The search uses counterexample-guided synthesis (CEGIS). It adds failing input orders after it checks a proposed program. Here, a frontier is the case set at which a query stopped.

### Resume the prior CEGIS frontiers

The first 25 longer Kissat retries produced no model. The old binary_03, tailfree_00, and tailone_00 queries had already accepted models on their initial case sets. They timed out after adding counterexamples. Thus a stronger restart preserves those added constraints.

Three additional phased Kissat queries resume those final case sets: 43 orders for binary_03, 55 for tailfree_00, and 44 for tailone_00. Their limits are 450, 900, and 450 seconds. All other instruction and register constraints match the prior queries. Each starting formula retains the old counterexamples. The new queries use the literal-complementation phase heuristic. They run after the phased positive control and before the new-seed windows. This is additional search; it does not relabel the 31 original retry queries.

Definitions: `round3/logs/frontier_tasks.json`. The three case lists are retained beside that file. Results will be in `round3/logs/frontier_summary.json`. The independent audit includes these additional queries.

The 31 original retry queries have now ended. All 31 remain unknown. Each reached its longer limit without a model. The retry batch recorded no query errors. This includes the two fully free windows, each with a 900-second limit. It does not exclude any program in those query scopes.

The independent audit command is `nice -n 19 python3 round3/src/audit_round3.py`. It checks each retained formula hash and each recorded UNSAT status. It also inventories strict judge outputs. It does not repeat synthesis. Its report is `round3/logs/independent_audit.json`.

The phase-heuristic positive control passed the strict out judge at k=32. PASS path: `round3/candidates/control_phased.s`. Judge log: `round3/logs/control_phased.judge`. It uses all 541 orders across [8,32), with free comparison operands, sources, and conditions. Write destinations and output locations remain fixed. Kissat used 0.340 CPU seconds, compared with 23.953 seconds in the unphased control. The mapped SAT assignment also satisfied the original clauses. This is a control result, not a shorter program.

The new fixed-output windows normalize comparison operand orientation. Each fixed suffix starts with cmp, so it discards the final window flags before any conditional move. Reversing a window comparison can reverse every following condition up to the next comparison. The four supported conditions remain available. This symmetry reduction does not fix operand value columns.

The three resumed queries ended as unknown. Their initial case, variable, and clause counts match the final counts of their prior queries. The audit records these checks.

All 270 new fixed-output crossing windows returned UNSAT. Their total recorded wall time was 193.716 seconds. They cover 22 k=32 seeds, including six cores with no mov. Each replacement has k=31. The finite register sets, fixed instruction classes, fixed write destinations, fixed output locations, and conservative defined-value rules limit this exclusion. The larger windows with free output snapshots are now running.

The final broad-window batch varies the deletion point. Some queries remove an early preparation write. Other queries remove a late mov or a write before a final comparison. For the retained no-mov `nomov_4c02da04dce39b74.s` seed, it uses the already known deletion at original index 27. This reuses the prior deletion result; it does not repeat the single-deletion scan. The SAT query can change every instruction in its window. It fixes only the comparison positions. It has no bound on the number of changed instructions. Full definitions remain in `round3/logs/variants_broad_tasks.json`.

All 22 full-suffix windows with free output snapshots reached their 60-second limits. None produced a model. Write destinations and instruction classes remained fixed in these queries.

The boundary-normalization control passed the strict out judge at k=32. PASS path: `round3/candidates/control_normalized_boundary32.s`. Log: `round3/logs/control_normalized_boundary32.judge`. This control uses all 541 orders, window [8,25), ordered comparison operands, free sources and conditions, fixed destinations, and fixed output locations. Its fixed suffix starts with cmp. It checks that comparison orientation changes can preserve the correct program across this boundary. It does not meet the target.

The final 22 broad queries are now running. Each has a 90-second limit. They preserve only comparison positions within the chosen deletion template. They allow every write destination, mov or any conditional-move condition, all move sources, and every output snapshot. They add one scratch register and start with all 31 binary weak orders.

### Round-3 completed search results

| Batch | Queries | Solver UNSAT | Unknown | Candidate | Wall seconds |
|---|---:|---:|---:|---:|---:|
| retry | 31 | 0 | 31 | 0 | 9905.584 |
| variants_fixed | 270 | 270 | 0 | 0 | 193.716 |
| variants_freeout | 22 | 0 | 22 | 0 | 1322.682 |
| variants_broad | 22 | 0 | 22 | 0 | 1982.472 |

The largest measured combined Python/Kissat resident set was 517,368 KiB. Kissat used 12859.282 recorded CPU seconds across these queries.

The retry batch used the original formulas and longer limits. The new-seed batches used optional literal complementation to map seed phase hints to Kissat initial phases. This is a reversible change of Boolean variable signs. It does not add constraints. SAT models were mapped back and checked against the original emitted clauses before decoding.

The fixed batch retains instruction classes, write destinations, and output locations. Its windows cross preparation and merge. Each has a 15-second limit and 24 initial strict cases. The freeout batch rebuilds the full suffix with fixed instruction classes and destinations. Its output snapshots are free, with a 60-second limit and 16 initial strict cases. The broad batch keeps only comparison positions. Every non-comparison slot can be mov or any supported conditional move. Write destinations and output snapshots are free. It adds one scratch register, starts from all 31 binary weak orders, and uses a 90-second limit. All three new-seed batches leave both comparison operands free.

Every UNSAT result concerns only its encoded finite register set and template. A time or resource limit is unknown. The conservative rules for undefined data and flags remain as stated in round 2. No global lower bound follows.

Machine-readable results: `round3/logs/final_audit.json`. Query definitions and full solver records are in the corresponding task and summary JSON files.

Every round-3 strict PASS is listed below. The known controls have k=32.

- `round3/logs/control_32.judge`: `PASS round3/candidates/control32.s [relaxed+strict] n=5 L=32 R=10 iset=I1 model=out`
- `round3/logs/control_normalized_boundary32.judge`: `PASS /path/to/repo/agents/team/codex-fleet/w4/round3/candidates/control_normalized_boundary32.s [relaxed+strict] n=5 L=32 R=10 iset=I1 model=out`
- `round3/logs/control_phased.judge`: `PASS /path/to/repo/agents/team/codex-fleet/w4/round3/candidates/control_phased.s [relaxed+strict] n=5 L=32 R=10 iset=I1 model=out`
- `round3/logs/control_symbolic.judge`: `PASS round3/candidates/control_symbolic.s [relaxed+strict] n=5 L=32 R=10 iset=I1 model=out`

All scheduled round-3 jobs have ended. No k<=31 program passed the strict judge.

### Round-3 final independent audit

No k<=31 program passed the strict judge in this round. All search and verification jobs have ended. The audit covers all 348 target queries. It found no query errors.

| Query group | Completed | Restricted UNSAT | Unknown | Query wall seconds |
|---|---:|---:|---:|---:|
| Original unknown queries, longer Kissat limits | 31 | 0 | 31 | 9905.584 |
| Prior final case sets, phased Kissat | 3 | 0 | 3 | 1800.429 |
| New w6 seeds, fixed outputs and destinations | 270 | 270 | 0 | 193.716 |
| New w6 seeds, free output snapshots | 22 | 0 | 22 | 1322.682 |
| New w6 seeds, free write types and destinations | 22 | 0 | 22 | 1982.472 |
| Total | 348 | 270 | 78 | 15204.883 |

All 270 UNSAT results concern the fixed-output templates. Their comparison operands were free over the stated register sets. The other 78 queries reached their time limits. They remain unknown.

Kissat used 14,636.400 recorded CPU seconds for the target queries. The largest sampled combined Python/Kissat resident set was 517,368 KiB. Searches used one single-threaded SAT job at a time, at nice level 19. The audit recorded 137,147,579 solver conflicts. Conflicts are solver events, not counts of distinct programs.

The three resumed queries match their prior final case, variable, and clause counts. The audit also checked every retained formula hash and every recorded UNSAT exit status.

The replay recovered all seven saved SAT assignments. Each produced a k=31 program. All seven passed the 31 binary weak orders in the simulator. Every one failed the strict out judge. Their full-order failure counts match the original synthesis records.

| Recovered program | Failing weak orders in simulator | Strict judge |
|---|---:|---|
| [variants_broad_v01_model01.s](round3/recovered/variants_broad_v01_model01.s) | 153 | [FAIL](round3/logs/variants_broad_v01_model01.judge) |
| [variants_broad_v01_model02.s](round3/recovered/variants_broad_v01_model02.s) | 144 | [FAIL](round3/logs/variants_broad_v01_model02.judge) |
| [variants_broad_v04_model01.s](round3/recovered/variants_broad_v04_model01.s) | 90 | [FAIL](round3/logs/variants_broad_v04_model01.judge) |
| [variants_broad_v10_model01.s](round3/recovered/variants_broad_v10_model01.s) | 98 | [FAIL](round3/logs/variants_broad_v10_model01.judge) |
| [variants_broad_v13_model01.s](round3/recovered/variants_broad_v13_model01.s) | 461 | [FAIL](round3/logs/variants_broad_v13_model01.judge) |
| [variants_broad_v17_model01.s](round3/recovered/variants_broad_v17_model01.s) | 27 | [FAIL](round3/logs/variants_broad_v17_model01.judge) |
| [variants_broad_v19_model01.s](round3/recovered/variants_broad_v19_model01.s) | 153 | [FAIL](round3/logs/variants_broad_v19_model01.judge) |

The smallest failure count is 27. This program comes from the query that reuses the known deletion at original index 27. The judge gives input `[0,0,2,1,1]` and output `[0,1,1,1,2]`. The required output is `[0,0,1,1,2]`.

Every strict PASS in this round is a k=32 control:

| PASS program | Model | Core length | Judge log |
|---|---|---:|---|
| [control32.s](round3/candidates/control32.s) | out | 32 | [control_32.judge](round3/logs/control_32.judge) |
| [control_normalized_boundary32.s](round3/candidates/control_normalized_boundary32.s) | out | 32 | [control_normalized_boundary32.judge](round3/logs/control_normalized_boundary32.judge) |
| [control_phased.s](round3/candidates/control_phased.s) | out | 32 | [control_phased.judge](round3/logs/control_phased.judge) |
| [control_symbolic.s](round3/candidates/control_symbolic.s) | out | 32 | [control_symbolic.judge](round3/logs/control_symbolic.judge) |

The register bounds, fixed prefixes, comparison-position choices, optional output restrictions, and conservative rules for undefined data limit these results. No global lower bound is claimed.

The complete report is `round3/logs/final_audit.json`. The identical independent report is `round3/logs/independent_audit.json`. The earlier automatic report is retained as `round3/logs/automatic_audit.json`. The assignment replay ledger is `round3/logs/recovered_models.json`.

The main unresolved searches are the full-suffix windows with free output locations and the broad write templates. Their exact seeds, deletion locations, case sets, limits, and solver logs are retained. A future run can resume these scopes without repeating the completed 270 templates.

## Round 4: 900-second retries and failed-model repair

Read the complete earlier results before this round. Do not repeat the 270 completed UNSAT templates. Resume the 78 unknown queries with Kissat. Each query has a 900-second wall limit. Restart from its final recorded case set, including every earlier counterexample. Before solving, require a byte-identical Boolean formula hash. Preserve each query's prior variable-sign mapping and random seed. The task list is `round4/logs/retry900_tasks.json`.

The controller is `round4/src/controller.py`. It runs one single-threaded search at a time at nice level 19, pinned to CPU 74. Each process has a 2,800 MiB address-space limit. The solver wrapper also checks combined Python/Kissat resident memory against 2,850,000 KiB. There are no writes outside w4. The controller will submit every decoded saved candidate to the strict out judge. A target PASS will be converted to the memory model and judged there. Only strict judge PASS counts.

The seven recovered k=31 programs remain failures. Their recorded failing weak-order counts are 153, 144, 90, 98, 461, 27, and 153. Their strict judge FAIL logs remain in `round3/logs/`. The repair handoff is `round4/handoff/W7_HANDOFF.md`. The controller will independently recompute these counts and trace the wrong outputs before selecting non-contiguous four-position windows. The repair search uses a local copy of w7's rank-value SAT encoder. It permits all six opcodes and free output snapshots. Each seed gets one additional register. It will check each completed repair UNSAT certificate with drat-trim.

Assumptions: [G1,G2,G3,G4,A2,A11]. These searches test local reachability (A11) within finite register sets (A2). Comparison operands remain free. The search does not impose the fixed value skeleton in A4, the term pool in A8, or the lattice restrictions in A12 and A15. No new result has contradicted an assumption at this point. Each completed UNSAT result has only its stated query scope. Every time or resource limit is UNKNOWN.

Status: the serial retry controller is running. Its first query is `variants_broad_v17`, which previously produced the 27-failure model. With no early solution or exclusion, 78 retries can take about 19.5 hours. The controller then runs the selected repair windows and appends final counts here. Current records are `round4/logs/controller.log`, `round4/logs/active.json`, and `round4/logs/progress.json`. No new target PASS is claimed.

Round-4 copied-encoder control: `/path/to/repo/agents/team/codex-fleet/w4/round4/candidates/repair_positive32.s` passed the strict out judge at k=32. Judge log: `/path/to/repo/agents/team/codex-fleet/w4/round4/logs/repair_positive32.judge`. This control does not meet the target.

### Round-4 first completed retry and checked handoff

The `variants_broad_v17` retry reached its 900-second search limit. Its result is UNKNOWN. Query wall time, including setup, was 901.641 seconds. Its initial formula hash matched the prior final formula exactly. It produced no model. The serial controller has started `variants_broad_v00`. At this checkpoint, one of 78 retries is complete. The other 77 are running or pending.

The independent scalar simulator reproduced all seven failure counts: 153, 144, 90, 98, 461, 27, and 153. Its initial scratch value was 9 and its initial flags were equal. The conservative undefined-value evaluator gave the same counts. These are simulation observations. All seven programs also have strict judge FAIL records. Detailed failing inputs and wrong-output traces are in `round4/handoff/analysis.json`. The handoff is `round4/handoff/W7_HANDOFF.md`.

There are 112 selected non-contiguous four-position repair windows, with 16 windows per failed program. Their exact register sets, positions, and time limits are in `round4/repair/tasks.json`. The controller will run these windows after the 78 retries. The new encoding control passed the strict out judge at k=32: `round4/candidates/repair_positive32.s`. Its judge log is `round4/logs/repair_positive32.judge`. This is a control, not a target result.

The checkpoint audit passed. It checked the retained retry formula hash, the seven program hashes and failure counts, and the strict PASS control log. Report: `round4/logs/independent_audit.json`. The final controller will replace that report after all jobs finish. The current scope remains [A2,A11]. No assumption has been contradicted. No k<=31 strict PASS has been found.

## Round 5: 600-second non-contiguous windows

The new supervisor request takes priority over the remaining round-4 retries. The retained round-4 summary has one completed 900-second retry, UNKNOWN. No prior search is relabeled or counted as complete here.

The new task list is `round5/logs/tasks.json`. It contains the exact 112 previously prepared four-position windows on seven recovered failures. Their positions and register counts are unchanged. Each new limit is 600 seconds. It also contains 16 selected four-position windows for each of the 15 w6 representatives in `w6/round6/artifacts/near_representatives_clean.txt`. These add 240 windows, for 352 total. The 15 w6 seeds have k=31, and the scalar simulator reports nine failed weak orders for each. Thus they are failing repair seeds, not verified k=32 controls. Private copies and hashes are retained in `round5/seeds/` and `round5/logs/w6_seeds.json`.

Each query fixes instructions outside its four positions. Inside those positions, the opcode, destination, and source are free. All six allowed opcodes are available. Both comparison operands are free over the finite register set. Every output snapshot is free. Each seed has one additional register. The search can change the number of comparisons. It does not impose a value skeleton or a min/max term pool.

`round5/src/search.py` copies the w7-style rank-value encoder used in round 4. `round5/src/kissat_adapter.py` replaces its solver with external single-threaded Kissat. Each accumulated formula gets a fresh solve. Every SAT assignment is checked against its exact clauses before decoding. Every decoded program is saved and submitted to the strict out judge. Each completed UNSAT result gets a retained DRAT certificate, checked with drat-trim. A certificate check limit is reported as UNSAT_UNCHECKED. A search time or resource limit is UNKNOWN.

The positive control uses all 541 weak orders. The strict out judge reports: `PASS round5/candidates/positive32.s [relaxed+strict] n=5 L=32 R=10 iset=I1 model=out`. The exact output, including the absolute path, is in `round5/logs/positive32_out.judge`. This k=32 program does not meet the target. The negative control fixes the 27-failure program and permits free output snapshots. It returned UNSAT, and drat-trim checked its certificate. These controls test the copied encoder and external solver path. They do not establish global completeness.

The controller runs one CPU job at a time, at nice level 19 and pinned to CPU 74. Each job has a 2,800 MiB address-space limit. The solver wrapper checks combined Python/Kissat resident memory against 2,850,000 KiB. All writes remain in w4. Run command: `nice -n 19 python3 -B round5/src/controller.py`. The live records are `round5/logs/controller.log`, `round5/logs/progress.json`, and `round5/logs/summary.json`.

Assumptions: [G1,G2,G3,G4,A2,A11]. These queries test local repair (A11) in finite register sets (A2). They do not impose A4, A8, A12, or A15. Scratch registers initially hold one value above all inputs, and flags initially indicate equality. This is a necessary test state for strict correctness. Only strict judge PASS counts as a correct program. A completed UNSAT result excludes only its stated finite window scope. No assumption is contradicted at this checkpoint. No target PASS is claimed.

The positive control also saved the decoded assignment as `round5/candidates/positive32.s.model000.s`. Its strict out judge passed at k=32. Log: `round5/candidates/positive32.s.model000.s.judge`. This is the same control core with the solver-selected output snapshots. Both control PASS paths are retained.

After the first three scopes, the search starts with at most eight sampled original failing orders, 16 strict orders, and case indices 0, 1, and 2. Earlier scopes initially included all original failing orders. The sample uses random seed 711, and each new log retains the exact initial case indices. This changes the initial case set, not the four-position search scope. Counterexamples still expand that set. Every decoded SAT program still gets the strict out judge. A certificate-backed UNSAT on a subset excludes correctness on all 541 orders within that scope. Completed scopes are not repeated.

CPU accounting note: the first search logs use cumulative child-process CPU counters. Those counters can include the small checkpoint-audit process at each 16-window boundary. Later logs mark `cpu_counter: solver_only` and accumulate only Kissat child CPU deltas. The final aggregate is a recorded counter total; the early audit overhead cannot be separated exactly.

### Round-5 checkpoint: 66 windows

The serial batch has completed 66 of 352 windows. There are 65 checked UNSAT certificates and one UNSAT_UNCHECKED result. That result has a complete Kissat UNSAT exit but a 120-second certificate-check limit. The final verification stage will give that certificate a 600-second check limit. No target program has been decoded. The checkpoint audit passed at 64 windows. The largest sampled combined search resident set is 179,948 KiB. Scope: [G1,G2,G3,G4,A2,A11]. No assumption has been contradicted.

### Round-5 original 112 windows complete

All 112 prepared non-contiguous windows on the seven recovered programs have completed. Kissat returned UNSAT for all 112. The certificate checker validated 111 results. One 120-second certificate-check limit remains UNSAT_UNCHECKED. No search reached its 600-second limit, and no program was decoded. Recorded query wall time is 586.014 seconds, excluding certificate checks. The independent audit passed at 112 windows. This is a local exclusion only: [G1,G2,G3,G4,A2,A11]. The 240 additional windows on the 15 w6 representatives have started. The unchecked certificate remains queued for its longer final check.

Rejection-rule review: the copied search originally blocked an entire instruction core after a strict rejection. The new search blocks only that core together with the tested SAT output snapshots. A different output snapshot can remain available for the same core. The first strict judge call checks exactly those SAT-selected snapshots. At the time of this correction, all target queries had produced zero models, so no completed target result used the old rejection block. The fixed controls passed and did not use a rejection block.

### Round-5 checkpoint: 256 windows

Completed all 112 recovered-program windows and all 144 windows for the first nine w6 representatives. There are 255 checked UNSAT certificates and one unresolved certificate check. No target model has been decoded. No search has reached its 600-second limit. There are 96 w6 windows left. The largest sampled combined search resident set remains 179,948 KiB. Scope: [G1,G2,G3,G4,A2,A11].

### Round-5 completed windows

Round 5: 352/352 windows complete. Statuses: {'UNSAT': 351, 'UNSAT_UNCHECKED': 1}.

Checked UNSAT certificates: 351. Strict model judges: 0.

Query wall seconds: 1600.882. Largest sampled job RSS: 179948 KiB.

Assumptions [G1,G2,G3,G4,A2,A11]. Each exclusion concerns four free instruction positions, free output snapshots, and the stated finite register set. The scratch value above all inputs and equal initial flags define a necessary test state. Candidates require the strict judge. Time and resource limits remain UNKNOWN. No global lower bound follows.

### Round-5 final certificate audit

Completed 352 of 352 prepared windows. Final statuses: {'UNSAT': 352}. Groups: {'recovered': {'UNSAT': 112}, 'w6': {'UNSAT': 240}}. Checked target UNSAT certificates: 352. Strict decoded-program judges: 0. Recorded Kissat CPU time: 1430.010 seconds. Largest sampled combined search resident set: 179948 KiB.

The independent audit checks all original 112 scopes, every copied seed hash, retained UNSAT formula/proof hashes, successful certificate-check logs, solver exit statuses, and strict judge records. Its report is `round5/logs/independent_audit.json`. Full query records are in `round5/logs/summary.json`.

Assumptions [G1,G2,G3,G4,A2,A11]. Each exclusion applies only to its stated four-position window and finite register set. Every search or resource limit remains UNKNOWN. No global lower bound follows.

No k<=31 strict PASS was found.

### Round-5 free-position positive control

The additional control leaves four non-contiguous instruction positions free on all 541 weak orders. It allows all six opcodes and both operands. The remaining instructions stay fixed. The solver recovered a strict out PASS at k=32. This is a control, not a target result.

- PASS file: `/path/to/repo/agents/team/codex-fleet/w4/round5/candidates/free_positive32.s.model000.s`. Judge log: `/path/to/repo/agents/team/codex-fleet/w4/round5/candidates/free_positive32.s.model000.s.judge`.
- PASS file: `/path/to/repo/agents/team/codex-fleet/w4/round5/candidates/free_positive32.s`. Judge log: `/path/to/repo/agents/team/codex-fleet/w4/round5/logs/free_positive32_out.judge`.

The independent audit includes this control. Scope: [G1,G2,G3,G4,A2,A11].

CPU-counter clarification: later solver-only counters total 1205.060 seconds. Earlier child counters total 224.950 seconds. The earlier counters include a small, inseparable checkpoint-audit overhead. Thus the aggregate printed above is recorded child CPU time, not an exact pure Kissat total.

All round-5 search, certificate, control, and audit jobs have ended. Final target counts: 112 recovered-program windows plus 240 w6 windows; all 352 returned UNSAT and have checked certificates. No target model was decoded. Both k=32 positive controls passed the strict out judge. All four control PASS paths are listed above. The final audit includes all 22 copied seeds and every retained certificate. No assumption was contradicted. Scope: [G1,G2,G3,G4,A2,A11]. No k<=31 strict PASS was found.

## Round 6: partial columns as move data on known c=8 shapes

Read the complete previous results and w11/BRIEF.md, w12/BRIEF.md, and w13/BRIEF.md before starting. This round uses the 18 k=32 seeds in w6/verified. It does not repeat the completed local windows. It keeps known comparison-value columns and permits new data columns. It does not enumerate exactly two non-lattice columns, compare undefined values, or generate distant comparison structures. Those directions remain with w11, w12, and w13.

The method is in `round6/METHOD.md`. Each target deletes one non-comparison instruction and rebuilds all move data across the full core. The first 87 queries keep physical write destinations. Both comparison registers, all move sources, all move types, and output snapshots are free. The final six queries also free write destinations and add two registers. Comparison operands must match the source value columns. Partial scratch columns can feed conditional-move data. No lattice term pool limits intermediate values.

The fixed positive control passed the strict out and mem judges at k=32. The partial-data control passed both judges at k=36. That control has two partial scratch columns and two reads of partial data. These are encoding controls and do not meet the target. The wrong-output control returned UNSAT with a checked certificate. Exact control records: `round6/logs/controls.json`.

Control PASS paths:

- `round6/candidates/positive32.s.model000.s`, strict out log of the same name plus `.judge`.
- `round6/candidates/positive32.s`, copied from that strict PASS model.
- `round6/verified/positive32.s`, strict out log `round6/logs/positive32_out.judge`.
- `round6/verified/positive32_mem.s`, strict mem log `round6/logs/positive32_mem.judge`.
- `round6/candidates/partial_data36.s.model000.s`, strict out log of the same name plus `.judge`.
- `round6/candidates/partial_data36.s`, copied from that strict PASS model.
- `round6/verified/partial_data36.s`, strict out log `round6/logs/partial_data36_out.judge`.
- `round6/verified/partial_data36_mem.s`, strict mem log `round6/logs/partial_data36_mem.judge`.

The serial campaign is running. Task definitions: `round6/logs/tasks.json`. Live records: `round6/logs/controller.log`, `round6/logs/progress.json`, and `round6/logs/summary.json`. Every search and judge inherits nice level 19, one CPU, and the 2,800 MiB address-space limit. Each UNSAT certificate is checked before the next search. Limits remain UNKNOWN.

Assumptions: [G1,G2,G3,G4,A2,A4,A11]. This round tests the partial-column gap in A15. It does not assume A15. No assumption has been contradicted. No k<=31 strict PASS is claimed.

### Round-6 first pass complete

All 87 whole-core queries with fixed write destinations returned UNSAT. drat-trim checked all 87 certificates. The queries span all 18 source seeds. They recorded 131.834 query wall seconds and 104.361 Kissat CPU seconds. No target model was decoded. Their largest sampled combined Python/Kissat resident set was 39,496 KiB.

The six queries with free write destinations and two additional registers have started. The first-pass exclusions remain limited to the stated comparison-value columns, instruction positions, physical write destinations, and finite register sets. Assumptions: [G1,G2,G3,G4,A2,A4,A11]. No assumption was contradicted.

### Round-6 first batch complete and audited

The first batch completed all 93 targets: 87 checked UNSAT results and six UNKNOWN results. All six free-destination queries reached their 120-second limits. No target model was decoded. The independent record audit passed: `round6/logs/independent_audit.json`.

The symbolic positive control leaves five move positions free and permits free comparison registers on all 541 orders. It passed the strict out judge at k=32. PASS file: `round6/candidates/symbolic_positive32.s`. Judge log: `round6/logs/symbolic_positive32.judge`.

The symbolic partial-data control leaves two move positions free on all 541 orders. It passed the strict out judge at k=36. PASS file: `round6/candidates/symbolic_partial36.s`. Judge log: `round6/logs/symbolic_partial36.judge`. These are controls, not target results.

### Follow-up preflight correction

The follow-up uses scratch-register symmetry and starts from the 31 binary orders. Its first 25 target attempts failed during Kissat parsing. The encoder wrote a fixed-false selector as integer zero after enabling canonical register rows. None reached a solver decision. None counts as an exclusion. Their original automatic UNKNOWN labels describe incomplete attempts; the cause was an encoding error, not a time limit.

The preflight records are retained in `round6/extra/preflight_logs/`, `preflight_cnf/`, `preflight_candidates/`, `preflight_verified/`, and `preflight_src/`. Absolute paths within those old records refer to their locations before this archive move. The follow-up now uses the encoder's Boolean-negation helper. The wrapper rejects any zero or non-integer literal before it writes CNF. An unexpected Kissat exit now raises an error. The audit also accepts the explicit 16-register test instead of imposing the ordinary 11-register cap. These corrections do not affect the first batch, which did not enable canonical register rows and produced no target models.

The corrected follow-up is running serially. It includes six unknown-scope retries, 18 early-deletion scopes, and one 16-register scope. The symmetry check found no duplicate scopes among these 25 tasks. Task definitions and current results are in `round6/extra/logs/`.

Assumptions: [G1,G2,G3,G4,A2,A4,A11]. No assumption has been contradicted. No k<=31 strict PASS has been found.

### Corrected follow-up checkpoint: 14 queries

Completed the six canonical-routing retries and eight early-deletion queries. All 14 remain UNKNOWN at their limits. The corrected encoder produced three k=31 models. Every model failed the strict out judge. No new exclusion is claimed by this checkpoint.

The saved models are:

- `round6/extra/candidates/retry_free_v17_d28.s.model000.s`: selected-output error counts `[0,0,117,0,0]` in the conservative evaluator. Its comparison columns differ from the requested columns on 27 weak orders.
- `round6/extra/candidates/retry_free_v11_d29.s.model000.s`: selected-output error counts `[0,98,0,0,0]`. All requested comparison columns match on all 541 orders. The evaluator records one partial result and a later conditional-move read of that partial data.
- `round6/extra/candidates/retry_free_v07_d28.s.model000.s`: selected-output error counts `[0,117,216,0,0]`. The evaluator records two partial results and no later partial-data read. Its comparison columns differ on 228 orders.

Each strict FAIL log is the program path plus `.judge`. These are failed candidates, not shorter sort5 programs. The final model analysis will independently count the failing orders for equal initial flags and scratch value 5. It will also check alternative output snapshots.

Scope: [G1,G2,G3,G4,A2,A4,A11]. The checked exclusion count remains 87 from the first batch. No assumption has been contradicted.

### Canonical-routing follow-up complete

All 25 corrected free-destination queries reached their limits and remain UNKNOWN. This includes six late-deletion retries, 18 early-deletion scopes, and the 16-register test. No target exclusion follows from this batch. The record audit passed: `round6/extra/logs/independent_audit.json`.

The batch saved four k=31 candidate files. All four failed the strict out judge. The 16-register query produced another model with selected-output errors `[0,0,117,0,0]` and 27 comparison-column mismatches. This is similar to the earlier retry model; the final analysis will count distinct instruction cores.

Recorded query wall time: 1981.823 seconds. Recorded Kissat CPU time: 1933.363 seconds. Largest sampled combined Python/Kissat resident set: 250,316 KiB. Every query ran serially at nice level 19. Source and formula hashes remain in the audit and query records.

The six required-partial scopes have started. Each requires two mixed conditional-move results and one mixed conditional-move data source on the initial 31 binary orders. The two-partial-column k=36 positive control passed both strict judges with those extra witness constraints. Its PASS paths and the final counts will appear in the final round-6 report. Assumptions: [G1,G2,G3,G4,A2,A4,A11]. No assumption has been contradicted.

### Round-6 completed campaign and final audit

| Batch | Target queries | Checked UNSAT | UNKNOWN | Decoded models |
|---|---:|---:|---:|---:|
| First batch | 93 | 87 | 6 | 0 |
| Canonical routing | 25 | 0 | 25 | 4 |
| Required partial witnesses | 6 | 0 | 6 | 0 |

The six canonical-routing retries revisit unknown scopes. The required-partial queries add restrictions to unresolved scopes. These row counts are query counts, not counts of disjoint program classes. The 25 parser failures from the preflight are excluded from this table. All listed UNSAT certificates were checked. Every limit remains UNKNOWN.

Recorded target query wall time: 3554.465 seconds. Recorded Kissat CPU time: 3454.109 seconds. Largest sampled combined Python/Kissat resident set: 250316 KiB. Queries, judges, certificate checks, and analysis jobs ran serially at nice level 19.

The model analysis covers 4 saved k<=31 candidates with 3 distinct cores. The minimum failure count with all scratch values set to 5 and initial flags equal is 98. These counts are observations for that initial state. The strict judge determines correctness. The analysis also checks whether another set of output snapshots can sort all 541 orders for each core. Full records and failure indices are in `round6/logs/model_analysis.json`.

Assumptions: [G1,G2,G3,G4,A2,A4,A11]. The first batch keeps physical write destinations. The broader batches free them. All batches keep comparison-value columns and comparison positions. Register sets remain finite. The required-partial batch also requires two mixed conditional-move results and one mixed conditional-move source among its initial 31 binary orders. Its exclusions do not cover partial columns visible only on other orders. No global lower bound follows. No assumption has been contradicted.

The fixed k=32 program with no partial columns returned UNSAT when required to contain two partial results. Its certificate was checked. Together with the k=36 partial-data positive control, this checks both outcomes of the extra witness condition. Record: `round6/partial/logs/negative_partial32.json`.

Every retained round-6 control PASS path is listed below. These controls have k=32 or k=36.

- `round6/candidates/positive32.s.model000.s` (out); judge: `round6/candidates/positive32.s.model000.s.judge`.
- `round6/candidates/positive32.s` (out); judge: `round6/candidates/positive32.s.model000.s.judge`.
- `round6/verified/positive32.s` (out); judge: `round6/logs/positive32_out.judge`.
- `round6/verified/positive32_mem.s` (mem); judge: `round6/logs/positive32_mem.judge`.
- `round6/candidates/partial_data36.s.model000.s` (out); judge: `round6/candidates/partial_data36.s.model000.s.judge`.
- `round6/candidates/partial_data36.s` (out); judge: `round6/candidates/partial_data36.s.model000.s.judge`.
- `round6/verified/partial_data36.s` (out); judge: `round6/logs/partial_data36_out.judge`.
- `round6/verified/partial_data36_mem.s` (mem); judge: `round6/logs/partial_data36_mem.judge`.
- `round6/extra/candidates/positive32.s.model000.s` (out); judge: `round6/extra/candidates/positive32.s.model000.s.judge`.
- `round6/extra/candidates/positive32.s` (out); judge: `round6/extra/candidates/positive32.s.model000.s.judge`.
- `round6/extra/verified/positive32.s` (out); judge: `round6/extra/logs/positive32_out.judge`.
- `round6/extra/verified/positive32_mem.s` (mem); judge: `round6/extra/logs/positive32_mem.judge`.
- `round6/extra/candidates/partial_data36.s.model000.s` (out); judge: `round6/extra/candidates/partial_data36.s.model000.s.judge`.
- `round6/extra/candidates/partial_data36.s` (out); judge: `round6/extra/candidates/partial_data36.s.model000.s.judge`.
- `round6/extra/verified/partial_data36.s` (out); judge: `round6/extra/logs/partial_data36_out.judge`.
- `round6/extra/verified/partial_data36_mem.s` (mem); judge: `round6/extra/logs/partial_data36_mem.judge`.
- `round6/partial/candidates/positive32.s.model000.s` (out); judge: `round6/partial/candidates/positive32.s.model000.s.judge`.
- `round6/partial/candidates/positive32.s` (out); judge: `round6/partial/candidates/positive32.s.model000.s.judge`.
- `round6/partial/verified/positive32.s` (out); judge: `round6/partial/logs/positive32_out.judge`.
- `round6/partial/verified/positive32_mem.s` (mem); judge: `round6/partial/logs/positive32_mem.judge`.
- `round6/partial/candidates/partial_data36.s.model000.s` (out); judge: `round6/partial/candidates/partial_data36.s.model000.s.judge`.
- `round6/partial/candidates/partial_data36.s` (out); judge: `round6/partial/candidates/partial_data36.s.model000.s.judge`.
- `round6/partial/verified/partial_data36.s` (out); judge: `round6/partial/logs/partial_data36_out.judge`.
- `round6/partial/verified/partial_data36_mem.s` (mem); judge: `round6/partial/logs/partial_data36_mem.judge`.
- `round6/candidates/symbolic_positive32.s` (out); judge: `round6/logs/symbolic_positive32.judge`.
- `round6/candidates/symbolic_partial36.s` (out); judge: `round6/logs/symbolic_partial36.judge`.
- `round6/extra/preflight_candidates/partial_data36.s` (out); judge: `round6/extra/preflight_logs/preflight_candidates_partial_data36.s.recheck.judge`.
- `round6/extra/preflight_candidates/partial_data36.s.model000.s` (out); judge: `round6/extra/preflight_logs/preflight_candidates_partial_data36.s.model000.s.recheck.judge`.
- `round6/extra/preflight_candidates/positive32.s` (out); judge: `round6/extra/preflight_logs/preflight_candidates_positive32.s.recheck.judge`.
- `round6/extra/preflight_candidates/positive32.s.model000.s` (out); judge: `round6/extra/preflight_logs/preflight_candidates_positive32.s.model000.s.recheck.judge`.
- `round6/extra/preflight_verified/partial_data36.s` (out); judge: `round6/extra/preflight_logs/preflight_verified_partial_data36.s.recheck.judge`.
- `round6/extra/preflight_verified/partial_data36_mem.s` (mem); judge: `round6/extra/preflight_logs/preflight_verified_partial_data36_mem.s.recheck.judge`.
- `round6/extra/preflight_verified/positive32.s` (out); judge: `round6/extra/preflight_logs/preflight_verified_positive32.s.recheck.judge`.
- `round6/extra/preflight_verified/positive32_mem.s` (mem); judge: `round6/extra/preflight_logs/preflight_verified_positive32_mem.s.recheck.judge`.

The audit reports are `round6/logs/independent_audit.json`, `round6/extra/logs/independent_audit.json`, and `round6/partial/logs/independent_audit.json`. All scheduled jobs have ended.

No k<=31 program passed the strict judge in this round.
