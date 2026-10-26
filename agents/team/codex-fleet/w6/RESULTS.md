No verified program with core k <= 31 was found.

## Purpose

Find a branchless sort5 with at most 31 register instructions in the AlphaDev model.

## Terms

Core k counts mov, cmp, and conditional moves. Free out instructions select output snapshots. The memory program adds five loads and five stores. A comparison structure is the ordered list of comparison operand columns over the 120 distinct-value input orders. The analyzer identifies input renaming, comparison reversal, and value-order reversal with 64-bit fingerprints. These fingerprints are search identifiers, not proof certificates.

## Method

Started from the supplied eight-comparison, 33-instruction program. Restricted the first searches to seven or eight comparisons. This avoids repeating the nine-comparison network searches in the brief. Used 33--35 slots to permit changes to conditional cycles.

Copied the supplied simulator, MCMC search, and exact routing code into src/ before building them. Wrote an independent bit-plane simulator in src/local.cpp. Value 7 represents unknown scratch data in that simulator. Its conservative propagation can reject some valid programs. Thus its negative filters are search limits, not general exclusions.

The independent packed search scores 120 permutations and 40 selected weak orders. These sets can overlap. It checks every zero-score proposal on all 541 weak orders before acceptance. src/packed.cpp also supports full-case deletion checks. The final authority for every retained result is shared/judge.py --strict.

All search commands use nice -n 10. Search processes are single-threaded. No files outside this worker folder were changed. Seeds, slot counts, temperatures, and run limits are recorded in artifacts/search_parameters.json.

## Result

The best verified core has k=32. It uses **8 cmp + 20 conditional moves + 4 mov**. Its memory version has **42 instructions**. Both strict judges passed:

- [Register program](artifacts/sort5_c8_k32_out.s), [judge log](logs/clean32_out_judge.log).
- [Memory program](artifacts/sort5_c8_k32_mem.s), [judge log](logs/clean32_mem_judge.log).

This gives an eight-comparison core at the AlphaDev length. It does not beat 42 instructions. The register program sorts a pair and a triple, retains a second copy of the pair maximum, then merges them with four comparisons and twelve conditional moves. The merge has no mov instruction. The extra maximum copy costs one mov before the merge.

The immutable verified folder contains **18** comparison-structure representatives. Each has k=32 and eight comparisons. All passed the strict out-model judge. The representatives include different mov/conditional-move counts. See the table below. The initial collection analysis found 12 fingerprints. The packed-sample analysis found 17 fingerprints among 4,396 saved states. Their union contains 18 fingerprints. Search samples under candidates/ are intermediate states. A sample is not a verified result unless it appears in the strict-judge ledger.

| Immutable representative | k | cmp | mov | conditional moves |
|---|---:|---:|---:|---:|
| [c8_108b52d1733c50f9.s](verified/c8_108b52d1733c50f9.s) | 32 | 8 | 4 | 20 |
| [c8_15d47dd100cf7fcb.s](verified/c8_15d47dd100cf7fcb.s) | 32 | 8 | 4 | 20 |
| [c8_23f00ca3e09530d3.s](verified/c8_23f00ca3e09530d3.s) | 32 | 8 | 5 | 19 |
| [c8_26e49cf60c846007.s](verified/c8_26e49cf60c846007.s) | 32 | 8 | 3 | 21 |
| [c8_2754b681df96846f.s](verified/c8_2754b681df96846f.s) | 32 | 8 | 3 | 21 |
| [c8_2b1431ee7889f02b.s](verified/c8_2b1431ee7889f02b.s) | 32 | 8 | 4 | 20 |
| [c8_2c342e0e0fbafd57.s](verified/c8_2c342e0e0fbafd57.s) | 32 | 8 | 4 | 20 |
| [c8_2dfea391c9fdd3bb.s](verified/c8_2dfea391c9fdd3bb.s) | 32 | 8 | 2 | 22 |
| [c8_2fc1b3fefa56100b.s](verified/c8_2fc1b3fefa56100b.s) | 32 | 8 | 4 | 20 |
| [c8_3395266762428bd.s](verified/c8_3395266762428bd.s) | 32 | 8 | 4 | 20 |
| [c8_3809e545578327.s](verified/c8_3809e545578327.s) | 32 | 8 | 4 | 20 |
| [c8_57fa7c797ed6c84f.s](verified/c8_57fa7c797ed6c84f.s) | 32 | 8 | 4 | 20 |
| [c8_903a0e9b56d0fdc7.s](verified/c8_903a0e9b56d0fdc7.s) | 32 | 8 | 3 | 21 |
| [c8_9dc3b82d8b1e62f.s](verified/c8_9dc3b82d8b1e62f.s) | 32 | 8 | 4 | 20 |
| [c8_9f2faf3e2b5848b.s](verified/c8_9f2faf3e2b5848b.s) | 32 | 8 | 5 | 19 |
| [c8_b71830c38f98f13.s](verified/c8_b71830c38f98f13.s) | 32 | 8 | 3 | 21 |
| [c8_be0bab6887969b3.s](verified/c8_be0bab6887969b3.s) | 32 | 8 | 4 | 20 |
| [c8_de052e5a1c75d83.s](verified/c8_de052e5a1c75d83.s) | 32 | 8 | 5 | 19 |

### Search counts

| Supplied MCMC run | Retained records | Iterations | Accepted | CPU seconds | Best k |
|---|---:|---:|---:|---:|---:|
| c8a | 310,007 | 9,515,008 | 1,247,841 | 600.3 | 32 |
| c8b | 230,864 | 7,344,128 | 1,043,723 | 600.0 | 32 |
| c8c | 528,428 | 14,082,048 | 1,706,432 | 600.1 | 32 |
| c8d | 4,006 | 91,463,680 | 16,611,403 | 600.0 | 33 |
| c8e | 112,599 | 21,164,032 | 2,581,626 | 900.3 | 32 |
| c8f | 65,615 | 20,676,608 | 2,514,916 | 900.0 | 32 |

Total: 1,251,519 retained records and 164,245,504 iterations. Records can repeat across runs. Logs: logs/c8[a-f].log. Collections: candidates/c8[a-f]_coll.txt.

| Independent packed run | Iterations | Accepted | Correct visits | Best k | CPU seconds |
|---|---:|---:|---:|---:|---:|
| p31a | 884,625,408 | 118,867,607 | 0 | none | 600.0 |
| p31b | 579,944,448 | 286,749,952 | 0 | none | 600.0 |
| p31c | 888,930,304 | 112,344,533 | 0 | none | 600.0 |
| p32a | 706,146,304 | 88,253,475 | 60,838,110 | 32 | 600.0 |
| p32b | 714,596,352 | 104,498,435 | 29,821 | 32 | 480.0 |
| p32c | 529,358,848 | 66,576,560 | 60,040,836 | 32 | 480.0 |
| p32d | 439,779,328 | 54,269,061 | 44,984,754 | 32 | 300.0 |

Total: 4,743,380,992 packed-search iterations. Iterations include proposals rejected before evaluation. Correct visits can repeat the same program.

The best saved k=31 near miss fails 39 weak orders in the independent scorer. It is candidates/p31c_near.s. The strict judge rejects it; see logs/p31c_near_judge.log. This is not an improvement over the earlier 39-case near-miss count in the brief.

The 3-to-2 replacement checks on the immutable representatives enumerated 119,672,640 sequences. 10 sequences passed the 32-case filter. None passed the full 541-case conservative check. The separate first-core check enumerated 8,748,000 sequences. The separate new-structure check enumerated 5,598,720 sequences. These two separate checks can overlap the representative checks.

A repeat check saved the best of the ten subset-passing replacements. That k=31 program also fails 39 weak orders. It is candidates/local_near31_near.s. Its strict judge failure is logs/local_near31_judge.log. This does not improve the near-miss count.

The first 4-to-3 check completed windows 0--23: 24 x 157,464,000 = 3,779,136,000 sequences. It stopped at the 900-second wall limit during the next window. The second 4-to-3 check completed windows 10--28: 1,531,809,792 sequences. Neither check found a replacement. Logs: logs/local4_31.log and logs/local4_13_31.log.

### Routing and solver checks

The routing search uses the copied dagx tool. It searches register reuse and conditional-move routing for a fixed comparison structure over 120 permutations. A node limit is incomplete. No formal certificate is provided.

- Supplied position33 structure at K=31: 5,000,084 calls, LIMIT.
- First new structure at K=31: 20,000,070 calls, LIMIT.
- First twelve representatives at K=31: each reached its five-million-node limit. No solution was found.
- New structure 15d47dd100cf7fcb at K=31: **NONE after 19,619,874 calls**. This run finished. Its scope is that fixed value structure only. Log: logs/c8_13_dag31.log.
- Further structures: see artifacts/new_routing_summary.json. These runs also found no K=31 program within their node limits.

src/window_sat.py replaces a five-instruction window with four instructions. It uses packed Z3 bit vectors and adds weak orders when a proposed output witness fails. The two template variants retain the remaining instruction classes and write destinations. Sources and conditional-move conditions remain free. Their results apply only to this encoding and these local constraints.

- window5_sat: 13 unknown.
- window5_template0: 4 unknown, 6 unsat.
- window5_template2: 5 unknown, 5 unsat.

The fixed 32-instruction positive control passed the solver and the strict judge. See logs/window_sat_control.log and logs/window_sat_control_judge.log.

A small first-principles calculation found 15 strict extensions of the paired Ford-Johnson prefix and six balanced four-level decision trees. Another worker owns that direction. No extra Ford-Johnson program search was run here.

## Limits

No global lower bound is claimed. MCMC results are search observations. The local simulator uses conservative unknown values. A solver timeout is unknown. The completed routing exclusion concerns one fixed comparison structure. The 42-instruction programs do not meet the requested 41-instruction total.

The immutable representatives and their SHA-256 hashes are recorded in artifacts/verified_ledger.json. The final strict-judge audit is recorded in artifacts/all_judge_results.json. The audit output is logs/final_judges.log.

### Every final strict PASS file

- [artifacts/skeletons/c8_108b52d1733c50f9.s](artifacts/skeletons/c8_108b52d1733c50f9.s) (out).
- [artifacts/skeletons/c8_15d47dd100cf7fcb.s](artifacts/skeletons/c8_15d47dd100cf7fcb.s) (out).
- [artifacts/skeletons/c8_23f00ca3e09530d3.s](artifacts/skeletons/c8_23f00ca3e09530d3.s) (out).
- [artifacts/skeletons/c8_26e49cf60c846007.s](artifacts/skeletons/c8_26e49cf60c846007.s) (out).
- [artifacts/skeletons/c8_2754b681df96846f.s](artifacts/skeletons/c8_2754b681df96846f.s) (out).
- [artifacts/skeletons/c8_2b1431ee7889f02b.s](artifacts/skeletons/c8_2b1431ee7889f02b.s) (out).
- [artifacts/skeletons/c8_2c342e0e0fbafd57.s](artifacts/skeletons/c8_2c342e0e0fbafd57.s) (out).
- [artifacts/skeletons/c8_2dfea391c9fdd3bb.s](artifacts/skeletons/c8_2dfea391c9fdd3bb.s) (out).
- [artifacts/skeletons/c8_2fc1b3fefa56100b.s](artifacts/skeletons/c8_2fc1b3fefa56100b.s) (out).
- [artifacts/skeletons/c8_3395266762428bd.s](artifacts/skeletons/c8_3395266762428bd.s) (out).
- [artifacts/skeletons/c8_3809e545578327.s](artifacts/skeletons/c8_3809e545578327.s) (out).
- [artifacts/skeletons/c8_57fa7c797ed6c84f.s](artifacts/skeletons/c8_57fa7c797ed6c84f.s) (out).
- [artifacts/skeletons/c8_903a0e9b56d0fdc7.s](artifacts/skeletons/c8_903a0e9b56d0fdc7.s) (out).
- [artifacts/skeletons/c8_9dc3b82d8b1e62f.s](artifacts/skeletons/c8_9dc3b82d8b1e62f.s) (out).
- [artifacts/skeletons/c8_9f2faf3e2b5848b.s](artifacts/skeletons/c8_9f2faf3e2b5848b.s) (out).
- [artifacts/skeletons/c8_b71830c38f98f13.s](artifacts/skeletons/c8_b71830c38f98f13.s) (out).
- [artifacts/skeletons/c8_be0bab6887969b3.s](artifacts/skeletons/c8_be0bab6887969b3.s) (out).
- [artifacts/skeletons/c8_de052e5a1c75d83.s](artifacts/skeletons/c8_de052e5a1c75d83.s) (out).
- [artifacts/sort5_c8_k32_mem.s](artifacts/sort5_c8_k32_mem.s) (mem).
- [artifacts/sort5_c8_k32_out.s](artifacts/sort5_c8_k32_out.s) (out).
- [candidates/c8a_len32_c35b6.s](candidates/c8a_len32_c35b6.s) (out).
- [candidates/c8a_len33_a32242.s](candidates/c8a_len33_a32242.s) (out).
- [candidates/c8b_len32_64cc82.s](candidates/c8b_len32_64cc82.s) (out).
- [candidates/c8b_len33_6085ec.s](candidates/c8b_len33_6085ec.s) (out).
- [candidates/c8c_len32_c29288.s](candidates/c8c_len32_c29288.s) (out).
- [candidates/c8c_len33_decb9e.s](candidates/c8c_len33_decb9e.s) (out).
- [candidates/c8d_len33_3133e9.s](candidates/c8d_len33_3133e9.s) (out).
- [candidates/c8e_len32_fe5a3d.s](candidates/c8e_len32_fe5a3d.s) (out).
- [candidates/c8f_len32_238c31.s](candidates/c8f_len32_238c31.s) (out).
- [candidates/p32a_k32.s](candidates/p32a_k32.s) (out).
- [candidates/p32b_k32.s](candidates/p32b_k32.s) (out).
- [candidates/p32c_k32.s](candidates/p32c_k32.s) (out).
- [candidates/p32d_k32.s](candidates/p32d_k32.s) (out).
- [candidates/window5_16_k32.s](candidates/window5_16_k32.s) (out).
- [seeds/c8_13_k32.s](seeds/c8_13_k32.s) (out).
- [seeds/c8_32.s](seeds/c8_32.s) (out).
- [seeds/position33.s](seeds/position33.s) (out).
- [verified/c8_108b52d1733c50f9.s](verified/c8_108b52d1733c50f9.s) (out).
- [verified/c8_15d47dd100cf7fcb.s](verified/c8_15d47dd100cf7fcb.s) (out).
- [verified/c8_23f00ca3e09530d3.s](verified/c8_23f00ca3e09530d3.s) (out).
- [verified/c8_26e49cf60c846007.s](verified/c8_26e49cf60c846007.s) (out).
- [verified/c8_2754b681df96846f.s](verified/c8_2754b681df96846f.s) (out).
- [verified/c8_2b1431ee7889f02b.s](verified/c8_2b1431ee7889f02b.s) (out).
- [verified/c8_2c342e0e0fbafd57.s](verified/c8_2c342e0e0fbafd57.s) (out).
- [verified/c8_2dfea391c9fdd3bb.s](verified/c8_2dfea391c9fdd3bb.s) (out).
- [verified/c8_2fc1b3fefa56100b.s](verified/c8_2fc1b3fefa56100b.s) (out).
- [verified/c8_3395266762428bd.s](verified/c8_3395266762428bd.s) (out).
- [verified/c8_3809e545578327.s](verified/c8_3809e545578327.s) (out).
- [verified/c8_57fa7c797ed6c84f.s](verified/c8_57fa7c797ed6c84f.s) (out).
- [verified/c8_903a0e9b56d0fdc7.s](verified/c8_903a0e9b56d0fdc7.s) (out).
- [verified/c8_9dc3b82d8b1e62f.s](verified/c8_9dc3b82d8b1e62f.s) (out).
- [verified/c8_9f2faf3e2b5848b.s](verified/c8_9f2faf3e2b5848b.s) (out).
- [verified/c8_b71830c38f98f13.s](verified/c8_b71830c38f98f13.s) (out).
- [verified/c8_be0bab6887969b3.s](verified/c8_be0bab6887969b3.s) (out).
- [verified/c8_de052e5a1c75d83.s](verified/c8_de052e5a1c75d83.s) (out).

## Round 2 — comparison changes

This round uses at most two CPU jobs. Every search and compiler command uses `nice -n 19`. All files remain inside w6. The 18 round-1 structures were not submitted again to the routing search.

The new stochastic search starts from all 18 representatives. It changes comparison operands and their following conditional moves together. It adds a visit cost to repeated comparison structures. It restarts from its archive. The independent simulator checks all 541 weak orders before it accepts a zero-error state. Saved states are search samples until the strict judge accepts a retained representative.

The first sample produced four new comparison-operand fingerprints. All four retained programs passed `shared/judge.py --strict --model out`:

| Strict PASS file | k | cmp | mov | conditional moves | Judge log |
|---|---:|---:|---:|---:|---|
| [round2/verified/c8_156fdd193572fb27.s](round2/verified/c8_156fdd193572fb27.s) | 32 | 8 | 1 | 23 | [log](round2/logs/c8_156fdd193572fb27_judge.log) |
| [round2/verified/c8_15bdbe5ff6cbe16f.s](round2/verified/c8_15bdbe5ff6cbe16f.s) | 32 | 8 | 1 | 23 | [log](round2/logs/c8_15bdbe5ff6cbe16f_judge.log) |
| [round2/verified/c8_22e8c2d0d1b113b.s](round2/verified/c8_22e8c2d0d1b113b.s) | 32 | 8 | 2 | 22 | [log](round2/logs/c8_22e8c2d0d1b113b_judge.log) |
| [round2/verified/c8_8fce06357f6d127.s](round2/verified/c8_8fce06357f6d127.s) | 32 | 8 | 2 | 22 | [log](round2/logs/c8_8fce06357f6d127_judge.log) |

The routing searches on these four new structures all finished with `RESULT NONE K=31`. They used 9,460,441; 20,161,593; 58,131,395; and 16,796,330 calls, respectively. None reached the 60-million-node limit. These results concern only the four fixed operand structures. See [round2/artifacts/initial_routing.json](round2/artifacts/initial_routing.json).

Further comparison-changing searches are in progress. No strict PASS with k <= 31 has been found in this round.

The completed 900-CPU-second run tested 1,239,777,280 proposals. It accepted 159,188,688 transitions and visited a correct state 288,471 times. Correct visits can repeat. It saved 4,794 raw comparison signatures. Input renaming, comparison reversal, and value-order reversal reduce the retained k=32 samples and the old collection to 30 operand fingerprints. Thus this run added 12 representatives to the 18 original representatives. The first four appear above. The other eight strict PASS files are:

- [c8_161f27bdd6e9955b.s](round2/verified/c8_161f27bdd6e9955b.s) (out; [judge log](round2/logs/c8_161f27bdd6e9955b_judge.log)).
- [c8_166731603245e2eb.s](round2/verified/c8_166731603245e2eb.s) (out; [judge log](round2/logs/c8_166731603245e2eb_judge.log)).
- [c8_1a082026b9b8a97.s](round2/verified/c8_1a082026b9b8a97.s) (out; [judge log](round2/logs/c8_1a082026b9b8a97_judge.log)).
- [c8_35006f3bfb8deb1b.s](round2/verified/c8_35006f3bfb8deb1b.s) (out; [judge log](round2/logs/c8_35006f3bfb8deb1b_judge.log)).
- [c8_4033c0cef9939583.s](round2/verified/c8_4033c0cef9939583.s) (out; [judge log](round2/logs/c8_4033c0cef9939583_judge.log)).
- [c8_40718fc8b65bfb.s](round2/verified/c8_40718fc8b65bfb.s) (out; [judge log](round2/logs/c8_40718fc8b65bfb_judge.log)).
- [c8_dbbbb77809455d7.s](round2/verified/c8_dbbbb77809455d7.s) (out; [judge log](round2/logs/c8_dbbbb77809455d7_judge.log)).
- [c8_e32bfb331db9cf7.s](round2/verified/c8_e32bfb331db9cf7.s) (out; [judge log](round2/logs/c8_e32bfb331db9cf7_judge.log)).

The fixed 32-instruction solver control also passed the strict judge: [round2/candidates/source_control32.s](round2/candidates/source_control32.s), [log](round2/logs/source_control_judge.log).

The first complete four-edit scan removed each non-comparison instruction in turn. It changed one operand in each of two surviving comparisons. It also changed the source and condition of one surviving conditional move. The write destination stayed fixed. This scan tested 147,883,008 candidates on `c8_156fdd193572fb27.s`. None passed the initial 32-case filter. It is a restricted search observation, not a general exclusion. Log: [round2/logs/doublecmp_all_first.log](round2/logs/doublecmp_all_first.log).

The global source search preserved write destinations and instruction classes. It allowed all comparison operands, write sources, and conditional-move conditions to change. The first four instructions stayed fixed. After deletion of the sole mov in `c8_156fdd193572fb27.s`, the query with at most six other changed instructions returned UNSAT in 33.3 seconds on 16 encoded cases. The corresponding eight-change query on `c8_15bdbe5ff6cbe16f.s` reached its 90-second wall limit. The latter result is unknown. The encoder uses a relaxed initial state; every retained solver candidate still requires the strict judge.


The first repair pattern completed on all 22 selected representatives (18 original and four initial new representatives). It enumerated 3,193,616,608 candidates. None passed the 32-case filter. The second repair pattern is still running. Full per-program counts are in [round2/artifacts/repair_batch.json](round2/artifacts/repair_batch.json).

The direct k=31 run used a new score: sum of e + 0.05 e^2 over the five output errors. It completed 792,387,584 proposals in 480 CPU seconds. It found no correct program. Its best saved near miss is [round2/candidates/b31a_near.s](round2/candidates/b31a_near.s). The independent simulator reports 30 failed weak orders. The strict judge rejects it; see [round2/logs/b31a_near_judge.log](round2/logs/b31a_near_judge.log).

This near miss has a new comparison-operand fingerprint, `c8_47641652f3b434f`. Its eight comparisons distinguish all 120 strict input orders. This observation does not establish that the program sorts. The best fixed snapshots for output 1 and output 2 fail on 12 and 18 weak orders, respectively. Output 1 fails on eight strict orders. Output 2 passes all strict orders but fails on ties. Outputs 0, 3, and 4 pass all 541 weak orders in the independent simulator. The strict judge gives input `[1,0,0,1,2]`, wrong output `[0,0,0,1,2]`, and expected output `[0,0,1,1,2]`.

The near-miss analysis is [round2/artifacts/b31a_near_analysis.json](round2/artifacts/b31a_near_analysis.json). Its new structure is queued for routing and a three-instruction source repair. The repair batch runs these jobs in sequence before its next scan. It does not add a third CPU job.

## Round 2 completion

No strict PASS with core k <= 31 was found. The best correct core remains k=32. Its memory form has 42 instructions.

This round added **143** comparison-operand fingerprints. Together with the 18 original fingerprints, the retained collection has **161** representatives. Every new representative passed the strict out and memory judges. Each uses eight comparisons. These fingerprints also distinguish comparison order. They do not establish that the representatives are different sorting algorithms.

| Core mov instructions | New representatives | Core conditional moves |
|---:|---:|---:|
| 0 | 1 | 24 |
| 1 | 14 | 23 |
| 2 | 39 | 22 |
| 3 | 54 | 21 |
| 4 | 32 | 20 |
| 5 | 3 | 19 |

The new core with no mov instruction is [round2/verified/c8_215cbe6f0d1c7837.s](round2/verified/c8_215cbe6f0d1c7837.s). It has eight comparisons and 24 conditional moves. Its [memory form](round2/verified_mem/c8_215cbe6f0d1c7837.s) adds five loads and five stores. Both strict judge logs report PASS. It does not meet the requested 41-instruction total.

| Search | Proposals | Accepted | Correct visits | Best k | CPU seconds |
|---|---:|---:|---:|---:|---:|
| n32a | 1,239,777,280 | 159,188,688 | 288,471 | 32 | 900.0 |
| b31a | 792,387,584 | 99,170,566 | 0 | none | 480.0 |
| n32b | 402,001,920 | 51,496,368 | 3,382,203 | 32 | 300.0 |
| f31a | 283,176,960 | 34,316,204 | 0 | none | 300.0 |
| e31a | 174,874,624 | 21,301,282 | 0 | none | 300.0 |

Search proposals include early rejections. Correct visits can repeat. n32b changes comparison groups together and uses input-renaming-normalized visit costs. f31a scores all 541 weak orders and retains better failing seeds. e31a also adds a search cost of 20 to the two prior near-miss comparison signatures. This cost is a search heuristic. It is not a program restriction or a correctness check.

The best retained k=31 failure is [round2/candidates/near14_frozen.s](round2/candidates/near14_frozen.s). The independent simulator reports 14 failed weak orders and an output-error sum of 18. The strict judge reports FAIL. For input `[0,1,2,1,3]`, the program returns `[0,1,2,2,3]` instead of `[0,1,1,2,3]`. See [the judge log](round2/logs/near14_frozen_judge.log).

The comparison structure of this 14-case failure differs from the 30-case failure. Both distinguish all 120 strict input orders. Routing completed with NONE at K=31 for the 30-case structure after 24,102,570 calls and for the 14-case structure after 24,478,546 calls. These results concern those fixed value structures only.

The 14-case condition-only query kept every source and destination fixed. It allowed all conditional-move conditions to change. It returned UNSAT on its 16 encoded cases in 0.35 seconds. The 30-case source repair, with at most three changes and fixed write destinations, returned UNSAT in 4.60 seconds. The separate unrestricted three-instruction repair had a 90-second cap and produced no final solver status. No exclusion is claimed for that incomplete query.

| Completed repair pattern | Representatives | Enumerated candidates | Passed case filter |
|---|---:|---:|---:|
| Delete + two cmp operand changes + one cmov change | 22 | 3,193,616,608 | 0 |
| Delete + one cmp change + two write-source changes | 22 | 6,217,776,576 | 0 |

The repair counts concern the stated register alphabet and edit patterns. One fresh scratch register is available. The filter uses 32 weak orders. Its conservative handling of unknown scratch values can reject valid programs. Thus these counts are observations from a bounded search, not a general impossibility result.

The final selected routing runs were:

- `c8_215cbe6f0d1c7837.s`: `RESULT NONE K=31 calls=32930695 leaves=51840 sols=0 best=-1 time=88.9s`. [Log](round2/logs/c8_215cbe6f0d1c7837_selected_route31.log).
- `c8_70dac6520f0a05af.s`: `RESULT LIMIT K=31 calls=10000049 leaves=0 sols=0 best=-1 time=25.8s (node limit hit: not exhaustive)`. [Log](round2/logs/c8_70dac6520f0a05af_selected_route31.log).
- `c8_44a89463151f5b8f.s`: `RESULT LIMIT K=31 calls=10000083 leaves=14112 sols=0 best=-1 time=27.4s (node limit hit: not exhaustive)`. [Log](round2/logs/c8_44a89463151f5b8f_selected_route31.log).
- `c8_24f787e7e88ef5ab.s`: `RESULT LIMIT K=31 calls=10000077 leaves=0 sols=0 best=-1 time=24.6s (node limit hit: not exhaustive)`. [Log](round2/logs/c8_24f787e7e88ef5ab_selected_route31.log).
- `c8_ffb1da4812016b.s`: `RESULT LIMIT K=31 calls=10000057 leaves=0 sols=0 best=-1 time=27.6s (node limit hit: not exhaustive)`. [Log](round2/logs/c8_ffb1da4812016b_selected_route31.log).
- `c8_36e5e6298381a683.s`: `RESULT LIMIT K=31 calls=10000060 leaves=17280 sols=0 best=-1 time=32.1s (node limit hit: not exhaustive)`. [Log](round2/logs/c8_36e5e6298381a683_selected_route31.log).

A node LIMIT or a wall-time limit is incomplete. No negative result is claimed for those runs. The completed zero-mov routing run returned NONE at K=31 after 32,930,695 calls. No old round-1 structure was rerouted in this round.

All searches and compiler jobs used nice level 19. At most two CPU jobs ran at once. The repair dispatcher ran its added near-miss jobs in sequence. It did not add a third CPU job. All writes stayed inside w6.

The final ledger records hashes, counts, and judge logs: [round2/artifacts/final_verified_ledger.json](round2/artifacts/final_verified_ledger.json). Retained out files are byte-identical to their tested out sources. The complete search summary is [round2/artifacts/final_summary.json](round2/artifacts/final_summary.json).

### Every new strict PASS file and retained copy

The two solver controls also passed: [source_control32.s](round2/candidates/source_control32.s), [log](round2/logs/source_control_judge.log); [slots_control32.s](round2/candidates/slots_control32.s), [log](round2/logs/slots_control32_judge.log).

| Retained out copy | Tested out file | Memory file | Judge logs |
|---|---|---|---|
| [c8_10040eff416c0867](round2/verified/c8_10040eff416c0867.s) | [out](round2/artifacts/skeletons/c8_10040eff416c0867.s) | [mem](round2/verified_mem/c8_10040eff416c0867.s) | [out](round2/logs/c8_10040eff416c0867_judge.log), [mem](round2/logs/c8_10040eff416c0867_mem_judge.log) |
| [c8_100fdc9beb7f87fb](round2/verified/c8_100fdc9beb7f87fb.s) | [out](round2/artifacts/skeletons/c8_100fdc9beb7f87fb.s) | [mem](round2/verified_mem/c8_100fdc9beb7f87fb.s) | [out](round2/logs/c8_100fdc9beb7f87fb_judge.log), [mem](round2/logs/c8_100fdc9beb7f87fb_mem_judge.log) |
| [c8_1125a776aad66f0f](round2/verified/c8_1125a776aad66f0f.s) | [out](round2/artifacts/skeletons/c8_1125a776aad66f0f.s) | [mem](round2/verified_mem/c8_1125a776aad66f0f.s) | [out](round2/logs/c8_1125a776aad66f0f_judge.log), [mem](round2/logs/c8_1125a776aad66f0f_mem_judge.log) |
| [c8_1133ec48c6cddf1b](round2/verified/c8_1133ec48c6cddf1b.s) | [out](round2/artifacts/skeletons/c8_1133ec48c6cddf1b.s) | [mem](round2/verified_mem/c8_1133ec48c6cddf1b.s) | [out](round2/logs/c8_1133ec48c6cddf1b_judge.log), [mem](round2/logs/c8_1133ec48c6cddf1b_mem_judge.log) |
| [c8_11c9d4867493ab47](round2/verified/c8_11c9d4867493ab47.s) | [out](round2/artifacts/skeletons/c8_11c9d4867493ab47.s) | [mem](round2/verified_mem/c8_11c9d4867493ab47.s) | [out](round2/logs/c8_11c9d4867493ab47_judge.log), [mem](round2/logs/c8_11c9d4867493ab47_mem_judge.log) |
| [c8_11ff7541f319ba6f](round2/verified/c8_11ff7541f319ba6f.s) | [out](round2/artifacts/skeletons/c8_11ff7541f319ba6f.s) | [mem](round2/verified_mem/c8_11ff7541f319ba6f.s) | [out](round2/logs/c8_11ff7541f319ba6f_judge.log), [mem](round2/logs/c8_11ff7541f319ba6f_mem_judge.log) |
| [c8_1225fd780bdd0fe7](round2/verified/c8_1225fd780bdd0fe7.s) | [out](round2/artifacts/skeletons/c8_1225fd780bdd0fe7.s) | [mem](round2/verified_mem/c8_1225fd780bdd0fe7.s) | [out](round2/logs/c8_1225fd780bdd0fe7_judge.log), [mem](round2/logs/c8_1225fd780bdd0fe7_mem_judge.log) |
| [c8_12651d8baa33ba0f](round2/verified/c8_12651d8baa33ba0f.s) | [out](round2/artifacts/skeletons/c8_12651d8baa33ba0f.s) | [mem](round2/verified_mem/c8_12651d8baa33ba0f.s) | [out](round2/logs/c8_12651d8baa33ba0f_judge.log), [mem](round2/logs/c8_12651d8baa33ba0f_mem_judge.log) |
| [c8_12b75491c4d308a3](round2/verified/c8_12b75491c4d308a3.s) | [out](round2/artifacts/skeletons/c8_12b75491c4d308a3.s) | [mem](round2/verified_mem/c8_12b75491c4d308a3.s) | [out](round2/logs/c8_12b75491c4d308a3_judge.log), [mem](round2/logs/c8_12b75491c4d308a3_mem_judge.log) |
| [c8_1338d3424477e129](round2/verified/c8_1338d3424477e129.s) | [out](round2/artifacts/skeletons/c8_1338d3424477e129.s) | [mem](round2/verified_mem/c8_1338d3424477e129.s) | [out](round2/logs/c8_1338d3424477e129_judge.log), [mem](round2/logs/c8_1338d3424477e129_mem_judge.log) |
| [c8_141a02776a21d45](round2/verified/c8_141a02776a21d45.s) | [out](round2/artifacts/skeletons/c8_141a02776a21d45.s) | [mem](round2/verified_mem/c8_141a02776a21d45.s) | [out](round2/logs/c8_141a02776a21d45_judge.log), [mem](round2/logs/c8_141a02776a21d45_mem_judge.log) |
| [c8_153074ef2f383393](round2/verified/c8_153074ef2f383393.s) | [out](round2/artifacts/skeletons/c8_153074ef2f383393.s) | [mem](round2/verified_mem/c8_153074ef2f383393.s) | [out](round2/logs/c8_153074ef2f383393_judge.log), [mem](round2/logs/c8_153074ef2f383393_mem_judge.log) |
| [c8_156fdd193572fb27](round2/verified/c8_156fdd193572fb27.s) | [out](round2/verified/c8_156fdd193572fb27.s) | [mem](round2/verified_mem/c8_156fdd193572fb27.s) | [out](round2/logs/c8_156fdd193572fb27_judge.log), [mem](round2/logs/c8_156fdd193572fb27_mem_judge.log) |
| [c8_15a18d5fe8f0f427](round2/verified/c8_15a18d5fe8f0f427.s) | [out](round2/artifacts/skeletons/c8_15a18d5fe8f0f427.s) | [mem](round2/verified_mem/c8_15a18d5fe8f0f427.s) | [out](round2/logs/c8_15a18d5fe8f0f427_judge.log), [mem](round2/logs/c8_15a18d5fe8f0f427_mem_judge.log) |
| [c8_15bdbe5ff6cbe16f](round2/verified/c8_15bdbe5ff6cbe16f.s) | [out](round2/verified/c8_15bdbe5ff6cbe16f.s) | [mem](round2/verified_mem/c8_15bdbe5ff6cbe16f.s) | [out](round2/logs/c8_15bdbe5ff6cbe16f_judge.log), [mem](round2/logs/c8_15bdbe5ff6cbe16f_mem_judge.log) |
| [c8_161f27bdd6e9955b](round2/verified/c8_161f27bdd6e9955b.s) | [out](round2/artifacts/skeletons/c8_161f27bdd6e9955b.s) | [mem](round2/verified_mem/c8_161f27bdd6e9955b.s) | [out](round2/logs/c8_161f27bdd6e9955b_judge.log), [mem](round2/logs/c8_161f27bdd6e9955b_mem_judge.log) |
| [c8_164a24929b8970bb](round2/verified/c8_164a24929b8970bb.s) | [out](round2/artifacts/skeletons/c8_164a24929b8970bb.s) | [mem](round2/verified_mem/c8_164a24929b8970bb.s) | [out](round2/logs/c8_164a24929b8970bb_judge.log), [mem](round2/logs/c8_164a24929b8970bb_mem_judge.log) |
| [c8_166731603245e2eb](round2/verified/c8_166731603245e2eb.s) | [out](round2/artifacts/skeletons/c8_166731603245e2eb.s) | [mem](round2/verified_mem/c8_166731603245e2eb.s) | [out](round2/logs/c8_166731603245e2eb_judge.log), [mem](round2/logs/c8_166731603245e2eb_mem_judge.log) |
| [c8_17907dae653ca8f](round2/verified/c8_17907dae653ca8f.s) | [out](round2/artifacts/skeletons/c8_17907dae653ca8f.s) | [mem](round2/verified_mem/c8_17907dae653ca8f.s) | [out](round2/logs/c8_17907dae653ca8f_judge.log), [mem](round2/logs/c8_17907dae653ca8f_mem_judge.log) |
| [c8_185d571c2e0f14f](round2/verified/c8_185d571c2e0f14f.s) | [out](round2/artifacts/skeletons/c8_185d571c2e0f14f.s) | [mem](round2/verified_mem/c8_185d571c2e0f14f.s) | [out](round2/logs/c8_185d571c2e0f14f_judge.log), [mem](round2/logs/c8_185d571c2e0f14f_mem_judge.log) |
| [c8_1a082026b9b8a97](round2/verified/c8_1a082026b9b8a97.s) | [out](round2/artifacts/skeletons/c8_1a082026b9b8a97.s) | [mem](round2/verified_mem/c8_1a082026b9b8a97.s) | [out](round2/logs/c8_1a082026b9b8a97_judge.log), [mem](round2/logs/c8_1a082026b9b8a97_mem_judge.log) |
| [c8_1a613ac2485250c7](round2/verified/c8_1a613ac2485250c7.s) | [out](round2/artifacts/skeletons/c8_1a613ac2485250c7.s) | [mem](round2/verified_mem/c8_1a613ac2485250c7.s) | [out](round2/logs/c8_1a613ac2485250c7_judge.log), [mem](round2/logs/c8_1a613ac2485250c7_mem_judge.log) |
| [c8_1a63d93b1f04a2cb](round2/verified/c8_1a63d93b1f04a2cb.s) | [out](round2/artifacts/skeletons/c8_1a63d93b1f04a2cb.s) | [mem](round2/verified_mem/c8_1a63d93b1f04a2cb.s) | [out](round2/logs/c8_1a63d93b1f04a2cb_judge.log), [mem](round2/logs/c8_1a63d93b1f04a2cb_mem_judge.log) |
| [c8_1ac755463afdc2ab](round2/verified/c8_1ac755463afdc2ab.s) | [out](round2/artifacts/skeletons/c8_1ac755463afdc2ab.s) | [mem](round2/verified_mem/c8_1ac755463afdc2ab.s) | [out](round2/logs/c8_1ac755463afdc2ab_judge.log), [mem](round2/logs/c8_1ac755463afdc2ab_mem_judge.log) |
| [c8_1b0c08cec2e379c3](round2/verified/c8_1b0c08cec2e379c3.s) | [out](round2/artifacts/skeletons/c8_1b0c08cec2e379c3.s) | [mem](round2/verified_mem/c8_1b0c08cec2e379c3.s) | [out](round2/logs/c8_1b0c08cec2e379c3_judge.log), [mem](round2/logs/c8_1b0c08cec2e379c3_mem_judge.log) |
| [c8_1be80efe56e14ebf](round2/verified/c8_1be80efe56e14ebf.s) | [out](round2/artifacts/skeletons/c8_1be80efe56e14ebf.s) | [mem](round2/verified_mem/c8_1be80efe56e14ebf.s) | [out](round2/logs/c8_1be80efe56e14ebf_judge.log), [mem](round2/logs/c8_1be80efe56e14ebf_mem_judge.log) |
| [c8_1c180823effee2ab](round2/verified/c8_1c180823effee2ab.s) | [out](round2/artifacts/skeletons/c8_1c180823effee2ab.s) | [mem](round2/verified_mem/c8_1c180823effee2ab.s) | [out](round2/logs/c8_1c180823effee2ab_judge.log), [mem](round2/logs/c8_1c180823effee2ab_mem_judge.log) |
| [c8_1cc416f5fb6c5bef](round2/verified/c8_1cc416f5fb6c5bef.s) | [out](round2/artifacts/skeletons/c8_1cc416f5fb6c5bef.s) | [mem](round2/verified_mem/c8_1cc416f5fb6c5bef.s) | [out](round2/logs/c8_1cc416f5fb6c5bef_judge.log), [mem](round2/logs/c8_1cc416f5fb6c5bef_mem_judge.log) |
| [c8_1d4ad416e35cc60b](round2/verified/c8_1d4ad416e35cc60b.s) | [out](round2/artifacts/skeletons/c8_1d4ad416e35cc60b.s) | [mem](round2/verified_mem/c8_1d4ad416e35cc60b.s) | [out](round2/logs/c8_1d4ad416e35cc60b_judge.log), [mem](round2/logs/c8_1d4ad416e35cc60b_mem_judge.log) |
| [c8_1e7b08432020f0b7](round2/verified/c8_1e7b08432020f0b7.s) | [out](round2/artifacts/skeletons/c8_1e7b08432020f0b7.s) | [mem](round2/verified_mem/c8_1e7b08432020f0b7.s) | [out](round2/logs/c8_1e7b08432020f0b7_judge.log), [mem](round2/logs/c8_1e7b08432020f0b7_mem_judge.log) |
| [c8_1f71d7979bb91b7](round2/verified/c8_1f71d7979bb91b7.s) | [out](round2/artifacts/skeletons/c8_1f71d7979bb91b7.s) | [mem](round2/verified_mem/c8_1f71d7979bb91b7.s) | [out](round2/logs/c8_1f71d7979bb91b7_judge.log), [mem](round2/logs/c8_1f71d7979bb91b7_mem_judge.log) |
| [c8_1fa5731a2358af7](round2/verified/c8_1fa5731a2358af7.s) | [out](round2/artifacts/skeletons/c8_1fa5731a2358af7.s) | [mem](round2/verified_mem/c8_1fa5731a2358af7.s) | [out](round2/logs/c8_1fa5731a2358af7_judge.log), [mem](round2/logs/c8_1fa5731a2358af7_mem_judge.log) |
| [c8_203f14ede4be42f](round2/verified/c8_203f14ede4be42f.s) | [out](round2/artifacts/skeletons/c8_203f14ede4be42f.s) | [mem](round2/verified_mem/c8_203f14ede4be42f.s) | [out](round2/logs/c8_203f14ede4be42f_judge.log), [mem](round2/logs/c8_203f14ede4be42f_mem_judge.log) |
| [c8_215cbe6f0d1c7837](round2/verified/c8_215cbe6f0d1c7837.s) | [out](round2/artifacts/skeletons/c8_215cbe6f0d1c7837.s) | [mem](round2/verified_mem/c8_215cbe6f0d1c7837.s) | [out](round2/logs/c8_215cbe6f0d1c7837_judge.log), [mem](round2/logs/c8_215cbe6f0d1c7837_mem_judge.log) |
| [c8_21a6f16bedc5b8bf](round2/verified/c8_21a6f16bedc5b8bf.s) | [out](round2/artifacts/skeletons/c8_21a6f16bedc5b8bf.s) | [mem](round2/verified_mem/c8_21a6f16bedc5b8bf.s) | [out](round2/logs/c8_21a6f16bedc5b8bf_judge.log), [mem](round2/logs/c8_21a6f16bedc5b8bf_mem_judge.log) |
| [c8_21abacdf36bcd7b3](round2/verified/c8_21abacdf36bcd7b3.s) | [out](round2/artifacts/skeletons/c8_21abacdf36bcd7b3.s) | [mem](round2/verified_mem/c8_21abacdf36bcd7b3.s) | [out](round2/logs/c8_21abacdf36bcd7b3_judge.log), [mem](round2/logs/c8_21abacdf36bcd7b3_mem_judge.log) |
| [c8_21f839ca06fe77d3](round2/verified/c8_21f839ca06fe77d3.s) | [out](round2/artifacts/skeletons/c8_21f839ca06fe77d3.s) | [mem](round2/verified_mem/c8_21f839ca06fe77d3.s) | [out](round2/logs/c8_21f839ca06fe77d3_judge.log), [mem](round2/logs/c8_21f839ca06fe77d3_mem_judge.log) |
| [c8_220dcb420effb46b](round2/verified/c8_220dcb420effb46b.s) | [out](round2/artifacts/skeletons/c8_220dcb420effb46b.s) | [mem](round2/verified_mem/c8_220dcb420effb46b.s) | [out](round2/logs/c8_220dcb420effb46b_judge.log), [mem](round2/logs/c8_220dcb420effb46b_mem_judge.log) |
| [c8_22389f7b99df6097](round2/verified/c8_22389f7b99df6097.s) | [out](round2/artifacts/skeletons/c8_22389f7b99df6097.s) | [mem](round2/verified_mem/c8_22389f7b99df6097.s) | [out](round2/logs/c8_22389f7b99df6097_judge.log), [mem](round2/logs/c8_22389f7b99df6097_mem_judge.log) |
| [c8_224e45102f6e86b](round2/verified/c8_224e45102f6e86b.s) | [out](round2/artifacts/skeletons/c8_224e45102f6e86b.s) | [mem](round2/verified_mem/c8_224e45102f6e86b.s) | [out](round2/logs/c8_224e45102f6e86b_judge.log), [mem](round2/logs/c8_224e45102f6e86b_mem_judge.log) |
| [c8_2289ab6219955a3b](round2/verified/c8_2289ab6219955a3b.s) | [out](round2/artifacts/skeletons/c8_2289ab6219955a3b.s) | [mem](round2/verified_mem/c8_2289ab6219955a3b.s) | [out](round2/logs/c8_2289ab6219955a3b_judge.log), [mem](round2/logs/c8_2289ab6219955a3b_mem_judge.log) |
| [c8_22e8c2d0d1b113b](round2/verified/c8_22e8c2d0d1b113b.s) | [out](round2/verified/c8_22e8c2d0d1b113b.s) | [mem](round2/verified_mem/c8_22e8c2d0d1b113b.s) | [out](round2/logs/c8_22e8c2d0d1b113b_judge.log), [mem](round2/logs/c8_22e8c2d0d1b113b_mem_judge.log) |
| [c8_23831cd511228447](round2/verified/c8_23831cd511228447.s) | [out](round2/artifacts/skeletons/c8_23831cd511228447.s) | [mem](round2/verified_mem/c8_23831cd511228447.s) | [out](round2/logs/c8_23831cd511228447_judge.log), [mem](round2/logs/c8_23831cd511228447_mem_judge.log) |
| [c8_24853a2a978e287f](round2/verified/c8_24853a2a978e287f.s) | [out](round2/artifacts/skeletons/c8_24853a2a978e287f.s) | [mem](round2/verified_mem/c8_24853a2a978e287f.s) | [out](round2/logs/c8_24853a2a978e287f_judge.log), [mem](round2/logs/c8_24853a2a978e287f_mem_judge.log) |
| [c8_24abc8199dc03077](round2/verified/c8_24abc8199dc03077.s) | [out](round2/artifacts/skeletons/c8_24abc8199dc03077.s) | [mem](round2/verified_mem/c8_24abc8199dc03077.s) | [out](round2/logs/c8_24abc8199dc03077_judge.log), [mem](round2/logs/c8_24abc8199dc03077_mem_judge.log) |
| [c8_24f787e7e88ef5ab](round2/verified/c8_24f787e7e88ef5ab.s) | [out](round2/artifacts/skeletons/c8_24f787e7e88ef5ab.s) | [mem](round2/verified_mem/c8_24f787e7e88ef5ab.s) | [out](round2/logs/c8_24f787e7e88ef5ab_judge.log), [mem](round2/logs/c8_24f787e7e88ef5ab_mem_judge.log) |
| [c8_2596dc2f20910faf](round2/verified/c8_2596dc2f20910faf.s) | [out](round2/artifacts/skeletons/c8_2596dc2f20910faf.s) | [mem](round2/verified_mem/c8_2596dc2f20910faf.s) | [out](round2/logs/c8_2596dc2f20910faf_judge.log), [mem](round2/logs/c8_2596dc2f20910faf_mem_judge.log) |
| [c8_2642972b24ea19b](round2/verified/c8_2642972b24ea19b.s) | [out](round2/artifacts/skeletons/c8_2642972b24ea19b.s) | [mem](round2/verified_mem/c8_2642972b24ea19b.s) | [out](round2/logs/c8_2642972b24ea19b_judge.log), [mem](round2/logs/c8_2642972b24ea19b_mem_judge.log) |
| [c8_267a2e3d4909af4b](round2/verified/c8_267a2e3d4909af4b.s) | [out](round2/artifacts/skeletons/c8_267a2e3d4909af4b.s) | [mem](round2/verified_mem/c8_267a2e3d4909af4b.s) | [out](round2/logs/c8_267a2e3d4909af4b_judge.log), [mem](round2/logs/c8_267a2e3d4909af4b_mem_judge.log) |
| [c8_2726f4afb2d799](round2/verified/c8_2726f4afb2d799.s) | [out](round2/artifacts/skeletons/c8_2726f4afb2d799.s) | [mem](round2/verified_mem/c8_2726f4afb2d799.s) | [out](round2/logs/c8_2726f4afb2d799_judge.log), [mem](round2/logs/c8_2726f4afb2d799_mem_judge.log) |
| [c8_273efbe5788053db](round2/verified/c8_273efbe5788053db.s) | [out](round2/artifacts/skeletons/c8_273efbe5788053db.s) | [mem](round2/verified_mem/c8_273efbe5788053db.s) | [out](round2/logs/c8_273efbe5788053db_judge.log), [mem](round2/logs/c8_273efbe5788053db_mem_judge.log) |
| [c8_2755e8d9e8382207](round2/verified/c8_2755e8d9e8382207.s) | [out](round2/artifacts/skeletons/c8_2755e8d9e8382207.s) | [mem](round2/verified_mem/c8_2755e8d9e8382207.s) | [out](round2/logs/c8_2755e8d9e8382207_judge.log), [mem](round2/logs/c8_2755e8d9e8382207_mem_judge.log) |
| [c8_27f65daa1cee4f4b](round2/verified/c8_27f65daa1cee4f4b.s) | [out](round2/artifacts/skeletons/c8_27f65daa1cee4f4b.s) | [mem](round2/verified_mem/c8_27f65daa1cee4f4b.s) | [out](round2/logs/c8_27f65daa1cee4f4b_judge.log), [mem](round2/logs/c8_27f65daa1cee4f4b_mem_judge.log) |
| [c8_281eb7be1ab4dfb](round2/verified/c8_281eb7be1ab4dfb.s) | [out](round2/artifacts/skeletons/c8_281eb7be1ab4dfb.s) | [mem](round2/verified_mem/c8_281eb7be1ab4dfb.s) | [out](round2/logs/c8_281eb7be1ab4dfb_judge.log), [mem](round2/logs/c8_281eb7be1ab4dfb_mem_judge.log) |
| [c8_289340d6380f179f](round2/verified/c8_289340d6380f179f.s) | [out](round2/artifacts/skeletons/c8_289340d6380f179f.s) | [mem](round2/verified_mem/c8_289340d6380f179f.s) | [out](round2/logs/c8_289340d6380f179f_judge.log), [mem](round2/logs/c8_289340d6380f179f_mem_judge.log) |
| [c8_2896d97bea6f9f9f](round2/verified/c8_2896d97bea6f9f9f.s) | [out](round2/artifacts/skeletons/c8_2896d97bea6f9f9f.s) | [mem](round2/verified_mem/c8_2896d97bea6f9f9f.s) | [out](round2/logs/c8_2896d97bea6f9f9f_judge.log), [mem](round2/logs/c8_2896d97bea6f9f9f_mem_judge.log) |
| [c8_290ba1ab50398fa7](round2/verified/c8_290ba1ab50398fa7.s) | [out](round2/artifacts/skeletons/c8_290ba1ab50398fa7.s) | [mem](round2/verified_mem/c8_290ba1ab50398fa7.s) | [out](round2/logs/c8_290ba1ab50398fa7_judge.log), [mem](round2/logs/c8_290ba1ab50398fa7_mem_judge.log) |
| [c8_2a67840a0b9e7f13](round2/verified/c8_2a67840a0b9e7f13.s) | [out](round2/artifacts/skeletons/c8_2a67840a0b9e7f13.s) | [mem](round2/verified_mem/c8_2a67840a0b9e7f13.s) | [out](round2/logs/c8_2a67840a0b9e7f13_judge.log), [mem](round2/logs/c8_2a67840a0b9e7f13_mem_judge.log) |
| [c8_2ab6c13ccb245a63](round2/verified/c8_2ab6c13ccb245a63.s) | [out](round2/artifacts/skeletons/c8_2ab6c13ccb245a63.s) | [mem](round2/verified_mem/c8_2ab6c13ccb245a63.s) | [out](round2/logs/c8_2ab6c13ccb245a63_judge.log), [mem](round2/logs/c8_2ab6c13ccb245a63_mem_judge.log) |
| [c8_2e9b0f58dbb178a7](round2/verified/c8_2e9b0f58dbb178a7.s) | [out](round2/artifacts/skeletons/c8_2e9b0f58dbb178a7.s) | [mem](round2/verified_mem/c8_2e9b0f58dbb178a7.s) | [out](round2/logs/c8_2e9b0f58dbb178a7_judge.log), [mem](round2/logs/c8_2e9b0f58dbb178a7_mem_judge.log) |
| [c8_2fc2edb8474e5733](round2/verified/c8_2fc2edb8474e5733.s) | [out](round2/artifacts/skeletons/c8_2fc2edb8474e5733.s) | [mem](round2/verified_mem/c8_2fc2edb8474e5733.s) | [out](round2/logs/c8_2fc2edb8474e5733_judge.log), [mem](round2/logs/c8_2fc2edb8474e5733_mem_judge.log) |
| [c8_308486b4944cbdf](round2/verified/c8_308486b4944cbdf.s) | [out](round2/artifacts/skeletons/c8_308486b4944cbdf.s) | [mem](round2/verified_mem/c8_308486b4944cbdf.s) | [out](round2/logs/c8_308486b4944cbdf_judge.log), [mem](round2/logs/c8_308486b4944cbdf_mem_judge.log) |
| [c8_30f500aaf2d3b42b](round2/verified/c8_30f500aaf2d3b42b.s) | [out](round2/artifacts/skeletons/c8_30f500aaf2d3b42b.s) | [mem](round2/verified_mem/c8_30f500aaf2d3b42b.s) | [out](round2/logs/c8_30f500aaf2d3b42b_judge.log), [mem](round2/logs/c8_30f500aaf2d3b42b_mem_judge.log) |
| [c8_3169712e775f63e7](round2/verified/c8_3169712e775f63e7.s) | [out](round2/artifacts/skeletons/c8_3169712e775f63e7.s) | [mem](round2/verified_mem/c8_3169712e775f63e7.s) | [out](round2/logs/c8_3169712e775f63e7_judge.log), [mem](round2/logs/c8_3169712e775f63e7_mem_judge.log) |
| [c8_336a411e8b85279](round2/verified/c8_336a411e8b85279.s) | [out](round2/artifacts/skeletons/c8_336a411e8b85279.s) | [mem](round2/verified_mem/c8_336a411e8b85279.s) | [out](round2/logs/c8_336a411e8b85279_judge.log), [mem](round2/logs/c8_336a411e8b85279_mem_judge.log) |
| [c8_33e730edcd75dbbf](round2/verified/c8_33e730edcd75dbbf.s) | [out](round2/artifacts/skeletons/c8_33e730edcd75dbbf.s) | [mem](round2/verified_mem/c8_33e730edcd75dbbf.s) | [out](round2/logs/c8_33e730edcd75dbbf_judge.log), [mem](round2/logs/c8_33e730edcd75dbbf_mem_judge.log) |
| [c8_33fd8cbe2fbbf34f](round2/verified/c8_33fd8cbe2fbbf34f.s) | [out](round2/artifacts/skeletons/c8_33fd8cbe2fbbf34f.s) | [mem](round2/verified_mem/c8_33fd8cbe2fbbf34f.s) | [out](round2/logs/c8_33fd8cbe2fbbf34f_judge.log), [mem](round2/logs/c8_33fd8cbe2fbbf34f_mem_judge.log) |
| [c8_34bda9f2efbb141b](round2/verified/c8_34bda9f2efbb141b.s) | [out](round2/artifacts/skeletons/c8_34bda9f2efbb141b.s) | [mem](round2/verified_mem/c8_34bda9f2efbb141b.s) | [out](round2/logs/c8_34bda9f2efbb141b_judge.log), [mem](round2/logs/c8_34bda9f2efbb141b_mem_judge.log) |
| [c8_35006f3bfb8deb1b](round2/verified/c8_35006f3bfb8deb1b.s) | [out](round2/artifacts/skeletons/c8_35006f3bfb8deb1b.s) | [mem](round2/verified_mem/c8_35006f3bfb8deb1b.s) | [out](round2/logs/c8_35006f3bfb8deb1b_judge.log), [mem](round2/logs/c8_35006f3bfb8deb1b_mem_judge.log) |
| [c8_3524001ad0523527](round2/verified/c8_3524001ad0523527.s) | [out](round2/artifacts/skeletons/c8_3524001ad0523527.s) | [mem](round2/verified_mem/c8_3524001ad0523527.s) | [out](round2/logs/c8_3524001ad0523527_judge.log), [mem](round2/logs/c8_3524001ad0523527_mem_judge.log) |
| [c8_3631163abf06d7af](round2/verified/c8_3631163abf06d7af.s) | [out](round2/artifacts/skeletons/c8_3631163abf06d7af.s) | [mem](round2/verified_mem/c8_3631163abf06d7af.s) | [out](round2/logs/c8_3631163abf06d7af_judge.log), [mem](round2/logs/c8_3631163abf06d7af_mem_judge.log) |
| [c8_36b2b7961244aaf3](round2/verified/c8_36b2b7961244aaf3.s) | [out](round2/artifacts/skeletons/c8_36b2b7961244aaf3.s) | [mem](round2/verified_mem/c8_36b2b7961244aaf3.s) | [out](round2/logs/c8_36b2b7961244aaf3_judge.log), [mem](round2/logs/c8_36b2b7961244aaf3_mem_judge.log) |
| [c8_36c3eb8e6d6769f](round2/verified/c8_36c3eb8e6d6769f.s) | [out](round2/artifacts/skeletons/c8_36c3eb8e6d6769f.s) | [mem](round2/verified_mem/c8_36c3eb8e6d6769f.s) | [out](round2/logs/c8_36c3eb8e6d6769f_judge.log), [mem](round2/logs/c8_36c3eb8e6d6769f_mem_judge.log) |
| [c8_36c68fd07f08ff](round2/verified/c8_36c68fd07f08ff.s) | [out](round2/artifacts/skeletons/c8_36c68fd07f08ff.s) | [mem](round2/verified_mem/c8_36c68fd07f08ff.s) | [out](round2/logs/c8_36c68fd07f08ff_judge.log), [mem](round2/logs/c8_36c68fd07f08ff_mem_judge.log) |
| [c8_36e5e6298381a683](round2/verified/c8_36e5e6298381a683.s) | [out](round2/artifacts/skeletons/c8_36e5e6298381a683.s) | [mem](round2/verified_mem/c8_36e5e6298381a683.s) | [out](round2/logs/c8_36e5e6298381a683_judge.log), [mem](round2/logs/c8_36e5e6298381a683_mem_judge.log) |
| [c8_397c742a631c1cdb](round2/verified/c8_397c742a631c1cdb.s) | [out](round2/artifacts/skeletons/c8_397c742a631c1cdb.s) | [mem](round2/verified_mem/c8_397c742a631c1cdb.s) | [out](round2/logs/c8_397c742a631c1cdb_judge.log), [mem](round2/logs/c8_397c742a631c1cdb_mem_judge.log) |
| [c8_399842c2f1576827](round2/verified/c8_399842c2f1576827.s) | [out](round2/artifacts/skeletons/c8_399842c2f1576827.s) | [mem](round2/verified_mem/c8_399842c2f1576827.s) | [out](round2/logs/c8_399842c2f1576827_judge.log), [mem](round2/logs/c8_399842c2f1576827_mem_judge.log) |
| [c8_39a6ceb5b893673](round2/verified/c8_39a6ceb5b893673.s) | [out](round2/artifacts/skeletons/c8_39a6ceb5b893673.s) | [mem](round2/verified_mem/c8_39a6ceb5b893673.s) | [out](round2/logs/c8_39a6ceb5b893673_judge.log), [mem](round2/logs/c8_39a6ceb5b893673_mem_judge.log) |
| [c8_39ca71836246603](round2/verified/c8_39ca71836246603.s) | [out](round2/artifacts/skeletons/c8_39ca71836246603.s) | [mem](round2/verified_mem/c8_39ca71836246603.s) | [out](round2/logs/c8_39ca71836246603_judge.log), [mem](round2/logs/c8_39ca71836246603_mem_judge.log) |
| [c8_3af92b135d8fbddb](round2/verified/c8_3af92b135d8fbddb.s) | [out](round2/artifacts/skeletons/c8_3af92b135d8fbddb.s) | [mem](round2/verified_mem/c8_3af92b135d8fbddb.s) | [out](round2/logs/c8_3af92b135d8fbddb_judge.log), [mem](round2/logs/c8_3af92b135d8fbddb_mem_judge.log) |
| [c8_3c8472e7eb77e88f](round2/verified/c8_3c8472e7eb77e88f.s) | [out](round2/artifacts/skeletons/c8_3c8472e7eb77e88f.s) | [mem](round2/verified_mem/c8_3c8472e7eb77e88f.s) | [out](round2/logs/c8_3c8472e7eb77e88f_judge.log), [mem](round2/logs/c8_3c8472e7eb77e88f_mem_judge.log) |
| [c8_3dab8eea3595c0cf](round2/verified/c8_3dab8eea3595c0cf.s) | [out](round2/artifacts/skeletons/c8_3dab8eea3595c0cf.s) | [mem](round2/verified_mem/c8_3dab8eea3595c0cf.s) | [out](round2/logs/c8_3dab8eea3595c0cf_judge.log), [mem](round2/logs/c8_3dab8eea3595c0cf_mem_judge.log) |
| [c8_3f3513bf9cd6caf3](round2/verified/c8_3f3513bf9cd6caf3.s) | [out](round2/artifacts/skeletons/c8_3f3513bf9cd6caf3.s) | [mem](round2/verified_mem/c8_3f3513bf9cd6caf3.s) | [out](round2/logs/c8_3f3513bf9cd6caf3_judge.log), [mem](round2/logs/c8_3f3513bf9cd6caf3_mem_judge.log) |
| [c8_3f8371a2666ae5c7](round2/verified/c8_3f8371a2666ae5c7.s) | [out](round2/artifacts/skeletons/c8_3f8371a2666ae5c7.s) | [mem](round2/verified_mem/c8_3f8371a2666ae5c7.s) | [out](round2/logs/c8_3f8371a2666ae5c7_judge.log), [mem](round2/logs/c8_3f8371a2666ae5c7_mem_judge.log) |
| [c8_3ff1974fb517ed2b](round2/verified/c8_3ff1974fb517ed2b.s) | [out](round2/artifacts/skeletons/c8_3ff1974fb517ed2b.s) | [mem](round2/verified_mem/c8_3ff1974fb517ed2b.s) | [out](round2/logs/c8_3ff1974fb517ed2b_judge.log), [mem](round2/logs/c8_3ff1974fb517ed2b_mem_judge.log) |
| [c8_4033c0cef9939583](round2/verified/c8_4033c0cef9939583.s) | [out](round2/artifacts/skeletons/c8_4033c0cef9939583.s) | [mem](round2/verified_mem/c8_4033c0cef9939583.s) | [out](round2/logs/c8_4033c0cef9939583_judge.log), [mem](round2/logs/c8_4033c0cef9939583_mem_judge.log) |
| [c8_4065e579161132f](round2/verified/c8_4065e579161132f.s) | [out](round2/artifacts/skeletons/c8_4065e579161132f.s) | [mem](round2/verified_mem/c8_4065e579161132f.s) | [out](round2/logs/c8_4065e579161132f_judge.log), [mem](round2/logs/c8_4065e579161132f_mem_judge.log) |
| [c8_40718fc8b65bfb](round2/verified/c8_40718fc8b65bfb.s) | [out](round2/artifacts/skeletons/c8_40718fc8b65bfb.s) | [mem](round2/verified_mem/c8_40718fc8b65bfb.s) | [out](round2/logs/c8_40718fc8b65bfb_judge.log), [mem](round2/logs/c8_40718fc8b65bfb_mem_judge.log) |
| [c8_43a93e06324c3bc3](round2/verified/c8_43a93e06324c3bc3.s) | [out](round2/artifacts/skeletons/c8_43a93e06324c3bc3.s) | [mem](round2/verified_mem/c8_43a93e06324c3bc3.s) | [out](round2/logs/c8_43a93e06324c3bc3_judge.log), [mem](round2/logs/c8_43a93e06324c3bc3_mem_judge.log) |
| [c8_43e28701f70f0cf](round2/verified/c8_43e28701f70f0cf.s) | [out](round2/artifacts/skeletons/c8_43e28701f70f0cf.s) | [mem](round2/verified_mem/c8_43e28701f70f0cf.s) | [out](round2/logs/c8_43e28701f70f0cf_judge.log), [mem](round2/logs/c8_43e28701f70f0cf_mem_judge.log) |
| [c8_4480f6c61beea14b](round2/verified/c8_4480f6c61beea14b.s) | [out](round2/artifacts/skeletons/c8_4480f6c61beea14b.s) | [mem](round2/verified_mem/c8_4480f6c61beea14b.s) | [out](round2/logs/c8_4480f6c61beea14b_judge.log), [mem](round2/logs/c8_4480f6c61beea14b_mem_judge.log) |
| [c8_44a89463151f5b8f](round2/verified/c8_44a89463151f5b8f.s) | [out](round2/artifacts/skeletons/c8_44a89463151f5b8f.s) | [mem](round2/verified_mem/c8_44a89463151f5b8f.s) | [out](round2/logs/c8_44a89463151f5b8f_judge.log), [mem](round2/logs/c8_44a89463151f5b8f_mem_judge.log) |
| [c8_45647ba89f2ce4ff](round2/verified/c8_45647ba89f2ce4ff.s) | [out](round2/artifacts/skeletons/c8_45647ba89f2ce4ff.s) | [mem](round2/verified_mem/c8_45647ba89f2ce4ff.s) | [out](round2/logs/c8_45647ba89f2ce4ff_judge.log), [mem](round2/logs/c8_45647ba89f2ce4ff_mem_judge.log) |
| [c8_4568144e518d6cff](round2/verified/c8_4568144e518d6cff.s) | [out](round2/artifacts/skeletons/c8_4568144e518d6cff.s) | [mem](round2/verified_mem/c8_4568144e518d6cff.s) | [out](round2/logs/c8_4568144e518d6cff_judge.log), [mem](round2/logs/c8_4568144e518d6cff_mem_judge.log) |
| [c8_490153be8f1298b](round2/verified/c8_490153be8f1298b.s) | [out](round2/artifacts/skeletons/c8_490153be8f1298b.s) | [mem](round2/verified_mem/c8_490153be8f1298b.s) | [out](round2/logs/c8_490153be8f1298b_judge.log), [mem](round2/logs/c8_490153be8f1298b_mem_judge.log) |
| [c8_4a225b46e63e8737](round2/verified/c8_4a225b46e63e8737.s) | [out](round2/artifacts/skeletons/c8_4a225b46e63e8737.s) | [mem](round2/verified_mem/c8_4a225b46e63e8737.s) | [out](round2/logs/c8_4a225b46e63e8737_judge.log), [mem](round2/logs/c8_4a225b46e63e8737_mem_judge.log) |
| [c8_4c82686d8d30d33](round2/verified/c8_4c82686d8d30d33.s) | [out](round2/artifacts/skeletons/c8_4c82686d8d30d33.s) | [mem](round2/verified_mem/c8_4c82686d8d30d33.s) | [out](round2/logs/c8_4c82686d8d30d33_judge.log), [mem](round2/logs/c8_4c82686d8d30d33_mem_judge.log) |
| [c8_504956aa3c140ea3](round2/verified/c8_504956aa3c140ea3.s) | [out](round2/artifacts/skeletons/c8_504956aa3c140ea3.s) | [mem](round2/verified_mem/c8_504956aa3c140ea3.s) | [out](round2/logs/c8_504956aa3c140ea3_judge.log), [mem](round2/logs/c8_504956aa3c140ea3_mem_judge.log) |
| [c8_54b8fd94e189948f](round2/verified/c8_54b8fd94e189948f.s) | [out](round2/artifacts/skeletons/c8_54b8fd94e189948f.s) | [mem](round2/verified_mem/c8_54b8fd94e189948f.s) | [out](round2/logs/c8_54b8fd94e189948f_judge.log), [mem](round2/logs/c8_54b8fd94e189948f_mem_judge.log) |
| [c8_59bb347d4b01a577](round2/verified/c8_59bb347d4b01a577.s) | [out](round2/artifacts/skeletons/c8_59bb347d4b01a577.s) | [mem](round2/verified_mem/c8_59bb347d4b01a577.s) | [out](round2/logs/c8_59bb347d4b01a577_judge.log), [mem](round2/logs/c8_59bb347d4b01a577_mem_judge.log) |
| [c8_5bdf24a222d2b63](round2/verified/c8_5bdf24a222d2b63.s) | [out](round2/artifacts/skeletons/c8_5bdf24a222d2b63.s) | [mem](round2/verified_mem/c8_5bdf24a222d2b63.s) | [out](round2/logs/c8_5bdf24a222d2b63_judge.log), [mem](round2/logs/c8_5bdf24a222d2b63_mem_judge.log) |
| [c8_63f1e94b2830099](round2/verified/c8_63f1e94b2830099.s) | [out](round2/artifacts/skeletons/c8_63f1e94b2830099.s) | [mem](round2/verified_mem/c8_63f1e94b2830099.s) | [out](round2/logs/c8_63f1e94b2830099_judge.log), [mem](round2/logs/c8_63f1e94b2830099_mem_judge.log) |
| [c8_6580b4e99d6036b](round2/verified/c8_6580b4e99d6036b.s) | [out](round2/artifacts/skeletons/c8_6580b4e99d6036b.s) | [mem](round2/verified_mem/c8_6580b4e99d6036b.s) | [out](round2/logs/c8_6580b4e99d6036b_judge.log), [mem](round2/logs/c8_6580b4e99d6036b_mem_judge.log) |
| [c8_66303d2fe517211](round2/verified/c8_66303d2fe517211.s) | [out](round2/artifacts/skeletons/c8_66303d2fe517211.s) | [mem](round2/verified_mem/c8_66303d2fe517211.s) | [out](round2/logs/c8_66303d2fe517211_judge.log), [mem](round2/logs/c8_66303d2fe517211_mem_judge.log) |
| [c8_66ea7778158faf](round2/verified/c8_66ea7778158faf.s) | [out](round2/artifacts/skeletons/c8_66ea7778158faf.s) | [mem](round2/verified_mem/c8_66ea7778158faf.s) | [out](round2/logs/c8_66ea7778158faf_judge.log), [mem](round2/logs/c8_66ea7778158faf_mem_judge.log) |
| [c8_6e38bedf286f04f](round2/verified/c8_6e38bedf286f04f.s) | [out](round2/artifacts/skeletons/c8_6e38bedf286f04f.s) | [mem](round2/verified_mem/c8_6e38bedf286f04f.s) | [out](round2/logs/c8_6e38bedf286f04f_judge.log), [mem](round2/logs/c8_6e38bedf286f04f_mem_judge.log) |
| [c8_70dac6520f0a05af](round2/verified/c8_70dac6520f0a05af.s) | [out](round2/artifacts/skeletons/c8_70dac6520f0a05af.s) | [mem](round2/verified_mem/c8_70dac6520f0a05af.s) | [out](round2/logs/c8_70dac6520f0a05af_judge.log), [mem](round2/logs/c8_70dac6520f0a05af_mem_judge.log) |
| [c8_784551952e246563](round2/verified/c8_784551952e246563.s) | [out](round2/artifacts/skeletons/c8_784551952e246563.s) | [mem](round2/verified_mem/c8_784551952e246563.s) | [out](round2/logs/c8_784551952e246563_judge.log), [mem](round2/logs/c8_784551952e246563_mem_judge.log) |
| [c8_7c7f65877f171ab](round2/verified/c8_7c7f65877f171ab.s) | [out](round2/artifacts/skeletons/c8_7c7f65877f171ab.s) | [mem](round2/verified_mem/c8_7c7f65877f171ab.s) | [out](round2/logs/c8_7c7f65877f171ab_judge.log), [mem](round2/logs/c8_7c7f65877f171ab_mem_judge.log) |
| [c8_7f146a90e5e9bcf](round2/verified/c8_7f146a90e5e9bcf.s) | [out](round2/artifacts/skeletons/c8_7f146a90e5e9bcf.s) | [mem](round2/verified_mem/c8_7f146a90e5e9bcf.s) | [out](round2/logs/c8_7f146a90e5e9bcf_judge.log), [mem](round2/logs/c8_7f146a90e5e9bcf_mem_judge.log) |
| [c8_8034dffd5d8c457](round2/verified/c8_8034dffd5d8c457.s) | [out](round2/artifacts/skeletons/c8_8034dffd5d8c457.s) | [mem](round2/verified_mem/c8_8034dffd5d8c457.s) | [out](round2/logs/c8_8034dffd5d8c457_judge.log), [mem](round2/logs/c8_8034dffd5d8c457_mem_judge.log) |
| [c8_81ed52dfbe00faf](round2/verified/c8_81ed52dfbe00faf.s) | [out](round2/artifacts/skeletons/c8_81ed52dfbe00faf.s) | [mem](round2/verified_mem/c8_81ed52dfbe00faf.s) | [out](round2/logs/c8_81ed52dfbe00faf_judge.log), [mem](round2/logs/c8_81ed52dfbe00faf_mem_judge.log) |
| [c8_845547c9459fdb7b](round2/verified/c8_845547c9459fdb7b.s) | [out](round2/artifacts/skeletons/c8_845547c9459fdb7b.s) | [mem](round2/verified_mem/c8_845547c9459fdb7b.s) | [out](round2/logs/c8_845547c9459fdb7b_judge.log), [mem](round2/logs/c8_845547c9459fdb7b_mem_judge.log) |
| [c8_85b4809f0fae497](round2/verified/c8_85b4809f0fae497.s) | [out](round2/artifacts/skeletons/c8_85b4809f0fae497.s) | [mem](round2/verified_mem/c8_85b4809f0fae497.s) | [out](round2/logs/c8_85b4809f0fae497_judge.log), [mem](round2/logs/c8_85b4809f0fae497_mem_judge.log) |
| [c8_8a1b7bc87d5e633](round2/verified/c8_8a1b7bc87d5e633.s) | [out](round2/artifacts/skeletons/c8_8a1b7bc87d5e633.s) | [mem](round2/verified_mem/c8_8a1b7bc87d5e633.s) | [out](round2/logs/c8_8a1b7bc87d5e633_judge.log), [mem](round2/logs/c8_8a1b7bc87d5e633_mem_judge.log) |
| [c8_8d0dd0ee89a970f](round2/verified/c8_8d0dd0ee89a970f.s) | [out](round2/artifacts/skeletons/c8_8d0dd0ee89a970f.s) | [mem](round2/verified_mem/c8_8d0dd0ee89a970f.s) | [out](round2/logs/c8_8d0dd0ee89a970f_judge.log), [mem](round2/logs/c8_8d0dd0ee89a970f_mem_judge.log) |
| [c8_8fce06357f6d127](round2/verified/c8_8fce06357f6d127.s) | [out](round2/verified/c8_8fce06357f6d127.s) | [mem](round2/verified_mem/c8_8fce06357f6d127.s) | [out](round2/logs/c8_8fce06357f6d127_judge.log), [mem](round2/logs/c8_8fce06357f6d127_mem_judge.log) |
| [c8_9356fd7b120de37](round2/verified/c8_9356fd7b120de37.s) | [out](round2/artifacts/skeletons/c8_9356fd7b120de37.s) | [mem](round2/verified_mem/c8_9356fd7b120de37.s) | [out](round2/logs/c8_9356fd7b120de37_judge.log), [mem](round2/logs/c8_9356fd7b120de37_mem_judge.log) |
| [c8_9755d36ddedc6b7](round2/verified/c8_9755d36ddedc6b7.s) | [out](round2/artifacts/skeletons/c8_9755d36ddedc6b7.s) | [mem](round2/verified_mem/c8_9755d36ddedc6b7.s) | [out](round2/logs/c8_9755d36ddedc6b7_judge.log), [mem](round2/logs/c8_9755d36ddedc6b7_mem_judge.log) |
| [c8_978e4716e9a7b55](round2/verified/c8_978e4716e9a7b55.s) | [out](round2/artifacts/skeletons/c8_978e4716e9a7b55.s) | [mem](round2/verified_mem/c8_978e4716e9a7b55.s) | [out](round2/logs/c8_978e4716e9a7b55_judge.log), [mem](round2/logs/c8_978e4716e9a7b55_mem_judge.log) |
| [c8_9e1a0f74131d81f](round2/verified/c8_9e1a0f74131d81f.s) | [out](round2/artifacts/skeletons/c8_9e1a0f74131d81f.s) | [mem](round2/verified_mem/c8_9e1a0f74131d81f.s) | [out](round2/logs/c8_9e1a0f74131d81f_judge.log), [mem](round2/logs/c8_9e1a0f74131d81f_mem_judge.log) |
| [c8_a333f1fdc61ed4b](round2/verified/c8_a333f1fdc61ed4b.s) | [out](round2/artifacts/skeletons/c8_a333f1fdc61ed4b.s) | [mem](round2/verified_mem/c8_a333f1fdc61ed4b.s) | [out](round2/logs/c8_a333f1fdc61ed4b_judge.log), [mem](round2/logs/c8_a333f1fdc61ed4b_mem_judge.log) |
| [c8_a7b174f83a0f43b](round2/verified/c8_a7b174f83a0f43b.s) | [out](round2/artifacts/skeletons/c8_a7b174f83a0f43b.s) | [mem](round2/verified_mem/c8_a7b174f83a0f43b.s) | [out](round2/logs/c8_a7b174f83a0f43b_judge.log), [mem](round2/logs/c8_a7b174f83a0f43b_mem_judge.log) |
| [c8_adb02b770a6193](round2/verified/c8_adb02b770a6193.s) | [out](round2/artifacts/skeletons/c8_adb02b770a6193.s) | [mem](round2/verified_mem/c8_adb02b770a6193.s) | [out](round2/logs/c8_adb02b770a6193_judge.log), [mem](round2/logs/c8_adb02b770a6193_mem_judge.log) |
| [c8_b1dc9333293688f](round2/verified/c8_b1dc9333293688f.s) | [out](round2/artifacts/skeletons/c8_b1dc9333293688f.s) | [mem](round2/verified_mem/c8_b1dc9333293688f.s) | [out](round2/logs/c8_b1dc9333293688f_judge.log), [mem](round2/logs/c8_b1dc9333293688f_mem_judge.log) |
| [c8_bcbcb19411aea31](round2/verified/c8_bcbcb19411aea31.s) | [out](round2/artifacts/skeletons/c8_bcbcb19411aea31.s) | [mem](round2/verified_mem/c8_bcbcb19411aea31.s) | [out](round2/logs/c8_bcbcb19411aea31_judge.log), [mem](round2/logs/c8_bcbcb19411aea31_mem_judge.log) |
| [c8_c060accd56c0c2f](round2/verified/c8_c060accd56c0c2f.s) | [out](round2/artifacts/skeletons/c8_c060accd56c0c2f.s) | [mem](round2/verified_mem/c8_c060accd56c0c2f.s) | [out](round2/logs/c8_c060accd56c0c2f_judge.log), [mem](round2/logs/c8_c060accd56c0c2f_mem_judge.log) |
| [c8_c3208d05a5329e7](round2/verified/c8_c3208d05a5329e7.s) | [out](round2/artifacts/skeletons/c8_c3208d05a5329e7.s) | [mem](round2/verified_mem/c8_c3208d05a5329e7.s) | [out](round2/logs/c8_c3208d05a5329e7_judge.log), [mem](round2/logs/c8_c3208d05a5329e7_mem_judge.log) |
| [c8_cd249ed48c06697](round2/verified/c8_cd249ed48c06697.s) | [out](round2/artifacts/skeletons/c8_cd249ed48c06697.s) | [mem](round2/verified_mem/c8_cd249ed48c06697.s) | [out](round2/logs/c8_cd249ed48c06697_judge.log), [mem](round2/logs/c8_cd249ed48c06697_mem_judge.log) |
| [c8_cd2c6a654c268eb](round2/verified/c8_cd2c6a654c268eb.s) | [out](round2/artifacts/skeletons/c8_cd2c6a654c268eb.s) | [mem](round2/verified_mem/c8_cd2c6a654c268eb.s) | [out](round2/logs/c8_cd2c6a654c268eb_judge.log), [mem](round2/logs/c8_cd2c6a654c268eb_mem_judge.log) |
| [c8_ce431b9f3a92ab9](round2/verified/c8_ce431b9f3a92ab9.s) | [out](round2/artifacts/skeletons/c8_ce431b9f3a92ab9.s) | [mem](round2/verified_mem/c8_ce431b9f3a92ab9.s) | [out](round2/logs/c8_ce431b9f3a92ab9_judge.log), [mem](round2/logs/c8_ce431b9f3a92ab9_mem_judge.log) |
| [c8_d7ea38d35580a9b](round2/verified/c8_d7ea38d35580a9b.s) | [out](round2/artifacts/skeletons/c8_d7ea38d35580a9b.s) | [mem](round2/verified_mem/c8_d7ea38d35580a9b.s) | [out](round2/logs/c8_d7ea38d35580a9b_judge.log), [mem](round2/logs/c8_d7ea38d35580a9b_mem_judge.log) |
| [c8_d971bb526287b89](round2/verified/c8_d971bb526287b89.s) | [out](round2/artifacts/skeletons/c8_d971bb526287b89.s) | [mem](round2/verified_mem/c8_d971bb526287b89.s) | [out](round2/logs/c8_d971bb526287b89_judge.log), [mem](round2/logs/c8_d971bb526287b89_mem_judge.log) |
| [c8_db8ff5154396dd7](round2/verified/c8_db8ff5154396dd7.s) | [out](round2/artifacts/skeletons/c8_db8ff5154396dd7.s) | [mem](round2/verified_mem/c8_db8ff5154396dd7.s) | [out](round2/logs/c8_db8ff5154396dd7_judge.log), [mem](round2/logs/c8_db8ff5154396dd7_mem_judge.log) |
| [c8_dbbbb77809455d7](round2/verified/c8_dbbbb77809455d7.s) | [out](round2/artifacts/skeletons/c8_dbbbb77809455d7.s) | [mem](round2/verified_mem/c8_dbbbb77809455d7.s) | [out](round2/logs/c8_dbbbb77809455d7_judge.log), [mem](round2/logs/c8_dbbbb77809455d7_mem_judge.log) |
| [c8_e1c0ebef11c2d07](round2/verified/c8_e1c0ebef11c2d07.s) | [out](round2/artifacts/skeletons/c8_e1c0ebef11c2d07.s) | [mem](round2/verified_mem/c8_e1c0ebef11c2d07.s) | [out](round2/logs/c8_e1c0ebef11c2d07_judge.log), [mem](round2/logs/c8_e1c0ebef11c2d07_mem_judge.log) |
| [c8_e32bfb331db9cf7](round2/verified/c8_e32bfb331db9cf7.s) | [out](round2/artifacts/skeletons/c8_e32bfb331db9cf7.s) | [mem](round2/verified_mem/c8_e32bfb331db9cf7.s) | [out](round2/logs/c8_e32bfb331db9cf7_judge.log), [mem](round2/logs/c8_e32bfb331db9cf7_mem_judge.log) |
| [c8_ee55e6ba214fb31](round2/verified/c8_ee55e6ba214fb31.s) | [out](round2/artifacts/skeletons/c8_ee55e6ba214fb31.s) | [mem](round2/verified_mem/c8_ee55e6ba214fb31.s) | [out](round2/logs/c8_ee55e6ba214fb31_judge.log), [mem](round2/logs/c8_ee55e6ba214fb31_mem_judge.log) |
| [c8_efa0c71440608fb](round2/verified/c8_efa0c71440608fb.s) | [out](round2/artifacts/skeletons/c8_efa0c71440608fb.s) | [mem](round2/verified_mem/c8_efa0c71440608fb.s) | [out](round2/logs/c8_efa0c71440608fb_judge.log), [mem](round2/logs/c8_efa0c71440608fb_mem_judge.log) |
| [c8_f76ab7383f3162f](round2/verified/c8_f76ab7383f3162f.s) | [out](round2/artifacts/skeletons/c8_f76ab7383f3162f.s) | [mem](round2/verified_mem/c8_f76ab7383f3162f.s) | [out](round2/logs/c8_f76ab7383f3162f_judge.log), [mem](round2/logs/c8_f76ab7383f3162f_mem_judge.log) |
| [c8_f861da3879904ef](round2/verified/c8_f861da3879904ef.s) | [out](round2/artifacts/skeletons/c8_f861da3879904ef.s) | [mem](round2/verified_mem/c8_f861da3879904ef.s) | [out](round2/logs/c8_f861da3879904ef_judge.log), [mem](round2/logs/c8_f861da3879904ef_mem_judge.log) |
| [c8_f8dffa39345ffaf](round2/verified/c8_f8dffa39345ffaf.s) | [out](round2/artifacts/skeletons/c8_f8dffa39345ffaf.s) | [mem](round2/verified_mem/c8_f8dffa39345ffaf.s) | [out](round2/logs/c8_f8dffa39345ffaf_judge.log), [mem](round2/logs/c8_f8dffa39345ffaf_mem_judge.log) |
| [c8_ffb1da4812016b](round2/verified/c8_ffb1da4812016b.s) | [out](round2/artifacts/skeletons/c8_ffb1da4812016b.s) | [mem](round2/verified_mem/c8_ffb1da4812016b.s) | [out](round2/logs/c8_ffb1da4812016b_judge.log), [mem](round2/logs/c8_ffb1da4812016b_mem_judge.log) |

The first repair pattern changes one operand in each of its two comparisons. Its conditional-move replacement can also be mov, and it excludes equal source and destination for that replacement. The second repair pattern changes both operands of one comparison. It preserves the two changed writes' conditions and destinations. The 32 filter entries comprise 24 strict orders and eight weak-order entries; entries can overlap. Search parameters are recorded in [round2/artifacts/search_parameters.json](round2/artifacts/search_parameters.json).

## Round 3 — near-miss repair and cores with no mov

This round starts from the 14-case failure and the 143 round-2 representatives. It does not rerun fixed-structure routing. All jobs use nice level 19. At most two jobs run at once. Each bounded job has an address-space limit of 2,800 MiB. Writes remain inside w6.

The new repair driver is [round3/src/satrep.py](round3/src/satrep.py). It uses SAT, then adds weak orders that reject failing output snapshots. Comparison operands can change. Write sources and conditions can change. The full mode also permits changes to destinations and instruction classes. Every solver candidate still needs the strict judge. The encoder uses a relaxed initial scratch state. Its output constraints allow free output snapshots.

The fixed k=32 control completed in 0.62 seconds. The strict out judge reported `PASS round3/candidates/control32.s [relaxed+strict] n=5 L=32 R=9 iset=I1 model=out`. This is a control result, not an improvement.

The first near-miss query returned UNSAT in 13.48 seconds on 13 encoded weak orders. It permits at most four changed instructions. It keeps the eight comparison slots and the write destinations. It permits free comparison operands and permits each write to be mov or any supported conditional move. The register bound is the original eight registers. The result applies only to these constraints. Log: [round3/logs/near14_typed4.log](round3/logs/near14_typed4.log).

The first saved-program inventory reached its 90-second wall limit. It found five distinct cores with no mov before it stopped. This inventory is incomplete. A second inventory records partial progress. The deletion and repair checks are in progress.

The completed inventory scanned 12,669 assembly files. It found seven k=32 files with no core mov. Input and scratch renaming reduced them to six instruction sequences. All six passed the strict out and memory judges. The hashes and PASS logs are in [round3/artifacts/mined_judge_ledger.json](round3/artifacts/mined_judge_ledger.json). Their comparison operands map to three known fingerprints. No new comparison structure is claimed.

All 144 single-cmov deletions failed in the independent evaluator. The best deletion fails 27 weak orders and has an output-error sum of 45. The strict judge rejects it. The near-miss scan tested 11,736 single changes and 65,593,152 two-instruction changes. The latter scan had 1,294 candidates that passed its 32-entry filter. None passed the full conservative check. These are bounded search observations.

Four of the six no-mov deletion-repair queries returned UNSAT at edit bound five, including the deletion. Two reached their 90-second limits. The fresh-register near-miss query also returned UNSAT. It uses nine registers and permits five changed instructions with fixed comparison positions and write destinations. Broader and deeper repair queries remain in progress. All limits are unknown, not negative results.

## Round 3 completion

No strict PASS with k <= 31 was found. The best correct core remains k=32. Its memory version has 42 instructions.

The saved-program scan read 12,669 assembly files. It found seven files with k=32 and no core mov. Input and scratch renaming reduced them to six instruction sequences. These counts concern saved assembly files. The scan did not read the large raw text collections. All six retained sequences passed the strict out and memory judges.

The comparison analyzer maps the six sequences to three known fingerprints: 215cbe6f0d1c7837, 23f00ca3e09530d3, and de052e5a1c75d83. The last two fingerprints were already in the round-1 collection. Their retained round-1 representatives used mov. The mined sequences show implementations with no mov for those structures. No new comparison structure is claimed. Log: [round3/logs/analyze_nomov.log](round3/logs/analyze_nomov.log).

Deleting each of the 24 conditional moves in each retained sequence gave 144 failing k=31 programs in the independent evaluator. The best deletion fails 27 weak orders and has an output-error sum of 45. The strict judge also rejects that deletion. Log: [round3/logs/nomov_4c02da04dce39b74_del27_out_judge.log](round3/logs/nomov_4c02da04dce39b74_del27_out_judge.log).

| Core with no mov | Deletions | Best output-error sum | Failed weak orders for that deletion |
|---|---:|---:|---:|
| [nomov_38bc4652d19a9d1c.s](round3/candidates/nomov_38bc4652d19a9d1c.s) | 24 | 126 | 126 |
| [nomov_68d29028b7fb54c4.s](round3/candidates/nomov_68d29028b7fb54c4.s) | 24 | 111 | 111 |
| [nomov_9f7a6fc77b297ff9.s](round3/candidates/nomov_9f7a6fc77b297ff9.s) | 24 | 129 | 129 |
| [nomov_4c02da04dce39b74.s](round3/candidates/nomov_4c02da04dce39b74.s) | 24 | 45 | 27 |
| [nomov_7e5d1b2681c79ac1.s](round3/candidates/nomov_7e5d1b2681c79ac1.s) | 24 | 126 | 126 |
| [nomov_cb7f7a699c4c9842.s](round3/candidates/nomov_cb7f7a699c4c9842.s) | 24 | 126 | 126 |

The near-miss scan tested 11,736 single-instruction replacements. It retained seven operand-column fingerprints with output-error sums at most 60. A fingerprint is a 64-bit search identifier. It is not a proof of structural equivalence. The best still fails 14 weak orders. The two-instruction scan tested 65,593,152 replacements. Of these, 1,294 passed the 32-entry case filter. None passed all 541 weak orders in the conservative evaluator. The smallest output-error sum remained 18. Logs: [one change](round3/logs/near14_scoreone.log), [two changes](round3/logs/near14_two.log).

The replacement alphabet contains mov, cmp, and all four supported conditional moves. It contains every distinct source/destination pair over the used registers and one fresh scratch register. Comparison counts stay between seven and eight. The two-change scan changes two different instruction positions. These are bounded search observations. The conservative evaluator can reject a valid program when it loses a relation between scratch values.

The rank-value encoder reduced the first six-change query from 29,648 variables and 202,297 clauses to 7,086 variables and 61,580 clauses. The two encoders agreed on 12 fixed-program controls. Four symbolic controls also matched their concrete executions on their 11 encoded cases. The fixed k=32 control passed the strict judge. The fixed 14-case failure returned UNSAT. These checks validate tested behavior. They do not establish an encoder correctness proof.

A separate analysis identifies the near miss's failure path. Let a and b be the sorted values from input cells P0 and P4. Let c, d, and e be the sorted values from input cells P1, P2, and P3. The independent check finds exactly these failures: a < c, b > e, and original P2 > c. Eight failing orders have distinct inputs. Six have ties. The merge needs a copy of c in P2 on this path. The prefix instead retains original P2. The case list is [round3/artifacts/near14_analysis.json](round3/artifacts/near14_analysis.json).

This analysis led to a new prefix query. It seeks an 11-instruction triple sort with two minimum copies, one middle value, and one maximum value. The first query keeps the original three comparison positions and result registers. It returned UNSAT in 3.92 seconds with five registers. The broader queries allow all instruction classes and result registers. They permit three or four comparisons. All 13 weak orders of three inputs are encoded. The 12-instruction control returned SAT. These results apply only to the stated register bounds and encoding.


| Solver job | Result | Wall seconds | Log |
|---|---|---:|---|
| control32 | CANDIDATE | 0.62 | [log](round3/logs/control32.log) |
| near14_free_dest4 | UNKNOWN (wall limit) | 150.02 | [log](round3/logs/near14_free_dest4.log) |
| near14_full4 | UNKNOWN (wall limit) | 240.02 | [log](round3/logs/near14_full4.log) |
| near14_full5 | UNKNOWN (wall limit) | 180.02 | [log](round3/logs/near14_full5.log) |
| near14_typed4 | UNSAT | 13.61 | [log](round3/logs/near14_typed4.log) |
| near14_typed6 | UNKNOWN (wall limit) | 180.02 | [log](round3/logs/near14_typed6.log) |
| near14_typed8 | UNKNOWN (wall limit) | 150.02 | [log](round3/logs/near14_typed8.log) |
| neighbour1_rank6 | UNKNOWN (wall limit) | 90.01 | [log](round3/logs/neighbour1_rank6.log) |
| neighbour2_rank6 | UNKNOWN (wall limit) | 90.03 | [log](round3/logs/neighbour2_rank6.log) |
| neighbour3_rank6 | UNKNOWN (wall limit) | 90.03 | [log](round3/logs/neighbour3_rank6.log) |
| neighbour4_rank6 | UNKNOWN (wall limit) | 90.01 | [log](round3/logs/neighbour4_rank6.log) |
| neighbour5_rank6 | UNKNOWN (wall limit) | 90.02 | [log](round3/logs/neighbour5_rank6.log) |
| neighbour6_rank6 | UNKNOWN (wall limit) | 90.01 | [log](round3/logs/neighbour6_rank6.log) |
| rank_control32 | CANDIDATE | 0.14 | [log](round3/logs/rank_control32.log) |
| rank_control_near31 | UNSAT | 0.13 | [log](round3/logs/rank_control_near31.log) |
| rank_del27_full5 | UNKNOWN (wall limit) | 120.02 | [log](round3/logs/rank_del27_full5.log) |
| rank_del27_typed7 | UNKNOWN (wall limit) | 150.01 | [log](round3/logs/rank_del27_typed7.log) |
| rank_fixedout_c9full5 | UNKNOWN (wall limit) | 90.02 | [log](round3/logs/rank_fixedout_c9full5.log) |
| rank_fixedout_free6 | UNKNOWN (wall limit) | 60.02 | [log](round3/logs/rank_fixedout_free6.log) |
| rank_fixedout_full4 | UNKNOWN (wall limit) | 60.03 | [log](round3/logs/rank_fixedout_full4.log) |
| rank_near14_fresh5 | UNSAT | 63.80 | [log](round3/logs/rank_near14_fresh5.log) |
| rank_near14_full4 | UNKNOWN (wall limit) | 150.02 | [log](round3/logs/rank_near14_full4.log) |
| rank_near14_merge16 | UNKNOWN (wall limit) | 150.01 | [log](round3/logs/rank_near14_merge16.log) |
| rank_near14_typed6 | UNKNOWN (wall limit) | 150.01 | [log](round3/logs/rank_near14_typed6.log) |
| triple_control12 | CONTROL_SAT | 0.10 | [log](round3/logs/triple_control12.log) |
| triple_copy_R5 | UNSAT | 3.92 | [log](round3/logs/triple_copy_R5.log) |
| triple_free_R5 | UNKNOWN (wall limit) | 180.01 | [log](round3/logs/triple_free_R5.log) |
| triple_free_R6 | UNKNOWN (wall limit) | 180.01 | [log](round3/logs/triple_free_R6.log) |
| zero0_sources5 | UNSAT | 80.27 | [log](round3/logs/zero0_sources5.log) |
| zero100_sources5 | UNKNOWN (wall limit) | 90.03 | [log](round3/logs/zero100_sources5.log) |
| zero125_sources5 | UNSAT | 89.69 | [log](round3/logs/zero125_sources5.log) |
| zero25_sources5 | UNSAT | 53.41 | [log](round3/logs/zero25_sources5.log) |
| zero50_sources5 | UNKNOWN (wall limit) | 90.02 | [log](round3/logs/zero50_sources5.log) |
| zero75_sources5 | UNSAT | 59.17 | [log](round3/logs/zero75_sources5.log) |

UNSAT applies only to the stated register bound, instruction positions, edit bound, and encoded initial state. The source queries keep write destinations fixed. Their one internal no-op chooses the deleted instruction. The edit count includes that deletion. The typed queries keep comparison positions fixed. The full queries can also change instruction classes and destinations. Queries marked UNKNOWN reached their wall limit. They give no exclusion.

The rank queries also test a fresh scratch register, a free 16-instruction suffix, and repairs of the 27-order deletion failure. Most repair queries require a syntactic change to at least one comparison. The 16-instruction suffix keeps the first 15 instructions fixed and has no edit bound. Comparison positions remain fixed in that query. Three further queries keep the output positions fixed. One of those queries permits up to nine comparisons.

All bounded jobs used nice level 19. At most two search or compiler jobs ran together. A 0.20-second analysis check briefly overlapped two searches. The process tree remained pinned to two cores. Each bounded job had an address-space limit of 2,800 MiB. No fixed-structure routing was rerun. The full job arguments and limits are in [round3/artifacts/final_summary.json](round3/artifacts/final_summary.json).


The final stochastic run scores the union of failed weak orders. It breaks equal output-error counts by overlap between failing cases. It permits seven to nine comparisons. It uses all 541 weak orders, and its register bound includes one fresh scratch register. Its completed counters are `SUMMARY iterations=107843584 accepted=12868835 correct_visits=0 best=999 best_error=18 cpu=180.003 newstructures=0 resets=10 archive=1 samples=0`. Log: [round3/logs/union31.log](round3/logs/union31.log). This is a search observation, not an exclusion.

Every new strict PASS file and byte-identical retained copy:

| Tested out file | Retained out copy | Strict memory file | Judge logs |
|---|---|---|---|
| [out](round3/candidates/nomov_38bc4652d19a9d1c.s) | [nomov_38bc4652d19a9d1c.s](round3/verified/nomov_38bc4652d19a9d1c.s) | [mem](round3/verified_mem/nomov_38bc4652d19a9d1c.s) | [out](round3/logs/nomov_38bc4652d19a9d1c_out_judge.log), [mem](round3/logs/nomov_38bc4652d19a9d1c_mem_judge.log) |
| [out](round3/candidates/nomov_68d29028b7fb54c4.s) | [nomov_68d29028b7fb54c4.s](round3/verified/nomov_68d29028b7fb54c4.s) | [mem](round3/verified_mem/nomov_68d29028b7fb54c4.s) | [out](round3/logs/nomov_68d29028b7fb54c4_out_judge.log), [mem](round3/logs/nomov_68d29028b7fb54c4_mem_judge.log) |
| [out](round3/candidates/nomov_9f7a6fc77b297ff9.s) | [nomov_9f7a6fc77b297ff9.s](round3/verified/nomov_9f7a6fc77b297ff9.s) | [mem](round3/verified_mem/nomov_9f7a6fc77b297ff9.s) | [out](round3/logs/nomov_9f7a6fc77b297ff9_out_judge.log), [mem](round3/logs/nomov_9f7a6fc77b297ff9_mem_judge.log) |
| [out](round3/candidates/nomov_4c02da04dce39b74.s) | [nomov_4c02da04dce39b74.s](round3/verified/nomov_4c02da04dce39b74.s) | [mem](round3/verified_mem/nomov_4c02da04dce39b74.s) | [out](round3/logs/nomov_4c02da04dce39b74_out_judge.log), [mem](round3/logs/nomov_4c02da04dce39b74_mem_judge.log) |
| [out](round3/candidates/nomov_7e5d1b2681c79ac1.s) | [nomov_7e5d1b2681c79ac1.s](round3/verified/nomov_7e5d1b2681c79ac1.s) | [mem](round3/verified_mem/nomov_7e5d1b2681c79ac1.s) | [out](round3/logs/nomov_7e5d1b2681c79ac1_out_judge.log), [mem](round3/logs/nomov_7e5d1b2681c79ac1_mem_judge.log) |
| [out](round3/candidates/nomov_cb7f7a699c4c9842.s) | [nomov_cb7f7a699c4c9842.s](round3/verified/nomov_cb7f7a699c4c9842.s) | [mem](round3/verified_mem/nomov_cb7f7a699c4c9842.s) | [out](round3/logs/nomov_cb7f7a699c4c9842_out_judge.log), [mem](round3/logs/nomov_cb7f7a699c4c9842_mem_judge.log) |

The two additional strict out controls are [control32.s](round3/candidates/control32.s) ([judge log](round3/logs/control32_judge.log)) and [rank_control32.s](round3/candidates/rank_control32.s) ([judge log](round3/logs/rank_control32_judge.log)). Each has k=32. None of the PASS files meets the requested length.

The duplicate-minimum repair also passed at k=32. It inserts `mov P2, P1` before the merge. The [out control](round3/verified/duplicate_min_control32.s) and [memory control](round3/verified_mem/duplicate_min_control32.s) passed their strict judges. Logs: [out](round3/logs/duplicate_min_control32_out_judge.log), [mem](round3/logs/duplicate_min_control32_mem_judge.log). This confirms the tested repair with one extra instruction. It does not meet the target.

## Round 4 — delete two writes, add one write

The inventory contains 168 verified k=32 seeds: 18 round-1 representatives, 143 round-2 representatives, six round-3 cores with no mov, and the duplicate-minimum repair. This includes the requested collection. The inventory and file hashes are in [round4/artifacts/inventory.json](round4/artifacts/inventory.json).

The new enumerator is [round4/src/search.cpp](round4/src/search.cpp). It removes two distinct non-comparison instructions. It inserts one mov or supported conditional move at every position in the remaining core. The source and destination can be any distinct pair from the used registers and one fresh scratch register. All surviving instructions stay fixed. Output snapshots are free. Comparison operands stay syntactically fixed in this first scan, but deletions can change their runtime values.

The case filters execute concrete values exactly. All scratch registers start at 7. Initial flags indicate equality. A strict-valid program must pass this concrete initial state. The first filter uses 64 different weak orders. A survivor then needs a fixed output snapshot for each rank across all 541 weak orders. This filter does not use conservative unknown-value propagation. Every full survivor still needs the strict judge.

Both halves of the first scan finished. They tested 558,963,480 edit sequences on 168 seeds. There were 102 first-filter survivors. None supplied all five fixed output snapshots across all 541 weak orders. Logs: [even seeds](round4/logs/delete2_even.log), [odd seeds](round4/logs/delete2_odd.log). This completed result applies to the stated edit pattern and register alphabet only.

The reconstructed k=32 control passed the strict judge: [out file](round4/candidates/check_seed0_control.s), [judge output](round4/logs/control_judge.log). This is a control, not a length improvement.

The new packed evaluator matched an independent scalar evaluator on 840 programs. These include all 168 seeds and 672 edited programs. The check compares every register, comparison flag, and output-snapshot match after each instruction. It uses both the 64-case filter and all 541 weak orders. See [check source](round4/src/check.cpp) and [check output](round4/logs/evaluator_check_fixed.log). This is a tested agreement, not a correctness proof.

The first check build failed because two included files declared main. The include guard was fixed. The next build and scalar comparison finished successfully. The first failed check command did not run an evaluator binary. These failed jobs remain in the job ledger.

The flag-source scans are now in progress on the six cores with no mov. They also change both operands of the comparison immediately before the inserted conditional move. They test every insertion position. Completed and incomplete statuses will be recorded separately.

## Round 4 completion

No strict PASS with k <= 31 was found. The best verified core remains k=32, or 42 instructions in the memory model.

All five new enumeration patterns finished. The table reports edit sequences, not unique programs. The case filter is a necessary concrete test. A first-filter survivor must still provide one fixed snapshot per output across all 541 weak orders. No full survivor was found.

| Pattern | Seeds | Edit sequences | 64-case survivors | 541-case survivors |
|---|---:|---:|---:|---:|
| Delete two writes; insert one write at any position | 168 | 558,963,480 | 102 | 0 |
| No-mov cores: delete two cmovs; insert one cmov anywhere; change its preceding cmp | 6 | 1,279,359,360 | 0 | 0 |
| All seeds: delete two writes; insert one write at either deleted position; change its preceding cmp | 168 | 2,981,719,500 | 14 | 0 |
| Delete two instructions; insert one instruction anywhere; edit includes a cmp | 168 | 670,501,480 | 13 | 0 |
| No-mov cores: delete two cmovs; insert one cmov at either deleted position; change any cmp | 6 | 662,547,456 | 0 | 0 |

Here, a write is mov or one of the four supported conditional moves. A changed comparison can use any ordered register pair, including equal operands. Inserted comparisons also permit equal operands. Inserted writes use distinct source and destination registers. Every alphabet includes all used registers and one fresh scratch register. Untouched instructions retain their order. The comparison-edit pattern skips the write-only pattern counted in the first row. Counts can otherwise overlap across rows.

The flag-source scans change comparison operands. They do not rerun fixed-structure routing. In the last scan, the changed comparison can occur before or after the inserted conditional move. In the preceding-comparison scans, it is the comparison that supplies flags to the inserted write. The comparison must change syntactically. The scans retain eight comparison slots. The general comparison-edit scan permits comparison deletion and insertion. It can therefore change the comparison count.

All counts were recomputed independently from each seed and edit pattern. Each seed count matched its log. The audit also checked aggregate counts, inventory hashes, the evaluator check, the strict control log, and two-core affinity. See [audit source](round4/src/report.py) and [full result ledger](round4/artifacts/final_summary.json).

Completed searches are negatives only within their stated register alphabets and edit patterns. No global lower bound is claimed. The scalar comparison is a tested agreement. It is not a proof of evaluator correctness.

All search and compiler commands used nice level 19. At most two CPU jobs ran at once. Bounded jobs had a 2,800 MiB address-space limit. The process tree remained restricted to two cores. All new files are inside w6. No fixed-structure routing was run.

Logs for the completed patterns:

- Delete two writes; insert one write at any position: [delete2_even.log](round4/logs/delete2_even.log), [delete2_odd.log](round4/logs/delete2_odd.log).
- No-mov cores: delete two cmovs; insert one cmov anywhere; change its preceding cmp: [flagsall_even.log](round4/logs/flagsall_even.log), [flagsall_odd.log](round4/logs/flagsall_odd.log).
- All seeds: delete two writes; insert one write at either deleted position; change its preceding cmp: [flagswrites_0.log](round4/logs/flagswrites_0.log), [flagswrites_1.log](round4/logs/flagswrites_1.log).
- Delete two instructions; insert one instruction anywhere; edit includes a cmp: [cmp2_0.log](round4/logs/cmp2_0.log), [cmp2_1.log](round4/logs/cmp2_1.log).
- No-mov cores: delete two cmovs; insert one cmov at either deleted position; change any cmp: [flagsany_0.log](round4/logs/flagsany_0.log), [flagsany_1.log](round4/logs/flagsany_1.log).

The only new strict PASS file is the k=32 reconstruction control: [out file](round4/candidates/check_seed0_control.s), [judge output](round4/logs/control_judge.log). It does not meet the target.

The five completed scans tested 6,153,091,276 edit sequences in total. Counts can overlap between patterns. No k=31 program passed the full-case filter.

Two scans retained a k=31 program with 14 failing weak orders and an output-error sum of 18. Both strict judge commands returned FAIL. For input `[0,1,2,1,3]`, both return `[0,1,2,2,3]` instead of `[0,1,1,2,3]`. These files do not improve the prior near miss.

- [flagswrites_1_seed161_near.s](round4/candidates/flagswrites_1_seed161_near.s), [strict judge output](round4/logs/near14_judge.log).
- [cmp2_1_seed161_near.s](round4/candidates/cmp2_1_seed161_near.s), [strict judge output](round4/logs/cmp2_near_judge.log).

The final scalar check used all 541 weak orders, scratch value 7, and initial equality flags. Both saved programs produced exactly the same outputs as the prior 14-order near miss on those concrete tests. This is an observed match under the stated initial state, not a general equivalence proof. The final judge failures and refreshed job ledger are in [round4/artifacts/final_summary.json](round4/artifacts/final_summary.json).

## Round 5 — new conditional-swap algorithms

This round starts from new conditional-swap programs. It does not use the 168 old seeds for local repair or rerun fixed-structure routing. A macro is one comparison followed by a conditional swap. The compared pair and the swapped pair can differ. The first search uses eight macros. Its necessary test uses all 120 strict input permutations. Its score measures the number of possible final permutations and their differing rank positions. A singleton final image is only a candidate; ties and scratch independence still need the strict judge.

The second search uses nine macros and requests at least two macros whose compared and swapped pairs differ. These are search restrictions, not lower-bound assumptions. The new global SAT script also targets a 31-instruction core. It fixes comparison positions and the first pair sort, but it places no edit-distance bound on the remaining instructions. Its comparison operands, write sources, write destinations, and write conditions are free within the register bound. These jobs are in progress. Limits will be recorded as unknown.

All bounded jobs use nice level 19 and a 2,800 MiB address-space limit. At most two search or compiler jobs run together. All writes remain inside w6.

The eight-macro stochastic run completed 1,070,268,416 proposals in 600.008 CPU seconds. It accepted 128,192,473 transitions. Its best final image contains two permutations. The nine-macro run with at least two different compared/swapped pairs completed 62,439,424 proposals in 40.008 CPU seconds. It also retained two final permutations. Neither stochastic run is an exclusion.

Relaxing the latter requirement to one different pair produced a strict PASS at k=36 after 97,965 proposals. Its third macro compares P3 with P0 but conditionally swaps P0 with P2. Both strict judges passed. The memory form has 46 instructions. This seed is a new construction for this round; no claim of a globally new comparison class is made.

- Tested out file: [macro9one_sort_813.s](round5/candidates/macro9one_sort_813.s).
- Byte-identical retained out file: [macro9one_sort_813.s](round5/verified/macro9one_sort_813.s).
- Strict memory file: [macro9one_sort_813.s](round5/verified_mem/macro9one_sort_813.s).
- Judge logs: [initial out](round5/logs/macro9one_sort_813_judge.log), [out](round5/logs/macro9one_sort_813_out_judge.log), [memory](round5/logs/macro9one_sort_813_mem_judge.log).

The new backward enumerator searches the same conditional-transposition grammar on all 120 strict orders. It starts from one fixed final permutation and takes preimages under each possible macro. It identifies sets that differ only by a wire permutation. Each macro has at most two preimages per permutation. Thus the remaining macro count bounds the maximum possible set size. This search does not model general cmov programs or free intermediate output snapshots.

The completed eight-macro run returned `RESULT NONE n=5 swaps=8 calls=20755 edges=4151000 canonical=92601 memo=20592 hits=0 cpu=1.20403`. It had no node or time limit exit. This result excludes only programs of at most eight macros in that grammar on distinct inputs. Source: [backward.cpp](round5/src/backward.cpp). Log: [backward8.log](round5/logs/backward8.log).

The backward controls passed the strict out judge:

- Four inputs, five macros, k=20: [backward4_control.s](round5/candidates/backward4_control.s), [judge log](round5/logs/backward4_control_judge.log).
- Five inputs, nine macros, k=36: [backward5_control.s](round5/candidates/backward5_control.s), [judge log](round5/logs/backward5_control_judge.log).

The first direct k=31 SAT query fixes eight comparison positions, the first four instructions, and a seven-register bound. All other sources, destinations, and supported write conditions are free. It reached its 240-second wall limit before its first solver result. Its status is UNKNOWN. Log: [global8_blocks_R7.log](round5/logs/global8_blocks_R7.log).

The second global query fixes nine comparison positions and the first eight instructions, which sort two disjoint pairs. It also uses seven registers. It reached its 300-second wall limit before its first solver result. Its status is UNKNOWN. Log: [global9_pairs_R7.log](round5/logs/global9_pairs_R7.log).

The new nine-comparison macro seed has an operand that is not a min/max expression. An explicit finite witness increases input P3 from 1 to 2 in `[1,1,0,1,0]`; the left operand of comparison 4 decreases from 1 to 0. Every expression made only from min and max is monotone in each input. Witness: [macro9one_nonmonotone.json](round5/artifacts/macro9one_nonmonotone.json). The routing search on this new fixed value structure finished with `RESULT NONE K=31 calls=377513 leaves=0 sols=0 best=-1 time=0.9s`. It did not reach a limit. Log: [macro9one31.log](round5/logs/macro9one31.log). This result concerns only that fixed comparison structure.

The new backward enumerator passed 234,000 independent checks of its inverse transitions, its two-preimage bound, and its wire-permutation identifiers. See [backward_check.cpp](round5/src/backward_check.cpp) and [check log](round5/logs/backward_check.log). These checks are tested agreement, not a formal proof of the enumerator.

The direct 31-slot search started only from the new k=36 macro seed and its own improved failing states. It completed **702,599,168** proposals in 600.001 CPU seconds. It accepted 94,193,543 transitions. It found no correct program. The search used 120 strict orders and 40 selected weak-order entries for its score. Every zero-error state would require the full 541-order check.

Its best retained failure improves the prior 14-order failure to **9 failed weak orders** in the independent evaluator. The file is [fresh31_near.s](round5/candidates/fresh31_near.s). It has **9 cmp + 20 cmov + 2 mov = k=31**. Only output 2 fails in the retained snapshots. The strict judge reports FAIL. For input `[0,1,2,0,2]`, the program returns `[0,0,0,2,2]` instead of `[0,0,1,2,2]`. See [strict judge log](round5/logs/fresh31_near_out_judge.log). This file is not a sorting program.

The new exact concrete repair scan tested all one- and two-instruction replacements over eight registers. It uses every ordered register pair for cmp, including equal operands. It uses every distinct source/destination pair for mov and all four cmov conditions. All other instructions retain their order. Output snapshots are free. The scan completed 10,664 single replacements and 55,026,240 double replacements. Of the 55,036,904 edit sequences, 1,692 passed the 64-order filter. None supplied all five fixed output snapshots over all 541 weak orders. The best full error remains nine. These counts are edit sequences and can include unchanged instructions. Log: [near9_two.log](round5/logs/near9_two.log). Source: [near_repair.cpp](round5/src/near_repair.cpp).

The four-change SAT repair returned UNSAT after CEGIS added one case, reaching 15 encoded weak orders. It preserves comparison positions and write destinations. Comparison operands, write sources, and supported write conditions are free. One fresh scratch register is available. The result concerns only those constraints and the relaxed initial scratch state. Log: [near9_typed4.log](round5/logs/near9_typed4.log). Broader repairs and the all-541-order stochastic search are in progress.

## Round 5 completion

No strict PASS with k <= 31 was found. The best verified core remains k=32, or 42 instructions in the memory model. The best retained k=31 failure now fails **9/541 weak orders**, compared with 14 in the earlier rounds. Its strict judge result is FAIL.

The independent scalar check matched the following failure condition on all 541 weak orders, with scratch value 7 and initial equality flags: `P1 > max(P0,P3)` and `min(P2,P4) > P1`, where these names refer to the original inputs. Four failures have five distinct inputs. Five failures have ties. Only output 2 fails in these concrete tests. The program writes the middle value of the P0/P1/P3 triple instead of its maximum. See [the complete case analysis](round5/artifacts/near9_analysis.json) and [analysis source](round5/src/near9_analysis.py). This finite check is not a proof for all scratch states.

Adding `cmovl P0, S1` just after `cmp S1, S2` repairs the program at k=32. The repaired core has **9 cmp + 21 cmov + 2 mov**. Both strict judges passed. This gives another correct implementation at the existing length. It does not meet the target.

The six-change repair returned UNSAT in 114.26 seconds on its 14 encoded orders. It preserves comparison positions and write destinations, and permits one fresh scratch register. Both the four-change and six-change queries require at least one comparison to change syntactically. Their UNSAT results apply only to those constraints and the relaxed initial state. The four-change query with free instruction classes and write destinations permits up to ten comparisons. It reached its 180-second wall limit after six solver candidates and 21 encoded orders. Its result is UNKNOWN. The unrestricted 15-instruction suffix query was skipped when work moved to the triple-prefix construction. It gives no result.

| Repair | Result | Log |
|---|---|---|
| Four changes, fixed write destinations and comparison positions | UNSAT, scoped | [near9_typed4.log](round5/logs/near9_typed4.log) |
| Six changes, fixed write destinations and comparison positions | UNSAT, scoped | [near9_typed6.log](round5/logs/near9_typed6.log) |
| Four changes, free classes and destinations | UNKNOWN, wall limit | [near9_full4.log](round5/logs/near9_full4.log) |
| Free 15-instruction suffix | SKIPPED | [near9_suffix15.log](round5/logs/near9_suffix15.log) |

The all-541-order stochastic run started from the new nine-order failure. It permits eight to ten comparisons and one fresh scratch register. It reached its 500-second wall limit before its intended 480-CPU-second limit. Its last status records 160,432,128 proposals, 19,771,198 accepted transitions, and 449.774 CPU seconds. The final proposal count is not available. No correct candidate was retained. Its best saved failure still fails nine orders. The strict judge rejects [union9_near.s](round5/candidates/union9_near.s); see [judge log](round5/logs/union9_near_out_judge.log) and [search log](round5/logs/union9.log). These are search observations, not exclusions.

The failure analysis gives a second constructive route. Sort a triple while retaining two copies of its minimum and two copies of its maximum. Then sort the other pair in four instructions. The resulting merge uses five comparisons and ten cmovs. A 13-instruction triple prefix gives k=32. A 12-instruction prefix would give k=31.

The 13-instruction control produced a core with **9 cmp + 20 cmov + 3 mov = 32**. Both strict judges passed. The initial 12-instruction query failed before solving because a Boolean operand selector was negated into a zero clause literal. The private encoder now uses Boolean-aware negation. That failed query gives no exclusion. Neither corrected query below finished within its 240-second wall limit:

- Six registers, exactly three comparisons, first instruction `cmp P0, P1`, all 13 weak orders of three inputs: UNKNOWN. [Log](round5/logs/triple_extrema_R6_c3_fixed.log).
- Six registers, exactly four comparisons, the same first instruction and all 13 weak orders: UNKNOWN. This query also requires every compared value to come from an input. [Log](round5/logs/triple_extrema_R6_c4_safe.log).

The second query would give a ten-comparison sort5 if it found a strict-valid prefix. No prefix candidate was returned. Sources: [triple_extrema.py](round5/src/triple_extrema.py), [private encoder](round5/src/triple_encode.py). The failed first query remains recorded separately in [triple_extrema_R6_c3.json](round5/artifacts/triple_extrema_R6_c3.json).

The final scan tested early output snapshots on all **3,001** new eight-macro samples. Each sample has k=32. It also tested every single-instruction deletion: **96,032** edit sequences. None passed the 64-order necessary filter. No original sample supplied all five fixed snapshots over all 541 orders. This scan uses the new samples, not the old 168 verified seeds. It completed in 0.263 CPU seconds. [Source](round5/src/macro_early.cpp), [log](round5/logs/macro_early.log).

Every new strict PASS file and byte-identical retained copy is listed below. The earlier macro and backward controls also appear above.

| Tested out file | Retained out copy | Tested memory file | Strict judge logs |
|---|---|---|---|
| [macro9one_sort_813.s](round5/candidates/macro9one_sort_813.s), k=36 | [out copy](round5/verified/macro9one_sort_813.s) | [memory](round5/verified_mem/macro9one_sort_813.s), L=46 | [initial out](round5/logs/macro9one_sort_813_judge.log), [out](round5/logs/macro9one_sort_813_out_judge.log), [memory](round5/logs/macro9one_sort_813_mem_judge.log) |
| [near9_repair32.s](round5/candidates/near9_repair32.s), k=32 | [out copy](round5/verified/near9_repair32.s) | [memory](round5/verified_mem/near9_repair32.s), L=42 | [out](round5/logs/near9_repair32_out_judge.log), [memory](round5/logs/near9_repair32_mem_judge.log) |
| [triple_extrema_13_R6_c3.s](round5/candidates/triple_extrema_13_R6_c3.s), k=32 | [out copy](round5/verified/triple_extrema_13_R6_c3.s) | [memory](round5/verified_mem/triple_extrema_13_R6_c3.s), L=42 | [out](round5/logs/triple_extrema_13_R6_c3_out_judge.log), [memory](round5/logs/triple_extrema_13_R6_c3_mem_judge.log) |
| [backward4_control.s](round5/candidates/backward4_control.s), n=4, k=20 | — | — | [out](round5/logs/backward4_control_judge.log) |
| [backward5_control.s](round5/candidates/backward5_control.s), n=5, k=36 | — | — | [out](round5/logs/backward5_control_judge.log) |

The final audit records eight tested PASS paths and three byte-identical retained copies. It checks file hashes and instruction counts. Its 22 bounded job records contain 14 finished jobs, six limits, one failed encoding attempt, and one skipped query. See [final_summary.json](round5/artifacts/final_summary.json). Every completed negative above has a stated search scope. Every limit remains unknown. No global lower bound is claimed. All bounded jobs used nice level 19 and a 2,800 MiB address-space limit. At most two search or compiler jobs ran together. No old fixed comparison structure was rerouted.

## Round 6 — seven- and nine-comparison searches

This round uses the latest supervisor brief. It does not repeat fixed-structure routing or the completed local scans. All search and compiler jobs use nice level 19. At most two CPU jobs run together. Bounded jobs have a 2,800 MiB address-space limit. All writes stay inside w6.

The memory-model search has exactly 41 instruction slots. It permits only mov, cmp, and the four allowed conditional moves. Comparisons and conditional moves use registers only. The search starts from seven-comparison deletions, nine-comparison deletions, and altered selects based on net9_41. It uses all 541 weak orders. It saves programs with at most ten failing weak orders for later SAT repair. Its partner-select mutation changes a select source to an operand of an earlier comparison. Search scores and saved programs are not strict PASS results.

The first new SAT query keeps the first 16 instructions of the previous nine-order failure. It leaves the last 15 instructions free within the original comparison positions. It permits one fresh scratch register and has no edit-distance bound. This query was skipped in the previous round, so it has no previous result. Jobs are in progress. Time limits will remain UNKNOWN.

Seed details: [round6/artifacts/seeds.json](round6/artifacts/seeds.json). Search code: [round6/src/mcmc.c](round6/src/mcmc.c). Job arguments and limits are recorded under round6/artifacts/.

The twelve memory searches used temperatures 0.5, 0.6, 0.8, 1, 1.2, 1.5, 2, 3, 5, 6, and 10. Three runs require exactly seven comparisons. Other runs require nine comparisons or permit a range from seven or eight through nine. No memory search found a correct program. Four early runs reached their wall limits without final counters. These runs are incomplete. The remaining counters are recorded in their logs.

The memory search retained 2,176 programs with at most ten failing weak orders. The converter accepted 543 programs with one initial load and one final store for each memory cell. It rejected 1,633 programs that did not meet that conversion pattern. Those rejections concern the converter's restrictions. The retained memory files remain available. The 543 converted programs give 26 raw comparison signatures and 15 signatures after input renaming, operand reversal, and value reversal. Fourteen differ from the original nine-order failure's signature. Each representative still fails nine weak orders. These are comparison fingerprints, not verified new sorting algorithms. The inventory is [round6/artifacts/near_inventory.json](round6/artifacts/near_inventory.json).

The two new k=32 cores from round 5 received three completed local scans. No candidate passed all 541 concrete weak-order tests. The scans use the original registers plus one fresh register, scratch value 7, and initial equality flags. Output snapshots are free. Every strictly correct program must pass those concrete initial states. A retained candidate would still need the strict judge.

| Edit pattern | Enumerated sequences | Passed 64-case filter | Full-test candidates |
|---|---:|---:|---:|
| Delete two writes, insert one mov or cmov at any position | 5,725,390 | 106 | 0 |
| Delete two instructions and insert one; at least one edit involves cmp | 8,020,754 | 18 | 0 |
| Delete two writes, insert one write at a deletion position, and change that flag's comparison operands | 29,661,930 | 30 | 0 |

These counts cover only the stated edit patterns on the two new round-5 cores. Logs: [delete2](round6/logs/new32_delete2.log), [cmp2](round6/logs/new32_cmp2.log), [flagswrites](round6/logs/new32_flags.log). Their sum is 43,408,074 edit sequences. Different patterns can overlap.

The seed analyzer found operands that are not representable by min/max expressions in both seven-comparison seeds. Its test uses threshold consistency on all 120 strict input orders. Thus these seeds are outside the excluded pure min/max grammar. They are failing programs. Details: [round6/artifacts/seed_analysis.json](round6/artifacts/seed_analysis.json). The analysis does not establish that a short sorting program exists in their neighborhoods.

The attempted packed seven-comparison run used an older binary. Its lower comparison bound conflicts with the requested upper bound of seven. This run rejected every proposal. Its search result is INVALID and will not be counted. The three earlier memory-model runs that require exactly seven comparisons use the new memory binaries and are unaffected. A private rebuild of the current packed-search source is queued. The replacement will log accepted transitions before its result is used.

The exact one- and two-instruction replacement scans finished on all 14 new comparison-fingerprint representatives. They tested **161,324 single replacements** and **911,997,060 double replacements**, or **912,158,384 edit sequences**. The 64-order filter accepted 13,882 sequences. None supplied all five fixed output snapshots on all 541 concrete weak orders. The register alphabet includes every ordered cmp pair, including equal operands, and every distinct-register mov or cmov pair. Each scan adds one fresh register. These completed results apply only to those 14 files and that replacement alphabet. They do not exclude other k=31 programs. Per-file arguments and counts appear in round6/artifacts/class_*_two.json and round6/logs/class_*_two.log.

All 15 retained failing representatives also received both strict judges. All 30 judge commands returned FAIL. The counterexample for the first representative is input `[0,1,2,0,2]`, output `[0,0,0,2,2]`, expected `[0,0,1,2,2]`. The complete file paths and judge logs are in [round6/artifacts/near_judges.json](round6/artifacts/near_judges.json).

A second conversion attempt first removed statically dead instructions. It still converted exactly 543 of the 2,176 memory failures and produced the same 15 comparison fingerprints. It added no repair seed. See [round6/artifacts/near_inventory_clean.json](round6/artifacts/near_inventory_clean.json).

Both conversion controls passed the strict out and memory judges. They reproduce the prior correct k=32 program. The tested PASS paths and their byte-identical retained copies are:

- [round6/candidates/conversion_control32.s](round6/candidates/conversion_control32.s), out, k=32; [judge](round6/logs/conversion_control32_out_judge.log).
- [round6/verified/conversion_control32.s](round6/verified/conversion_control32.s), retained out copy.
- [round6/verified_mem/conversion_control32.s](round6/verified_mem/conversion_control32.s), memory, L=42; [judge](round6/logs/conversion_control32_mem_judge.log).
- [round6/candidates/conversion_clean_control32.s](round6/candidates/conversion_clean_control32.s), out, k=32; [judge](round6/logs/conversion_clean_control32_out_judge.log).
- [round6/verified/conversion_clean_control32.s](round6/verified/conversion_clean_control32.s), retained out copy.
- [round6/verified_mem/conversion_clean_control32.s](round6/verified_mem/conversion_clean_control32.s), memory, L=42; [judge](round6/logs/conversion_clean_control32_mem_judge.log).

The older packed binary finished with 2,040,758,272 proposals and **zero accepted transitions**. These proposals are discarded. The rebuilt binary's 0.2-CPU-second control accepted 46,395 transitions from 278,528 proposals with the exact seven-comparison bound. The corrected searches use this rebuilt binary.

All six new SAT queries reached their wall limits. Their results are UNKNOWN. No SAT exclusion is claimed. The queries comprise the 15-instruction typed suffix, the 12-instruction suffix with free classes, the 12-instruction typed suffix, and four-edit repairs of three new nine-order representatives. The three representative repairs keep comparison positions fixed, leave write destinations free, permit one fresh scratch register, and require a syntactic change to a comparison. Their CEGIS case counts are 14, 14, and 22 at the last solve calls. Full arguments, last solver states, and limits are recorded in [round6/artifacts/final_summary.json](round6/artifacts/final_summary.json).

The two stochastic suffix searches also reached their wall limits. Their status is incomplete. Both retained failures with nine weak orders. They found no correct program. Their limits give no exclusion. Logs: [suffix19_t1.log](round6/logs/suffix19_t1.log), [suffix16_t3.log](round6/logs/suffix16_t3.log).

Eight memory-model runs have complete counters. They total **264,843,264 proposals** and **47,626,046 accepted transitions**. Four other memory runs stopped at their wall limits without final counters. Those four runs are excluded from these totals. No memory-model run found a correct program.

## Round 6 completion

No strict PASS with core k <= 31 was found. The best verified core remains k=32, or 42 instructions in the memory model. The best retained k=31 failure still fails nine weak orders. No global lower bound is claimed.

The corrected seven-comparison packed searches finished:

| Temperature | Proposals | Accepted transitions | CPU seconds | Strict result for saved failure |
|---:|---:|---:|---:|---|
| 4 | 95,014,912 | 26,182,685 | 65.0004 | FAIL: k=30, 184 failed weak orders |
| 10 | 62,656,512 | 41,434,119 | 65.0023 | FAIL: k=31, 219 failed weak orders |

These searches score 120 strict input orders plus 40 selected weak-order entries. They check a zero score on all 541 weak orders before retaining a correct candidate. Their best sample scores did not improve the full-order failure count. The counts above are stochastic proposals, including early rejections. They are not exclusions. The invalid old-binary run is not included.

The tested failure files are [round6/candidates/c7_fixed_t4_near.s](round6/candidates/c7_fixed_t4_near.s) and [round6/candidates/c7_fixed_t10_near.s](round6/candidates/c7_fixed_t10_near.s). Their strict judge outputs and instruction counts are in [round6/artifacts/c7_near_judges.json](round6/artifacts/c7_near_judges.json).

The completed local scans total **955,566,458 edit sequences** across the three patterns on the two new k=32 cores and the one/two-replacement scans on the 14 new failing representatives. These counts can overlap. No sequence passed the full-case filter. Their exclusions apply only to their stated files, register bounds, instruction alphabets, and edit patterns.

All six SAT limits remain UNKNOWN. Both stochastic suffix limits remain incomplete. Static dead-instruction removal added no convertible representative. No fixed comparison structure was rerouted. The new seven-comparison seeds contain operands outside the pure min/max grammar, but none of the searched seeds became a correct program.

The final ledger records 52 bounded jobs, every new tested PASS path, the retained PASS copies, all 30 strict near-miss rejections, both corrected seven-comparison rejections, command arguments, available CPU/RAM counters, and source hashes: [round6/artifacts/final_summary.json](round6/artifacts/final_summary.json). The only new strict PASS files are the conversion controls listed above. They retain the existing length. All search and compiler jobs used nice level 19. At most two search or compiler jobs ran together. Bounded jobs had a 2,800 MiB address-space limit. All writes remained inside w6.

## Round 7 — small windows on the nine-order failures

This round tests assumptions A2 (bounded registers) and A11 (local repair). It starts from all 15 round-6 comparison-fingerprint representatives. Each has k=31 and fails nine weak orders. No fixed value structure is rerouted. No earlier completed edit scan is repeated.

The new analyzer traces the execution paths of the wrong output snapshots. It records the instructions that produce their values, the comparisons that control those instructions, and writes that discard the required median. The analysis is a priority method, not a pruning rule. See [path analysis](round7/artifacts/path_analysis.json).

The repair query fixes every instruction outside one window. The window has six, seven, or eight instructions. The typed queries keep comparison positions fixed. They leave comparison operands, write sources, write destinations, and write conditions free. A write can be mov or any of the four permitted conditional moves. The full queries also leave instruction classes free. Every query permits all used registers and one fresh register. Outputs can use any fixed input or write snapshot. There is no edit-count bound inside the window.

The first formula uses rank values as separate Boolean choices. The second uses three bits per rank, cached Boolean gates, and constant propagation through fixed instructions. Both set scratch above all inputs and set initial flags to equality. These are necessary concrete states for strict correctness. An UNSAT result excludes the stated local query in this relaxed initial state. It does not exclude other register bounds or other windows. Every solver candidate still needs the strict judge. Sources: [window.py](round7/src/window.py), [binary_encode.py](round7/src/binary_encode.py).

The binary formula matched an independent scalar executor on 90 programs and 540 program/input pairs. The check compared 155,124 register values and 32,400 flag predicates after instructions. The sample includes all 15 seeds and 75 edited programs. Window selectors remain symbolic during formula construction and are fixed only before solving. This is tested agreement, not a proof. [Check source](round7/src/check.py), [check log](round7/logs/binary_check.log).

The fixed failing-program control returned UNSAT. Both fixed sorting-program controls passed the strict out and memory judges. Each retains k=32, or L=42 in memory. Every new PASS path is listed here:

- [round7/candidates/fixed_control32.s](round7/candidates/fixed_control32.s), tested out file; [retained out copy](round7/verified/fixed_control32.s); [memory file](round7/verified_mem/fixed_control32.s); [out judge](round7/logs/fixed_control32_out_judge.log); [memory judge](round7/logs/fixed_control32_mem_judge.log).
- [round7/candidates/binary_control32.s](round7/candidates/binary_control32.s), tested out file; [retained out copy](round7/verified/binary_control32.s); [memory file](round7/verified_mem/binary_control32.s); [out judge](round7/logs/binary_control32_out_judge.log); [memory judge](round7/logs/binary_control32_mem_judge.log).

The first unrestricted six-instruction query at start 12 reached 30 seconds in each formula. Both results are UNKNOWN. The typed binary query for that window returned UNSAT in 4.63 seconds on 15 encoded orders. Instruction indices start at zero. Logs: [rank formula](round7/logs/s00_w6_i12.log), [binary formula](round7/logs/b00_w6_i12.log), [typed query](round7/logs/t00_w6_i12.log).

The sequential batch is in progress. It first tests the central seven- and eight-instruction windows on all 15 seeds. It then slides the six-instruction window through every possible start on every seed. It finally tests central six-instruction windows with free instruction classes. Query arguments, limits, and completed statuses are recorded in [query plan](round7/artifacts/query_plan.json) and [query ledger](round7/artifacts/query_ledger.json). A timeout is UNKNOWN. No k<=31 strict PASS has been found.

Later queries reuse counterexample inputs from earlier queries on the same seed. Their logs record the complete initial case set. This adds necessary input constraints. It does not remove any program that passes all 541 input orders. Queries before this change use the nine failing orders and six seeded strict orders, with overlaps removed.

The next wider-window pass can also use a completed typed six-instruction UNSAT result. If its six positions lie inside a larger typed window, a valid larger repair must change at least one instruction outside those six positions. Otherwise it would solve the completed smaller query. The code adds that disjunction of syntactic changes. This deduction requires the same seed, output model, typed positions, and register bound. It is not applied to queries with free instruction classes or a different register bound. The query log lists every smaller-query dependency. These constraints use prior solver results. They are not independent proof certificates.

All new jobs use nice level 19. Search processes have a 2,800 MiB address-space limit. A 0.74-second control judge briefly overlapped the first 30-second query. This was a scheduling error under the one-job update. All subsequent verification and search commands run sequentially. All new files remain inside w6.

### Round 7 checkpoint — sliding scan complete

The primary batch finished all 434 planned queries. It returned 253 scoped UNSAT results and 181 UNKNOWN results. The separate first typed six-instruction query also returned UNSAT. Thus the primary coverage is 435 distinct window queries: 390 typed six-instruction queries, 15 typed seven-instruction queries, 15 typed eight-instruction queries, and 15 queries with free instruction classes. Each of the 15 seeds received all 26 possible six-instruction window starts. The two initial 30-second unrestricted formula probes repeat one of these scopes with different formulas or limits. They remain UNKNOWN.

Code review found a possible collision between Boolean `True` and SAT variable 1 in a gate helper. The helper now compares types before it identifies equal operands. Regenerating the formulas for all 436 binary repair attempts found zero calls with that collision. Thus the audit found no affected reported query. The corrected helper passed 4,096 exhaustive truth-table checks for its three arguments over constants and three signed literals. The scalar comparison passed again on the 90 programs and 540 program/input pairs. [Audit source](round7/src/audit_encoding.py), [audit result](round7/artifacts/encoding_audit.json), [scalar check](round7/logs/binary_check_final.log). These are verification results, not formal proof certificates.

The next pass tests typed seven- and eight-instruction windows at start 14 on all 15 seeds. These windows include more selects after the median comparisons. Each query has a 20-second wall limit. It reuses prior counterexamples and the necessary-change constraints from completed smaller windows. The prior 434-query batch is complete; this later pass has 30 separate queries. [Pass source](round7/src/refine.py), [pass ledger](round7/artifacts/refined_ledger.json).

## Round 7 completion

No strict PASS with core k <= 31 was found. The best verified core remains k=32, or 42 memory instructions. The best retained failure still fails nine weak orders. No global lower bound is claimed.

All 465 distinct window queries finished or reached their stated limits. This includes the first typed six-instruction query, the 434-query primary batch, and the 30-query later-window pass. The two separate unrestricted formula probes repeat one of these scopes and are not added to the distinct-query total.

| Window constraints | Distinct queries | Solver returned UNSAT | UNKNOWN at wall limit |
|---|---:|---:|---:|
| Typed, width 6, every start on all 15 seeds | 390 | 254 | 136 |
| Typed, width 7, starts 12 and 14 on all 15 seeds | 30 | 8 | 22 |
| Typed, width 8, starts 12 and 14 on all 15 seeds | 30 | 0 | 30 |
| Free instruction classes, width 6, start 12 on all 15 seeds | 15 | 0 | 15 |
| Total | 465 | 262 | 203 |

UNSAT concerns only the stated seed, fixed outside instructions, typed positions where applicable, output model, register bound, and encoded input constraints. The later pass also uses the necessary-change constraints derived from completed smaller queries. Its eight UNSAT results all concern width 7. Every width-8 query remains UNKNOWN. No timeout is a negative result.

The two batches made 532 solver calls. This count excludes the separate first typed query, the initial formula probes, and the controls. They produced 68 completed SAT models and used up to 35 encoded weak orders. Every model failed the full 541-order conservative snapshot check. The model miner decoded and checked all 68 models again. Exactly one had at most ten failing orders. It had nine failures and an existing comparison fingerprint. The miner found no new low-error comparison fingerprint and retained no new repair seed. This is a completed scan of those 68 saved models, not an exclusion of other programs. [Miner source](round7/src/mine.py), [mining result](round7/artifacts/mined_models.json).

The final audit confirms all 26 six-instruction starts on each of the 15 seeds. It checks query statuses, cut dependencies, seed hashes, strict control logs, and retained control copies. It records memory counters and source hashes. The query ledger records 2,907.05 CPU seconds and 3,091.96 query wall seconds across the two batches. Their peak recorded child memory was 44,720 KiB. These counters exclude the separate formula probes, controls, and encoding checks. [Audit source](round7/src/report.py), [final ledger](round7/artifacts/final_summary.json), [audit output](round7/logs/final_report.log).

The only new strict PASS files are the two k=32 controls and their byte-identical retained copies listed above. No k<=31 candidate was accepted. No old comparison structure was rerouted. No completed prior edit scan was repeated. The results test A2 and A11 only within their stated bounds. They do not contradict an assumption in ASSUMPTIONS_42.md.

## Round 8 — longer SAT windows and failure-count restarts

This round tests A1 (stochastic reachability), A2 (bounded registers), and A11 (local repair). It starts from the 203 unresolved round-7 window queries and the 15 round-6 nine-order failures. It does not repeat any completed exclusion or fixed-structure routing run.

The SAT plan ranks the unresolved queries by the clause count in their last solve call. It breaks ties by variable count and query name. It selects the first 40 queries. Each query has a 900-second total wall limit, including formula generation and all CEGIS solve calls. Each solve uses kissat. Later queries reuse counterexample inputs from both rounds. The fixed outside instructions, window positions, and register bounds remain the same as in the selected prior query. A limit remains UNKNOWN. See [selection plan](round8/artifacts/smallest40_plan.json).

The stochastic plan starts from every one of the 15 nine-order representatives at temperatures 0.25, 0.8, and 2.4. Each run has 31 slots, permits seven to ten comparisons, permits two fresh scratch registers, and requests 40 CPU seconds. Its primary score counts the union of failed weak orders over all 541 orders. A small output-error sum breaks ties between equal failure counts. Each output uses a fixed snapshot with minimum error count; equal-count snapshots favor overlap with the other outputs' errors. These choices are search heuristics. They do not enumerate all output combinations. Every accepted program with at most six failed orders is retained, up to 3,000 different instruction sequences per run. Any zero-error candidate still requires both strict judges.

The zero-iteration scorer control reports the expected nine failures and an error sum of nine on representative 0. This is a scorer control, not a correctness PASS. Sources: [failure search](round8/src/failure_search.cpp), [sequential dispatcher](round8/src/run.py), [private source preparation](round8/src/prepare.py). The private SAT copy changes only import paths and counterexample-log collection. The round-7 encoder is unchanged.

The sequential batch is in progress. Its SAT ledger is [sat_ledger.json](round8/artifacts/sat_ledger.json). Its stochastic ledger is [mcmc_ledger.json](round8/artifacts/mcmc_ledger.json). All search and compiler jobs use nice level 19. Search processes have a 2,800 MiB address-space limit. Only one CPU search job runs at a time. All new writes remain inside w6. No new strict PASS has been found.

### Round 8 checkpoint — wall-limit adjustment

The first four selected SAT queries returned UNSAT. The first four MCMC runs stopped at their 90-second wall limits, with complete final counters. They received 22.24, 38.88, 33.28, and 25.57 CPU seconds. Each kept nine failures. These runs are incomplete stochastic searches. Their ledger status is `FINISHED_AT_WALL_LIMIT`; their exit code is 124. They are not exclusions.

The dispatcher stopped between jobs. The next SAT query had not started its solver, so the restart discarded no solver result. The restarted dispatcher preserves all completed ledger entries and gives later MCMC jobs a 300-second wall limit. It retains the 40-CPU-second target. A private child-to-parent restart hook permits this controlled stop where executor sessions have separate process namespaces. The hook checks the exact dispatcher command before sending a signal.

The separate scalar executor matched all reported failure counts and output-error sums in the first five saved files. It checked all 541 weak orders per file. Its scratch and flag propagation matches the conservative search semantics. This is tested agreement, not a proof. Source: [check.py](round8/src/check.py). Result: [score_check.json](round8/artifacts/score_check.json). The final audit will repeat this check on all saved search files.

The first 16 selected queries returned UNSAT. Every one has width six. The wider queries now use the round-7 necessary-change constraints. They also use completed smaller-window UNSAT results from this round. If a wider repair changed nothing outside such a smaller window, it would solve that completed smaller query. Thus an all-541-order repair must change at least one outside instruction. This deduction requires the same seed, typed positions, free output snapshots, and register bound. Each query logs its dependencies. The final audit checks every dependency and its instruction positions. These are derived constraints, not independent proof certificates. No solver result was discarded when this change was added.

### Round 8 checkpoint — eight-instruction windows

The first 32 selected queries returned UNSAT. Six of these queries have width eight. The first 32 MCMC runs retained no program below nine failures. No strict PASS with k<=31 was found.

The stochastic plan adds temperature 8 after the original 45-run batch. This gives all 15 representatives one higher-temperature run with the same 31 slots, register bound, comparison bounds, failure-count score, and 40-CPU-second target. Its wall limit is 300 seconds. The added runs execute sequentially after the main batch ends. The purpose is to test stochastic reachability at a higher temperature. A run that finds no improvement remains a bounded observation. Source: [hot.py](round8/src/hot.py).

### Round 8 checkpoint — all 40 SAT queries complete

Every selected SAT query returned UNSAT within its 900-second wall limit. The selected scopes comprise 25 typed six-instruction windows, seven typed seven-instruction windows, and eight typed eight-instruction windows. No selected query remains UNKNOWN. Each result concerns the stated seed, fixed outside instructions, typed comparison positions, free output snapshots, and used registers plus one fresh register. The wider queries can also use the logged necessary-change constraints. These results do not establish a global lower bound.

Overlaying these results on the 465 distinct round-7 scopes gives 302 scoped UNSAT results and 163 UNKNOWN results. The overlay does not add distinct windows. Forty MCMC runs have ended. Their best retained failure still fails nine orders. Five original MCMC runs and the added temperature-8 pass remain. No strict PASS with k<=31 has been found.

## Round 8 completion

No strict PASS with core k <= 31 was found. The best correct core remains k=32, or 42 memory instructions. No new PASS file was produced in this round. No fixed comparison structure was rerouted.

All 40 selected window queries returned UNSAT. Their scopes comprise 25 typed windows of width six, seven typed windows of width seven, and eight typed windows of width eight. Every query fixed the outside instructions and retained its register bound. Outputs remained free snapshots. The logged derived constraints are necessary for an all-541-order repair. These results concern only the stated local scopes. They do not establish a global lower bound.

The final audit checked 41 smaller-window dependencies and the hashes of all 15 seeds. The longer pass made 40 solver calls and produced 0 completed SAT models. Model mining decoded every saved SAT model and retained no program with at most six failing orders. The original 465-scope inventory now has 302 scoped UNSAT results and 163 UNKNOWN results.

The stochastic searches ran every representative at four temperatures. Each run used 31 slots, seven to ten comparisons, all 541 weak orders, and two fresh scratch registers. The table gives stochastic proposals, not unique programs. A proposal can be rejected before execution. None of these searches is exhaustive.

| Temperature | Runs | Proposals | Accepted transitions | Binary CPU seconds | Best failed orders |
|---:|---:|---:|---:|---:|---:|
| 0.25 | 15 | 351,346,688 | 43,097,499 | 560.003 | 9 |
| 0.8 | 15 | 371,675,136 | 45,592,184 | 600.051 | 9 |
| 2.4 | 15 | 383,287,296 | 47,738,612 | 600.035 | 9 |
| 8 | 15 | 213,651,456 | 153,540,412 | 600.093 | 9 |

The 60 runs made **1,319,960,576 proposals** and accepted **289,968,707 transitions**. No run improved the nine-order failure count. No program with at most six failing orders was retained. The four initial runs reached their 90-second wall limits and returned final counters. The other 56 runs reached their 40-CPU-second targets within their 300-second wall limits. Every bounded result remains a search observation.

The separate scalar executor matched the saved failure counts and output-error sums on all 61 search files. It checked all 541 orders for each file. This is tested agreement under the conservative unknown-value semantics, not a proof. No zero-error candidate reached the strict judge. The earlier strict PASS files remain the only correct files cited by this worker.

The SAT queries used 871.337 child CPU seconds. The stochastic jobs used 2360.541 child CPU seconds. The recorded jobs used 5357.004 wall seconds in total, excluding the restart gap and final audits. The largest recorded child memory was 39,224 KiB. All bounded jobs had a 2,800 MiB address-space limit. Search and compiler jobs used nice level 19. Search jobs ran sequentially. All new retained files are in w6.

This round tests A1, A2, and A11 within the stated search bounds. It does not contradict an assumption in ASSUMPTIONS_42.md. Every remaining UNKNOWN scope remains unresolved.

Artifacts: [final audit](round8/artifacts/final_summary.json), [SAT ledger](round8/artifacts/sat_ledger.json), [MCMC ledger](round8/artifacts/mcmc_ledger.json), [model mining](round8/artifacts/mined_models.json), [scalar score check](round8/artifacts/score_check.json). The source files and seed hashes are in the final audit.


## Round 9 — weighted failures and median preservation

This round tests A1 (stochastic reachability), A2 (bounded scratch registers), and A11 (repair near retained failures). It does not repeat completed routing or edit scans.

The new search uses all 541 weak orders. Its score is `failed orders + (focus weight - 1) * failed focus orders + median weight * median output errors + loss weight * lost medians + 0.001 * output errors`. The focus set is the nine failing orders of the initial representative. Every other order keeps weight one. A lost median is a case where the required median is absent from every current register or memory cell and from the chosen earlier median output snapshot, if the model permits one. This penalty is a search heuristic. The simulator uses conservative unknown scratch values and unknown initial flags.

The three register runs start from representatives 0, 2, and 10. Each requests 600 CPU seconds with 31 slots and two fresh scratch registers. Their focus/median/loss weights are (4,2,4), (8,2,6), and (16,4,8). Base temperatures are 2, 4, and 8. Restart heat cycles through base multipliers 0.5, 1, 2, and 4. Comparison count can vary from seven through ten. Each run is followed by a 120-CPU-second memory run from its corresponding 41-instruction source. Memory mutations can change loads, stores, register instructions, and their positions. They forbid memory operands in cmp/cmov and memory-to-memory mov.

The scalar simulator matched all five reported counts and the objective on 120 emitted control files, using 541 cases per file. Controls include the 15 original representatives in both models and 30 mutated seeds. These checks are tested agreement, not proof of the simulator. See [scorer controls](round9/artifacts/scorer_controls.json). Positive k=32 controls and both strict judge models are checked separately.

All search jobs run sequentially at nice level 19 on one selected CPU. Each has a 2,800 MiB address-space limit. A wall limit is incomplete. Every retained search candidate receives the applicable strict judge. No strict PASS with k<=31 has been found. Sources: [search](round9/src/weighted.cpp), [scalar check](round9/src/check.py), [dispatcher](round9/src/run.py). Parameters and results will be recorded in [plan](round9/artifacts/plan.json) and [ledger](round9/artifacts/ledger.json).


The positive scorer controls passed the strict judge. These are k=32 / L=42 controls, not target improvements. Every new strict PASS control path is listed here:

- [control_out_best_fail.s](round9/candidates/control_out_best_fail.s), out k=32; [judge log](round9/logs/control_out_best_fail_judge.log).
- [control_out_best_objective.s](round9/candidates/control_out_best_objective.s), out k=32; [judge log](round9/logs/control_out_best_objective_judge.log).
- [control_mem_best_fail.s](round9/candidates/control_mem_best_fail.s), memory L=42; [judge log](round9/logs/control_mem_best_fail_judge.log).
- [control_mem_best_objective.s](round9/candidates/control_mem_best_objective.s), memory L=42; [judge log](round9/logs/control_mem_best_objective_judge.log).


### Round 9 checkpoint — first register run

The first weighted register run completed 136,351,744 proposals in 600.002724 binary CPU seconds. It accepted 16,352,727 transitions. Its best failure count remains nine. It retained no state with at most six failures and produced no zero-error candidate. Both saved files failed the strict out judge. The objective-best file has 39 failing orders, zero failures among the nine focus orders, nine median output errors, and no lost median. Its score is 57.048. These are search observations. The corresponding memory run is now in progress. See [run log](round9/logs/weighted_out_s00.log), [best-failure judge](round9/logs/weighted_out_s00_best_fail_out_judge.log), and [objective-best judge](round9/logs/weighted_out_s00_best_objective_out_judge.log).


The first memory run completed 86,974,464 proposals in 120.002827 binary CPU seconds. It accepted 8,421,617 transitions. Its best failure remains nine. Both saved files failed the strict memory judge. No state with at most six failures was retained. The second register run is in progress.

The dispatcher requested a one-CPU affinity at startup. The host later replaced that mask with a two-CPU worker mask. The search still uses one thread, and the dispatcher starts only one search or judge process at a time. The first ledger entry records the later mask as [73,74]. The concurrency limit concerns actual single-threaded jobs; a mask is an allowed CPU set.


### Round 9 checkpoint — second register run

The second register run completed 116,760,576 proposals in 600.001094 binary CPU seconds. It accepted 27,307,907 transitions. Its best failure remains nine. It retained no state with at most six failures. Both saved candidates failed the strict out judge.

The objective-best file has eight comparisons, eighteen conditional moves, and five register moves. The scorer reports 39 failed orders and 39 output errors, with zero focus failures, zero median errors, and zero lost medians. Its score is 39.039. This state changes the comparison count and retains a median-correct computation under the conservative simulator. It is not a sorter. The final scalar check will audit these counts. File: [weighted_out_s02_best_objective.s](round9/candidates/weighted_out_s02_best_objective.s); [strict FAIL log](round9/logs/weighted_out_s02_best_objective_out_judge.log). The second memory run is in progress.


## Round 9 completion

No strict PASS with core k <= 31 was found. The best verified core remains k=32, or 42 memory instructions. The best retained failure still fails nine of 541 weak orders. No program with at most six failures was retained.

All three register runs reached their 600-CPU-second targets. All three memory runs reached their 120-CPU-second targets. No job reached its wall limit. These are bounded stochastic searches, not exhaustive searches. Proposal counts include early rejections and repeated programs.

| Model | Representative | Proposals | Accepted transitions | Binary CPU seconds | Best failed orders |
|---|---:|---:|---:|---:|---:|
| out | 0 | 136,351,744 | 16,352,727 | 600.002724 | 9 |
| mem | 0 | 86,974,464 | 8,421,617 | 120.002827 | 9 |
| out | 2 | 116,760,576 | 27,307,907 | 600.001094 | 9 |
| mem | 2 | 70,475,776 | 16,495,652 | 120.008365 | 9 |
| out | 10 | 114,352,128 | 29,344,029 | 600.013569 | 9 |
| mem | 10 | 65,974,272 | 16,485,842 | 120.002860 | 9 |

The six searches tested **590,888,960 proposals** and accepted **114,407,774 transitions**. The register runs account for 367,464,448 proposals. The memory runs account for 223,424,512 proposals. The binary CPU time totals 2,160.031439 seconds. The recorded search-job wall time totals 2,470.792126 seconds. The largest recorded child memory was 15,052 KiB. Search jobs used nice level 19, one thread, and a 2,800 MiB address-space limit. Jobs ran sequentially. All writes remained inside w6.

The independent scalar executor matched all five counts and the weighted objective in all 12 saved search files. It checked every file on all 541 weak orders. The final audit also checked the 15-seed scorer controls, four positive control judge logs, source hashes, binary hash, seed hashes, command parameters, and completed run counters. These checks are tested agreement, not a proof of evaluator correctness.

The new weights changed the saved error pattern. In the representative-2 register run, the objective-best program uses 8 cmp + 18 cmov + 5 mov. Its median output passes all 541 conservative tests, but another output fails 39 orders. The representative-10 register and memory runs also saved median-correct states with 39 failed orders. All six objective-best files have zero focus failures and zero lost medians. None sorts. This is a dead end for the tested weights and run budgets: a lower weighted score did not produce fewer failed orders.

The general memory-to-register converter accepted all six new memory files. Every converted core has k=31. Every converted file failed the strict out judge. No conversion saved an extra instruction beyond the standard ten-instruction input/output cost. Conversions are recorded in [snapshot_mining.json](round9/artifacts/snapshot_mining.json).

The output-snapshot search completed on the six saved register programs and the six converted memory programs. It removes error masks that contain another mask, then enumerates the remaining snapshot combinations with branch pruning. All 12 searches completed; none reached the one-million-node limit. They visited 135 recursion nodes in total. Their scope is the fixed instructions, available snapshots, and conservative unknown-value semantics. The best failure counts remain nine for the six best-failure programs and 39 for the six objective-best programs. No new program with at most six failures was found. The six retained nine-failure snapshot programs all failed the strict out judge.

The final judge audit records **24 strict FAIL logs**: 12 original search files, six converted memory files, and six retained snapshot files. The only strict PASS files are the four k=32 / L=42 controls listed above. No target PASS was produced. No fixed comparison structure was rerouted. No previous completed edit scan was repeated.

This round tests A1, A2, and A11 within the stated register bounds, score choices, and search budgets. It does not contradict an assumption in ASSUMPTIONS_42.md. No global lower bound is claimed.

Artifacts: [final audit](round9/artifacts/final_summary.json), [run ledger](round9/artifacts/ledger.json), [run parameters](round9/artifacts/plan.json), [snapshot search and conversions](round9/artifacts/snapshot_mining.json), [scorer controls](round9/artifacts/scorer_controls.json), [positive controls](round9/artifacts/positive_controls.json).

## Round 10 — one delayed comparison repeat in new c=9 structures

This round tests A4 (fixed comparison operand columns) and A6 (fixed comparison order). It targets ten comparisons with one delayed repeat of an earlier comparison. It does not rerun the earlier weighted search, local edit scans, or old fixed skeletons.

The source inventory starts from the 15 round-6 nine-order failures and the round-5 unusual nine-comparison programs. A source must have nine comparisons with defined operands on all 120 strict input orders. Its comparison histories must distinguish those 120 orders. This is a necessary filter, not a sorting check. The generator inserts an exact earlier operand-column pair after at least one intervening comparison. The router can change all moves, conditional moves, and output snapshots within that fixed ten-comparison structure.

The exclusion scan reads the current w2/sk and d1/sk inventories. It identifies flag partitions under input renaming. This deliberately omits some operand-distinct structures if their flag partitions match a saved structure. It is a conservative duplicate filter. It never transfers NONE between flag-equivalent structures. Alternative operand lists use their first member for this filter; the saved lists have the same flag partition by construction. Generated structures that remain are new relative to this filter.

The local router copy is w2/src/dagx_safe.cpp. It includes the conservative correction to the open-requirement bound. Each new K=31 query has no node limit. A wall timeout remains UNKNOWN. A completed NONE concerns only the stated operand columns, their order, the router representation, and 120 strict input orders. No register cap is imposed. Every emitted candidate must pass both strict judges before it counts.

Sources: [generator](round10/src/generate.py), [duplicate filter](round10/src/canon.cpp), [router](round10/src/dagx_safe.cpp), [sequential dispatcher](round10/src/run.py). All CPU jobs run sequentially at nice level 19. Search jobs use one thread and a 2,800 MiB address-space limit. New files remain inside w6. Generation and controls are in progress. No new strict PASS is claimed.

### Round 10 checkpoint — generation and controls

The initial scan read 38,765 ten-comparison files from w2/sk and 41,773 from d1/sk. The initial conservative flag-partition filter retained 144 new structures from four flag-history classes. It excluded none against that saved inventory. The expanded scan preserves comparison operand distinctions. It retained 1,152 queries from 18 nine-comparison operand structures. The expanded queries represent 3,285 repeat-operand choices. Its later live-inventory exclusion scan recorded 69,079 flag classes. The source folders remain live, so the two scans need not have identical inventory counts. No exclusion is transferred between flag-equivalent operand structures.

The first conservative-router query reached 120 seconds and remains UNKNOWN. The second query finished: `r00043.txt`, `RESULT NONE K=31 calls=13193968 leaves=0 sols=0 best=-1 time=65.9s`. This is a completed result for that fixed structure only. The dispatcher then stopped at a job boundary before it started a third solver. No completed solver result was discarded. See [initial ledger](round10/artifacts/ledger.json).

The faster copy starts from w2/src/dagx_lb.cpp. It adds only the flag-operand adapter from w2/src/dagx_flags_safe.cpp. The adapter maps each reference conditional-move mask to an opcode for the selected operand pair. The build record stores all four exact source edits and source hashes. Both the conservative and faster copies use the corrected open-requirement bound. Cached copy and open bounds were checked against their legacy implementations during the positive controls.

The faster router's requirement order 1 reached 120 seconds on the k=33 positive control. This is UNKNOWN. With requirement order 0, the faster router found a k=33 program in 2.78 seconds. The conservative router found one in 2.23 seconds. Both emitted programs passed both strict judges. These are control results above the target. The first conservative control also passed both strict judges.

The three-input controls use the sort3 comparison structure at K=11 and K=10. Both routers returned FOUND at K=11 and NONE at K=10. The first two emitted candidates from each K=11 run failed on ties. The third candidate passed the strict out judge. This illustrates why a routing candidate is not a strict PASS. The first control script incorrectly expected its first permutation-only candidate to pass ties; that assertion was corrected. The failure and subsequent individual judge logs are retained. No failed candidate was counted as correct.

The duplicate filters passed 261 independent symmetry checks: every input renaming, each single comparison reversal, and value-order reversal for the operand key. These are tested checks, not a correctness proof. Artifacts: [initial generation](round10/artifacts/exclusions.json), [expanded generation](round10/artifacts/expanded_generation.json), [build](round10/artifacts/fast_build.json), [original controls](round10/artifacts/controls.json), [default-order controls](round10/artifacts/controls_root0.json), [sort3 controls](round10/artifacts/small_controls.json), [symmetry checks](round10/artifacts/canonical_controls.json).

The selected pilot uses one transformed-repeat query from each of the 18 operand structures. Every query has no node limit and a 90-second wall limit. A timeout remains UNKNOWN. The larger retained plan has 176 selected queries. Full generation is not a claim that every generated query has run. See [selected plan](round10/artifacts/selected_manifest.json) and [pilot ledger](round10/artifacts/pilot_ledger.json).

Every new strict PASS path so far:

- [control33_safe_0_out.s](round10/candidates/control33_safe_0_out.s), n=5 k=33; [out judge](round10/logs/control33_safe_0_out_judge.log).
- [control33_safe_0_mem.s](round10/candidates/control33_safe_0_mem.s), n=5 L=43; [memory judge](round10/logs/control33_safe_0_mem_judge.log).
- [control33_fast_root0_0_out.s](round10/candidates/control33_fast_root0_0_out.s), n=5 k=33; [out judge](round10/logs/control33_fast_root0_0_out_judge.log).
- [control33_fast_root0_0_mem.s](round10/candidates/control33_fast_root0_0_mem.s), n=5 L=43; [memory judge](round10/logs/control33_fast_root0_0_mem_judge.log).
- [control33_safe_root0_0_out.s](round10/candidates/control33_safe_root0_0_out.s), n=5 k=33; [out judge](round10/logs/control33_safe_root0_0_out_judge.log).
- [control33_safe_root0_0_mem.s](round10/candidates/control33_safe_root0_0_mem.s), n=5 L=43; [memory judge](round10/logs/control33_safe_root0_0_mem_judge.log).
- [sort3_fast_control_2_out.s](round10/candidates/sort3_fast_control_2_out.s), n=3 k=11; [out judge](round10/logs/sort3_fast_control_2_out_judge.log).
- [sort3_safe_control_2_out.s](round10/candidates/sort3_safe_control_2_out.s), n=3 k=11; [out judge](round10/logs/sort3_safe_control_2_out_judge.log).

No new sort5 program with k<=31 has passed the strict judge. These controls do not contradict a listed assumption. All search jobs remain sequential at nice level 19, with one thread and the 2,800 MiB address-space limit.

### Round 10 checkpoint — completed fixed-operand batches

All 36 delayed exact repeats of the unusual round-5 macro algorithm returned NONE at K=31. None reached a limit. Each query used 134,281 recursive calls. The batch used 4.5624 CPU seconds and 6.2695 wall seconds. Scope: each fixed ten-comparison operand structure, all router moves/selects and free output snapshots, on 120 strict input orders. See [macro ledger](round10/artifacts/macro_ledger.json).

The grouped transformed-repeat pilot stopped cleanly after three 90-second timeouts. Those three queries remain UNKNOWN. They used 239.4538 CPU seconds. No fourth grouped solver started. The fixed-pair search separates each alternative pair. This strengthens the router's required-value bound for that query. It does not transfer a negative result to an untested alternative.

The fixed-pair inventory contains 2,781 operand-distinct structures after canonical duplicate removal. The first selection has two queries from each of the 18 source structures, or 36 queries. Every one finished with NONE at K=31. This batch used 304.7849 CPU seconds and 338.2015 wall seconds. No query reached its 120-second wall limit. The largest recorded child memory was 16,456 KiB. See [fixed-pair inventory](round10/artifacts/singleton_inventory.json) and [fixed-pair ledger](round10/artifacts/singleton_ledger.json).

At this checkpoint, 73 new fixed c=10 queries have completed with NONE: one initial query, 36 macro-repeat queries, and 36 fixed transformed-repeat queries. One initial query and three grouped queries remain UNKNOWN. These are scoped search results, not a sort5 lower bound. No target PASS has been produced.

The extended fixed-pair plan has 144 queries, including the 36 completed ones. It adds repeat stages and insertion positions across all 18 source structures. Completed queries are reused by file identity. Files remain unchanged. Each remaining query has no node limit and a 120-second wall limit. Plan: [diverse_manifest.json](round10/artifacts/diverse_manifest.json). Limited queries remain UNKNOWN. These results test A4 and A6; no listed assumption is contradicted.

### Round 10 checkpoint — alternate-order retries

The extended fixed-pair batch stopped cleanly after 73 query records. At that point, 69 had returned NONE and four had timed out. The independent audit passed on all 4,077 generated files. It matched 116,640 source comparison values with a separate scalar executor under three scratch initial values. It checked 6,210 repeated-flag operand choices. See [audit](round10/artifacts/audit.json).

The four unresolved fixed-pair scopes received requirement-order-1 retries, each with no node limit and a 180-second wall limit. Original logs remain unchanged. Results:

- `s00058.txt`: timeout; UNKNOWN.
- `s00066.txt`: timeout; UNKNOWN.
- `s00140.txt`: NONE after 61,640,027 calls, 54.8 seconds.
- `s00141.txt`: NONE after 121,061,067 calls, 122.9 seconds.

Thus two earlier fixed-pair limits are now resolved within their fixed scopes. The other two remain unresolved. The retry does not transfer a result to another operand structure. See [retry ledger](round10/artifacts/retry_ledger.json).

The remaining diverse-plan queries resume with requirement order 0. Completed records are reused by file identity. After that batch, the new source collector will retain at most 48 operand-distinct nine-conditional-swap samples, using a 120-CPU-second bound. Its first swap is the canonical P0/P1 compare-exchange. The other swaps can compare and exchange different pairs. Its archive seeks different comparison structures. Every retained source will receive the strict out judge. Only a source PASS can supply the additional exact-repeat structures. Up to 360 new structures will be selected across sources and repeat stages. This is a bounded A1 test; it is not an exhaustive source-grammar search. Exact routing on each selected fixed c=10 structure still tests A4/A6.

## Round 10 completion

No strict PASS with core k <= 31 was found. The best verified sort5 core remains k=32, or 42 memory instructions. The new strict PASS files are controls and larger source programs.

This round tests A4 and A6 with new fixed ten-comparison structures. The source collector also tests A1 within its five-wire conditional-swap grammar and stated stochastic budget. No result establishes a global lower bound. No listed assumption is contradicted.

| Routing batch | Query records | Completed NONE | UNKNOWN | CPU seconds |
|---|---:|---:|---:|---:|
| ledger | 2 | 1 | 1 | 185.176 |
| pilot_ledger | 3 | 0 | 3 | 239.454 |
| macro_ledger | 36 | 36 | 0 | 4.562 |
| singleton_ledger | 144 | 115 | 29 | 6044.553 |
| invented_ledger | 360 | 360 | 0 | 110.942 |
| retry_ledger | 4 | 2 | 2 | 498.987 |

The audit records 545 distinct attempted fixed scopes. Exactly 514 completed with NONE. Exactly 31 remain unresolved. The completed NONE queries used 3,781,214,576 recursive calls. A query has no node limit. Every timeout remains UNKNOWN. A NONE result concerns only its stated operand columns, comparison order, router representation, and 120 strict input orders. Registers and conditional-move values are not restricted to the source program.

The independent scalar executor matched 414,720 comparison values from 64 source programs. It used all 120 strict input orders and scratch initial values -2147483648, 0, and 2147483647. The scope audit checked 5,718 generated files and 7,851 repeated-flag operand choices. It checked source-file hashes, insertion positions, unchanged original comparisons, and equivalent conditional-move masks. These are tested checks, not a proof of evaluator correctness.

The additional collector sampled nine conditional swaps. The compared pair and swapped pair could differ. It retained operand-distinct comparison structures and required at least one differing pair. Its output snapshots map the singleton strict final permutation to ascending ranks. The strict judge tested every retained source before it was used as a correct source. A strict source PASS has k=36; it is not a target result.

Collector counters: `SUMMARY iterations=7470 accepted=401 correct_visits=402 raw=61 operand_classes=48 resets=0 cpu=0.036581`. The generation audit records 48 source samples, judge statuses {'PASS': 47, 'FAIL': 1}, 1,641 new repeat structures, and 360 selected queries. The exclusion filter omits saved w2/d1 flag classes and the earlier round-10 classes. Its omitted cases inherit no negative result.

The stochastic run used 0.040 child CPU seconds and 0.049 wall seconds. Its result is a bounded observation. The selected invented-source queries have all run; limits remain unresolved. The larger generated inventory is not claimed as searched.

Routing used 7083.675 recorded child CPU seconds and 7571.091 recorded wall seconds. Peak recorded routing memory was 19,208 KiB. These totals omit compiler jobs and controls. All CPU jobs ran sequentially at nice level 19. Search jobs used one thread and a 2,800 MiB address-space limit. All new files remain inside w6.

The final ledgers preserve UNKNOWN queries and untested inventory. No completed old edit scan was repeated. New scopes passed the saved w2/d1 exclusion filter. Control queries use larger budgets or three inputs. The conservative duplicate filter can omit operand-distinct scopes, so it supplies no completeness claim.

### Every strict PASS path produced in round 10

| Strict PASS file | Judge log |
|---|---|
| [round10/candidates/control33_fast_root0_0_mem.s](round10/candidates/control33_fast_root0_0_mem.s) | [judge](round10/logs/control33_fast_root0_0_mem_judge.log) |
| [round10/candidates/control33_fast_root0_0_out.s](round10/candidates/control33_fast_root0_0_out.s) | [judge](round10/logs/control33_fast_root0_0_out_judge.log) |
| [round10/candidates/control33_safe_0_mem.s](round10/candidates/control33_safe_0_mem.s) | [judge](round10/logs/control33_safe_0_mem_judge.log) |
| [round10/candidates/control33_safe_0_out.s](round10/candidates/control33_safe_0_out.s) | [judge](round10/logs/control33_safe_0_out_judge.log) |
| [round10/candidates/control33_safe_root0_0_mem.s](round10/candidates/control33_safe_root0_0_mem.s) | [judge](round10/logs/control33_safe_root0_0_mem_judge.log) |
| [round10/candidates/control33_safe_root0_0_out.s](round10/candidates/control33_safe_root0_0_out.s) | [judge](round10/logs/control33_safe_root0_0_out_judge.log) |
| [round10/invented/m00000.s](round10/invented/m00000.s) | [judge](round10/logs/m00000_invented_out_judge.log) |
| [round10/invented/m00001.s](round10/invented/m00001.s) | [judge](round10/logs/m00001_invented_out_judge.log) |
| [round10/invented/m00002.s](round10/invented/m00002.s) | [judge](round10/logs/m00002_invented_out_judge.log) |
| [round10/invented/m00003.s](round10/invented/m00003.s) | [judge](round10/logs/m00003_invented_out_judge.log) |
| [round10/invented/m00004.s](round10/invented/m00004.s) | [judge](round10/logs/m00004_invented_out_judge.log) |
| [round10/invented/m00005.s](round10/invented/m00005.s) | [judge](round10/logs/m00005_invented_out_judge.log) |
| [round10/invented/m00006.s](round10/invented/m00006.s) | [judge](round10/logs/m00006_invented_out_judge.log) |
| [round10/invented/m00007.s](round10/invented/m00007.s) | [judge](round10/logs/m00007_invented_out_judge.log) |
| [round10/invented/m00008.s](round10/invented/m00008.s) | [judge](round10/logs/m00008_invented_out_judge.log) |
| [round10/invented/m00009.s](round10/invented/m00009.s) | [judge](round10/logs/m00009_invented_out_judge.log) |
| [round10/invented/m00010.s](round10/invented/m00010.s) | [judge](round10/logs/m00010_invented_out_judge.log) |
| [round10/invented/m00011.s](round10/invented/m00011.s) | [judge](round10/logs/m00011_invented_out_judge.log) |
| [round10/invented/m00012.s](round10/invented/m00012.s) | [judge](round10/logs/m00012_invented_out_judge.log) |
| [round10/invented/m00013.s](round10/invented/m00013.s) | [judge](round10/logs/m00013_invented_out_judge.log) |
| [round10/invented/m00014.s](round10/invented/m00014.s) | [judge](round10/logs/m00014_invented_out_judge.log) |
| [round10/invented/m00015.s](round10/invented/m00015.s) | [judge](round10/logs/m00015_invented_out_judge.log) |
| [round10/invented/m00016.s](round10/invented/m00016.s) | [judge](round10/logs/m00016_invented_out_judge.log) |
| [round10/invented/m00017.s](round10/invented/m00017.s) | [judge](round10/logs/m00017_invented_out_judge.log) |
| [round10/invented/m00018.s](round10/invented/m00018.s) | [judge](round10/logs/m00018_invented_out_judge.log) |
| [round10/invented/m00019.s](round10/invented/m00019.s) | [judge](round10/logs/m00019_invented_out_judge.log) |
| [round10/invented/m00020.s](round10/invented/m00020.s) | [judge](round10/logs/m00020_invented_out_judge.log) |
| [round10/invented/m00021.s](round10/invented/m00021.s) | [judge](round10/logs/m00021_invented_out_judge.log) |
| [round10/invented/m00022.s](round10/invented/m00022.s) | [judge](round10/logs/m00022_invented_out_judge.log) |
| [round10/invented/m00023.s](round10/invented/m00023.s) | [judge](round10/logs/m00023_invented_out_judge.log) |
| [round10/invented/m00024.s](round10/invented/m00024.s) | [judge](round10/logs/m00024_invented_out_judge.log) |
| [round10/invented/m00025.s](round10/invented/m00025.s) | [judge](round10/logs/m00025_invented_out_judge.log) |
| [round10/invented/m00026.s](round10/invented/m00026.s) | [judge](round10/logs/m00026_invented_out_judge.log) |
| [round10/invented/m00027.s](round10/invented/m00027.s) | [judge](round10/logs/m00027_invented_out_judge.log) |
| [round10/invented/m00028.s](round10/invented/m00028.s) | [judge](round10/logs/m00028_invented_out_judge.log) |
| [round10/invented/m00029.s](round10/invented/m00029.s) | [judge](round10/logs/m00029_invented_out_judge.log) |
| [round10/invented/m00030.s](round10/invented/m00030.s) | [judge](round10/logs/m00030_invented_out_judge.log) |
| [round10/invented/m00031.s](round10/invented/m00031.s) | [judge](round10/logs/m00031_invented_out_judge.log) |
| [round10/invented/m00032.s](round10/invented/m00032.s) | [judge](round10/logs/m00032_invented_out_judge.log) |
| [round10/invented/m00033.s](round10/invented/m00033.s) | [judge](round10/logs/m00033_invented_out_judge.log) |
| [round10/invented/m00034.s](round10/invented/m00034.s) | [judge](round10/logs/m00034_invented_out_judge.log) |
| [round10/invented/m00035.s](round10/invented/m00035.s) | [judge](round10/logs/m00035_invented_out_judge.log) |
| [round10/invented/m00037.s](round10/invented/m00037.s) | [judge](round10/logs/m00037_invented_out_judge.log) |
| [round10/invented/m00038.s](round10/invented/m00038.s) | [judge](round10/logs/m00038_invented_out_judge.log) |
| [round10/invented/m00039.s](round10/invented/m00039.s) | [judge](round10/logs/m00039_invented_out_judge.log) |
| [round10/invented/m00040.s](round10/invented/m00040.s) | [judge](round10/logs/m00040_invented_out_judge.log) |
| [round10/invented/m00041.s](round10/invented/m00041.s) | [judge](round10/logs/m00041_invented_out_judge.log) |
| [round10/invented/m00042.s](round10/invented/m00042.s) | [judge](round10/logs/m00042_invented_out_judge.log) |
| [round10/invented/m00043.s](round10/invented/m00043.s) | [judge](round10/logs/m00043_invented_out_judge.log) |
| [round10/invented/m00044.s](round10/invented/m00044.s) | [judge](round10/logs/m00044_invented_out_judge.log) |
| [round10/invented/m00045.s](round10/invented/m00045.s) | [judge](round10/logs/m00045_invented_out_judge.log) |
| [round10/invented/m00046.s](round10/invented/m00046.s) | [judge](round10/logs/m00046_invented_out_judge.log) |
| [round10/invented/m00047.s](round10/invented/m00047.s) | [judge](round10/logs/m00047_invented_out_judge.log) |
| [round10/candidates/sort3_fast_control_2_out.s](round10/candidates/sort3_fast_control_2_out.s) | [judge](round10/logs/sort3_fast_control_2_out_judge.log) |
| [round10/candidates/sort3_safe_control_2_out.s](round10/candidates/sort3_safe_control_2_out.s) | [judge](round10/logs/sort3_safe_control_2_out_judge.log) |

Artifacts: [final audit and ledgers](round10/artifacts/final_summary.json), [scope and source audit](round10/artifacts/audit.json), [diverse plan](round10/artifacts/diverse_manifest.json), [full fixed-pair inventory](round10/artifacts/singleton_inventory.json).
