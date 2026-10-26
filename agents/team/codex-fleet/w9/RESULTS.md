No strict PASS with core k <= 31 was found. The best verified core remains k=32.

## Purpose

Find an eight-comparison sort5 with at most 23 data instructions. A data instruction is mov or a conditional move. The target core length is 31. The target memory length is 41.

## Terms

A value column gives one register value for each tested order. A comparison tree fixes the input-order partitions after comparisons. A merge interleaving describes the order between two sorted groups. SAT is Boolean satisfiability. UNSAT means that the solver found no assignment for the stated constraints. A time limit means UNKNOWN.

## Method

Read the w6 results and the earlier w1 and w4 merge results. The new searches did not repeat their fixed-operand routing searches. All project writes stayed in w9. Search, compiler, and judge commands used nice level 10. The combined CPU affinity used at most CPUs 84 through 91. No agents were started.

The family scan read 167 distinct eight-comparison programs from w6 verified folders. It evaluated all 541 weak orders with one concrete scratch state. This scan describes structure. It does not replace strict verification of the source collection.

At the fifth comparison, 126 programs retain a sorted pair and a sorted triple. The other 41 have started to combine pieces earlier. Prefix lengths are 15 for 63 programs, 16 for 98 programs, and 17 for six programs. All 63 length-15 prefixes retain one register for each sorted value. Their suffix costs 17. Of the length-16 prefixes, 58 retain both sorted pieces and 40 combine pieces earlier. See [family_analysis.json](artifacts/family_analysis.json).

The normalized control sorts a pair in four instructions and a triple in eleven instructions. Its merge costs 17 instructions: four comparisons, twelve conditional moves, and one mov. The extra mov saves the pair maximum.

Write the sorted pair as x <= y and the sorted triple as a <= b <= c. The first merge comparison outputs min(a,x) and retains u=max(a,x). The second comparison tests y against c. It outputs max(y,c). It also needs T, equal to y when y <= c and equal to u when y > c. Later comparisons use T. A saved y lets one conditional move make T. Constructing T in an unrelated register takes two conditional moves in this implementation. This explains its copy cost. It does not establish a bound for every merge.

The searches use the copied bit-plane evaluator in src/bitplanes.cpp. Value 7 means conservatively unknown scratch data. This representation can reject some valid programs. Zero-error proposals require the full-case check before retention. Every retained sorting control also requires the strict judge.

| Stochastic group | Runs | Score cases | Entry state | Target suffix | Registers | Temperatures |
|---|---:|---:|---|---|---|---|
| Sorted pieces | 3 | 10 strict interleavings | Five sorted values | 16; four cmp | 7, 8, 7 | 0.18, 0.35, 0.7 |
| Prefix leftovers | 3 | 120 strict orders | Actual 15-instruction prefix | 16; four cmp | 8, 9, 8 | 0.45, 0.8, 1.5 |
| Early minimum | 2 | 120 strict orders | Actual 16-instruction prefix; output 0 available | 15; four cmp | 10, 9 | 0.4, 0.9 |

The first group checks all 76 sorted weak interleavings before retaining a zero-error state. The other groups check all 541 weak orders. These eight runs stopped when work moved to exact repair. They did not write final counters. Their total iteration counts and CPU times are unavailable. No exclusion follows from these interrupted runs. Logs: logs/m16[a-c].log, logs/residual_[a-c].log, and logs/integrated_[a-b].log.

Two later searches score all 541 weak orders. They start from the new 12-order failure. They retain the original first 15 or first 12 instructions. The second search can change the final triple comparison and the partner selection together. Each has a 60-CPU-second limit and a 120-second wall limit.


- weak12: 51,642,368 proposals; 7,267,313 accepted; 0 zero-error proposals; best error sum 12; 45.0724 CPU seconds.
- weak_prefix12: 61,865,984 proposals; 8,571,837 accepted; 0 zero-error proposals; best error sum 12; 60.0171 CPU seconds.

The first weak_prefix12 launch preceded compiler completion and did not execute. The corrected launch produced the final counters above.

The constraint merge search permits free comparison operands, branch-specific polarity, and arbitrary less/equal/greater padding on finished branches. Thus its trees fix partitions rather than operand identities. Queries use ten strict interleavings. The first instruction is the tree root. Comparisons must read input-derived values. Outputs can select any write snapshot.

- trees_a: 8 recorded queries; {'UNKNOWN': 8}; 96.697 CPU seconds.
- trees_b: 8 recorded queries; {'UNKNOWN': 8}; 97.031 CPU seconds.
- shapes39: 41 recorded queries; {'UNKNOWN': 41}; 83.510 CPU seconds.
- tree39_glucose: 1 recorded queries; {'UNKNOWN': 1}; 15.028 CPU seconds.
- debug: 1 recorded queries; {'UNKNOWN': 1}; 2.030 CPU seconds.

The broad batches stopped after eight trees each. They did not complete the planned 104 trees. The fixed-placement batch stopped after 41 of its planned 80 placements. The two-second debug query overlaps tree 0. The pinned 17-instruction positive control returned SAT and matches tree 39. See artifacts/sat_control.json. These timed queries give no global exclusion.

The exact repair scan tests every one- and two-instruction replacement in the new 31-instruction failure. Its alphabet contains 441 instructions over nine registers. It includes same-register cmp, every distinct-register mov, and all four permitted conditional moves. The scan completed 13,671 single replacements and 90,433,665 double replacements. None passed the 64-case necessary filter. Counts include unchanged instructions. The total is 90,447,336 edit sequences. Log: [repair12.log](logs/repair12.log).

The failure suggests another copy location. If the merge receives a duplicate triple minimum, its sixteen instructions sort all 76 sorted weak interleavings. A 12-instruction triple prefix supplies that duplicate. Complete sort5 controls passed both strict judges at k=32. An 11-instruction prefix with the same entry values would give k=31.

The triple-prefix encoder requires two distinct physical minimum registers, one median register, and one maximum register at the end. It encodes all thirteen weak orders of three inputs. It requires exactly three comparisons. The first instruction is cmp P0,P1. Comparisons cannot read the initial scratch sentinel. These restrictions define the scope of the results below.

| Query | Registers | Length | Fixed pair prefix | Result | Seconds |
|---|---:|---:|---|---|---:|
| [triple_min11](artifacts/triple_min11.json) | 5 | 11 | False | UNKNOWN | 120.072 |
| [triple_min11_R4](artifacts/triple_min11_R4.json) | 4 | 11 | False | UNKNOWN | 123.456 |
| [triple_min11_pairfirst](artifacts/triple_min11_pairfirst.json) | 5 | 11 | True | UNSAT | 42.265 |
| [triple_min11_pair_shapes](artifacts/triple_min11_pair_shapes.json) | 4 | 11 | True | UNSAT | 0.788 |
| [triple_min11_pair_R6](artifacts/triple_min11_pair_R6.json) | 6 | 11 | True | UNSAT | 6.230 |
| [triple_min11_pair_R8](artifacts/triple_min11_pair_R8.json) | 8 | 11 | True | UNSAT | 28.577 |
| [triple_min11_full_shapes](artifacts/triple_min11_full_shapes.json) | 4 | 11 | False | UNKNOWN | 198.369 |
| [triple_min11_R5_shapes](artifacts/triple_min11_R5_shapes.json) | 5 | 11 | False | UNKNOWN | 122.447 |
| [triple_min12_control](artifacts/triple_min12_control.json) | 5 | 12 | True | SAT | 1.344 |

The fixed pair prefix is cmp P0,P1; mov S0,P0; cmovg P0,P1; cmovg P1,S0. The completed shape searches cover all 21 placements of the remaining comparisons after this prefix. The R=8 query returned UNSAT. This excludes only that eleven-instruction query with the stated prefix, register bound, and operand restrictions. It does not exclude other preparations. The broader shape queries reached their wall limits. Their per-placement records remain in the linked JSON files. The twelve-instruction positive control returned SAT. Its complete sort5 program passed both strict judges.

## Result

No k <= 31 candidate passed the strict judge. Four control implementations have core length 32 and memory length 42. Three use 8 cmp + 20 cmov + 4 mov. The duplicate-triple-minimum control uses 8 cmp + 21 cmov + 3 mov.

The best new eight-comparison failure has k=31 and fails 12/541 weak orders. Four failures have distinct inputs. Eight have ties. Only output 1 fails in the retained snapshots. The strict judge reports FAIL. File: [residual_b_near31_out.s](candidates/residual_b_near31_out.s). Log: [strict judge](logs/residual_b_near31_judge.log).

Let x0 through x4 name the original inputs. The independent evaluator matched this failure condition on all 541 weak orders: min(x0,x1) < x2 < min(x3,x4), and max(x0,x1) >= max(x3,x4). This is a finite test result. In those cases, the merge loses the triple minimum before constructing output 1. See [near12_condition.json](artifacts/near12_condition.json).

The final audit tested every control and every retained copy with shared/judge.py --strict. All sixteen files passed. The ledger records hashes, instruction counts, models, and exact logs: [strict_pass_ledger.json](artifacts/strict_pass_ledger.json). Every PASS file path follows.

| PASS file | Model | Length | Judge log |
|---|---|---:|---|
| [candidates/control32_mem.s](candidates/control32_mem.s) | mem | 42 | [audit_candidates_control32_mem.log](logs/audit_candidates_control32_mem.log) |
| [candidates/control32_out.s](candidates/control32_out.s) | out | 32 | [audit_candidates_control32_out.log](logs/audit_candidates_control32_out.log) |
| [candidates/residual_control32_mem.s](candidates/residual_control32_mem.s) | mem | 42 | [audit_candidates_residual_control32_mem.log](logs/audit_candidates_residual_control32_mem.log) |
| [candidates/residual_control32_out.s](candidates/residual_control32_out.s) | out | 32 | [audit_candidates_residual_control32_out.log](logs/audit_candidates_residual_control32_out.log) |
| [candidates/synth_triple12_control32_mem.s](candidates/synth_triple12_control32_mem.s) | mem | 42 | [audit_candidates_synth_triple12_control32_mem.log](logs/audit_candidates_synth_triple12_control32_mem.log) |
| [candidates/synth_triple12_control32_out.s](candidates/synth_triple12_control32_out.s) | out | 32 | [audit_candidates_synth_triple12_control32_out.log](logs/audit_candidates_synth_triple12_control32_out.log) |
| [candidates/triplemin_control32_mem.s](candidates/triplemin_control32_mem.s) | mem | 42 | [audit_candidates_triplemin_control32_mem.log](logs/audit_candidates_triplemin_control32_mem.log) |
| [candidates/triplemin_control32_out.s](candidates/triplemin_control32_out.s) | out | 32 | [audit_candidates_triplemin_control32_out.log](logs/audit_candidates_triplemin_control32_out.log) |
| [verified/control32_mem.s](verified/control32_mem.s) | mem | 42 | [audit_verified_control32_mem.log](logs/audit_verified_control32_mem.log) |
| [verified/control32_out.s](verified/control32_out.s) | out | 32 | [audit_verified_control32_out.log](logs/audit_verified_control32_out.log) |
| [verified/residual_control32_mem.s](verified/residual_control32_mem.s) | mem | 42 | [audit_verified_residual_control32_mem.log](logs/audit_verified_residual_control32_mem.log) |
| [verified/residual_control32_out.s](verified/residual_control32_out.s) | out | 32 | [audit_verified_residual_control32_out.log](logs/audit_verified_residual_control32_out.log) |
| [verified/synth_triple12_control32_mem.s](verified/synth_triple12_control32_mem.s) | mem | 42 | [audit_verified_synth_triple12_control32_mem.log](logs/audit_verified_synth_triple12_control32_mem.log) |
| [verified/synth_triple12_control32_out.s](verified/synth_triple12_control32_out.s) | out | 32 | [audit_verified_synth_triple12_control32_out.log](logs/audit_verified_synth_triple12_control32_out.log) |
| [verified/triplemin_control32_mem.s](verified/triplemin_control32_mem.s) | mem | 42 | [audit_verified_triplemin_control32_mem.log](logs/audit_verified_triplemin_control32_mem.log) |
| [verified/triplemin_control32_out.s](verified/triplemin_control32_out.s) | out | 32 | [audit_verified_triplemin_control32_out.log](logs/audit_verified_triplemin_control32_out.log) |

## Limits

No global lower bound is claimed. Stochastic failures give no exclusion. Interrupted runs have no inferred counters. The completed repair concerns only its stated edit neighborhood. Prefix exclusions concern only their stated constraints. UNKNOWN is not UNSAT. The 42-instruction controls do not meet the requested 41-instruction memory length.

## Round 2 — new comparison orders

The next round reads the earlier results first. It does not repeat the recorded one/two-replacement scan or the triple-prefix exclusions. Every CPU job uses `nice -n 19`, one CPU, and a 2,800 MiB address-space limit. Search jobs run sequentially. All writes remain in w9.

The new enumeration groups 178 observed comparison-flag sequences into 19 families. It identifies input renaming and individual comparison reversal. Each family fixes a multiset of eight flag columns over 120 strict orders. A history class contains input orders with the same preceding comparison flags. Before a comparison, each history class must admit a pair of original input identities that supplies the requested flag result. This necessary test permits unlimited data instructions. It is not a short-program test.

The enumeration covers all 40,320 permutations in each family. It retains 731 family/order pairs. Of these, 653 are absent from the read source collection. The source collection contains the w6 verified folders from its first three rounds and the earlier w9 out files. These families are comparison-flag families, not claims of distinct sorting algorithms. Data: [orders.json](round2/artifacts/orders.json). Code: [orders.py](round2/src/orders.py).

The SAT encoder permits free comparison positions, free register operands, all five data opcodes, and free output snapshots. It fixes the ordered comparison-flag columns. It uses eight comparisons and 23 data instructions. Scratch starts above all input values. Comparisons must read input-derived values. A fixed prefix, when supplied, remains exact. The first comparison reads original inputs; leading copies are delayed until after that comparison. The query permits self writes as padding. It starts with eight strict orders and the all-equal order. A candidate adds failing cases from all 541 weak orders. Only the strict judge can establish PASS.

The four initial queries with no fixed data prefix reached their limits. Their status is UNKNOWN. The new prefix scan selects a source with the longest unchanged comparison prefix for each new order. Its queries use at least nine registers. If a source needs more registers, the query retains that larger bound. These restrictions define the scope of any UNSAT result. A completed permutation enumeration does not make a limited SAT query complete.

Three pinned 32-instruction controls returned SAT. Each also passed the strict out judge. Their paths and exact judge logs are recorded in [controls.json](round2/artifacts/controls.json). These controls have not improved the target length.

Assumptions tested: A6 (one comparison order per family), A4 (fixed comparison operand columns), A11 (local repair), and A2 (register bounds). Comparison operands are free subject to the required flag results. Fixed-prefix queries still retain part of an existing program.

The full first pass completed all 653 new orders. The solver returned UNSAT for 47 exact-prefix queries. It reached the limit on the other 606 queries. All 653 queries began with nine encoded cases. Six queries produced a SAT model on that subset. Each failed the full-case requirements. Each query added five cases and then returned UNSAT. No fully checked candidate was found. Final case counts are nine or fourteen. The UNSAT queries use fixed prefixes after six comparisons. This does not exclude shorter programs with different prefixes. Results: [first 20](round2/artifacts/prefix_pilot.jsonl), [remaining 633](round2/artifacts/prefix_all.jsonl). Every index occurs once.

The independent list-based checker agreed with the bitset filter on all 731 retained orders and 3,889 sampled rejected orders. Rejected orders outside that sample were not independently checked. Eighteen pinned SAT controls cover three source programs, prefix lengths 0/15/25, and fixed/free comparison direction. All returned SAT. Their decoded outputs matched all 541 concrete weak orders. See [checks.json](round2/artifacts/checks.json). These checks are tests, not formal proofs of the encoders.

The wider query lets each comparison reverse its operands separately for each earlier flag history. It preserves the equality outcome. It frees four instructions before the first changed comparison. It tests comparison placements obtained by removing one data instruction from reordered source blocks. All later register operands and data instructions remain free. A source program supplies preferred SAT variable values; these preferences are not constraints. The queries start with twelve strict orders and the all-equal order.

A further pinned control reverses the seventh comparison and every conditional-move condition that uses its flags. The encoder must choose a nonzero reversal assignment. It returned SAT. The control passed both strict judges at k=32 and L=42. This tests the new comparison-direction variables with a real polarity change. See [polarity_control.json](round2/artifacts/polarity_control.json).

ASSUMPTION CHALLENGED: A3 / E2's literal budget list — the reproduced [fd7a081c6ece control](round2/candidates/control_fd7a081c6ece_k32.s) has 8 cmp + 22 cmov + 2 mov. Both strict judges report PASS. It is a transformation of an existing w6 source, not a new discovery of that budget. The earlier w6 results also record an 8 cmp + 24 cmov + 0 mov program. The data-instruction total remains 24 in both budgets. This does not challenge a possible lower bound of 24 data instructions for eight comparisons.

### Round 2 final result

No strict PASS with core k <= 31 was found. The earlier twelve-order failure remains the best retained w9 failure. The new strict PASS cores have k=32. Their memory forms have L=42.

The wider scan covered 48 selected new orders with 138 queries. It returned 46 UNSAT and 92 UNKNOWN results before replay. Three queries produced a subset SAT model and added five cases each. The other queries retained thirteen cases. The variable comparison placements were fixed only when a 32-instruction source supplied deletion placements. The one 31-instruction source retained free comparison placements.

A final code review found a validation gap. The original full-case filter could reject a program for different comparison flags without accepting correct outputs outside the requested flag structure. The corrected filter first accepts any strict PASS, regardless of those flag requirements. It also checks every available output snapshot before it rejects the program.

The nine queries that had produced subset SAT models were replayed with twelve-CPU-second limits. Every decoded program was saved and strictly judged. All nine programs returned FAIL. The independent snapshot audit checked every data-write snapshot in each program. No program supplied all five correct output columns. The best retained snapshot choices fail at least 27 weak orders. Thus this audit did not improve the earlier twelve-order failure. Replay returned seven UNSAT and two UNKNOWN results. One formerly UNKNOWN wider query became UNSAT. Data: [replay.jsonl](round2/artifacts/replay.jsonl), [snapshot_audit.json](round2/artifacts/snapshot_audit.json).

| Query group | Recorded queries | UNSAT | UNKNOWN | Process CPU seconds |
|---|---:|---:|---:|---:|
| No fixed data prefix, initial pilot | 4 | 0 | 4 | 16.172 |
| All new orders, exact retained prefixes | 653 | 47 | 606 | 1,248.474 |
| Wider prefixes and free comparison direction | 138 | 46 | 92 | 378.897 |
| Validation replay of nine earlier queries | 9 | 7 | 2 | 38.678 |
| Total recorded queries, including replay | 804 | 100 | 704 | 1,682.220 |

After replay updates the earlier configurations, there are **795 distinct query configurations: 94 UNSAT and 701 UNKNOWN**. These counts include only the recorded valid queries. CPU time covers query construction and the solver in the parent process. It does not include child strict-judge CPU time. The 766,080 family/order pairs in the exhaustive information filter are not SAT-query counts.

Setup failures were corrected before production results were counted. A Boolean constant initially produced a zero SAT literal. A positive control initially retained copies before the required first comparison. One batch stopped at a register-bound assertion after 46 recorded orders; it resumed at index 46 with the source register bound preserved. The final ledger confirms that all 653 first-pass indices occur exactly once.

The input-symmetry check found no additional equivalences between these stored comparison-order representations. It retains 731 valid order classes and 653 classes absent from the observed source sequences. This statement concerns the 19 fixed strict-flag families. It does not classify all sorting algorithms. See [symmetry.json](round2/artifacts/symmetry.json).

The final strict audit tested 17 emitted files. Eight control files returned PASS. Nine replay files returned FAIL. Every new tested PASS path and its byte-identical retained copy follows. The logs record the exact strict-judge outputs.

| Tested PASS file | Retained copy | Model | Length | Strict judge |
|---|---|---|---:|---|
| [control_30ac78ad04f7_k32.s](round2/candidates/control_30ac78ad04f7_k32.s) | [copy](round2/verified/control_30ac78ad04f7_k32.s) | out | 32 | [PASS](round2/logs/control_30ac78ad04f7_k32_out_audit.log) |
| [control_30ac78ad04f7_k32_mem.s](round2/candidates/control_30ac78ad04f7_k32_mem.s) | [copy](round2/verified/control_30ac78ad04f7_k32_mem.s) | mem | 42 | [PASS](round2/logs/control_30ac78ad04f7_k32_mem_mem_audit.log) |
| [control_66221a2755ee_k32.s](round2/candidates/control_66221a2755ee_k32.s) | [copy](round2/verified/control_66221a2755ee_k32.s) | out | 32 | [PASS](round2/logs/control_66221a2755ee_k32_out_audit.log) |
| [control_66221a2755ee_k32_mem.s](round2/candidates/control_66221a2755ee_k32_mem.s) | [copy](round2/verified/control_66221a2755ee_k32_mem.s) | mem | 42 | [PASS](round2/logs/control_66221a2755ee_k32_mem_mem_audit.log) |
| [control_fd7a081c6ece_k32.s](round2/candidates/control_fd7a081c6ece_k32.s) | [copy](round2/verified/control_fd7a081c6ece_k32.s) | out | 32 | [PASS](round2/logs/control_fd7a081c6ece_k32_out_audit.log) |
| [control_fd7a081c6ece_k32_mem.s](round2/candidates/control_fd7a081c6ece_k32_mem.s) | [copy](round2/verified/control_fd7a081c6ece_k32_mem.s) | mem | 42 | [PASS](round2/logs/control_fd7a081c6ece_k32_mem_mem_audit.log) |
| [polarity_control32.s](round2/candidates/polarity_control32.s) | [copy](round2/verified/polarity_control32.s) | out | 32 | [PASS](round2/logs/polarity_control32_out_audit.log) |
| [polarity_control32_mem.s](round2/candidates/polarity_control32_mem.s) | [copy](round2/verified/polarity_control32_mem.s) | mem | 42 | [PASS](round2/logs/polarity_control32_mem_mem_audit.log) |

The [final summary](round2/artifacts/final_summary.json) records every batch, the latest result for each distinct query, source hashes, code hashes, snapshot checks, resource limits, and the strict ledger. No global exclusion follows from this round. Fixed prefixes, fixed flag partitions, finite register bounds, input-derived comparison operands, and limited solver time remain restrictions. No independently checked UNSAT certificate was produced.

## Round 3 — Kissat reruns and median-path repair

Read all earlier results before starting. The new queue reconstructs the 795 distinct round-2 configurations and selects the 701 UNKNOWN configurations. It sorts them by their recorded variable count, then clause count. The smallest query has 9,993 variables and 70,208 clauses. The queue retains each source hash, fixed prefix, comparison order, register bound, comparison placements, and comparison-direction option. File: [unknown_queue.json](round3/artifacts/unknown_queue.json).

Each rerun has a shared 900-second wall limit across SAT refinements. Kissat 4.0.4 runs as a single child process. A SAT model must satisfy every emitted CNF clause before decoding. Each decoded program is saved and strictly judged. Failed programs add weak orders to the query. Every time limit remains UNKNOWN. Reruns retain the original query restrictions. They do not establish a general lower bound. Assumptions tested: A2, A4, A6, and A11.

Three pinned controls returned SAT with external Kissat. All three passed the strict out judge at k=32. Details: [controls.json](round3/artifacts/controls.json). Memory-form checks and the final PASS ledger will be recorded below after this round's audit.

The median-path search uses w1's round-6 finding: all fifteen w6 near misses lose the last copy of the required median. A new query traces the median data dependencies of a source on all 541 weak orders. Correct sources have k=32. Some families contain only earlier k=31 failures. Those sources receive an erasable self-move to form a length-32 baseline. If a source lacks a correct median snapshot, the trace uses its closest median snapshot. The source ledger records every missing output column and every median failure. Thus a near-miss baseline is not described as a correct control.

The query reorders the eight comparison blocks to a previously absent valid order. It frees the median data instructions and all comparison operands. It retains the other data instructions. A selector permits deletion of any one median data instruction, including the padding instruction where present. Every output can select any write snapshot. The median is output 2. Scratch-register numbering is unrestricted in these repair queries because fixed source instructions need their original register names. This is a restricted repair family under A2, A4, A6, and A11.

Preparation enumerated all 653 new orders. It permits 12,375 single-deletion choices. The query frees 16, 18, 19, or 20 data slots, depending on the source. An isolated replay reproduced each selected source snapshot on all 541 weak orders while omitting data instructions outside its traced path. This checks the path computation. It does not establish correctness for a near-miss source. Files: [median_queue.json](round3/artifacts/median_queue.json), [median_sources.json](round3/artifacts/median_sources.json), and [median_scope.json](round3/artifacts/median_scope.json).

All new CPU jobs use `nice -n 19`, one CPU affinity, and a 2,800 MiB address-space limit. The Kissat wrapper also monitors combined parent/child resident memory and stops above 2,800,000 KiB. Search jobs run sequentially. All project writes remain in w9. No agents were started.

Round 3 is in progress. No new k<=31 PASS has been recorded.

One initial Kissat launch was interrupted after its last 391-second progress report. It had not reached its 900-second limit and had not returned SAT or UNSAT. It is not a completed rerun. Its CNF and raw log remain under `round3/cnf/interrupted_unknown_0000.cnf` and `round3/logs/interrupted_unknown_0000_kissat_01.log`. At interruption, the query was UNKNOWN. The later completed launch restarted it with the full budget and added valid witness cases.

The new information filter uses all 541 weak orders. The earlier enumeration used only 120 strict orders. For each required comparison, the new filter partitions cases by earlier comparison flags. It then tests all 25 ordered pairs of original input identities in each history class. The test permits arbitrary data instructions and register counts. It assumes comparisons use input-derived values. It also permits comparison reversal within each earlier history. Each rejection retains a small witness whose cases have identical earlier flags, but for which no input pair supplies the required next flag column.

The filter rejects 402 of the 653 median-repair orders and 447 of the 701 unresolved configurations. These are information-filter results, not Kissat UNSAT counts. The retained 251 median-repair orders and 254 unresolved configurations still need synthesis. Files: [median_weak_filter.json](round3/artifacts/median_weak_filter.json) and [unknown_weak_filter.json](round3/artifacts/unknown_weak_filter.json).

The first unresolved configuration was restarted with its two witness cases added to the SAT formula. Kissat returned UNSAT in 7.130 solver wall seconds, within the 900-second limit. The formula had 11 cases, 11,489 variables, and 82,899 clauses. The earlier interrupted formula lacked these two cases. Thus this is a completed restricted exclusion, not a timeout. Raw solver output: [unknown_0000_kissat_01.log](round3/logs/unknown_0000_kissat_01.log). Query result: [kissat_unknown.jsonl](round3/artifacts/kissat_unknown.jsonl). The round-2 solver ledger now has 95 UNSAT and 700 UNKNOWN configurations before further reruns.

The median scan completed all 653 records. The separate filter rejected 402 orders. The remaining 251 SAT repair queries reached their three-second wall limits. Seven queries reached the limit before Kissat started. No SAT model was produced. The scan used 157.540 parent CPU seconds, 475.225 child CPU seconds, and 782.584 summed query wall seconds. Peak combined parent/child resident memory was 117,872 KiB. These short searches are all UNKNOWN. File: [median_all.jsonl](round3/artifacts/median_all.jsonl).

The second smallest original configuration completed its 900-second wall budget. It remains UNKNOWN. It used 641.014 child CPU seconds and reached 119,636 KiB combined resident memory. It produced no SAT model. The raw output is [unknown_0001_kissat_01.log](round3/logs/unknown_0001_kissat_01.log).

The full remaining queue is resumable through [run_remaining.sh](round3/run_remaining.sh). The runner writes current counts to [LIVE.md](round3/LIVE.md) before and after each query. The optional comparison-origin constraints require their pinned controls to pass before that queue uses them. A comparison origin is the original input identity selected by a register. Within a fixed earlier flag history, a program using only mov and conditional moves must select one fixed identity for an input-derived comparison operand. These optional constraints encode that necessary condition across all weak orders. They retain the original fixed-flag scope. They do not apply to a general search with free comparison histories.

Six comparison-origin controls returned SAT. Each pinned the complete source program while leaving the comparison-origin choices active. Three controls use the original comparison directions. Three reverse comparison seven and all conditional moves that use its flags. Every control passed the strict out judge at k=32 and the strict memory judge at length 42. This checks the added origin constraints with both comparison directions. It does not formally verify the encoder. Records: [origin_controls.json](round3/artifacts/origin_controls.json).

The full remaining queue was launched after the control audit. It runs sequentially with a 900-second limit per query and the validated comparison-origin constraints. It skips recorded queue indices and retains the original size order. A recorded timeout remains UNKNOWN and is not retried by this same batch. The queue stops on a strict k<=31 PASS. Otherwise, it audits emitted files and refreshes this report after all queued reruns finish. Current counts and the active queue index are in [LIVE.md](round3/LIVE.md). The audit table below updates when the queue stops. During continuation, LIVE includes later results that the earlier audit snapshot does not contain.

The first continuation results resolved queue indices 2 and 3 as UNSAT. Their solver calls took 0.192 and 0.242 seconds. These queries use the validated comparison-origin constraints. Together with index 0, three earlier UNKNOWN configurations have now returned UNSAT. The original solver ledger reached 97 UNSAT and 698 UNKNOWN before queue index 4 started. Raw outputs: [unknown_0002_kissat_01.log](round3/logs/unknown_0002_kissat_01.log) and [unknown_0003_kissat_01.log](round3/logs/unknown_0003_kissat_01.log). Current counts may be newer in LIVE.

### Round 3 recorded result

No k<=31 program received strict PASS in the recorded searches. The best verified core remains k=32. Its memory form has length 42.

The separate checker confirmed all 402 median-queue rejection witnesses and all 447 unresolved-queue rejection witnesses. It also checked 21 and 26 sampled accepted orders, respectively. It generated the comparison flags through the original SAT encoder path. See [weak_filter_checks.json](round3/artifacts/weak_filter_checks.json). This is an independent implementation check of the filter, not an independently checked UNSAT certificate.

| Search | Recorded configurations | Status | Parent CPU seconds | Child CPU seconds | Wall seconds |
|---|---:|---|---:|---:|---:|
| unknown_rerun | 2/701 | 1 UNSAT, 1 UNKNOWN | 1.384 | 647.999 | 907.436 |
| median_repair | 653/653 | 402 FILTER_REJECTED, 251 UNKNOWN | 157.540 | 475.225 | 782.584 |


median_repair: 7 queries reached their wall limit during construction or transfer, before a Kissat call. These queries remain UNKNOWN.


After completed Kissat reruns, the original 795-configuration solver ledger has 95 UNSAT and 700 UNKNOWN configurations. Information-filter rejections are reported separately. Reruns retain the original program restrictions and add valid weak-order cases. A solver limit remains UNKNOWN. Unrun configurations remain UNKNOWN. No global lower bound follows.


All new strict PASS paths follow. Retained copies have identical bytes. The ledger also records every tested FAIL. See [strict_ledger.json](round3/artifacts/strict_ledger.json) and [summary.json](round3/artifacts/summary.json).

| Strict PASS file | Retained copy | Model | Length | Judge output |
|---|---|---|---:|---|
| [model_control_0_30ac78ad04f7_37102465_1_k32.s](round3/candidates/model_control_0_30ac78ad04f7_37102465_1_k32.s) | [copy](round3/verified/model_control_0_30ac78ad04f7_37102465_1_k32.s) | out | 32 | [PASS](round3/logs/model_control_0_30ac78ad04f7_37102465_1_k32_out_audit.log) |
| [model_control_0_30ac78ad04f7_37102465_1_k32_mem.s](round3/candidates/model_control_0_30ac78ad04f7_37102465_1_k32_mem.s) | [copy](round3/verified/model_control_0_30ac78ad04f7_37102465_1_k32_mem.s) | mem | 42 | [PASS](round3/logs/model_control_0_30ac78ad04f7_37102465_1_k32_mem_mem_audit.log) |
| [model_control_2_fd7a081c6ece_42031657_1_k32.s](round3/candidates/model_control_2_fd7a081c6ece_42031657_1_k32.s) | [copy](round3/verified/model_control_2_fd7a081c6ece_42031657_1_k32.s) | out | 32 | [PASS](round3/logs/model_control_2_fd7a081c6ece_42031657_1_k32_out_audit.log) |
| [model_control_2_fd7a081c6ece_42031657_1_k32_mem.s](round3/candidates/model_control_2_fd7a081c6ece_42031657_1_k32_mem.s) | [copy](round3/verified/model_control_2_fd7a081c6ece_42031657_1_k32_mem.s) | mem | 42 | [PASS](round3/logs/model_control_2_fd7a081c6ece_42031657_1_k32_mem_mem_audit.log) |
| [model_control_5_66221a2755ee_42031756_1_k32.s](round3/candidates/model_control_5_66221a2755ee_42031756_1_k32.s) | [copy](round3/verified/model_control_5_66221a2755ee_42031756_1_k32.s) | out | 32 | [PASS](round3/logs/model_control_5_66221a2755ee_42031756_1_k32_out_audit.log) |
| [model_control_5_66221a2755ee_42031756_1_k32_mem.s](round3/candidates/model_control_5_66221a2755ee_42031756_1_k32_mem.s) | [copy](round3/verified/model_control_5_66221a2755ee_42031756_1_k32_mem.s) | mem | 42 | [PASS](round3/logs/model_control_5_66221a2755ee_42031756_1_k32_mem_mem_audit.log) |
| [model_median_control_0_1_30ac78ad04f7_37102465_1_k32.s](round3/candidates/model_median_control_0_1_30ac78ad04f7_37102465_1_k32.s) | [copy](round3/verified/model_median_control_0_1_30ac78ad04f7_37102465_1_k32.s) | out | 32 | [PASS](round3/logs/model_median_control_0_1_30ac78ad04f7_37102465_1_k32_out_audit.log) |
| [model_median_control_0_1_30ac78ad04f7_37102465_1_k32_mem.s](round3/candidates/model_median_control_0_1_30ac78ad04f7_37102465_1_k32_mem.s) | [copy](round3/verified/model_median_control_0_1_30ac78ad04f7_37102465_1_k32_mem.s) | mem | 42 | [PASS](round3/logs/model_median_control_0_1_30ac78ad04f7_37102465_1_k32_mem_mem_audit.log) |
| [model_median_control_0_32_30ac78ad04f7_37102465_1_k32.s](round3/candidates/model_median_control_0_32_30ac78ad04f7_37102465_1_k32.s) | [copy](round3/verified/model_median_control_0_32_30ac78ad04f7_37102465_1_k32.s) | out | 32 | [PASS](round3/logs/model_median_control_0_32_30ac78ad04f7_37102465_1_k32_out_audit.log) |
| [model_median_control_0_32_30ac78ad04f7_37102465_1_k32_mem.s](round3/candidates/model_median_control_0_32_30ac78ad04f7_37102465_1_k32_mem.s) | [copy](round3/verified/model_median_control_0_32_30ac78ad04f7_37102465_1_k32_mem.s) | mem | 42 | [PASS](round3/logs/model_median_control_0_32_30ac78ad04f7_37102465_1_k32_mem_mem_audit.log) |
| [model_median_control_2_1_fd7a081c6ece_42031657_1_k32.s](round3/candidates/model_median_control_2_1_fd7a081c6ece_42031657_1_k32.s) | [copy](round3/verified/model_median_control_2_1_fd7a081c6ece_42031657_1_k32.s) | out | 32 | [PASS](round3/logs/model_median_control_2_1_fd7a081c6ece_42031657_1_k32_out_audit.log) |
| [model_median_control_2_1_fd7a081c6ece_42031657_1_k32_mem.s](round3/candidates/model_median_control_2_1_fd7a081c6ece_42031657_1_k32_mem.s) | [copy](round3/verified/model_median_control_2_1_fd7a081c6ece_42031657_1_k32_mem.s) | mem | 42 | [PASS](round3/logs/model_median_control_2_1_fd7a081c6ece_42031657_1_k32_mem_mem_audit.log) |
| [model_median_control_2_31_fd7a081c6ece_42031657_1_k32.s](round3/candidates/model_median_control_2_31_fd7a081c6ece_42031657_1_k32.s) | [copy](round3/verified/model_median_control_2_31_fd7a081c6ece_42031657_1_k32.s) | out | 32 | [PASS](round3/logs/model_median_control_2_31_fd7a081c6ece_42031657_1_k32_out_audit.log) |
| [model_median_control_2_31_fd7a081c6ece_42031657_1_k32_mem.s](round3/candidates/model_median_control_2_31_fd7a081c6ece_42031657_1_k32_mem.s) | [copy](round3/verified/model_median_control_2_31_fd7a081c6ece_42031657_1_k32_mem.s) | mem | 42 | [PASS](round3/logs/model_median_control_2_31_fd7a081c6ece_42031657_1_k32_mem_mem_audit.log) |
| [model_median_control_5_1_66221a2755ee_42031756_1_k32.s](round3/candidates/model_median_control_5_1_66221a2755ee_42031756_1_k32.s) | [copy](round3/verified/model_median_control_5_1_66221a2755ee_42031756_1_k32.s) | out | 32 | [PASS](round3/logs/model_median_control_5_1_66221a2755ee_42031756_1_k32_out_audit.log) |
| [model_median_control_5_1_66221a2755ee_42031756_1_k32_mem.s](round3/candidates/model_median_control_5_1_66221a2755ee_42031756_1_k32_mem.s) | [copy](round3/verified/model_median_control_5_1_66221a2755ee_42031756_1_k32_mem.s) | mem | 42 | [PASS](round3/logs/model_median_control_5_1_66221a2755ee_42031756_1_k32_mem_mem_audit.log) |
| [model_median_control_5_31_66221a2755ee_42031756_1_k32.s](round3/candidates/model_median_control_5_31_66221a2755ee_42031756_1_k32.s) | [copy](round3/verified/model_median_control_5_31_66221a2755ee_42031756_1_k32.s) | out | 32 | [PASS](round3/logs/model_median_control_5_31_66221a2755ee_42031756_1_k32_out_audit.log) |
| [model_median_control_5_31_66221a2755ee_42031756_1_k32_mem.s](round3/candidates/model_median_control_5_31_66221a2755ee_42031756_1_k32_mem.s) | [copy](round3/verified/model_median_control_5_31_66221a2755ee_42031756_1_k32_mem.s) | mem | 42 | [PASS](round3/logs/model_median_control_5_31_66221a2755ee_42031756_1_k32_mem_mem_audit.log) |
| [model_origin_control_0_0_30ac78ad04f7_37102465_1_k32.s](round3/candidates/model_origin_control_0_0_30ac78ad04f7_37102465_1_k32.s) | [copy](round3/verified/model_origin_control_0_0_30ac78ad04f7_37102465_1_k32.s) | out | 32 | [PASS](round3/logs/model_origin_control_0_0_30ac78ad04f7_37102465_1_k32_out_audit.log) |
| [model_origin_control_0_0_30ac78ad04f7_37102465_1_k32_mem.s](round3/candidates/model_origin_control_0_0_30ac78ad04f7_37102465_1_k32_mem.s) | [copy](round3/verified/model_origin_control_0_0_30ac78ad04f7_37102465_1_k32_mem.s) | mem | 42 | [PASS](round3/logs/model_origin_control_0_0_30ac78ad04f7_37102465_1_k32_mem_mem_audit.log) |
| [model_origin_control_0_1_30ac78ad04f7_37102465_1_k32.s](round3/candidates/model_origin_control_0_1_30ac78ad04f7_37102465_1_k32.s) | [copy](round3/verified/model_origin_control_0_1_30ac78ad04f7_37102465_1_k32.s) | out | 32 | [PASS](round3/logs/model_origin_control_0_1_30ac78ad04f7_37102465_1_k32_out_audit.log) |
| [model_origin_control_0_1_30ac78ad04f7_37102465_1_k32_mem.s](round3/candidates/model_origin_control_0_1_30ac78ad04f7_37102465_1_k32_mem.s) | [copy](round3/verified/model_origin_control_0_1_30ac78ad04f7_37102465_1_k32_mem.s) | mem | 42 | [PASS](round3/logs/model_origin_control_0_1_30ac78ad04f7_37102465_1_k32_mem_mem_audit.log) |
| [model_origin_control_2_0_fd7a081c6ece_42031657_1_k32.s](round3/candidates/model_origin_control_2_0_fd7a081c6ece_42031657_1_k32.s) | [copy](round3/verified/model_origin_control_2_0_fd7a081c6ece_42031657_1_k32.s) | out | 32 | [PASS](round3/logs/model_origin_control_2_0_fd7a081c6ece_42031657_1_k32_out_audit.log) |
| [model_origin_control_2_0_fd7a081c6ece_42031657_1_k32_mem.s](round3/candidates/model_origin_control_2_0_fd7a081c6ece_42031657_1_k32_mem.s) | [copy](round3/verified/model_origin_control_2_0_fd7a081c6ece_42031657_1_k32_mem.s) | mem | 42 | [PASS](round3/logs/model_origin_control_2_0_fd7a081c6ece_42031657_1_k32_mem_mem_audit.log) |
| [model_origin_control_2_1_fd7a081c6ece_42031657_1_k32.s](round3/candidates/model_origin_control_2_1_fd7a081c6ece_42031657_1_k32.s) | [copy](round3/verified/model_origin_control_2_1_fd7a081c6ece_42031657_1_k32.s) | out | 32 | [PASS](round3/logs/model_origin_control_2_1_fd7a081c6ece_42031657_1_k32_out_audit.log) |
| [model_origin_control_2_1_fd7a081c6ece_42031657_1_k32_mem.s](round3/candidates/model_origin_control_2_1_fd7a081c6ece_42031657_1_k32_mem.s) | [copy](round3/verified/model_origin_control_2_1_fd7a081c6ece_42031657_1_k32_mem.s) | mem | 42 | [PASS](round3/logs/model_origin_control_2_1_fd7a081c6ece_42031657_1_k32_mem_mem_audit.log) |
| [model_origin_control_5_0_66221a2755ee_42031756_1_k32.s](round3/candidates/model_origin_control_5_0_66221a2755ee_42031756_1_k32.s) | [copy](round3/verified/model_origin_control_5_0_66221a2755ee_42031756_1_k32.s) | out | 32 | [PASS](round3/logs/model_origin_control_5_0_66221a2755ee_42031756_1_k32_out_audit.log) |
| [model_origin_control_5_0_66221a2755ee_42031756_1_k32_mem.s](round3/candidates/model_origin_control_5_0_66221a2755ee_42031756_1_k32_mem.s) | [copy](round3/verified/model_origin_control_5_0_66221a2755ee_42031756_1_k32_mem.s) | mem | 42 | [PASS](round3/logs/model_origin_control_5_0_66221a2755ee_42031756_1_k32_mem_mem_audit.log) |
| [model_origin_control_5_1_66221a2755ee_42031756_1_k32.s](round3/candidates/model_origin_control_5_1_66221a2755ee_42031756_1_k32.s) | [copy](round3/verified/model_origin_control_5_1_66221a2755ee_42031756_1_k32.s) | out | 32 | [PASS](round3/logs/model_origin_control_5_1_66221a2755ee_42031756_1_k32_out_audit.log) |
| [model_origin_control_5_1_66221a2755ee_42031756_1_k32_mem.s](round3/candidates/model_origin_control_5_1_66221a2755ee_42031756_1_k32_mem.s) | [copy](round3/verified/model_origin_control_5_1_66221a2755ee_42031756_1_k32_mem.s) | mem | 42 | [PASS](round3/logs/model_origin_control_5_1_66221a2755ee_42031756_1_k32_mem_mem_audit.log) |


Resume unrun queue entries with `nice -n 19 bash round3/run_remaining.sh`. The runner skips recorded queue indices, including recorded UNKNOWN timeouts. It keeps the original size order. Re-run the final audit with `nice -n 19 python3 -B round3/src/audit.py`. The median scan is a bounded repair search. Every UNKNOWN remains open. The round tests A2, A4, A6, and A11. No new assumption was contradicted.

## Round 4 — ranked repairs and three extra changed data slots

Read RESULTS.md and the saved round-3 queues before this round. No earlier repair scan was repeated. No later result had been recorded for the prior 900-second continuation. Its last active query had no completed result. The ledger therefore started at 97 UNSAT and 698 UNKNOWN.

Assumptions tested: A2 (finite register bounds), A4 (fixed comparison flags), A6 (comparison order), and A11 (repair neighborhood). Comparison operands remain free within their required flag histories. No global lower bound follows.

Most unresolved queries have no decoded model. Thus they have no measured candidate failure set. The new ranking tests a reproducible baseline for each configuration: reorder the source comparison blocks, delete one permitted data instruction, and choose output snapshots with a coordinate-descent heuristic. The test uses all 541 weak orders and concrete scratch value 7. The score is not an exact minimum. A seed need not satisfy the requested comparison flags; prefix compatibility is recorded separately. The ranking uses the smaller of the baseline failure count and any earlier decoded-model failure count. It breaks ties by the original variable count, clause count, and queue index.

The independent list evaluator matched all 698 retained baseline failure sets. Preparation used 7.238 CPU seconds. The selected 100 have scores 39 through 163. The all-weak-order information filter accepts 48 selected orders. This ranking does not improve the earlier twelve-order near miss. Files: [ranked_unknown.json](round4/artifacts/ranked_unknown.json) and [preparation.json](round4/artifacts/preparation.json).

All 698 unresolved configurations fall into 306 recorded structure classes. A class records the comparison-flag family, unchanged comparison-prefix length, fixed data-prefix length, comparison positions, direction freedom, first rejected comparison if any, and failing output positions. The class file identifies all 598 configurations outside the selected 100. These are descriptive classes, not proven program equivalences. File: [structure_classes.json](round4/artifacts/structure_classes.json).

Each selected original configuration gets a new 600-second wall budget shared across SAT refinements. The query retains its previous prefix, register bound, positions, and comparison-direction option. Validated comparison-origin constraints encode the necessary identity choice within each earlier flag history. Information-filter witness cases are added where available. For an accepted order, up to 64 evenly sampled baseline failures are also added to the initial query. These are ordinary weak-order cases, so they do not change the full-case query scope. Kissat checks every emitted Boolean clause against a SAT assignment before decoding. Each decoded program goes through the strict out judge. A passing program also gets a memory form and the strict memory judge.

The absent-order repair keeps k=31 and eight comparisons. It frees the earlier median data path and allows up to three other source data slots to change. The solver chooses these additional slots. The deletion selector still removes one median-path data instruction from the length-32 baseline. Thus “three extra instructions” means three additional changed source slots in this experiment. It does not raise the target length. Each order gets the recorded wall limit; limited queries remain UNKNOWN.

The new encoder controls pin three correct sources after deliberately changing three fixed source slots in their baselines. With an allowance of three, all three must return SAT and strict PASS. With an allowance of two, all three must return UNSAT. These are tests of the selector and shift handling. They are not a proof of encoder correctness. The first memory conversion used an unsupported register name. It failed to parse. The conversion now assigns distinct S registers, and the controls were rerun.

Controls completed: 6/6; {'SAT_CANDIDATE': 3, 'UNSAT': 3}. File: [controls.json](round4/artifacts/controls.json).

| Search | Completed | Status | Parent CPU seconds | Child CPU seconds | Wall seconds |
|---|---:|---|---:|---:|---:|
| ranked_600_second_reruns | 1/100 | {'UNKNOWN': 1} | 2.479 | 474.970 | 600.032 |
| median_plus_three_changed_slots | 653/653 | {'UNSAT': 401, 'UNKNOWN': 252} | 648.876 | 867.399 | 2317.147 |

The original 795-configuration ledger now has 97 UNSAT and 698 UNKNOWN configurations. Only completed selected-query UNSAT results change this ledger. The broader median repairs form a separate query family. Unrun and timed-out queries remain UNKNOWN. No independently checked UNSAT certificate was produced.

All jobs run sequentially at nice level 19 on one CPU. Each job has a 2,800 MiB address-space limit. The solver wrapper also checks combined parent and child resident memory against 2,800,000 KiB. All writes stay in w9. No agents were started.


The completed absent-order audit confirms all 653 distinct indices. The solver returned UNSAT for six orders accepted by the earlier information filter. Their indices are 425, 426, 459, 461, 465, 467. These six results retain the new repair restrictions. Seven filter-rejected orders reached the five-second solver limit and remain UNKNOWN. The audit records all four filter/status counts, query identities, solver logs, and resource totals. File: [extra3_audit.json](round4/artifacts/extra3_audit.json).

Recorded strict PASS files from this round follow. These controls have k=32 and memory length 42.

| PASS file | Model | Judge output |
|---|---|---|
| [model_extra_control_0_3_30ac78ad04f7_37102465_1_k32.s](round4/candidates/model_extra_control_0_3_30ac78ad04f7_37102465_1_k32.s) | out | [PASS](round4/logs/model_extra_control_0_3_30ac78ad04f7_37102465_1_k32_strict.log) |
| [model_extra_control_0_3_30ac78ad04f7_37102465_1_k32_mem.s](round4/candidates/model_extra_control_0_3_30ac78ad04f7_37102465_1_k32_mem.s) | mem | [PASS](round4/logs/model_extra_control_0_3_30ac78ad04f7_37102465_1_k32_mem_strict.log) |
| [model_extra_control_0_3_30ac78ad04f7_37102465_1_k32.s retained copy](round4/verified/model_extra_control_0_3_30ac78ad04f7_37102465_1_k32.s) | out | byte-identical to tested file |
| [model_extra_control_0_3_30ac78ad04f7_37102465_1_k32_mem.s retained copy](round4/verified/model_extra_control_0_3_30ac78ad04f7_37102465_1_k32_mem.s) | mem | byte-identical to tested file |
| [model_extra_control_2_3_fd7a081c6ece_42031657_1_k32.s](round4/candidates/model_extra_control_2_3_fd7a081c6ece_42031657_1_k32.s) | out | [PASS](round4/logs/model_extra_control_2_3_fd7a081c6ece_42031657_1_k32_strict.log) |
| [model_extra_control_2_3_fd7a081c6ece_42031657_1_k32_mem.s](round4/candidates/model_extra_control_2_3_fd7a081c6ece_42031657_1_k32_mem.s) | mem | [PASS](round4/logs/model_extra_control_2_3_fd7a081c6ece_42031657_1_k32_mem_strict.log) |
| [model_extra_control_2_3_fd7a081c6ece_42031657_1_k32.s retained copy](round4/verified/model_extra_control_2_3_fd7a081c6ece_42031657_1_k32.s) | out | byte-identical to tested file |
| [model_extra_control_2_3_fd7a081c6ece_42031657_1_k32_mem.s retained copy](round4/verified/model_extra_control_2_3_fd7a081c6ece_42031657_1_k32_mem.s) | mem | byte-identical to tested file |
| [model_extra_control_5_3_66221a2755ee_42031756_1_k32.s](round4/candidates/model_extra_control_5_3_66221a2755ee_42031756_1_k32.s) | out | [PASS](round4/logs/model_extra_control_5_3_66221a2755ee_42031756_1_k32_strict.log) |
| [model_extra_control_5_3_66221a2755ee_42031756_1_k32_mem.s](round4/candidates/model_extra_control_5_3_66221a2755ee_42031756_1_k32_mem.s) | mem | [PASS](round4/logs/model_extra_control_5_3_66221a2755ee_42031756_1_k32_mem_strict.log) |
| [model_extra_control_5_3_66221a2755ee_42031756_1_k32.s retained copy](round4/verified/model_extra_control_5_3_66221a2755ee_42031756_1_k32.s) | out | byte-identical to tested file |
| [model_extra_control_5_3_66221a2755ee_42031756_1_k32_mem.s retained copy](round4/verified/model_extra_control_5_3_66221a2755ee_42031756_1_k32_mem.s) | mem | byte-identical to tested file |

No k<=31 strict PASS is recorded in this round.

Current activity: [LIVE.md](round4/LIVE.md). Full records: [summary.json](round4/artifacts/summary.json), [top100.jsonl](round4/artifacts/top100.jsonl), and [median_extra3.jsonl](round4/artifacts/median_extra3.jsonl).

Resume with `bash round4/run_remaining.sh`. The runner skips every recorded query, including recorded time limits. To stop a later runner between queries, create `round4/STOP_AFTER_QUERY`; remove that file before resuming. The active query can use its remaining wall budget before the runner stops.

## Round 5 — one representative per structure class

Read all prior results before this round. The new queue selects one of the 698 unresolved configurations from each of the 306 saved structure classes. It does not repeat the earlier broad scans. The representative has the smallest recorded failure ranking in its class. Ties use the earlier variable count, clause count, and queue index. The failure ranking uses concrete scratch value 7. It is not a strict correctness result.

Assumptions tested: A2 (finite register bound), A4 (fixed comparison-flag histories), A6 (comparison order), and A11 (fixed-prefix repair scope). The classes are descriptive groups. They are not established program equivalences. A representative UNSAT result does not exclude every member of its class.

The queue contains 200 representatives rejected by the earlier information filter and 106 accepted representatives. Rejected representatives run first. Accepted representatives run in decreasing fixed-prefix length, then increasing formula size. Each query retains the saved register bound, prefix, comparison positions, and direction freedom. All queries use the previously tested comparison-origin constraints. Witness cases and up to 64 baseline failure cases seed the formula. These cases retain the full-case query scope. Both the query encoder and the Kissat wrapper were copied unchanged from round 4.

The encoder permits mov and all four allowed conditional moves. Scratch starts at a sentinel above the input values. Comparisons must use input-derived values. These are stated query restrictions. A strict judge result is still required for any candidate.

Each representative has a 900-second wall budget shared across formula construction, solver calls, and refinements. A limit remains UNKNOWN. An unrun representative is UNRUN. No independently checked UNSAT certificate is produced. Kissat SAT assignments must satisfy every emitted clause. Every decoded program gets the strict out judge. A strict out PASS also gets the strict memory judge.

Recorded representatives: 205/306. Status: {'UNSAT': 200, 'UNKNOWN': 5}. Unrun: 101.

Recorded parent CPU seconds: 159.124. Child CPU seconds: 3844.028. Summed query wall seconds: 4747.606. Peak recorded combined resident memory: 297148 KiB.

All jobs run sequentially on one CPU at nice level 19. Each job has a 2,800 MiB address-space limit. The wrapper stops above 2,800,000 KiB combined parent and child resident memory. All project writes remain in w9. No agents were started.

Per-class results: [CLASS_STATUS.md](round5/CLASS_STATUS.md) and [class_status.json](round5/artifacts/class_status.json). Full queries and raw solver log paths: [class_results.jsonl](round5/artifacts/class_results.jsonl). Selection and source hashes: [queue.json](round5/artifacts/queue.json). Resource totals and code hashes: [summary.json](round5/artifacts/summary.json).

New pinned controls completed: 3/3. Their lengths are k=32 and memory length 42. Every new strict PASS file follows. Each retained copy has identical bytes.

| PASS file | Model | Strict judge output |
|---|---|---|
| [model_class_control_0_30ac78ad04f7_37102465_1_k32.s](round5/candidates/model_class_control_0_30ac78ad04f7_37102465_1_k32.s) | out | [PASS](round5/logs/model_class_control_0_30ac78ad04f7_37102465_1_k32_strict.log) |
| [model_class_control_0_30ac78ad04f7_37102465_1_k32.s retained copy](round5/verified/model_class_control_0_30ac78ad04f7_37102465_1_k32.s) | out | identical to tested file |
| [model_class_control_0_30ac78ad04f7_37102465_1_k32_mem.s](round5/candidates/model_class_control_0_30ac78ad04f7_37102465_1_k32_mem.s) | mem | [PASS](round5/logs/model_class_control_0_30ac78ad04f7_37102465_1_k32_mem_strict.log) |
| [model_class_control_0_30ac78ad04f7_37102465_1_k32_mem.s retained copy](round5/verified/model_class_control_0_30ac78ad04f7_37102465_1_k32_mem.s) | mem | identical to tested file |
| [model_class_control_2_fd7a081c6ece_42031657_1_k32.s](round5/candidates/model_class_control_2_fd7a081c6ece_42031657_1_k32.s) | out | [PASS](round5/logs/model_class_control_2_fd7a081c6ece_42031657_1_k32_strict.log) |
| [model_class_control_2_fd7a081c6ece_42031657_1_k32.s retained copy](round5/verified/model_class_control_2_fd7a081c6ece_42031657_1_k32.s) | out | identical to tested file |
| [model_class_control_2_fd7a081c6ece_42031657_1_k32_mem.s](round5/candidates/model_class_control_2_fd7a081c6ece_42031657_1_k32_mem.s) | mem | [PASS](round5/logs/model_class_control_2_fd7a081c6ece_42031657_1_k32_mem_strict.log) |
| [model_class_control_2_fd7a081c6ece_42031657_1_k32_mem.s retained copy](round5/verified/model_class_control_2_fd7a081c6ece_42031657_1_k32_mem.s) | mem | identical to tested file |
| [model_class_control_5_66221a2755ee_42031756_1_k32.s](round5/candidates/model_class_control_5_66221a2755ee_42031756_1_k32.s) | out | [PASS](round5/logs/model_class_control_5_66221a2755ee_42031756_1_k32_strict.log) |
| [model_class_control_5_66221a2755ee_42031756_1_k32.s retained copy](round5/verified/model_class_control_5_66221a2755ee_42031756_1_k32.s) | out | identical to tested file |
| [model_class_control_5_66221a2755ee_42031756_1_k32_mem.s](round5/candidates/model_class_control_5_66221a2755ee_42031756_1_k32_mem.s) | mem | [PASS](round5/logs/model_class_control_5_66221a2755ee_42031756_1_k32_mem_strict.log) |
| [model_class_control_5_66221a2755ee_42031756_1_k32_mem.s retained copy](round5/verified/model_class_control_5_66221a2755ee_42031756_1_k32_mem.s) | mem | identical to tested file |

No new strict PASS with k<=31 is recorded.

Current activity: [LIVE.md](round5/LIVE.md). Resume with `bash round5/run_remaining.sh`. The runner skips completed representatives, including recorded time limits. A stopped or interrupted query without a result record is not complete.

## Round 6 — remaining 102 structure representatives

Read all prior results before this continuation. The saved ledger began at 204/306 representatives: 200 UNSAT and four UNKNOWN. The saved queue identified 102 unrecorded representatives. All 102 passed the earlier necessary information filter. No recorded representative is rerun. The interrupted class_121_q0015 query had no result record and receives its full budget.

Assumptions tested: A2 (finite register bound), A4 (fixed comparison-flag histories), A6 (comparison order), and A11 (fixed-prefix repair scope). The representatives retain their saved prefixes, register bounds, comparison positions, direction options, and seed cases. The encoder and Kissat wrapper are unchanged. Only continuation reporting was added.

Each query gets a 900-second wall budget shared across construction, Kissat calls, and refinements. One CPU job runs at nice level 19. The address-space limit is 2,800 MiB. The wrapper also enforces a combined resident-memory limit of 2,800,000 KiB. All writes remain in w9. No agents were started.

Completed in this continuation: 1/102; {'UNKNOWN': 1}. Unrecorded: 101. Total recorded: 205/306; {'UNSAT': 200, 'UNKNOWN': 5}.

Recorded parent CPU seconds: 3.706. Child CPU seconds: 808.413. Summed query wall seconds: 900.022. Peak recorded combined resident memory: 281136 KiB.

Decoded candidate models in this continuation: 0. No new strict PASS is recorded.

A time limit remains UNKNOWN. An unrecorded representative remains UNRUN. A representative UNSAT result does not exclude the other members of its descriptive class. No independently checked UNSAT certificate was produced. No global lower bound follows.

Files: [continuation summary](round6/artifacts/summary.json), [start snapshot](round6/artifacts/start.json), [per-class status](round5/CLASS_STATUS.md), [query ledger](round5/artifacts/class_results.jsonl), and [current activity](round5/LIVE.md). Resume with `nice -n 19 bash round6/run_remaining.sh`.

Continuation incomplete. Current query: class_237_q0111.
