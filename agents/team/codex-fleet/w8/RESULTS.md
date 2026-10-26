No program with core k <= 31 passed the strict judge.

## Purpose

Search sort5 programs with nine comparisons and at most 31 core instructions. Use partner values and value sets outside sorting networks.

## Terms

- Core k counts register moves, comparisons, and conditional moves. The memory length is k + 10.
- A value column lists one register value on each of the 120 strict input orders.
- A skeleton fixes the comparison operand columns. A non-lattice column has no min/max term representation on these orders.
- NONE means the routing search completed in its stated representation. LIMIT and TIMEOUT leave the case open.
- A SAT solver searches Boolean assignments. UNSAT concerns the stated encoding. It is not a general sort5 lower bound.
- PASS means the reference judge accepted the file with --strict.

## Method

`src/switch_prefix.cpp` enumerates nine-comparison sequences. One comparison conditionally swaps two disjoint pairs. One pair supplies the comparison operands. The other pair carries partner values. The switch occurs at comparison 2, 3, 4, 5, or 6. Ordinary compare-exchange steps complete the sequence.

`src/two_switch.cpp` adds another partner swap to each one-swap sequence. It retains traces that send all 120 strict orders to one fixed permutation. These traces are skeleton sources. They are not strict-judge candidates.

`src/mutation.cpp` changes one operation in the supplied k=32 functional graph. Each conditional move creates a new value node in this graph. The generator requires comparison histories that distinguish all 120 strict orders. `src/second_mutation.py` repeats the pass on twelve retained graphs.

The canonical form removes input renaming and independent comparison reversal. It does not remove all possible program symmetries. `src/check_canonical.cpp` matched a full 120-renaming reference on 240 seeded cases. This check is not a proof.

`src/dagx.cpp` is the w2 router with its conservative open-requirement bound. It searches moves, conditional moves, register reuse, and output times. `src/route_batch.py` records node and time limits.

`src/pool_sat.py` is the w2 finite-pool router. It permits at most two copies of each permitted column. Its UNSAT results do not close the unrestricted routing cases. Every decoded candidate must pass the strict judge.

Search jobs used nice -n 10. At most eight CPU search jobs ran together. Routing and SAT subprocesses had a 3 GiB address-space limit. See `RUNS.md` for commands.

## Result

Generation counts:

| Family | Retained skeletons |
| --- | ---: |
| Partner swap at comparison 2 | 707 |
| Partner swap at comparison 3 | 1,489 |
| Partner swap at comparison 4 | 2,340 |
| Partner swap at comparison 5 | 2,856 |
| Partner swap at comparison 6 | 2,062 |
| Two partner swaps | 25,485 |

The separate pair-carry generator retained 513 cases. All 513 occur in the comparison-3 family. The one-swap union has 9,454 cases. Adding five non-lattice functional mutations gives the 9,459-case broad search set.

The two-swap generator tested 170,172 mutations. It found 34,442 traces that sort strict orders. Canonicalization retained 25,485 skeletons. Of these, 651 require at most 17 non-input columns. Removing 90 one-swap cases left 561 priority cases. The other two-swap cases did not receive routing searches.

The first functional pass tested 15,705 mutations. It retained twelve skeletons relative to the control. Five have non-lattice operands. The second pass tested 188,460 mutations. It produced 170 records. Removing 39 first-pass cases and 43 duplicates left 88 skeletons. Sixty-nine have non-lattice operands.

The fixed-graph copy search tested 168 first-pass layouts. Their lengths were k=32 or k=33. It tested two layouts per strict-order sorting graph. One layout merges equal columns. Output nodes remain fixed in each tested layout. This is not a minimum over every possible output choice.

Second-pass fixed-graph layouts: k=32: 428, k=33: 304. No tested layout had k <= 31.

Routing batches:

| Batch | Cases | Results | Recorded calls |
| --- | ---: | --- | ---: |
| broad100k | 3202 | LIMIT 1303, NONE 1882, TIMEOUT 17 | 192,598,331 |
| broad20k | 6167 | LIMIT 4611, NONE 1556 | 106,628,896 |
| mutation_deep | 1 | TIMEOUT 1 | 0 |
| priority17 | 18 | NONE 18 | 23,283,818 |
| priority5 | 72 | NONE 72 | 45,768,208 |
| selected1m | 404 | LIMIT 63, NONE 324, TIMEOUT 17 | 201,753,665 |
| selected1m_remaining | 155 | LIMIT 61, NONE 86, TIMEOUT 8 | 85,559,593 |
| two_priority50k | 469 | LIMIT 413, NONE 56 | 22,789,129 |

The batches overlap. A later NONE closes an earlier limited search for the same skeleton. Interrupted processes can have unreported calls. The table does not count those calls.

Finite-pool SAT batches:

| Batch | Cases | Results |
| --- | ---: | --- |
| mutation2_sat | 69 | UNSAT 69 |
| mutation_sat | 5 | UNSAT 5 |
| two_limited_sat | 43 | UNSAT 43 |

The first finite-pool k=31 target also returned UNSAT. Its log is `logs/priority17_sat.log`. Its pool has 23 columns. The free-copy gate lower bound is 18.

Final canonical audit:

- Selected source records: 10,089.
- Distinct selected skeletons: 10,089.
- New skeletons relative to the cached corpus: 10,069.
- New-case routing status: NONE 3994, UNRESOLVED 6075.
- Routing status: NONE 3994, PRIOR_MATCH 18, UNRESOLVED 6077.
- Recorded routing calls: 678,381,640.
- Prior canonical keys: 8245. Selected skeletons that match the cache: 20.

`logs/audit.json` contains the final counts and prior matches. `sk/open_cases.json` contains unresolved new skeletons and their recorded statuses. Prior matches are listed separately. Eighteen matched cases were excluded before deeper routing. Two first-pass mutation skeletons had already received bounded routing rechecks. The SAT batches include all twenty prior-matching mutation cases as rechecks.

The prior check reads nine-comparison .txt files from d1 and w2. It includes linked files. It reads the first pair on a line with alternatives. It does not enumerate all alternative combinations.

Every strict PASS file:

| File | Model | Length | Judge log |
| --- | --- | ---: | --- |
| `programs/fixed_control_000000.s` | out | 32 | `logs/fixed_control_000000.judge.log` |
| `programs/fixed_control_000000_mem.s` | mem | 42 | `logs/fixed_control_000000_mem.judge.log` |
| `programs/known32.s` | out | 32 | `logs/known32.judge.log` |
| `programs/router_control32.s` | out | 32 | `logs/router_control32.judge.log` |
| `programs/router_control32_mem.s` | mem | 42 | `logs/router_control32_mem.judge.log` |
| `programs/sat_control32.s` | out | 32 | `logs/sat_control32.judge.log` |
| `programs/sat_control32_mem.s` | mem | 42 | `logs/sat_control32_mem.judge.log` |

These PASS files are controls. They match k=32 or memory length 42. They do not improve AlphaDev's length. `logs/judge_registry.json` stores exact PASS lines and file hashes.

Dead ends:

- Early broad corpus scans were cancelled. The later filter replaces them. Cancelled scans give no negative result.
- Single-operation and two-operation functional mutations gave no tested fixed-graph layout below k=32.
- Finite-pool SAT checks found no target candidate. Their negative scope remains the permitted pool and copy limit.
- Some routing cases reached node or time limits. They remain open.

## Limits

The generators cover the stated partner-swap sequences and functional mutations. They do not cover every nine-comparison program. Sorting the 120 strict orders does not establish correctness on ties or arbitrary scratch state.

The router starts from the five input columns. It creates fully defined conditional-move values. It does not search programs that keep scratch registers only partly initialized.

Only a strict-judge PASS establishes candidate correctness here. The judge checks all 541 weak orders and arbitrary scratch values and flags. A completed routing result concerns its fixed skeleton representation. It is not a general sort5 lower bound.

## Conclusion

No target improvement was verified. The shortest verified register controls have k=32. Their memory versions have length 42. The unresolved cases remain available for later searches.

## Round 2 initial checkpoint (2026-10-26; superseded below)

Assumptions tested: [A4, A8]. No assumption contradiction is established.

The initial unresolved list is frozen in `sk/round2_original_open.json`.
The rerun manifest has 6,075 cases. It sorts cases by required non-input
columns, then node limit. Each case gets ten times its largest prior node
limit. The limits are 200,000 (4,611 cases), 1,000,000 (1,315 cases),
10,000,000 (148 cases), and 100,000,000 (one case). LIMIT means unknown.

The net9_41 single-operation pass tested 15,705 mutations and retained 14
skeletons. The new partner-select generator tested 12,941 variants and
retained 105 skeletons after canonical exclusion and deduplication. A separate
evaluator checked all 105 saved graphs against their saved operand columns
and their 120 distinct comparison histories. After six lattice-only cases
were removed, the new routing set has 113 skeletons. Its node limit is one
million per case. Required columns: 15 in 61 cases; 16 in 52 cases.

Fixed-graph layout counts: k=32: 106; k=33: 58; k=34: 72; k=35: 2. These
counts cover 238 layouts. None meets the target. They do not close routing.

`src/dagx_cache.cpp` caches the exact copy-count calculation. Eight checks
matched the original router's results, node counts, and emitted solution.
See `logs/round2_cache_check.json`. This check is not a proof.

New strict control PASS files:

| File | Model | Length | Judge log |
| --- | --- | ---: | --- |
| `programs/round2_control32.s` | out | 32 | `logs/round2_control32.judge.log` |
| `programs/round2_control32_mem.s` | mem | 42 | `logs/round2_control32_mem.judge.log` |

Exact judge output:

```text
PASS programs/round2_control32.s [relaxed+strict] n=5 L=32 R=10 iset=I1 model=out
PASS programs/round2_control32_mem.s [relaxed+strict] n=5 L=42 R=15 iset=I1 model=mem
```

The batch uses one routing process at a time, nice -n 19, and a 3 GiB
address-space limit. Live state counts are in `logs/round2_net41/summary.json`
and `logs/round2_rerun/summary.json`. The second file appears when the rerun
starts. Each result also has a full router log. No k <= 31 strict PASS has
been recorded at this checkpoint. The final round-two report follows below.

## Round 2: tenfold reruns and net9_41 partner selections

Report time: 2026-10-26T03:24:58.955793+00:00.

Assumptions tested: [A4, A8]. Each routing search fixes one comparison skeleton. The added skeletons use values outside the lattice scope. No general lower bound follows from this search.

Resource limits for this round: one routing process at a time; nice -n 19; 3 GiB address-space limit. All writes stay in the w8 folder.

The frozen initial list is `sk/round2_original_open.json`. It has 6,075 unresolved cases. Each rerun uses ten times its largest prior node limit. The queue sorts cases by required non-input columns, then by node limit and file name. A required non-input column needs at least one conditional move. State counts are the router's recursive-call counts. They include pruned calls and a small overrun while the search returns from the node limit. There is no wall-time cutoff in this round. LIMIT remains unknown.

| Required columns | Initial cases | Reruns completed | NONE | LIMIT | Other | Recorded states |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 15 | 47 | 47 | 0 | 47 | 0 | 560,005,169 |
| 16 | 87 | 87 | 80 | 7 | 0 | 235,471,111 |
| 17 | 15 | 15 | 15 | 0 | 0 | 18,442,323 |
| 18 | 5621 | 5621 | 2311 | 3310 | 0 | 1,307,980,513 |
| 19 | 171 | 171 | 170 | 1 | 0 | 8,406,856 |
| 20 | 134 | 134 | 134 | 0 | 0 | 6,908,034 |

Node limits: 4,611 cases at 200,000; 1,315 at 1,000,000; 148 at 10,000,000; one at 100,000,000.

`src/partner_select.cpp` inserts a non-lattice selector into the net9_41 functional graph. It replaces each later comparison operand separately. It also replaces all later uses of each available source value. Within one comparison block, the generator keeps the first insertion point for each selected column. It excludes known canonical skeletons. The scan uses both strict and non-strict conditional-move conditions.

The generator made 1,421 distinct non-lattice selected columns. It tested 12,941 redirects. Of these, 2,758 separate all 120 strict input orders. Canonicalization excluded 178 known records and 2,475 duplicates. It retained 105 skeletons. A separate evaluator checked all 105 saved graphs against their exact skeleton columns and flag histories.

The single-operation net9_41 mutation pass tested 15,705 changes. It retained 14 skeletons. Six of the 119 combined skeletons have only lattice comparison operands. The new routing set has 113 non-lattice skeletons: 61 need at least 15 columns; 52 need at least 16. Each new case has a 1,000,000-node limit. A separate audit found no canonical matches against the prior cache or the d6 net9_41 skeleton set. See `logs/round2_net41_prior_audit.json`.

| Batch | Planned | Completed | Status counts | Recorded states |
| --- | ---: | ---: | --- | ---: |
| round2_net41 | 113 | 113 | LIMIT 113 | 113,011,519 |
| round2_rerun | 6075 | 6075 | LIMIT 3365, NONE 2710 | 2,137,214,006 |

Fixed-graph copy minimization tested two layouts for each of 119 retained sorting traces. Its length counts are k=32: 106, k=33: 58, k=34: 72, k=35: 2. No tested layout had k <= 31. These are fixed-graph layout results, not unrestricted routing results.

`src/dagx_fast.cpp` caches the exact copy bound. The cache key includes every resolved gate, its block, its two operand nodes, and all current comparison uses. It omits value columns because the bound does not read them. The search order and pruning decisions stay the same. It also caches the exact prefix-consistency test by partial column and comparison block. The prefix classes remain fixed within each process. `logs/round2_cache_check.json` records eight cached/original comparisons. `logs/round2_cache2_check.json` records eight more comparisons after the second cache was added. `logs/round2_fast_check.json` records ten comparisons after covered-order masks were stored in each column. The final change reduced aggregate CPU time in those ten checks from 2.105325 to 1.490461 seconds. These timings do not establish a full-batch speed ratio. Every result, node count, and emitted solution matched after timing and cache statistics were removed. This check is evidence for the implementation. It is not a proof.

Control judge output (`logs/round2_control32.judge.log`):

```text
PASS programs/round2_control32.s [relaxed+strict] n=5 L=32 R=10 iset=I1 model=out
```

Control judge output (`logs/round2_control32_mem.judge.log`):

```text
PASS programs/round2_control32_mem.s [relaxed+strict] n=5 L=42 R=15 iset=I1 model=mem
```

Combined canonical audit (`logs/round2_audit.json`): 10202 selected skeletons; NONE 6704, PRIOR_MATCH 18, UNRESOLVED 3480. The full new-case unresolved list, including the 113 added skeletons, is `sk/round2_all_open_cases.json`. It contains 3478 cases. Two unresolved prior-cache matches are recorded separately in the audit.

Unclosed cases from the initial 6,075-case list: 3365. `sk/round2_remaining.json` preserves their status. Only NONE closes a negative search within the router representation. LIMIT, ERROR, and unprocessed cases remain unknown.

New control PASS files: `programs/round2_control32.s` (out, k=32) and `programs/round2_control32_mem.s` (mem, length 42). Their exact judge output is shown above. Earlier PASS files remain listed in the first report.

No k <= 31 strict PASS was recorded in this round.

## Round 3: changed search order (supervisor 04:30)

Report time: 2026-10-26T04:06:12.051540+00:00.

Assumptions tested: [A4, A8]. No assumption contradiction was established.

The round used the permitted search-order alternative. Prior logs had no full-tree size estimate. This report does not infer a full-tree ratio from a limited prefix.

`src/dagx_order.cpp` adds independent search-order controls. Mode bit 1 resolves the conditional-move operand with more constrained strict orders first. Mode bit 2 visits earlier comparison blocks first. Mode bit 4 reverses the order of the initial comparison-operand requirements. Mode bit 8 resolves output requirements in median-first order. All gate choices remain available. The bound formulas are unchanged. The controls change only the search order. Mode 0 retains the previous traversal.

All searches ran one process at a time, with nice -n 19 and a 3 GiB address-space limit. The node limit controls each search. There was no wall-time cutoff. State counts include recursive calls pruned at entry and the small limit overrun during return.

| Batch | Search cases | Status counts | Recorded states | CPU seconds |
| --- | ---: | --- | ---: | ---: |
| round3_bench | 140 | FOUND 4, LIMIT 24, NONE 112 | 115,167,812 | 173.130 |
| round3_bench2 | 88 | FOUND 4, LIMIT 24, NONE 60 | 47,426,429 | 68.853 |
| round3_deep200 | 200 | LIMIT 40, NONE 160 | 190,380,953 | 258.631 |
| round3_order200 | 200 | LIMIT 178, NONE 22 | 373,451,902 | 504.850 |

Ordering checks:

- `round3_bench`: mode 0 matched the earlier NONE result and exact state count on 25 completed negative cases.
- `round3_bench`, mode 1: the same 25 negative cases completed. Full-tree states were 20,503,545, compared with 22,453,205 before reordering (ratio 0.913168).
- `round3_bench`, mode 2: the same 25 negative cases completed. Full-tree states were 22,453,205, compared with 22,453,205 before reordering (ratio 1.000000).
- `round3_bench`, mode 3: the same 25 negative cases completed. Full-tree states were 20,503,545, compared with 22,453,205 before reordering (ratio 0.913168).
- `round3_bench2`: mode 0 matched the earlier NONE result and exact state count on 12 completed negative cases.
- `round3_bench2`, mode 5: the same 12 negative cases completed. Full-tree states were 4,117,890, compared with 5,389,013 before reordering (ratio 0.764127).
- `round3_bench2`, mode 9: the same 12 negative cases completed. Full-tree states were 4,699,605, compared with 5,389,013 before reordering (ratio 0.872072).
- `round3_bench2`, mode 13: the same 12 negative cases completed. Full-tree states were 4,117,890, compared with 5,389,013 before reordering (ratio 0.764127).

These completed-case checks support the implementation. They do not prove it correct. Ratios above concern completed negative controls only. A bounded prefix does not estimate a full search-tree size.


The frozen 200-case queue is `sk/round3_order200.json`. It includes all 167 initial unknown cases that require 15 or 16 non-input columns. Its other 33 cases sample the comparison-3, comparison-4, comparison-5, and comparison-6 partner-swap families. Cases closed by the ordering benchmark were excluded before queue selection. Each case has a 2,000,000-node limit under the selected new order. This is a changed-order rerun, not a claim that every case received 100 times its prior node limit.

| Required columns | Cases | Status counts | Recorded states |
| --- | ---: | --- | ---: |
| 15 | 108 | LIMIT 108 | 216,010,858 |
| 16 | 59 | LIMIT 59 | 118,005,767 |
| 18 | 33 | LIMIT 11, NONE 22 | 39,435,277 |

All 113 net9_41 cases were rerun under mode 13. Their statuses are {'LIMIT': 113}.

The 200-case additional queue has prior copy-bound visit ratios from 0.468885123 to 0.560627040.

Additional 100-fold original-limit queue: `sk/round3_deep200.json` contains 200 other unresolved cases. The queue excludes all 200 cases in the main changed-order queue. It ranks cases by the ratio of visits to the exact copy bound to recursive calls in the previous limited run. This ratio is a recorded prefix statistic, not a full-tree size estimate. Each selected case received 2,000,000 states: 100 times its original 20,000-state limit and ten times its round-two 200,000-state limit. Mode 13 supplied the changed order.

`round3_order200` closed 5 cases within their previous node limits under the new order. There were 22 completed negative cases in this batch.

`round3_deep200` closed 20 cases within their previous node limits under the new order. There were 160 completed negative cases in this batch.

The two dedicated queues searched 400 distinct cases: NONE 182, LIMIT 218. They recorded 563,832,855 states. Including the ordering checks, this round recorded 726,427,096 states.

Remaining new unknown cases by required non-input columns: 15: 108, 16: 59, 18: 3126. The unresolved list records the largest node limit tested under each search order.

Relative to the initial 3,478 new unknown skeletons, this round closed 185 with NONE. The remaining 3293 are unknown. `logs/round3_audit.json` lists each newly closed file. `sk/round3_all_open_cases.json` preserves every remaining unknown case. The two separately recorded prior-cache matches remain outside this list.

NONE concerns only the fixed skeleton and the router representation. The router permits non-lattice intermediate columns and unbounded register names. It starts from fully initialized inputs. Its negative search is on 120 strict input orders. It does not close the general nine-comparison search or the garbage-partial-register gap. LIMIT remains unknown.

New strict control PASS files:

| File | Model | Exact judge log |
| --- | --- | --- |
| `programs/round2_round3_bench_034_order0.s` | out | `logs/round2_round3_bench_034_order0.judge.log` |
| `programs/round2_round3_bench_034_order0_mem.s` | mem | `logs/round2_round3_bench_034_order0_mem.judge.log` |
| `programs/round2_round3_bench_034_order1.s` | out | `logs/round2_round3_bench_034_order1.judge.log` |
| `programs/round2_round3_bench_034_order1_mem.s` | mem | `logs/round2_round3_bench_034_order1_mem.judge.log` |
| `programs/round2_round3_bench_034_order2.s` | out | `logs/round2_round3_bench_034_order2.judge.log` |
| `programs/round2_round3_bench_034_order2_mem.s` | mem | `logs/round2_round3_bench_034_order2_mem.judge.log` |
| `programs/round2_round3_bench_034_order3.s` | out | `logs/round2_round3_bench_034_order3.judge.log` |
| `programs/round2_round3_bench_034_order3_mem.s` | mem | `logs/round2_round3_bench_034_order3_mem.judge.log` |
| `programs/round2_round3_bench_021_order0.s` | out | `logs/round2_round3_bench_021_order0.judge.log` |
| `programs/round2_round3_bench_021_order0_mem.s` | mem | `logs/round2_round3_bench_021_order0_mem.judge.log` |
| `programs/round2_round3_bench_021_order5.s` | out | `logs/round2_round3_bench_021_order5.judge.log` |
| `programs/round2_round3_bench_021_order5_mem.s` | mem | `logs/round2_round3_bench_021_order5_mem.judge.log` |
| `programs/round2_round3_bench_021_order9.s` | out | `logs/round2_round3_bench_021_order9.judge.log` |
| `programs/round2_round3_bench_021_order9_mem.s` | mem | `logs/round2_round3_bench_021_order9_mem.judge.log` |
| `programs/round2_round3_bench_021_order13.s` | out | `logs/round2_round3_bench_021_order13.judge.log` |
| `programs/round2_round3_bench_021_order13_mem.s` | mem | `logs/round2_round3_bench_021_order13_mem.judge.log` |

Exact judge output:

```text
PASS programs/round2_round3_bench_034_order0.s [relaxed+strict] n=5 L=32 R=10 iset=I1 model=out
PASS programs/round2_round3_bench_034_order0_mem.s [relaxed+strict] n=5 L=42 R=15 iset=I1 model=mem
PASS programs/round2_round3_bench_034_order1.s [relaxed+strict] n=5 L=32 R=10 iset=I1 model=out
PASS programs/round2_round3_bench_034_order1_mem.s [relaxed+strict] n=5 L=42 R=15 iset=I1 model=mem
PASS programs/round2_round3_bench_034_order2.s [relaxed+strict] n=5 L=32 R=10 iset=I1 model=out
PASS programs/round2_round3_bench_034_order2_mem.s [relaxed+strict] n=5 L=42 R=15 iset=I1 model=mem
PASS programs/round2_round3_bench_034_order3.s [relaxed+strict] n=5 L=32 R=10 iset=I1 model=out
PASS programs/round2_round3_bench_034_order3_mem.s [relaxed+strict] n=5 L=42 R=15 iset=I1 model=mem
PASS programs/round2_round3_bench_021_order0.s [relaxed+strict] n=5 L=32 R=10 iset=I1 model=out
PASS programs/round2_round3_bench_021_order0_mem.s [relaxed+strict] n=5 L=42 R=15 iset=I1 model=mem
PASS programs/round2_round3_bench_021_order5.s [relaxed+strict] n=5 L=32 R=10 iset=I1 model=out
PASS programs/round2_round3_bench_021_order5_mem.s [relaxed+strict] n=5 L=42 R=15 iset=I1 model=mem
PASS programs/round2_round3_bench_021_order9.s [relaxed+strict] n=5 L=32 R=10 iset=I1 model=out
PASS programs/round2_round3_bench_021_order9_mem.s [relaxed+strict] n=5 L=42 R=15 iset=I1 model=mem
PASS programs/round2_round3_bench_021_order13.s [relaxed+strict] n=5 L=32 R=10 iset=I1 model=out
PASS programs/round2_round3_bench_021_order13_mem.s [relaxed+strict] n=5 L=42 R=15 iset=I1 model=mem
```

The verified controls have k=32 in the out model and length 42 in the memory model. No target improvement was verified.

## Round 4 checkpoint: new skeleton classes (supervisor correction 05:30)

Assumptions tested: [A4, A8]. The 3,293 unresolved round-three skeletons are assigned to d1-skeleton. This round does not rerun those nine-comparison cases. A repeated-comparison extension has ten comparisons and is a new routing case.

`src/rotation_prefix.cpp` adds a conditional three-cycle on the three wires outside one compared pair. If the first compared value is larger, the step swaps the compared values and rotates the other three values. The scan covers both cycle directions. The special step occurs at comparison 2, 3, 4, 5, or 6. Ordinary compare-exchange steps complete the nine-comparison trace. The generator retains a trace only when its 120 strict input orders reach the same final wire permutation. These traces are skeleton sources. They are not strict-judge PASS programs.

| Rotation position | Prefixes tested | Sorting traces | Canonical skeletons |
| --- | ---: | ---: | ---: |
| 2 | 20 | 570 | 95 |
| 3 | 200 | 1,443 | 452 |
| 4 | 2,000 | 3,168 | 1,077 |
| 5 | 20,000 | 3,756 | 1,030 |
| 6 | 200,000 | 228 | 76 |

The resulting 2,730 skeletons have no canonical matches against 43,295 prior nine-comparison keys. This audit includes all earlier w8 generated skeletons, including unsearched two-switch cases, the cached prior keys, and w2 files read by the audit. Required non-input columns: 17: 72; 18: 2,091; 19: 458; 20: 109.

`src/round4_prepare.cpp` adds an exact repeat of an earlier comparison operand pair. The repeat occurs after at least one intervening comparison. The original nine-comparison columns remain fixed. This tests whether renewed flags permit cheaper routing. The source list contains all available explicit w8 source records with at most 16 required columns, a deterministic sample of 17-column records across source directories, and the known32 control. The generator then removes lattice-only sources and canonical duplicates.

There are 733 distinct non-lattice sources. Each source has 36 delayed repeat positions. The generator retained all 26,388 extensions. None matches the 924 prior non-lattice ten-comparison keys read from w2. Required columns: 15: 4,608; 16: 18,360; 17: 3,420. The prior audit reads the first operand alternative on each line. It does not expand every combination of alternatives.

The initial frozen routing limits are 100,000 nodes for each rotation skeleton and 20,000 nodes for each repeated-comparison skeleton. Cases are ordered by required columns. Routing uses `dagx_order`, K=31, mode 13. One routing child runs at a time, with nice -n 19 and a 3 GiB address-space limit. Live exact counts are in `logs/round4_rotation/summary.json` and `logs/round4_repeat10/summary.json`. LIMIT remains unknown.

Two setup probes on `sk/round4_repeat10/r000000.txt`, at K=33 and K=36, reached one-million-node limits. They are unknown controls, not positive checks. Their logs are `logs/round4_repeat_control33.log` and `logs/round4_repeat_control36.log`.

The final report will append completed search counts, independent source checks, and any strict PASS files. No target improvement has been verified at this checkpoint.

## Round 4 final: new rotations and delayed repeated comparisons

Report time: 2026-10-26T05:07:01.657692+00:00.

Assumptions tested: [A4, A8]. No contradiction of an assumption was established. The old unresolved nine-comparison cases were not rerun.

The checkpoint above describes generation and canonical exclusions. This report gives final routing counts. Each NONE exhausts only the fixed skeleton within the router representation. LIMIT remains unknown.

The new special step covers the two three-cycle permutations of the three partner wires. The earlier generator covered the three pair swaps on those wires. This extends the action patterns for one special comparison. It does not cover arbitrary conditional permutations across several comparisons.

The final deeper pass tests 200 new rotation cases. It includes all 63 limited cases with 17 required columns and 137 cases with 18 required columns. Each case gets 1,000,000 nodes, ten times its first limit. The queue ranks required columns first, then exact-copy-bound visits divided by recursive calls in the earlier limited run. This prefix statistic does not estimate the full search-tree size.

| Batch | Cases | Status counts | Recorded states | CPU seconds |
| --- | ---: | --- | ---: | ---: |
| round4_rotation | 2,730 | LIMIT 1,210, NONE 1,520 | 154,923,831 | 223.973 |
| round4_repeat10 | 26,388 | LIMIT 25,510, NONE 878 | 525,823,704 | 804.659 |
| round4_deep | 200 | NONE 200 | 64,018,053 | 78.356 |

Required-column groups:

| Batch | Required columns | Cases | Status counts | Recorded states |
| --- | ---: | ---: | --- | ---: |
| round4_rotation | 17 | 72 | LIMIT 63, NONE 9 | 7,052,084 |
| round4_rotation | 18 | 2,091 | LIMIT 1,147, NONE 944 | 145,345,410 |
| round4_rotation | 19 | 458 | NONE 458 | 2,336,135 |
| round4_rotation | 20 | 109 | NONE 109 | 190,202 |
| round4_repeat10 | 15 | 4,608 | LIMIT 4,608 | 92,507,313 |
| round4_repeat10 | 16 | 18,360 | LIMIT 17,539, NONE 821 | 365,108,978 |
| round4_repeat10 | 17 | 3,420 | LIMIT 3,363, NONE 57 | 68,207,413 |
| round4_deep | 17 | 63 | NONE 63 | 15,448,945 |
| round4_deep | 18 | 137 | NONE 137 | 48,569,108 |

The searches recorded 744,765,588 recursive calls. These counts include pruned calls and the small overrun when a limited search returns. All searches used one routing process at a time, nice -n 19, and a 3 GiB address-space limit. The largest recorded child peak was 50,456 KiB.

The separate Python evaluator checked all 2,730 rotation sources. Each saved comparison column matched the evaluator. Each source reached one fixed final wire permutation and had 120 distinct comparison histories. Every source had a non-lattice comparison column. The evaluator checked all 26,388 repeated-comparison files against their stated source and insertion recipe. It checked the 120 comparison histories of all 733 source skeletons. These implementation checks are not a proof.

Fixed-graph copy minimization tested 5,460 rotation layouts. Its length counts are k=36: 84, k=38: 88, k=40: 5,288. These layouts fix the source graph and output choices. They do not close unrestricted routing.

Setup probes on the first delayed-repeat case reached limits at K=33 (1,000,111 calls) and K=36 (1,000,094 calls). The separate positive ten-comparison control found a k=33 route in 661,985 calls. These setup calls are outside the target-state totals above.

Strict controls:

- `programs/round4_rotation_control_0.s`: k=36; strict PASS in both models. Source: `sk/round4_rotation5/s000000.txt`.
- `programs/round4_rotation_control_1.s`: k=36; strict PASS in both models. Source: `sk/round4_rotation5/s000001.txt`.
- `programs/round4_rotation_control_2.s`: k=36; strict PASS in both models. Source: `sk/round4_rotation5/s000002.txt`.

The ten-comparison router control passed in both models: `programs/round2_round4_repeat_positive.s`. This control repeats the first comparison immediately. It checks the ten-comparison input and output path. The search set uses delayed repeats.

Exact positive-control judge output:

```text
PASS programs/round2_round4_repeat_positive.s [relaxed+strict] n=5 L=33 R=10 iset=I1 model=out
  AlphaDev-pruning notes (not enforced): line 3: consecutive cmp
PASS programs/round2_round4_repeat_positive_mem.s [relaxed+strict] n=5 L=43 R=15 iset=I1 model=mem
  AlphaDev-pruning notes (not enforced): line 8: consecutive cmp
```

Exact rotation-control judge output:

```text
PASS programs/round4_rotation_control_0.s [relaxed+strict] n=5 L=36 R=14 iset=I1 model=out
PASS programs/round4_rotation_control_0_mem.s [relaxed+strict] n=5 L=46 R=19 iset=I1 model=mem
```

Exact rotation-control judge output:

```text
PASS programs/round4_rotation_control_1.s [relaxed+strict] n=5 L=36 R=14 iset=I1 model=out
PASS programs/round4_rotation_control_1_mem.s [relaxed+strict] n=5 L=46 R=19 iset=I1 model=mem
```

Exact rotation-control judge output:

```text
PASS programs/round4_rotation_control_2.s [relaxed+strict] n=5 L=36 R=14 iset=I1 model=out
PASS programs/round4_rotation_control_2_mem.s [relaxed+strict] n=5 L=46 R=19 iset=I1 model=mem
```

Distinct new skeletons tested: 29,118. Completed negative routing cases: 2,598.

After the deeper pass, all 72 new rotation cases with 17 required columns returned NONE. The remaining 1,010 nine-comparison cases each require 18 columns.

New unresolved skeletons: 26,520. Their group counts are c=10, 15 columns: 4,608, c=10, 16 columns: 17,539, c=10, 17 columns: 3,363, c=9, 18 columns: 1,010. `sk/round4_open_cases.json` preserves every case and its largest tested limit in this round.

The router searches fully defined value columns on the 120 strict input orders. It permits non-lattice intermediate values and unbounded register names. Its negative scope excludes programs with partly initialized scratch registers. It does not establish a general nine- or ten-comparison lower bound.

The eight new control PASS files and their hashes are in `logs/round4_judge_registry.json`. Final source and manifest hashes are in `logs/round4_build.json`.

No k <= 31 strict PASS was recorded in this round.
