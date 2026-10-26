No program with k <= 31 was found.

Strict PASS side result: a sort5 core with k=32 and 8 comparisons. Its memory version has 42 instructions.

The first such result is `verified/walk30_delete_k32.s`: 8 cmp + 20 cmov + 4 mov.
Other strict PASS forms are `verified/walk30_final.s` (8 cmp + 21 cmov + 3 mov)
and `verified/palette_c8_k32.s` (8 cmp + 19 cmov + 5 mov).

## Purpose

Find a core with k<=31. The main search tried to remove a CMOV from correct programs.
This run did not meet that target. The 8-comparison k=32 result improves the supplied 8-comparison k=33 example.

## Terms

- Core length k counts mov, cmp, and cmov. The out records have no cost.
- A weak order is an input order that can include equal values. There are 541 weak orders for five inputs.
- A mirror list obeys comparator[c-1-i] = (4-b,4-a) when comparator[i] = (a,b). This reflects both time and wires.
- A palette is the finite set of value functions that a program computes.

## Method

All writes stayed in this folder. Search jobs used nice -n 10. At most eight search CPU cores ran at one time.
The SIMD search filter used 16 concrete order tests, scratch value 7, and equal initial flags.
This filter is a necessary-condition test. It can reject a program but cannot accept one.
The independent full simulator used all 541 weak orders, unknown scratch values, and unknown initial flags.
Every reported PASS file then passed shared/judge.py with --strict and its stated model.

The independent simulator agreed with the supplied simulator on 20,000 random mutations.
Of these mutations, both simulators accepted 3,984. See `logs/crosscheck.log`.

Sources: all 26 files in d7-structure/fam32, the three upper_sort5_*k32 files, and sat_sort5_k32.s.
The full source list is in `seeds/manifest.json`.
The later search also used d4-evolve/codex/work/position33_valid.txt.

## Result

### CMOV value checks

The 30 initial seeds contain 542 CMOV instructions. None is a no-op on all weak orders.
One CMOV has a full result already held by another register: instruction 9, with zero-based numbering,
in upper_sort5_I1_k32_out.s. It copies S3 into P2. The source S3 changes before later uses.
The deletion search found no shorter program from this reuse.
See `analysis/cmov_audit.json` and `src/audit.py`.

The first 8-comparison k=32 result has 20 CMOV instructions. None has a full result already held
by another register. It computes 24 distinct fully defined value functions, including the five inputs.
One extra CMOV first writes a value that still depends on scratch data in some cases.
A later CMOV removes that dependence. See `analysis/c8_k32_cmovs.json`.

The last two comparisons in that program each use two operands that are not min/max expressions of the inputs.
The check constructs the only possible Boolean min/max expression and tests it on all 541 weak orders.
Counterexamples are in `analysis/c8_k32_comparison_terms.json`.

### Exact bounded repairs

- The final seed scan tested 257,671,968 candidates over 30 seeds. It tried every single deletion,
  then every two deletions with one insertion at every gap. The insertion alphabet includes all six legal opcodes,
  all used registers, one fresh register, and equal source/destination operands. No k<=31 candidate survived the filter.
- Deleting one CMOV, changing one CMP, and changing one surviving CMOV tested 2,583,112,698 candidates
  over the 30 initial seeds. This scan used one fresh register and excluded self CMOVs. It found no k<=31 result.
- The same CMP/CMOV repair on the first 8-comparison k=32 result tested 108,044,640 candidates.
  The 16-case filter admitted 20,735. None passed the full simulator.
- Deleting one CMOV and changing two surviving CMOVs in the first 8-comparison k=32 result tested 544,467,420 candidates.
  The filter admitted 160. None passed the full simulator. Both shards of this scan include self CMOVs.

The three-MOV form also failed 416,272,710 two-CMOV repair candidates and 86,822,400 CMP/CMOV repair candidates.
Those scans include self CMOVs. See `logs/cmov3_lowmov.log` and `logs/repair3_lowmov.log`.
The first eight-comparison k=32 result also failed the full two-delete/one-insert scan. See `logs/repair_v5_c8.log`.

### Correct-program walks

Each accepted state passed the independent full simulator. Only files listed in the PASS table received a reference-judge PASS.
The distinct counts normalize scratch register names. They count instruction lists, not distinct sorting algorithms.
Mutations include instruction changes, moves, swaps, two instruction changes, and suffix register exchanges.
The walks check single deletions in every new state. Most runs also check complete two-delete/one-insert repairs at intervals.

| Run | Proposals | Accepted transitions | Distinct states | Total candidate tests |
|---|---:|---:|---:|---:|
| walk00 | 657,714,612 | 12,184,658 | 10,900,050 | 988,368,527 |
| walk27repair | 7,020,341 | 118,989 | 107,000 | 7,117,656,616 |
| walk30 | 3,230,644 | 73,821 | 58,500 | 7,647,600,013 |
| c8_walk1 | 12,080,833 | 224,867 | 193,500 | 5,472,537,245 |
| c8_walk2 | 12,163,237 | 225,872 | 194,400 | 5,498,015,250 |
| c8_walk3 | 12,781,671 | 248,524 | 214,800 | 6,074,333,084 |
| c8_walk4 | 13,438,774 | 246,481 | 210,600 | 5,956,437,223 |

walk00 checked single deletions only. walk27repair checked a full repair after every 100 new states.
walk30 started from the supplied k=33 program. It found k=32 by deleting instruction 24 from a mutated state.
Its comparison histogram remained at eight comparisons. The four c8_walk runs started from that k=32 result.

### Mirror restriction

These runs restrict comparator lists to time-and-wire reflection symmetry. The final assembly can use different register routes
on the two sides. This is a restriction on comparator structure, not literal instruction-by-instruction assembly symmetry.
Only lists that sort all 32 Boolean inputs are accepted by the network walk.
A separate enumeration confirmed the total list counts below. Each walk reached every accepted list in its space.

| Comparisons | Lists tested by enumeration | Accepted lists | Distinct value/comparison circuits compiled | k<=31 result |
|---:|---:|---:|---:|---|
| 10 | 100,000 | 402 | 390 | None |
| 11 | 200,000 | 4,018 | 3,878 | None |
| 12 | 1,000,000 | 27,922 | 21,712 | None |

The first compiler builds required results at their defining comparison. It can omit repeated results and use any available
register whose value matches the desired result on the inactive flag cases. It can also use any matching source register.
A later compiler permits delayed CMOVs. It tested the 10- and 11-comparison spaces again.
That search visited 33,362,702 states and hit no state limit. It found no k<=31 route in its restricted palettes.
At limit 32, the first compiler produced a strict PASS program from a 10-comparator list.
Dead result removal reduced the emitted core to nine comparisons. This is `verified/mirror10_near_k32.s`.

### Fixed palette route for the 8-comparison program

The final route search used its 24 known value functions and its eight comparison operand functions.
Only 15 non-input functions are direct comparison/output requirements. Other palette functions were optional.
The search allowed CMOVs at later comparison blocks, arbitrary matching sources and destinations, and early outputs.
It generates each value function at most once and preserves a needed comparison operand through its last comparison use.
At k<=31 it visited 129,560 states and returned no route. It did not hit its state limit.
At k<=32 it found a route after 325,116 states. That route has eight comparisons, 19 CMOVs, and five MOVs.
Both its out and memory forms passed the reference judge. See `logs/palette_c8_31.log` and `logs/palette_c8_32.log`.

### Reference-judge PASS files

Every row below has a saved PASS output in logs/judge_<file stem>.log.

| File | Model | Count |
|---|---|---:|
| [c8_walk1_checkpoint.s](verified/c8_walk1_checkpoint.s) | out | 32 |
| [c8_walk1_checkpoint_mem.s](verified/c8_walk1_checkpoint_mem.s) | mem | 42 |
| [c8_walk1_final.s](verified/c8_walk1_final.s) | out | 32 |
| [c8_walk1_final_mem.s](verified/c8_walk1_final_mem.s) | mem | 42 |
| [c8_walk2_checkpoint.s](verified/c8_walk2_checkpoint.s) | out | 32 |
| [c8_walk2_checkpoint_mem.s](verified/c8_walk2_checkpoint_mem.s) | mem | 42 |
| [c8_walk2_final.s](verified/c8_walk2_final.s) | out | 32 |
| [c8_walk2_final_mem.s](verified/c8_walk2_final_mem.s) | mem | 42 |
| [c8_walk3_checkpoint.s](verified/c8_walk3_checkpoint.s) | out | 32 |
| [c8_walk3_checkpoint_mem.s](verified/c8_walk3_checkpoint_mem.s) | mem | 42 |
| [c8_walk3_final.s](verified/c8_walk3_final.s) | out | 32 |
| [c8_walk3_final_mem.s](verified/c8_walk3_final_mem.s) | mem | 42 |
| [c8_walk4_checkpoint.s](verified/c8_walk4_checkpoint.s) | out | 32 |
| [c8_walk4_checkpoint_mem.s](verified/c8_walk4_checkpoint_mem.s) | mem | 42 |
| [c8_walk4_final.s](verified/c8_walk4_final.s) | out | 32 |
| [c8_walk4_final_mem.s](verified/c8_walk4_final_mem.s) | mem | 42 |
| [mirror10_near_k32.s](verified/mirror10_near_k32.s) | out | 32 |
| [mirror10_near_k32_mem.s](verified/mirror10_near_k32_mem.s) | mem | 42 |
| [mirror_test_k33.s](verified/mirror_test_k33.s) | out | 33 |
| [mirror_test_k33_mem.s](verified/mirror_test_k33_mem.s) | mem | 43 |
| [palette_c8_k32.s](verified/palette_c8_k32.s) | out | 32 |
| [palette_c8_k32_mem.s](verified/palette_c8_k32_mem.s) | mem | 42 |
| [seed00_baseline.s](verified/seed00_baseline.s) | out | 32 |
| [seed00_baseline_mem.s](verified/seed00_baseline_mem.s) | mem | 42 |
| [walk00_checkpoint.s](verified/walk00_checkpoint.s) | out | 32 |
| [walk00_checkpoint_mem.s](verified/walk00_checkpoint_mem.s) | mem | 42 |
| [walk00_final.s](verified/walk00_final.s) | out | 32 |
| [walk00_final_mem.s](verified/walk00_final_mem.s) | mem | 42 |
| [walk27repair_checkpoint.s](verified/walk27repair_checkpoint.s) | out | 32 |
| [walk27repair_checkpoint_mem.s](verified/walk27repair_checkpoint_mem.s) | mem | 42 |
| [walk27repair_final.s](verified/walk27repair_final.s) | out | 32 |
| [walk27repair_final_mem.s](verified/walk27repair_final_mem.s) | mem | 42 |
| [walk30_checkpoint.s](verified/walk30_checkpoint.s) | out | 32 |
| [walk30_checkpoint_mem.s](verified/walk30_checkpoint_mem.s) | mem | 42 |
| [walk30_delete_k32.s](verified/walk30_delete_k32.s) | out | 32 |
| [walk30_delete_k32_mem.s](verified/walk30_delete_k32_mem.s) | mem | 42 |
| [walk30_final.s](verified/walk30_final.s) | out | 32 |
| [walk30_final_mem.s](verified/walk30_final_mem.s) | mem | 42 |

These identical source paths also received a direct reference-judge PASS:
- `candidates/mirror_test_k33.s`
- `candidates/walk00_final.s`

## Limits

These are bounded search results. They do not establish a lower bound for arbitrary programs.
The correct-program walks are stochastic. The exact repair neighborhoods have the stated edit and register limits.
The palette compilers do not consider arbitrary new conditional values, repeated value construction, or arbitrary comparison changes.
The mirror result covers the stated comparator symmetry only.

## Conclusion

The target total length of 41 remains open in this run. The main useful result is a strict PASS sort5 core with eight comparisons
and k=32, in several MOV/CMOV count forms. Its memory length equals 42.
The complete scripts, seeds, candidate files, judge outputs, and search counts are in this folder.


## Round 2: eight-comparison repairs

No program with k<=31 received a strict judge PASS in this round.

### Method

Read the round-1 result first. Used the 18 immutable w6 representatives and `verified/palette_c8_k32.s`. The source list is `round2/manifest.json`. The search did not rerun network enumeration, dagx, lattice search, or the earlier solver exclusions.

All round-2 search, compilation, and judge commands used `nice -n 19`. At most two CPU jobs ran at one time. The inherited CPU affinity was 76-77. All new files are under this worker folder.

The independent simulator from round 1 supplied the filter and full checks. The filter uses 16 concrete cases. The full check uses all 541 weak orders and conservative unknown values. The search can choose output snapshots again after each edit. Each register alphabet includes all seed registers and one fresh register. Self operands are included.

### CMOV value reuse

The 19 seeds contain 382 conditional moves. None is a no-op on all weak orders. Two conditional-move results already exist in another register. With zero-based core numbering, they are instruction 8 of `../w6/verified/c8_26e49cf60c846007.s` and instruction 5 of `../w6/verified/c8_b71830c38f98f13.s`. Both results equal their source register. The audit is `round2/cmov_audit.json`.

The register reuse scan deletes one non-comparison instruction. It then redirects or exchanges the deleted destination with each other register from the deletion point to each later instruction boundary. A third form redirects explicit reads only. This scan tested 49,286 candidates over 19 seeds. It found no shorter core.

### Bounded repairs

Each row below completed on all 19 seeds. Counts are candidate tests. The counts include duplicates across repair neighborhoods.

| Repair neighborhood | Candidate tests | Filter survivors |
|---|---:|---:|
| Delete one; then delete two and insert one at every gap | 156,190,016 | 10,397 |
| Delete CMOV; change one CMP and one surviving CMOV | 1,848,398,736 | 44,402 |
| Delete CMOV; change two surviving CMOVs | 8,432,268,096 | 7,071 |
| Delete CMP; reselect following predicates; optional one class-preserving substitution outside that block | 112,208,000 | 0 |
| Delete CMOV; replace one CMP; reselect every predicate before the next CMP | 25,739,000 | 334 |
| Remaining deletion plus two class-preserving substitutions | 8,336,122,428 | 23,971 |

The remaining-substitution scan covers MOV/MOV, MOV/CMP, MOV/CMOV, and CMP/CMP repairs after CMOV deletion. After MOV or CMP deletion it covers every pair of the three instruction classes. A CMOV substitution can select any of the four legal conditions. The other two classes retain their opcode. The flag scans can change more than three instruction lines when a block has several conditional moves.

No candidate in these scans passed the full simulator. Logs are `round2/logs/[00-18]_{repair,repair3,cmov3}.log` and `round2/logs/[00-18]_flag_{other,cmp,cmov}.log`.

### Correct-program walks

Every accepted state passed the independent full check. Distinct-list counts use 64-bit hashes after scratch-register name normalization. Each new normalized instruction list received a deletion check. Every 2,000 new lists received the register reuse scan and one rotating repair scan. The rotating scans were flag reuse after CMP deletion, flag repair after CMOV deletion, CMP/CMOV repair, and two-delete/one-insert repair. Extra moves can change all predicates in a comparison block, move a CMOV across a CMP, move a CMP, or exchange registers over a bounded interval.

| Run | Proposals | Accepted transitions | Distinct instruction lists | Repair checkpoints | Candidate tests |
|---|---:|---:|---:|---:|---:|
| walk_03 | 35,159,606 | 383,063 | 340,000 | 170 | 5,844,197,926 |
| walk_07 | 47,974,527 | 530,893 | 494,000 | 247 | 5,834,800,390 |
| walk_15 | 47,910,697 | 576,298 | 534,000 | 267 | 6,014,790,172 |
| walk_18 | 24,360,104 | 306,936 | 262,000 | 131 | 6,179,947,865 |

The retained-state audit identifies 18 comparison structures in the seed set. The eight saved walk states contain three additional variants over all 541 weak orders. The differences occur only when inputs contain equal values. On the 120 orders with distinct input values, every saved structure belongs to an existing seed class. All compared operand values are defined by the inputs. The audit identifies input renaming, value-order reversal, and reversal of individual comparisons. It covers the saved states only. The structure identifiers and file paths are in `round2/comparison_structures.json`.

The walks `walk_03` and `walk_15` start from the two seeds with duplicate CMOV results. The walk `walk_07` starts from the two-MOV representative. The walk `walk_18` starts from the palette route. The walks found no core with k<=31. Parameters are in `round2/walk_batch.py`. Detailed counts are in `round2/summary.json`.

### Strict judge results

The predicate enumerator returned a positive control for each seed. All 19 controls passed both strict judges. The final walk states and their last checkpoints also passed both strict judges. Every result below has k=32 in the out model or L=42 in the memory model. The complete judge text is in `round2/logs/judge_<stem>.log` and `round2/verify_ledger.jsonl`.

| PASS file | Model | Length |
|---|---|---:|
| [round2/verified/00_flag_control_k32.s](round2/verified/00_flag_control_k32.s) | out | 32 |
| [round2/verified/00_flag_control_k32_mem.s](round2/verified/00_flag_control_k32_mem.s) | mem | 42 |
| [round2/verified/01_flag_control_k32.s](round2/verified/01_flag_control_k32.s) | out | 32 |
| [round2/verified/01_flag_control_k32_mem.s](round2/verified/01_flag_control_k32_mem.s) | mem | 42 |
| [round2/verified/02_flag_control_k32.s](round2/verified/02_flag_control_k32.s) | out | 32 |
| [round2/verified/02_flag_control_k32_mem.s](round2/verified/02_flag_control_k32_mem.s) | mem | 42 |
| [round2/verified/03_flag_control_k32.s](round2/verified/03_flag_control_k32.s) | out | 32 |
| [round2/verified/03_flag_control_k32_mem.s](round2/verified/03_flag_control_k32_mem.s) | mem | 42 |
| [round2/verified/04_flag_control_k32.s](round2/verified/04_flag_control_k32.s) | out | 32 |
| [round2/verified/04_flag_control_k32_mem.s](round2/verified/04_flag_control_k32_mem.s) | mem | 42 |
| [round2/verified/05_flag_control_k32.s](round2/verified/05_flag_control_k32.s) | out | 32 |
| [round2/verified/05_flag_control_k32_mem.s](round2/verified/05_flag_control_k32_mem.s) | mem | 42 |
| [round2/verified/06_flag_control_k32.s](round2/verified/06_flag_control_k32.s) | out | 32 |
| [round2/verified/06_flag_control_k32_mem.s](round2/verified/06_flag_control_k32_mem.s) | mem | 42 |
| [round2/verified/07_flag_control_k32.s](round2/verified/07_flag_control_k32.s) | out | 32 |
| [round2/verified/07_flag_control_k32_mem.s](round2/verified/07_flag_control_k32_mem.s) | mem | 42 |
| [round2/verified/08_flag_control_k32.s](round2/verified/08_flag_control_k32.s) | out | 32 |
| [round2/verified/08_flag_control_k32_mem.s](round2/verified/08_flag_control_k32_mem.s) | mem | 42 |
| [round2/verified/09_flag_control_k32.s](round2/verified/09_flag_control_k32.s) | out | 32 |
| [round2/verified/09_flag_control_k32_mem.s](round2/verified/09_flag_control_k32_mem.s) | mem | 42 |
| [round2/verified/10_flag_control_k32.s](round2/verified/10_flag_control_k32.s) | out | 32 |
| [round2/verified/10_flag_control_k32_mem.s](round2/verified/10_flag_control_k32_mem.s) | mem | 42 |
| [round2/verified/11_flag_control_k32.s](round2/verified/11_flag_control_k32.s) | out | 32 |
| [round2/verified/11_flag_control_k32_mem.s](round2/verified/11_flag_control_k32_mem.s) | mem | 42 |
| [round2/verified/12_flag_control_k32.s](round2/verified/12_flag_control_k32.s) | out | 32 |
| [round2/verified/12_flag_control_k32_mem.s](round2/verified/12_flag_control_k32_mem.s) | mem | 42 |
| [round2/verified/13_flag_control_k32.s](round2/verified/13_flag_control_k32.s) | out | 32 |
| [round2/verified/13_flag_control_k32_mem.s](round2/verified/13_flag_control_k32_mem.s) | mem | 42 |
| [round2/verified/14_flag_control_k32.s](round2/verified/14_flag_control_k32.s) | out | 32 |
| [round2/verified/14_flag_control_k32_mem.s](round2/verified/14_flag_control_k32_mem.s) | mem | 42 |
| [round2/verified/15_flag_control_k32.s](round2/verified/15_flag_control_k32.s) | out | 32 |
| [round2/verified/15_flag_control_k32_mem.s](round2/verified/15_flag_control_k32_mem.s) | mem | 42 |
| [round2/verified/16_flag_control_k32.s](round2/verified/16_flag_control_k32.s) | out | 32 |
| [round2/verified/16_flag_control_k32_mem.s](round2/verified/16_flag_control_k32_mem.s) | mem | 42 |
| [round2/verified/17_flag_control_k32.s](round2/verified/17_flag_control_k32.s) | out | 32 |
| [round2/verified/17_flag_control_k32_mem.s](round2/verified/17_flag_control_k32_mem.s) | mem | 42 |
| [round2/verified/18_flag_control_k32.s](round2/verified/18_flag_control_k32.s) | out | 32 |
| [round2/verified/18_flag_control_k32_mem.s](round2/verified/18_flag_control_k32_mem.s) | mem | 42 |
| [round2/verified/walk_03_checkpoint.s](round2/verified/walk_03_checkpoint.s) | out | 32 |
| [round2/verified/walk_03_checkpoint_mem.s](round2/verified/walk_03_checkpoint_mem.s) | mem | 42 |
| [round2/verified/walk_03_final.s](round2/verified/walk_03_final.s) | out | 32 |
| [round2/verified/walk_03_final_mem.s](round2/verified/walk_03_final_mem.s) | mem | 42 |
| [round2/verified/walk_07_checkpoint.s](round2/verified/walk_07_checkpoint.s) | out | 32 |
| [round2/verified/walk_07_checkpoint_mem.s](round2/verified/walk_07_checkpoint_mem.s) | mem | 42 |
| [round2/verified/walk_07_final.s](round2/verified/walk_07_final.s) | out | 32 |
| [round2/verified/walk_07_final_mem.s](round2/verified/walk_07_final_mem.s) | mem | 42 |
| [round2/verified/walk_15_checkpoint.s](round2/verified/walk_15_checkpoint.s) | out | 32 |
| [round2/verified/walk_15_checkpoint_mem.s](round2/verified/walk_15_checkpoint_mem.s) | mem | 42 |
| [round2/verified/walk_15_final.s](round2/verified/walk_15_final.s) | out | 32 |
| [round2/verified/walk_15_final_mem.s](round2/verified/walk_15_final_mem.s) | mem | 42 |
| [round2/verified/walk_18_checkpoint.s](round2/verified/walk_18_checkpoint.s) | out | 32 |
| [round2/verified/walk_18_checkpoint_mem.s](round2/verified/walk_18_checkpoint_mem.s) | mem | 42 |
| [round2/verified/walk_18_final.s](round2/verified/walk_18_final.s) | out | 32 |
| [round2/verified/walk_18_final_mem.s](round2/verified/walk_18_final_mem.s) | mem | 42 |

### Limits

These results concern finite edit alphabets and sampled correct-program walks. The conservative unknown-value check can reject valid programs that depend on correlations involving scratch values. No lower bound for arbitrary programs follows. The total-length target of 41 remains open.

Round-2 totals: 18,910,926,276 bounded repair tests, 49,286 initial register reuse tests, and 23,873,736,353 walk candidate tests. The four walks recorded 1,630,000 instruction lists and 815 repair checkpoints. Each walk removes duplicate lists within its own run. The final file audit checked all 54 retained PASS files and their judge logs. File hashes are in `round2/verified_integrity.json`.


## Round 3: near-miss repair and two-MOV removal

This round completed. No k<=31 program received a strict judge PASS.

Read the round-1 and round-2 results before starting. Used the frozen 14-case and 30-case w6 near-misses and all 143 new w6 representatives. The source hashes and MOV counts are in `round3/manifest.json`. Every search, compiler, and judge command uses `nice -n 19`. At most two CPU jobs run at one time. CPU affinity remains 76-77. The solver has a 2,900 MiB address-space limit. All writes remain in w5.

The complete two-MOV removal scan deletes each MOV pair and tries one arbitrary legal instruction at each gap. It also checks the 30-instruction core after both deletions. This scan tested 7,019,319 candidates across 143 programs. Its 16-case filter admitted 23 candidates. None passed the full independent check. The log is `round3/logs/two_mov_insert.log`.

A wider scan adds one source-operand change to a surviving instruction. For a CMP, either operand can change. The insertion still has any opcode, destination, and source. This scan tested 2,276,695,479 candidates. Its filter admitted 294 candidates. None passed the full independent check. The log is `round3/logs/two_mov_source_insert.log`. The two scans overlap. The 15 representatives with fewer than two MOV instructions have no eligible MOV pair.

The exact near-miss repair scan replaces at most two entire instructions. Replacements can use any of the six opcodes and any seed register or one fresh register. It chooses outputs again from snapshots. It tested 109,394,660 candidates for each frozen near-miss. For the 14-case seed, the filter admitted 638 candidates. For the 30-case seed, it admitted 50 candidates. None passed the full check. See `round3/logs/near14_exact2.log` and `round3/logs/near30_exact2.log`.

The independent SAT query for at most two instruction changes in the 14-case seed returned UNSAT in 143.23 seconds. It used 26 weak orders, the same register alphabet, and free output snapshots. SAT fixes initial scratch values to a top sentinel and initial flags to equal. Its negative result concerns this bounded query only. The log is `round3/logs/near14_general2.log`.

The SAT positive control returned the known 32-instruction core. Both strict judges passed. PASS files: `round3/verified/sat_control32.s` (out, k=32) and `round3/verified/sat_control32_mem.s` (mem, L=42). Logs: `round3/logs/judge_sat_control32.log` and `round3/logs/judge_sat_control32_mem.log`.

The three-instruction query and further source and suffix repairs ran with wall limits. The completed results appear below. These local searches do not establish a lower bound for arbitrary programs.


### Round-3 completed result

No k<=31 program received a strict judge PASS. No new near-miss improved the 14-case seed.

The additional finite suffix scan changes one CMP and two conditional moves. The first 15 instructions stay fixed. Each changed CMP can choose either operand. Each changed conditional move can choose either operand and any of the four conditions. The scan uses all seed registers and one fresh register. Outputs can select new snapshots. All 264 eligible instruction triples finished. The scan tested 2,203,428,480 candidates. None passed the 16-case concrete filter. See `round3/logs/near14_suffix_cmp2cmov.log`.

The near-miss scoring check rescored the 638 filter survivors from the 14-case seed's two-instruction repair scan. It selected the least-error snapshot for each output on all 541 weak orders. None improved the seed's 18 output errors across 14 failed weak orders. This check repeats the 109,394,660 candidate enumeration for scoring. Its counts overlap the earlier scan. See `round3/logs/near14_exact2_scored.log`.

The second SAT transition encoding represents concrete ranks with three bits. It uses the same instruction selectors as the first encoder. Its transition relation is separate. A scalar execution check covered 80 random programs and 400 input cases. All 7,200 instruction-result values matched. The solver rejected 80 deliberately wrong result bits. These checks validate sampled behavior; they are not a proof of the encoder.

The solver results below include all completed queries and time limits. Each query uses a fixed finite register alphabet. Initial scratch values are one top sentinel, and initial flags are equal. Outputs are free snapshots except where stated. UNSAT concerns only the stated query. A time limit is unknown.

| Query | Result | Seconds or wall limit | Log |
|---|---|---:|---|
| 14-case seed; at most two complete instruction changes | UNSAT, 26 weak orders | 143.23 | `round3/logs/near14_general2.log` |
| 14-case seed; at most three complete instruction changes | unknown, time limit | 900 | `round3/logs/near14_general3.log` |
| 14-case seed; all sources, CMP operands, and predicates free; write destinations and classes fixed | unknown, time limit | 180 | `round3/logs/near14_sources_all.log` |
| 14-case seed; at most four complete suffix changes; first 15 instructions and output snapshots fixed | UNSAT | 19.92 | `round3/logs/near14_suffix4.log` |
| 14-case seed; at most four changes with instruction classes fixed | unknown, time limit | 180 | `round3/logs/near14_classes4.log` |
| 30-case seed; at most three complete instruction changes | unknown, time limit | 300 | `round3/logs/near30_general3.log` |
| 14-case seed; at most four complete instruction changes | unknown, time limit | 300 | `round3/logs/near14_general4.log` |
| 14-case seed; at most three complete changes; three-bit transition encoder | unknown, time limit | 300 | `round3/logs/rank_near14_general3.log` |
| 14-case seed; at most six complete suffix changes; first 15 instructions and output snapshots fixed; three-bit encoder | unknown, time limit | 180 | `round3/logs/rank_near14_suffix6.log` |

Every new strict PASS file is listed below. Both controls retain k=32. Their memory versions retain 42 instructions. They do not meet the requested length of 41.

| PASS file | Model | Length | Judge log |
|---|---|---:|---|
| [round3/verified/rank_control32.s](round3/verified/rank_control32.s) | out | 32 | `round3/logs/judge_rank_control32.log` |
| [round3/verified/rank_control32_mem.s](round3/verified/rank_control32_mem.s) | mem | 42 | `round3/logs/judge_rank_control32_mem.log` |
| [round3/verified/sat_control32.s](round3/verified/sat_control32.s) | out | 32 | `round3/logs/judge_sat_control32.log` |
| [round3/verified/sat_control32_mem.s](round3/verified/sat_control32_mem.s) | mem | 42 | `round3/logs/judge_sat_control32_mem.log` |

The conservative full simulator can reject programs that depend on correlations involving scratch values. No such rejected candidate is treated as a strict PASS. The 16-case filter is a concrete necessary-condition check with scratch=7 and equal initial flags. No global lower bound follows from these bounded searches. The requested shorter program remains unfound in this round.

All scan counts, solver commands, source hashes, and retained strict PASS paths are in `round3/summary.json`. The judge ledger is `round3/judge_ledger.jsonl`. All round-3 processes have finished.


## Round 4: compare removal through flag reuse and restart walks

### Purpose

Find a core with k<=31 by removing a comparison and reusing earlier flags. Explore new programs through random restarts.

No k<=31 core received a strict judge PASS in this round. The best strict PASS core remains k=32, with 42 memory instructions.

### Terms

Core length k counts MOV, CMP, and CMOV instructions. An output snapshot records one register value at one program step. A comparison block starts at a CMP and ends before the next CMP. A comparison column lists one operand value for each weak order. A SAT query asks whether Boolean constraints can all hold. UNSAT means that no assignment satisfies those encoded constraints.

### Method

Read rounds 1–3 first. This round changes the repair neighborhood. It does not rerun dagx, lattice enumeration, fixed-skeleton routing, or the earlier near-miss scans. The frozen manifest has 149 distinct instruction sequences from the 143 w6 round-2 representatives, the six retained w6 no-MOV forms, and the w5 palette form. One sequence overlaps those sources. See `round4/manifest.json`.

All new search, compiler, simulator-check, and judge jobs use nice level 19. At most two CPU jobs run together. CPU affinity is 76–77. Walk, block-repair, and SAT jobs have a 2,800 MiB address-space limit. All writes stay in w5.

#### Fixed-flag value tests

A flag outcome is the equal, less, or greater result of a comparison. With flags fixed, MOV and CMOV can only select an entry register value on each outcome. The first test permits a separate entry source for every target and every flag outcome. It has no write-count limit. It tests removal of each comparison and merger of each adjacent comparison pair. For a merged pair, the remaining comparison can use any entry register pair, including equal operands and a fresh scratch register. Opposite operand orders give the same partitions and need not be repeated.

The completed test checked 2,235 windows and 50,351 remaining-comparison operand pairs. No window passed its necessary value test. Its required values preserve each later register read and each original output snapshot. The later test uses per-case dependencies through the suffix. It preserves the original suffix branches and only the values that those branches need. It checked the same 2,235 windows. No window passed. These results exclude the stated value-preserving replacements. They do not exclude arbitrary output-equivalent suffix changes. Both tests use scratch=7 and initial flags equal. Audit data: `round4/flag_audit.json`, `round4/masked_audit.json`.

Each audit accepted all 1,192 original comparison blocks when their own flags were restored. The folded SAT transition encoding matched scalar execution on 100 random programs, 500 cases, and 9,000 instruction-result values. It rejected 100 deliberately wrong result bits. These sampled checks are not encoding proofs. See `round4/logs/test_audit.log` and `round4/logs/test_fold.log`.

#### Completed finite block repairs

The new exact enumeration deletes one comparison and reuses the previous flags. Until the next comparison, every write can choose MOV or any of the four CMOV predicates. One selected write can also choose any source and destination from the seed registers plus one fresh register. Equal operands are included. Outputs can select new snapshots. The enumeration finished all 149 seeds and tested 347,656,550 candidates. The concrete 16-case filter admitted 3,318. None passed the full independent simulator. Counts include duplicate programs from different selected-write positions. Log: `round4/logs/block_repair.log`.

This scan differs from round 2 because it changes operands inside the removed comparison block and permits every block write to change between MOV and CMOV. The positive control duplicates one comparison, then removes a duplicate. The returned k=32 core passed both strict judges.

The same finite scan also finished one representative of each of the 197 comparison-column forms absent from the frozen seeds. It tested 407,357,775 candidates. The filter admitted 3,173. None passed the full independent simulator. The new source hashes are in `round4/novel_manifest.json`. Log: `round4/logs/novel_block_repair.log`.

#### Correct-program walks

Each accepted state passed the independent simulator on all 541 weak orders with conservative unknown scratch values and flags. Distinct-list counts use 64-bit hashes after scratch-register normalization. Every retained assembly sample listed below passed both reference judges. Internal states have simulator checks only.

| Run | Proposals | Accepted transitions | Distinct instruction lists | Restarts | Candidate tests | Wall seconds |
|---|---:|---:|---:|---:|---:|---:|
| Fixed length 32 | 177,568,248 | 12,246,001 | 10,316,562 | 2,450 | 499,077,440 | 600.0 |
| Lengths 32–34 | 202,294,216 | 9,862,410 | 9,363,175 | 986 | 202,689,057 | 600.0 |

The first walk restarts from a random frozen seed after 5,000 accepted transitions. It checks all single deletions in every new instruction list. It proposed 22,193,619 compare-to-write changes, including moved insertions and simultaneous predicate/source repairs. None was accepted. Every new list retained eight comparisons. Whole-block comparison inversion is an allowed neutral move and accounts for many accepted transitions.

The second walk permits insertions and deletions while keeping every state correct. It probes greedy deletion paths on copies after every 100 new lists. It completed 93,631 probes; 50,731 reached length 32. Each probe tries single deletions until it finds a correct one. At the final reached core, it tests every single deletion before stopping. The walk can continue from a longer state. Its length/comparison histogram is in `round4/logs/bridge.log`. Neither stochastic walk is an exhaustive exclusion.

#### SAT queries

The wider SAT queries remove one comparison, free all write operands and write opcodes in the selected window, and retain the seven remaining comparison positions. The remaining comparison operands inside the window are free. The local queries free the preceding block, the removed block, and one following block. They also allow one outside instruction change while retaining every comparison position. The merge queries free the last five original comparison blocks except for the removed comparison. They make no outside changes. Outputs are free snapshots.

Wider-query status counts: `{"UNKNOWN_WALL_LIMIT": 26}`. Each local query has a 20-second wall limit. Each merge query has a 35-second wall limit. The narrower queries keep write destinations fixed, free their sources and conditions inside the same three-block window, and allow no outside edits. Their wall limit is 12 seconds. Narrower-query status counts: `{"UNSAT": 12}`. A wall limit is UNKNOWN and gives no exclusion. The exact commands, register bounds, encoded case counts, and progress are in `round4/solver_results.json`, `round4/narrow_results.json`, and their log paths.

All SAT queries fix initial scratch to a top sentinel and initial flags to equal. New weak orders are added after failed candidates. UNSAT, where reported, concerns only the stated finite query and its encoded weak orders. The k=32 SAT control passed both strict judges.

The final eight queries extend the narrow window by allowing at most one changed write destination. All write sources and conditions in the window remain free. Comparison operands remain free there. Each query has a 15-second wall limit. Status counts: `{"UNKNOWN_WALL_LIMIT": 8}`. The exact commands and logs are in `round4/destination_results.json`.

#### Retained comparison structures

The comparison-column audit checked 770 saved k=32 states. The frozen seeds have 148 classes on all 541 weak orders and 146 classes on the 120 strict input orders. Input permutations, reversed value order, and reversal of comparison operands are identified. The samples contain 197 additional full-order classes; 338 samples have comparison columns outside the known strict-order classes. These counts concern saved states only. No general algorithmic novelty follows from a column identifier. See `round4/comparison_structures.json`.

### Result

The completed ledger contains 1,548 strict PASS files. Every path, model, length, SHA-256 hash, and judge log is in `round4/verified_integrity.json`. Each row below lists the out and memory files. For a core length k, the memory length is k+10. All these lengths remain above the requested target.

| Out PASS file | Memory PASS file | Core k |
|---|---|---:|
| [block_control_found_k32.s](round4/verified/block_control_found_k32.s) | [block_control_found_k32_mem.s](round4/verified/block_control_found_k32_mem.s) | 32 |
| [bridge_checkpoint.s](round4/verified/bridge_checkpoint.s) | [bridge_checkpoint_mem.s](round4/verified/bridge_checkpoint_mem.s) | 32 |
| [bridge_final.s](round4/verified/bridge_final.s) | [bridge_final_mem.s](round4/verified/bridge_final_mem.s) | 34 |
| [bridge_short_sample1.s](round4/verified/bridge_short_sample1.s) | [bridge_short_sample1_mem.s](round4/verified/bridge_short_sample1_mem.s) | 32 |
| [bridge_short_sample10.s](round4/verified/bridge_short_sample10.s) | [bridge_short_sample10_mem.s](round4/verified/bridge_short_sample10_mem.s) | 32 |
| [bridge_short_sample100.s](round4/verified/bridge_short_sample100.s) | [bridge_short_sample100_mem.s](round4/verified/bridge_short_sample100_mem.s) | 32 |
| [bridge_short_sample101.s](round4/verified/bridge_short_sample101.s) | [bridge_short_sample101_mem.s](round4/verified/bridge_short_sample101_mem.s) | 32 |
| [bridge_short_sample102.s](round4/verified/bridge_short_sample102.s) | [bridge_short_sample102_mem.s](round4/verified/bridge_short_sample102_mem.s) | 32 |
| [bridge_short_sample103.s](round4/verified/bridge_short_sample103.s) | [bridge_short_sample103_mem.s](round4/verified/bridge_short_sample103_mem.s) | 32 |
| [bridge_short_sample104.s](round4/verified/bridge_short_sample104.s) | [bridge_short_sample104_mem.s](round4/verified/bridge_short_sample104_mem.s) | 32 |
| [bridge_short_sample105.s](round4/verified/bridge_short_sample105.s) | [bridge_short_sample105_mem.s](round4/verified/bridge_short_sample105_mem.s) | 32 |
| [bridge_short_sample106.s](round4/verified/bridge_short_sample106.s) | [bridge_short_sample106_mem.s](round4/verified/bridge_short_sample106_mem.s) | 32 |
| [bridge_short_sample107.s](round4/verified/bridge_short_sample107.s) | [bridge_short_sample107_mem.s](round4/verified/bridge_short_sample107_mem.s) | 32 |
| [bridge_short_sample108.s](round4/verified/bridge_short_sample108.s) | [bridge_short_sample108_mem.s](round4/verified/bridge_short_sample108_mem.s) | 32 |
| [bridge_short_sample109.s](round4/verified/bridge_short_sample109.s) | [bridge_short_sample109_mem.s](round4/verified/bridge_short_sample109_mem.s) | 32 |
| [bridge_short_sample11.s](round4/verified/bridge_short_sample11.s) | [bridge_short_sample11_mem.s](round4/verified/bridge_short_sample11_mem.s) | 32 |
| [bridge_short_sample110.s](round4/verified/bridge_short_sample110.s) | [bridge_short_sample110_mem.s](round4/verified/bridge_short_sample110_mem.s) | 32 |
| [bridge_short_sample111.s](round4/verified/bridge_short_sample111.s) | [bridge_short_sample111_mem.s](round4/verified/bridge_short_sample111_mem.s) | 32 |
| [bridge_short_sample112.s](round4/verified/bridge_short_sample112.s) | [bridge_short_sample112_mem.s](round4/verified/bridge_short_sample112_mem.s) | 32 |
| [bridge_short_sample113.s](round4/verified/bridge_short_sample113.s) | [bridge_short_sample113_mem.s](round4/verified/bridge_short_sample113_mem.s) | 32 |
| [bridge_short_sample114.s](round4/verified/bridge_short_sample114.s) | [bridge_short_sample114_mem.s](round4/verified/bridge_short_sample114_mem.s) | 32 |
| [bridge_short_sample115.s](round4/verified/bridge_short_sample115.s) | [bridge_short_sample115_mem.s](round4/verified/bridge_short_sample115_mem.s) | 32 |
| [bridge_short_sample116.s](round4/verified/bridge_short_sample116.s) | [bridge_short_sample116_mem.s](round4/verified/bridge_short_sample116_mem.s) | 32 |
| [bridge_short_sample117.s](round4/verified/bridge_short_sample117.s) | [bridge_short_sample117_mem.s](round4/verified/bridge_short_sample117_mem.s) | 32 |
| [bridge_short_sample118.s](round4/verified/bridge_short_sample118.s) | [bridge_short_sample118_mem.s](round4/verified/bridge_short_sample118_mem.s) | 32 |
| [bridge_short_sample119.s](round4/verified/bridge_short_sample119.s) | [bridge_short_sample119_mem.s](round4/verified/bridge_short_sample119_mem.s) | 32 |
| [bridge_short_sample12.s](round4/verified/bridge_short_sample12.s) | [bridge_short_sample12_mem.s](round4/verified/bridge_short_sample12_mem.s) | 32 |
| [bridge_short_sample120.s](round4/verified/bridge_short_sample120.s) | [bridge_short_sample120_mem.s](round4/verified/bridge_short_sample120_mem.s) | 32 |
| [bridge_short_sample121.s](round4/verified/bridge_short_sample121.s) | [bridge_short_sample121_mem.s](round4/verified/bridge_short_sample121_mem.s) | 32 |
| [bridge_short_sample122.s](round4/verified/bridge_short_sample122.s) | [bridge_short_sample122_mem.s](round4/verified/bridge_short_sample122_mem.s) | 32 |
| [bridge_short_sample123.s](round4/verified/bridge_short_sample123.s) | [bridge_short_sample123_mem.s](round4/verified/bridge_short_sample123_mem.s) | 32 |
| [bridge_short_sample124.s](round4/verified/bridge_short_sample124.s) | [bridge_short_sample124_mem.s](round4/verified/bridge_short_sample124_mem.s) | 32 |
| [bridge_short_sample125.s](round4/verified/bridge_short_sample125.s) | [bridge_short_sample125_mem.s](round4/verified/bridge_short_sample125_mem.s) | 32 |
| [bridge_short_sample126.s](round4/verified/bridge_short_sample126.s) | [bridge_short_sample126_mem.s](round4/verified/bridge_short_sample126_mem.s) | 32 |
| [bridge_short_sample127.s](round4/verified/bridge_short_sample127.s) | [bridge_short_sample127_mem.s](round4/verified/bridge_short_sample127_mem.s) | 32 |
| [bridge_short_sample128.s](round4/verified/bridge_short_sample128.s) | [bridge_short_sample128_mem.s](round4/verified/bridge_short_sample128_mem.s) | 32 |
| [bridge_short_sample129.s](round4/verified/bridge_short_sample129.s) | [bridge_short_sample129_mem.s](round4/verified/bridge_short_sample129_mem.s) | 32 |
| [bridge_short_sample13.s](round4/verified/bridge_short_sample13.s) | [bridge_short_sample13_mem.s](round4/verified/bridge_short_sample13_mem.s) | 32 |
| [bridge_short_sample130.s](round4/verified/bridge_short_sample130.s) | [bridge_short_sample130_mem.s](round4/verified/bridge_short_sample130_mem.s) | 32 |
| [bridge_short_sample131.s](round4/verified/bridge_short_sample131.s) | [bridge_short_sample131_mem.s](round4/verified/bridge_short_sample131_mem.s) | 32 |
| [bridge_short_sample132.s](round4/verified/bridge_short_sample132.s) | [bridge_short_sample132_mem.s](round4/verified/bridge_short_sample132_mem.s) | 32 |
| [bridge_short_sample133.s](round4/verified/bridge_short_sample133.s) | [bridge_short_sample133_mem.s](round4/verified/bridge_short_sample133_mem.s) | 32 |
| [bridge_short_sample134.s](round4/verified/bridge_short_sample134.s) | [bridge_short_sample134_mem.s](round4/verified/bridge_short_sample134_mem.s) | 32 |
| [bridge_short_sample135.s](round4/verified/bridge_short_sample135.s) | [bridge_short_sample135_mem.s](round4/verified/bridge_short_sample135_mem.s) | 32 |
| [bridge_short_sample136.s](round4/verified/bridge_short_sample136.s) | [bridge_short_sample136_mem.s](round4/verified/bridge_short_sample136_mem.s) | 32 |
| [bridge_short_sample137.s](round4/verified/bridge_short_sample137.s) | [bridge_short_sample137_mem.s](round4/verified/bridge_short_sample137_mem.s) | 32 |
| [bridge_short_sample138.s](round4/verified/bridge_short_sample138.s) | [bridge_short_sample138_mem.s](round4/verified/bridge_short_sample138_mem.s) | 32 |
| [bridge_short_sample139.s](round4/verified/bridge_short_sample139.s) | [bridge_short_sample139_mem.s](round4/verified/bridge_short_sample139_mem.s) | 32 |
| [bridge_short_sample14.s](round4/verified/bridge_short_sample14.s) | [bridge_short_sample14_mem.s](round4/verified/bridge_short_sample14_mem.s) | 32 |
| [bridge_short_sample140.s](round4/verified/bridge_short_sample140.s) | [bridge_short_sample140_mem.s](round4/verified/bridge_short_sample140_mem.s) | 32 |
| [bridge_short_sample141.s](round4/verified/bridge_short_sample141.s) | [bridge_short_sample141_mem.s](round4/verified/bridge_short_sample141_mem.s) | 32 |
| [bridge_short_sample142.s](round4/verified/bridge_short_sample142.s) | [bridge_short_sample142_mem.s](round4/verified/bridge_short_sample142_mem.s) | 32 |
| [bridge_short_sample143.s](round4/verified/bridge_short_sample143.s) | [bridge_short_sample143_mem.s](round4/verified/bridge_short_sample143_mem.s) | 32 |
| [bridge_short_sample144.s](round4/verified/bridge_short_sample144.s) | [bridge_short_sample144_mem.s](round4/verified/bridge_short_sample144_mem.s) | 32 |
| [bridge_short_sample145.s](round4/verified/bridge_short_sample145.s) | [bridge_short_sample145_mem.s](round4/verified/bridge_short_sample145_mem.s) | 32 |
| [bridge_short_sample146.s](round4/verified/bridge_short_sample146.s) | [bridge_short_sample146_mem.s](round4/verified/bridge_short_sample146_mem.s) | 32 |
| [bridge_short_sample147.s](round4/verified/bridge_short_sample147.s) | [bridge_short_sample147_mem.s](round4/verified/bridge_short_sample147_mem.s) | 32 |
| [bridge_short_sample148.s](round4/verified/bridge_short_sample148.s) | [bridge_short_sample148_mem.s](round4/verified/bridge_short_sample148_mem.s) | 32 |
| [bridge_short_sample149.s](round4/verified/bridge_short_sample149.s) | [bridge_short_sample149_mem.s](round4/verified/bridge_short_sample149_mem.s) | 32 |
| [bridge_short_sample15.s](round4/verified/bridge_short_sample15.s) | [bridge_short_sample15_mem.s](round4/verified/bridge_short_sample15_mem.s) | 32 |
| [bridge_short_sample150.s](round4/verified/bridge_short_sample150.s) | [bridge_short_sample150_mem.s](round4/verified/bridge_short_sample150_mem.s) | 32 |
| [bridge_short_sample151.s](round4/verified/bridge_short_sample151.s) | [bridge_short_sample151_mem.s](round4/verified/bridge_short_sample151_mem.s) | 32 |
| [bridge_short_sample152.s](round4/verified/bridge_short_sample152.s) | [bridge_short_sample152_mem.s](round4/verified/bridge_short_sample152_mem.s) | 32 |
| [bridge_short_sample153.s](round4/verified/bridge_short_sample153.s) | [bridge_short_sample153_mem.s](round4/verified/bridge_short_sample153_mem.s) | 32 |
| [bridge_short_sample154.s](round4/verified/bridge_short_sample154.s) | [bridge_short_sample154_mem.s](round4/verified/bridge_short_sample154_mem.s) | 32 |
| [bridge_short_sample155.s](round4/verified/bridge_short_sample155.s) | [bridge_short_sample155_mem.s](round4/verified/bridge_short_sample155_mem.s) | 32 |
| [bridge_short_sample156.s](round4/verified/bridge_short_sample156.s) | [bridge_short_sample156_mem.s](round4/verified/bridge_short_sample156_mem.s) | 32 |
| [bridge_short_sample157.s](round4/verified/bridge_short_sample157.s) | [bridge_short_sample157_mem.s](round4/verified/bridge_short_sample157_mem.s) | 32 |
| [bridge_short_sample158.s](round4/verified/bridge_short_sample158.s) | [bridge_short_sample158_mem.s](round4/verified/bridge_short_sample158_mem.s) | 32 |
| [bridge_short_sample159.s](round4/verified/bridge_short_sample159.s) | [bridge_short_sample159_mem.s](round4/verified/bridge_short_sample159_mem.s) | 32 |
| [bridge_short_sample16.s](round4/verified/bridge_short_sample16.s) | [bridge_short_sample16_mem.s](round4/verified/bridge_short_sample16_mem.s) | 32 |
| [bridge_short_sample160.s](round4/verified/bridge_short_sample160.s) | [bridge_short_sample160_mem.s](round4/verified/bridge_short_sample160_mem.s) | 32 |
| [bridge_short_sample161.s](round4/verified/bridge_short_sample161.s) | [bridge_short_sample161_mem.s](round4/verified/bridge_short_sample161_mem.s) | 32 |
| [bridge_short_sample162.s](round4/verified/bridge_short_sample162.s) | [bridge_short_sample162_mem.s](round4/verified/bridge_short_sample162_mem.s) | 32 |
| [bridge_short_sample163.s](round4/verified/bridge_short_sample163.s) | [bridge_short_sample163_mem.s](round4/verified/bridge_short_sample163_mem.s) | 32 |
| [bridge_short_sample164.s](round4/verified/bridge_short_sample164.s) | [bridge_short_sample164_mem.s](round4/verified/bridge_short_sample164_mem.s) | 32 |
| [bridge_short_sample165.s](round4/verified/bridge_short_sample165.s) | [bridge_short_sample165_mem.s](round4/verified/bridge_short_sample165_mem.s) | 32 |
| [bridge_short_sample166.s](round4/verified/bridge_short_sample166.s) | [bridge_short_sample166_mem.s](round4/verified/bridge_short_sample166_mem.s) | 32 |
| [bridge_short_sample167.s](round4/verified/bridge_short_sample167.s) | [bridge_short_sample167_mem.s](round4/verified/bridge_short_sample167_mem.s) | 32 |
| [bridge_short_sample168.s](round4/verified/bridge_short_sample168.s) | [bridge_short_sample168_mem.s](round4/verified/bridge_short_sample168_mem.s) | 32 |
| [bridge_short_sample169.s](round4/verified/bridge_short_sample169.s) | [bridge_short_sample169_mem.s](round4/verified/bridge_short_sample169_mem.s) | 32 |
| [bridge_short_sample17.s](round4/verified/bridge_short_sample17.s) | [bridge_short_sample17_mem.s](round4/verified/bridge_short_sample17_mem.s) | 32 |
| [bridge_short_sample170.s](round4/verified/bridge_short_sample170.s) | [bridge_short_sample170_mem.s](round4/verified/bridge_short_sample170_mem.s) | 32 |
| [bridge_short_sample171.s](round4/verified/bridge_short_sample171.s) | [bridge_short_sample171_mem.s](round4/verified/bridge_short_sample171_mem.s) | 32 |
| [bridge_short_sample172.s](round4/verified/bridge_short_sample172.s) | [bridge_short_sample172_mem.s](round4/verified/bridge_short_sample172_mem.s) | 32 |
| [bridge_short_sample173.s](round4/verified/bridge_short_sample173.s) | [bridge_short_sample173_mem.s](round4/verified/bridge_short_sample173_mem.s) | 32 |
| [bridge_short_sample174.s](round4/verified/bridge_short_sample174.s) | [bridge_short_sample174_mem.s](round4/verified/bridge_short_sample174_mem.s) | 32 |
| [bridge_short_sample175.s](round4/verified/bridge_short_sample175.s) | [bridge_short_sample175_mem.s](round4/verified/bridge_short_sample175_mem.s) | 32 |
| [bridge_short_sample176.s](round4/verified/bridge_short_sample176.s) | [bridge_short_sample176_mem.s](round4/verified/bridge_short_sample176_mem.s) | 32 |
| [bridge_short_sample177.s](round4/verified/bridge_short_sample177.s) | [bridge_short_sample177_mem.s](round4/verified/bridge_short_sample177_mem.s) | 32 |
| [bridge_short_sample178.s](round4/verified/bridge_short_sample178.s) | [bridge_short_sample178_mem.s](round4/verified/bridge_short_sample178_mem.s) | 32 |
| [bridge_short_sample179.s](round4/verified/bridge_short_sample179.s) | [bridge_short_sample179_mem.s](round4/verified/bridge_short_sample179_mem.s) | 32 |
| [bridge_short_sample18.s](round4/verified/bridge_short_sample18.s) | [bridge_short_sample18_mem.s](round4/verified/bridge_short_sample18_mem.s) | 32 |
| [bridge_short_sample180.s](round4/verified/bridge_short_sample180.s) | [bridge_short_sample180_mem.s](round4/verified/bridge_short_sample180_mem.s) | 32 |
| [bridge_short_sample181.s](round4/verified/bridge_short_sample181.s) | [bridge_short_sample181_mem.s](round4/verified/bridge_short_sample181_mem.s) | 32 |
| [bridge_short_sample182.s](round4/verified/bridge_short_sample182.s) | [bridge_short_sample182_mem.s](round4/verified/bridge_short_sample182_mem.s) | 32 |
| [bridge_short_sample183.s](round4/verified/bridge_short_sample183.s) | [bridge_short_sample183_mem.s](round4/verified/bridge_short_sample183_mem.s) | 32 |
| [bridge_short_sample184.s](round4/verified/bridge_short_sample184.s) | [bridge_short_sample184_mem.s](round4/verified/bridge_short_sample184_mem.s) | 32 |
| [bridge_short_sample185.s](round4/verified/bridge_short_sample185.s) | [bridge_short_sample185_mem.s](round4/verified/bridge_short_sample185_mem.s) | 32 |
| [bridge_short_sample186.s](round4/verified/bridge_short_sample186.s) | [bridge_short_sample186_mem.s](round4/verified/bridge_short_sample186_mem.s) | 32 |
| [bridge_short_sample187.s](round4/verified/bridge_short_sample187.s) | [bridge_short_sample187_mem.s](round4/verified/bridge_short_sample187_mem.s) | 32 |
| [bridge_short_sample188.s](round4/verified/bridge_short_sample188.s) | [bridge_short_sample188_mem.s](round4/verified/bridge_short_sample188_mem.s) | 32 |
| [bridge_short_sample189.s](round4/verified/bridge_short_sample189.s) | [bridge_short_sample189_mem.s](round4/verified/bridge_short_sample189_mem.s) | 32 |
| [bridge_short_sample19.s](round4/verified/bridge_short_sample19.s) | [bridge_short_sample19_mem.s](round4/verified/bridge_short_sample19_mem.s) | 32 |
| [bridge_short_sample190.s](round4/verified/bridge_short_sample190.s) | [bridge_short_sample190_mem.s](round4/verified/bridge_short_sample190_mem.s) | 32 |
| [bridge_short_sample191.s](round4/verified/bridge_short_sample191.s) | [bridge_short_sample191_mem.s](round4/verified/bridge_short_sample191_mem.s) | 32 |
| [bridge_short_sample192.s](round4/verified/bridge_short_sample192.s) | [bridge_short_sample192_mem.s](round4/verified/bridge_short_sample192_mem.s) | 32 |
| [bridge_short_sample193.s](round4/verified/bridge_short_sample193.s) | [bridge_short_sample193_mem.s](round4/verified/bridge_short_sample193_mem.s) | 32 |
| [bridge_short_sample194.s](round4/verified/bridge_short_sample194.s) | [bridge_short_sample194_mem.s](round4/verified/bridge_short_sample194_mem.s) | 32 |
| [bridge_short_sample195.s](round4/verified/bridge_short_sample195.s) | [bridge_short_sample195_mem.s](round4/verified/bridge_short_sample195_mem.s) | 32 |
| [bridge_short_sample196.s](round4/verified/bridge_short_sample196.s) | [bridge_short_sample196_mem.s](round4/verified/bridge_short_sample196_mem.s) | 32 |
| [bridge_short_sample197.s](round4/verified/bridge_short_sample197.s) | [bridge_short_sample197_mem.s](round4/verified/bridge_short_sample197_mem.s) | 32 |
| [bridge_short_sample198.s](round4/verified/bridge_short_sample198.s) | [bridge_short_sample198_mem.s](round4/verified/bridge_short_sample198_mem.s) | 32 |
| [bridge_short_sample199.s](round4/verified/bridge_short_sample199.s) | [bridge_short_sample199_mem.s](round4/verified/bridge_short_sample199_mem.s) | 32 |
| [bridge_short_sample2.s](round4/verified/bridge_short_sample2.s) | [bridge_short_sample2_mem.s](round4/verified/bridge_short_sample2_mem.s) | 32 |
| [bridge_short_sample20.s](round4/verified/bridge_short_sample20.s) | [bridge_short_sample20_mem.s](round4/verified/bridge_short_sample20_mem.s) | 32 |
| [bridge_short_sample200.s](round4/verified/bridge_short_sample200.s) | [bridge_short_sample200_mem.s](round4/verified/bridge_short_sample200_mem.s) | 32 |
| [bridge_short_sample201.s](round4/verified/bridge_short_sample201.s) | [bridge_short_sample201_mem.s](round4/verified/bridge_short_sample201_mem.s) | 32 |
| [bridge_short_sample202.s](round4/verified/bridge_short_sample202.s) | [bridge_short_sample202_mem.s](round4/verified/bridge_short_sample202_mem.s) | 32 |
| [bridge_short_sample203.s](round4/verified/bridge_short_sample203.s) | [bridge_short_sample203_mem.s](round4/verified/bridge_short_sample203_mem.s) | 32 |
| [bridge_short_sample204.s](round4/verified/bridge_short_sample204.s) | [bridge_short_sample204_mem.s](round4/verified/bridge_short_sample204_mem.s) | 32 |
| [bridge_short_sample205.s](round4/verified/bridge_short_sample205.s) | [bridge_short_sample205_mem.s](round4/verified/bridge_short_sample205_mem.s) | 32 |
| [bridge_short_sample206.s](round4/verified/bridge_short_sample206.s) | [bridge_short_sample206_mem.s](round4/verified/bridge_short_sample206_mem.s) | 32 |
| [bridge_short_sample207.s](round4/verified/bridge_short_sample207.s) | [bridge_short_sample207_mem.s](round4/verified/bridge_short_sample207_mem.s) | 32 |
| [bridge_short_sample208.s](round4/verified/bridge_short_sample208.s) | [bridge_short_sample208_mem.s](round4/verified/bridge_short_sample208_mem.s) | 32 |
| [bridge_short_sample209.s](round4/verified/bridge_short_sample209.s) | [bridge_short_sample209_mem.s](round4/verified/bridge_short_sample209_mem.s) | 32 |
| [bridge_short_sample21.s](round4/verified/bridge_short_sample21.s) | [bridge_short_sample21_mem.s](round4/verified/bridge_short_sample21_mem.s) | 32 |
| [bridge_short_sample210.s](round4/verified/bridge_short_sample210.s) | [bridge_short_sample210_mem.s](round4/verified/bridge_short_sample210_mem.s) | 32 |
| [bridge_short_sample211.s](round4/verified/bridge_short_sample211.s) | [bridge_short_sample211_mem.s](round4/verified/bridge_short_sample211_mem.s) | 32 |
| [bridge_short_sample212.s](round4/verified/bridge_short_sample212.s) | [bridge_short_sample212_mem.s](round4/verified/bridge_short_sample212_mem.s) | 32 |
| [bridge_short_sample213.s](round4/verified/bridge_short_sample213.s) | [bridge_short_sample213_mem.s](round4/verified/bridge_short_sample213_mem.s) | 32 |
| [bridge_short_sample214.s](round4/verified/bridge_short_sample214.s) | [bridge_short_sample214_mem.s](round4/verified/bridge_short_sample214_mem.s) | 32 |
| [bridge_short_sample215.s](round4/verified/bridge_short_sample215.s) | [bridge_short_sample215_mem.s](round4/verified/bridge_short_sample215_mem.s) | 32 |
| [bridge_short_sample216.s](round4/verified/bridge_short_sample216.s) | [bridge_short_sample216_mem.s](round4/verified/bridge_short_sample216_mem.s) | 32 |
| [bridge_short_sample217.s](round4/verified/bridge_short_sample217.s) | [bridge_short_sample217_mem.s](round4/verified/bridge_short_sample217_mem.s) | 32 |
| [bridge_short_sample218.s](round4/verified/bridge_short_sample218.s) | [bridge_short_sample218_mem.s](round4/verified/bridge_short_sample218_mem.s) | 32 |
| [bridge_short_sample219.s](round4/verified/bridge_short_sample219.s) | [bridge_short_sample219_mem.s](round4/verified/bridge_short_sample219_mem.s) | 32 |
| [bridge_short_sample22.s](round4/verified/bridge_short_sample22.s) | [bridge_short_sample22_mem.s](round4/verified/bridge_short_sample22_mem.s) | 32 |
| [bridge_short_sample220.s](round4/verified/bridge_short_sample220.s) | [bridge_short_sample220_mem.s](round4/verified/bridge_short_sample220_mem.s) | 32 |
| [bridge_short_sample221.s](round4/verified/bridge_short_sample221.s) | [bridge_short_sample221_mem.s](round4/verified/bridge_short_sample221_mem.s) | 32 |
| [bridge_short_sample222.s](round4/verified/bridge_short_sample222.s) | [bridge_short_sample222_mem.s](round4/verified/bridge_short_sample222_mem.s) | 32 |
| [bridge_short_sample223.s](round4/verified/bridge_short_sample223.s) | [bridge_short_sample223_mem.s](round4/verified/bridge_short_sample223_mem.s) | 32 |
| [bridge_short_sample224.s](round4/verified/bridge_short_sample224.s) | [bridge_short_sample224_mem.s](round4/verified/bridge_short_sample224_mem.s) | 32 |
| [bridge_short_sample225.s](round4/verified/bridge_short_sample225.s) | [bridge_short_sample225_mem.s](round4/verified/bridge_short_sample225_mem.s) | 32 |
| [bridge_short_sample226.s](round4/verified/bridge_short_sample226.s) | [bridge_short_sample226_mem.s](round4/verified/bridge_short_sample226_mem.s) | 32 |
| [bridge_short_sample227.s](round4/verified/bridge_short_sample227.s) | [bridge_short_sample227_mem.s](round4/verified/bridge_short_sample227_mem.s) | 32 |
| [bridge_short_sample228.s](round4/verified/bridge_short_sample228.s) | [bridge_short_sample228_mem.s](round4/verified/bridge_short_sample228_mem.s) | 32 |
| [bridge_short_sample229.s](round4/verified/bridge_short_sample229.s) | [bridge_short_sample229_mem.s](round4/verified/bridge_short_sample229_mem.s) | 32 |
| [bridge_short_sample23.s](round4/verified/bridge_short_sample23.s) | [bridge_short_sample23_mem.s](round4/verified/bridge_short_sample23_mem.s) | 32 |
| [bridge_short_sample230.s](round4/verified/bridge_short_sample230.s) | [bridge_short_sample230_mem.s](round4/verified/bridge_short_sample230_mem.s) | 32 |
| [bridge_short_sample231.s](round4/verified/bridge_short_sample231.s) | [bridge_short_sample231_mem.s](round4/verified/bridge_short_sample231_mem.s) | 32 |
| [bridge_short_sample232.s](round4/verified/bridge_short_sample232.s) | [bridge_short_sample232_mem.s](round4/verified/bridge_short_sample232_mem.s) | 32 |
| [bridge_short_sample233.s](round4/verified/bridge_short_sample233.s) | [bridge_short_sample233_mem.s](round4/verified/bridge_short_sample233_mem.s) | 32 |
| [bridge_short_sample234.s](round4/verified/bridge_short_sample234.s) | [bridge_short_sample234_mem.s](round4/verified/bridge_short_sample234_mem.s) | 32 |
| [bridge_short_sample235.s](round4/verified/bridge_short_sample235.s) | [bridge_short_sample235_mem.s](round4/verified/bridge_short_sample235_mem.s) | 32 |
| [bridge_short_sample236.s](round4/verified/bridge_short_sample236.s) | [bridge_short_sample236_mem.s](round4/verified/bridge_short_sample236_mem.s) | 32 |
| [bridge_short_sample237.s](round4/verified/bridge_short_sample237.s) | [bridge_short_sample237_mem.s](round4/verified/bridge_short_sample237_mem.s) | 32 |
| [bridge_short_sample238.s](round4/verified/bridge_short_sample238.s) | [bridge_short_sample238_mem.s](round4/verified/bridge_short_sample238_mem.s) | 32 |
| [bridge_short_sample239.s](round4/verified/bridge_short_sample239.s) | [bridge_short_sample239_mem.s](round4/verified/bridge_short_sample239_mem.s) | 32 |
| [bridge_short_sample24.s](round4/verified/bridge_short_sample24.s) | [bridge_short_sample24_mem.s](round4/verified/bridge_short_sample24_mem.s) | 32 |
| [bridge_short_sample240.s](round4/verified/bridge_short_sample240.s) | [bridge_short_sample240_mem.s](round4/verified/bridge_short_sample240_mem.s) | 32 |
| [bridge_short_sample241.s](round4/verified/bridge_short_sample241.s) | [bridge_short_sample241_mem.s](round4/verified/bridge_short_sample241_mem.s) | 32 |
| [bridge_short_sample242.s](round4/verified/bridge_short_sample242.s) | [bridge_short_sample242_mem.s](round4/verified/bridge_short_sample242_mem.s) | 32 |
| [bridge_short_sample243.s](round4/verified/bridge_short_sample243.s) | [bridge_short_sample243_mem.s](round4/verified/bridge_short_sample243_mem.s) | 32 |
| [bridge_short_sample244.s](round4/verified/bridge_short_sample244.s) | [bridge_short_sample244_mem.s](round4/verified/bridge_short_sample244_mem.s) | 32 |
| [bridge_short_sample245.s](round4/verified/bridge_short_sample245.s) | [bridge_short_sample245_mem.s](round4/verified/bridge_short_sample245_mem.s) | 32 |
| [bridge_short_sample246.s](round4/verified/bridge_short_sample246.s) | [bridge_short_sample246_mem.s](round4/verified/bridge_short_sample246_mem.s) | 32 |
| [bridge_short_sample247.s](round4/verified/bridge_short_sample247.s) | [bridge_short_sample247_mem.s](round4/verified/bridge_short_sample247_mem.s) | 32 |
| [bridge_short_sample248.s](round4/verified/bridge_short_sample248.s) | [bridge_short_sample248_mem.s](round4/verified/bridge_short_sample248_mem.s) | 32 |
| [bridge_short_sample249.s](round4/verified/bridge_short_sample249.s) | [bridge_short_sample249_mem.s](round4/verified/bridge_short_sample249_mem.s) | 32 |
| [bridge_short_sample25.s](round4/verified/bridge_short_sample25.s) | [bridge_short_sample25_mem.s](round4/verified/bridge_short_sample25_mem.s) | 32 |
| [bridge_short_sample250.s](round4/verified/bridge_short_sample250.s) | [bridge_short_sample250_mem.s](round4/verified/bridge_short_sample250_mem.s) | 32 |
| [bridge_short_sample251.s](round4/verified/bridge_short_sample251.s) | [bridge_short_sample251_mem.s](round4/verified/bridge_short_sample251_mem.s) | 32 |
| [bridge_short_sample252.s](round4/verified/bridge_short_sample252.s) | [bridge_short_sample252_mem.s](round4/verified/bridge_short_sample252_mem.s) | 32 |
| [bridge_short_sample253.s](round4/verified/bridge_short_sample253.s) | [bridge_short_sample253_mem.s](round4/verified/bridge_short_sample253_mem.s) | 32 |
| [bridge_short_sample26.s](round4/verified/bridge_short_sample26.s) | [bridge_short_sample26_mem.s](round4/verified/bridge_short_sample26_mem.s) | 32 |
| [bridge_short_sample27.s](round4/verified/bridge_short_sample27.s) | [bridge_short_sample27_mem.s](round4/verified/bridge_short_sample27_mem.s) | 32 |
| [bridge_short_sample28.s](round4/verified/bridge_short_sample28.s) | [bridge_short_sample28_mem.s](round4/verified/bridge_short_sample28_mem.s) | 32 |
| [bridge_short_sample29.s](round4/verified/bridge_short_sample29.s) | [bridge_short_sample29_mem.s](round4/verified/bridge_short_sample29_mem.s) | 32 |
| [bridge_short_sample3.s](round4/verified/bridge_short_sample3.s) | [bridge_short_sample3_mem.s](round4/verified/bridge_short_sample3_mem.s) | 32 |
| [bridge_short_sample30.s](round4/verified/bridge_short_sample30.s) | [bridge_short_sample30_mem.s](round4/verified/bridge_short_sample30_mem.s) | 32 |
| [bridge_short_sample31.s](round4/verified/bridge_short_sample31.s) | [bridge_short_sample31_mem.s](round4/verified/bridge_short_sample31_mem.s) | 32 |
| [bridge_short_sample32.s](round4/verified/bridge_short_sample32.s) | [bridge_short_sample32_mem.s](round4/verified/bridge_short_sample32_mem.s) | 32 |
| [bridge_short_sample33.s](round4/verified/bridge_short_sample33.s) | [bridge_short_sample33_mem.s](round4/verified/bridge_short_sample33_mem.s) | 32 |
| [bridge_short_sample34.s](round4/verified/bridge_short_sample34.s) | [bridge_short_sample34_mem.s](round4/verified/bridge_short_sample34_mem.s) | 32 |
| [bridge_short_sample35.s](round4/verified/bridge_short_sample35.s) | [bridge_short_sample35_mem.s](round4/verified/bridge_short_sample35_mem.s) | 32 |
| [bridge_short_sample36.s](round4/verified/bridge_short_sample36.s) | [bridge_short_sample36_mem.s](round4/verified/bridge_short_sample36_mem.s) | 32 |
| [bridge_short_sample37.s](round4/verified/bridge_short_sample37.s) | [bridge_short_sample37_mem.s](round4/verified/bridge_short_sample37_mem.s) | 32 |
| [bridge_short_sample38.s](round4/verified/bridge_short_sample38.s) | [bridge_short_sample38_mem.s](round4/verified/bridge_short_sample38_mem.s) | 32 |
| [bridge_short_sample39.s](round4/verified/bridge_short_sample39.s) | [bridge_short_sample39_mem.s](round4/verified/bridge_short_sample39_mem.s) | 32 |
| [bridge_short_sample4.s](round4/verified/bridge_short_sample4.s) | [bridge_short_sample4_mem.s](round4/verified/bridge_short_sample4_mem.s) | 32 |
| [bridge_short_sample40.s](round4/verified/bridge_short_sample40.s) | [bridge_short_sample40_mem.s](round4/verified/bridge_short_sample40_mem.s) | 32 |
| [bridge_short_sample41.s](round4/verified/bridge_short_sample41.s) | [bridge_short_sample41_mem.s](round4/verified/bridge_short_sample41_mem.s) | 32 |
| [bridge_short_sample42.s](round4/verified/bridge_short_sample42.s) | [bridge_short_sample42_mem.s](round4/verified/bridge_short_sample42_mem.s) | 32 |
| [bridge_short_sample43.s](round4/verified/bridge_short_sample43.s) | [bridge_short_sample43_mem.s](round4/verified/bridge_short_sample43_mem.s) | 32 |
| [bridge_short_sample44.s](round4/verified/bridge_short_sample44.s) | [bridge_short_sample44_mem.s](round4/verified/bridge_short_sample44_mem.s) | 32 |
| [bridge_short_sample45.s](round4/verified/bridge_short_sample45.s) | [bridge_short_sample45_mem.s](round4/verified/bridge_short_sample45_mem.s) | 32 |
| [bridge_short_sample46.s](round4/verified/bridge_short_sample46.s) | [bridge_short_sample46_mem.s](round4/verified/bridge_short_sample46_mem.s) | 32 |
| [bridge_short_sample47.s](round4/verified/bridge_short_sample47.s) | [bridge_short_sample47_mem.s](round4/verified/bridge_short_sample47_mem.s) | 32 |
| [bridge_short_sample48.s](round4/verified/bridge_short_sample48.s) | [bridge_short_sample48_mem.s](round4/verified/bridge_short_sample48_mem.s) | 32 |
| [bridge_short_sample49.s](round4/verified/bridge_short_sample49.s) | [bridge_short_sample49_mem.s](round4/verified/bridge_short_sample49_mem.s) | 32 |
| [bridge_short_sample5.s](round4/verified/bridge_short_sample5.s) | [bridge_short_sample5_mem.s](round4/verified/bridge_short_sample5_mem.s) | 32 |
| [bridge_short_sample50.s](round4/verified/bridge_short_sample50.s) | [bridge_short_sample50_mem.s](round4/verified/bridge_short_sample50_mem.s) | 32 |
| [bridge_short_sample51.s](round4/verified/bridge_short_sample51.s) | [bridge_short_sample51_mem.s](round4/verified/bridge_short_sample51_mem.s) | 32 |
| [bridge_short_sample52.s](round4/verified/bridge_short_sample52.s) | [bridge_short_sample52_mem.s](round4/verified/bridge_short_sample52_mem.s) | 32 |
| [bridge_short_sample53.s](round4/verified/bridge_short_sample53.s) | [bridge_short_sample53_mem.s](round4/verified/bridge_short_sample53_mem.s) | 32 |
| [bridge_short_sample54.s](round4/verified/bridge_short_sample54.s) | [bridge_short_sample54_mem.s](round4/verified/bridge_short_sample54_mem.s) | 32 |
| [bridge_short_sample55.s](round4/verified/bridge_short_sample55.s) | [bridge_short_sample55_mem.s](round4/verified/bridge_short_sample55_mem.s) | 32 |
| [bridge_short_sample56.s](round4/verified/bridge_short_sample56.s) | [bridge_short_sample56_mem.s](round4/verified/bridge_short_sample56_mem.s) | 32 |
| [bridge_short_sample57.s](round4/verified/bridge_short_sample57.s) | [bridge_short_sample57_mem.s](round4/verified/bridge_short_sample57_mem.s) | 32 |
| [bridge_short_sample58.s](round4/verified/bridge_short_sample58.s) | [bridge_short_sample58_mem.s](round4/verified/bridge_short_sample58_mem.s) | 32 |
| [bridge_short_sample59.s](round4/verified/bridge_short_sample59.s) | [bridge_short_sample59_mem.s](round4/verified/bridge_short_sample59_mem.s) | 32 |
| [bridge_short_sample6.s](round4/verified/bridge_short_sample6.s) | [bridge_short_sample6_mem.s](round4/verified/bridge_short_sample6_mem.s) | 32 |
| [bridge_short_sample60.s](round4/verified/bridge_short_sample60.s) | [bridge_short_sample60_mem.s](round4/verified/bridge_short_sample60_mem.s) | 32 |
| [bridge_short_sample61.s](round4/verified/bridge_short_sample61.s) | [bridge_short_sample61_mem.s](round4/verified/bridge_short_sample61_mem.s) | 32 |
| [bridge_short_sample62.s](round4/verified/bridge_short_sample62.s) | [bridge_short_sample62_mem.s](round4/verified/bridge_short_sample62_mem.s) | 32 |
| [bridge_short_sample63.s](round4/verified/bridge_short_sample63.s) | [bridge_short_sample63_mem.s](round4/verified/bridge_short_sample63_mem.s) | 32 |
| [bridge_short_sample64.s](round4/verified/bridge_short_sample64.s) | [bridge_short_sample64_mem.s](round4/verified/bridge_short_sample64_mem.s) | 32 |
| [bridge_short_sample65.s](round4/verified/bridge_short_sample65.s) | [bridge_short_sample65_mem.s](round4/verified/bridge_short_sample65_mem.s) | 32 |
| [bridge_short_sample66.s](round4/verified/bridge_short_sample66.s) | [bridge_short_sample66_mem.s](round4/verified/bridge_short_sample66_mem.s) | 32 |
| [bridge_short_sample67.s](round4/verified/bridge_short_sample67.s) | [bridge_short_sample67_mem.s](round4/verified/bridge_short_sample67_mem.s) | 32 |
| [bridge_short_sample68.s](round4/verified/bridge_short_sample68.s) | [bridge_short_sample68_mem.s](round4/verified/bridge_short_sample68_mem.s) | 32 |
| [bridge_short_sample69.s](round4/verified/bridge_short_sample69.s) | [bridge_short_sample69_mem.s](round4/verified/bridge_short_sample69_mem.s) | 32 |
| [bridge_short_sample7.s](round4/verified/bridge_short_sample7.s) | [bridge_short_sample7_mem.s](round4/verified/bridge_short_sample7_mem.s) | 32 |
| [bridge_short_sample70.s](round4/verified/bridge_short_sample70.s) | [bridge_short_sample70_mem.s](round4/verified/bridge_short_sample70_mem.s) | 32 |
| [bridge_short_sample71.s](round4/verified/bridge_short_sample71.s) | [bridge_short_sample71_mem.s](round4/verified/bridge_short_sample71_mem.s) | 32 |
| [bridge_short_sample72.s](round4/verified/bridge_short_sample72.s) | [bridge_short_sample72_mem.s](round4/verified/bridge_short_sample72_mem.s) | 32 |
| [bridge_short_sample73.s](round4/verified/bridge_short_sample73.s) | [bridge_short_sample73_mem.s](round4/verified/bridge_short_sample73_mem.s) | 32 |
| [bridge_short_sample74.s](round4/verified/bridge_short_sample74.s) | [bridge_short_sample74_mem.s](round4/verified/bridge_short_sample74_mem.s) | 32 |
| [bridge_short_sample75.s](round4/verified/bridge_short_sample75.s) | [bridge_short_sample75_mem.s](round4/verified/bridge_short_sample75_mem.s) | 32 |
| [bridge_short_sample76.s](round4/verified/bridge_short_sample76.s) | [bridge_short_sample76_mem.s](round4/verified/bridge_short_sample76_mem.s) | 32 |
| [bridge_short_sample77.s](round4/verified/bridge_short_sample77.s) | [bridge_short_sample77_mem.s](round4/verified/bridge_short_sample77_mem.s) | 32 |
| [bridge_short_sample78.s](round4/verified/bridge_short_sample78.s) | [bridge_short_sample78_mem.s](round4/verified/bridge_short_sample78_mem.s) | 32 |
| [bridge_short_sample79.s](round4/verified/bridge_short_sample79.s) | [bridge_short_sample79_mem.s](round4/verified/bridge_short_sample79_mem.s) | 32 |
| [bridge_short_sample8.s](round4/verified/bridge_short_sample8.s) | [bridge_short_sample8_mem.s](round4/verified/bridge_short_sample8_mem.s) | 32 |
| [bridge_short_sample80.s](round4/verified/bridge_short_sample80.s) | [bridge_short_sample80_mem.s](round4/verified/bridge_short_sample80_mem.s) | 32 |
| [bridge_short_sample81.s](round4/verified/bridge_short_sample81.s) | [bridge_short_sample81_mem.s](round4/verified/bridge_short_sample81_mem.s) | 32 |
| [bridge_short_sample82.s](round4/verified/bridge_short_sample82.s) | [bridge_short_sample82_mem.s](round4/verified/bridge_short_sample82_mem.s) | 32 |
| [bridge_short_sample83.s](round4/verified/bridge_short_sample83.s) | [bridge_short_sample83_mem.s](round4/verified/bridge_short_sample83_mem.s) | 32 |
| [bridge_short_sample84.s](round4/verified/bridge_short_sample84.s) | [bridge_short_sample84_mem.s](round4/verified/bridge_short_sample84_mem.s) | 32 |
| [bridge_short_sample85.s](round4/verified/bridge_short_sample85.s) | [bridge_short_sample85_mem.s](round4/verified/bridge_short_sample85_mem.s) | 32 |
| [bridge_short_sample86.s](round4/verified/bridge_short_sample86.s) | [bridge_short_sample86_mem.s](round4/verified/bridge_short_sample86_mem.s) | 32 |
| [bridge_short_sample87.s](round4/verified/bridge_short_sample87.s) | [bridge_short_sample87_mem.s](round4/verified/bridge_short_sample87_mem.s) | 32 |
| [bridge_short_sample88.s](round4/verified/bridge_short_sample88.s) | [bridge_short_sample88_mem.s](round4/verified/bridge_short_sample88_mem.s) | 32 |
| [bridge_short_sample89.s](round4/verified/bridge_short_sample89.s) | [bridge_short_sample89_mem.s](round4/verified/bridge_short_sample89_mem.s) | 32 |
| [bridge_short_sample9.s](round4/verified/bridge_short_sample9.s) | [bridge_short_sample9_mem.s](round4/verified/bridge_short_sample9_mem.s) | 32 |
| [bridge_short_sample90.s](round4/verified/bridge_short_sample90.s) | [bridge_short_sample90_mem.s](round4/verified/bridge_short_sample90_mem.s) | 32 |
| [bridge_short_sample91.s](round4/verified/bridge_short_sample91.s) | [bridge_short_sample91_mem.s](round4/verified/bridge_short_sample91_mem.s) | 32 |
| [bridge_short_sample92.s](round4/verified/bridge_short_sample92.s) | [bridge_short_sample92_mem.s](round4/verified/bridge_short_sample92_mem.s) | 32 |
| [bridge_short_sample93.s](round4/verified/bridge_short_sample93.s) | [bridge_short_sample93_mem.s](round4/verified/bridge_short_sample93_mem.s) | 32 |
| [bridge_short_sample94.s](round4/verified/bridge_short_sample94.s) | [bridge_short_sample94_mem.s](round4/verified/bridge_short_sample94_mem.s) | 32 |
| [bridge_short_sample95.s](round4/verified/bridge_short_sample95.s) | [bridge_short_sample95_mem.s](round4/verified/bridge_short_sample95_mem.s) | 32 |
| [bridge_short_sample96.s](round4/verified/bridge_short_sample96.s) | [bridge_short_sample96_mem.s](round4/verified/bridge_short_sample96_mem.s) | 32 |
| [bridge_short_sample97.s](round4/verified/bridge_short_sample97.s) | [bridge_short_sample97_mem.s](round4/verified/bridge_short_sample97_mem.s) | 32 |
| [bridge_short_sample98.s](round4/verified/bridge_short_sample98.s) | [bridge_short_sample98_mem.s](round4/verified/bridge_short_sample98_mem.s) | 32 |
| [bridge_short_sample99.s](round4/verified/bridge_short_sample99.s) | [bridge_short_sample99_mem.s](round4/verified/bridge_short_sample99_mem.s) | 32 |
| [restart_a_checkpoint.s](round4/verified/restart_a_checkpoint.s) | [restart_a_checkpoint_mem.s](round4/verified/restart_a_checkpoint_mem.s) | 32 |
| [restart_a_final.s](round4/verified/restart_a_final.s) | [restart_a_final_mem.s](round4/verified/restart_a_final_mem.s) | 32 |
| [restart_a_sample1.s](round4/verified/restart_a_sample1.s) | [restart_a_sample1_mem.s](round4/verified/restart_a_sample1_mem.s) | 32 |
| [restart_a_sample10.s](round4/verified/restart_a_sample10.s) | [restart_a_sample10_mem.s](round4/verified/restart_a_sample10_mem.s) | 32 |
| [restart_a_sample100.s](round4/verified/restart_a_sample100.s) | [restart_a_sample100_mem.s](round4/verified/restart_a_sample100_mem.s) | 32 |
| [restart_a_sample101.s](round4/verified/restart_a_sample101.s) | [restart_a_sample101_mem.s](round4/verified/restart_a_sample101_mem.s) | 32 |
| [restart_a_sample102.s](round4/verified/restart_a_sample102.s) | [restart_a_sample102_mem.s](round4/verified/restart_a_sample102_mem.s) | 32 |
| [restart_a_sample103.s](round4/verified/restart_a_sample103.s) | [restart_a_sample103_mem.s](round4/verified/restart_a_sample103_mem.s) | 32 |
| [restart_a_sample104.s](round4/verified/restart_a_sample104.s) | [restart_a_sample104_mem.s](round4/verified/restart_a_sample104_mem.s) | 32 |
| [restart_a_sample105.s](round4/verified/restart_a_sample105.s) | [restart_a_sample105_mem.s](round4/verified/restart_a_sample105_mem.s) | 32 |
| [restart_a_sample106.s](round4/verified/restart_a_sample106.s) | [restart_a_sample106_mem.s](round4/verified/restart_a_sample106_mem.s) | 32 |
| [restart_a_sample107.s](round4/verified/restart_a_sample107.s) | [restart_a_sample107_mem.s](round4/verified/restart_a_sample107_mem.s) | 32 |
| [restart_a_sample108.s](round4/verified/restart_a_sample108.s) | [restart_a_sample108_mem.s](round4/verified/restart_a_sample108_mem.s) | 32 |
| [restart_a_sample109.s](round4/verified/restart_a_sample109.s) | [restart_a_sample109_mem.s](round4/verified/restart_a_sample109_mem.s) | 32 |
| [restart_a_sample11.s](round4/verified/restart_a_sample11.s) | [restart_a_sample11_mem.s](round4/verified/restart_a_sample11_mem.s) | 32 |
| [restart_a_sample110.s](round4/verified/restart_a_sample110.s) | [restart_a_sample110_mem.s](round4/verified/restart_a_sample110_mem.s) | 32 |
| [restart_a_sample111.s](round4/verified/restart_a_sample111.s) | [restart_a_sample111_mem.s](round4/verified/restart_a_sample111_mem.s) | 32 |
| [restart_a_sample112.s](round4/verified/restart_a_sample112.s) | [restart_a_sample112_mem.s](round4/verified/restart_a_sample112_mem.s) | 32 |
| [restart_a_sample113.s](round4/verified/restart_a_sample113.s) | [restart_a_sample113_mem.s](round4/verified/restart_a_sample113_mem.s) | 32 |
| [restart_a_sample114.s](round4/verified/restart_a_sample114.s) | [restart_a_sample114_mem.s](round4/verified/restart_a_sample114_mem.s) | 32 |
| [restart_a_sample115.s](round4/verified/restart_a_sample115.s) | [restart_a_sample115_mem.s](round4/verified/restart_a_sample115_mem.s) | 32 |
| [restart_a_sample116.s](round4/verified/restart_a_sample116.s) | [restart_a_sample116_mem.s](round4/verified/restart_a_sample116_mem.s) | 32 |
| [restart_a_sample117.s](round4/verified/restart_a_sample117.s) | [restart_a_sample117_mem.s](round4/verified/restart_a_sample117_mem.s) | 32 |
| [restart_a_sample118.s](round4/verified/restart_a_sample118.s) | [restart_a_sample118_mem.s](round4/verified/restart_a_sample118_mem.s) | 32 |
| [restart_a_sample119.s](round4/verified/restart_a_sample119.s) | [restart_a_sample119_mem.s](round4/verified/restart_a_sample119_mem.s) | 32 |
| [restart_a_sample12.s](round4/verified/restart_a_sample12.s) | [restart_a_sample12_mem.s](round4/verified/restart_a_sample12_mem.s) | 32 |
| [restart_a_sample120.s](round4/verified/restart_a_sample120.s) | [restart_a_sample120_mem.s](round4/verified/restart_a_sample120_mem.s) | 32 |
| [restart_a_sample121.s](round4/verified/restart_a_sample121.s) | [restart_a_sample121_mem.s](round4/verified/restart_a_sample121_mem.s) | 32 |
| [restart_a_sample122.s](round4/verified/restart_a_sample122.s) | [restart_a_sample122_mem.s](round4/verified/restart_a_sample122_mem.s) | 32 |
| [restart_a_sample123.s](round4/verified/restart_a_sample123.s) | [restart_a_sample123_mem.s](round4/verified/restart_a_sample123_mem.s) | 32 |
| [restart_a_sample124.s](round4/verified/restart_a_sample124.s) | [restart_a_sample124_mem.s](round4/verified/restart_a_sample124_mem.s) | 32 |
| [restart_a_sample125.s](round4/verified/restart_a_sample125.s) | [restart_a_sample125_mem.s](round4/verified/restart_a_sample125_mem.s) | 32 |
| [restart_a_sample126.s](round4/verified/restart_a_sample126.s) | [restart_a_sample126_mem.s](round4/verified/restart_a_sample126_mem.s) | 32 |
| [restart_a_sample127.s](round4/verified/restart_a_sample127.s) | [restart_a_sample127_mem.s](round4/verified/restart_a_sample127_mem.s) | 32 |
| [restart_a_sample128.s](round4/verified/restart_a_sample128.s) | [restart_a_sample128_mem.s](round4/verified/restart_a_sample128_mem.s) | 32 |
| [restart_a_sample129.s](round4/verified/restart_a_sample129.s) | [restart_a_sample129_mem.s](round4/verified/restart_a_sample129_mem.s) | 32 |
| [restart_a_sample13.s](round4/verified/restart_a_sample13.s) | [restart_a_sample13_mem.s](round4/verified/restart_a_sample13_mem.s) | 32 |
| [restart_a_sample130.s](round4/verified/restart_a_sample130.s) | [restart_a_sample130_mem.s](round4/verified/restart_a_sample130_mem.s) | 32 |
| [restart_a_sample131.s](round4/verified/restart_a_sample131.s) | [restart_a_sample131_mem.s](round4/verified/restart_a_sample131_mem.s) | 32 |
| [restart_a_sample132.s](round4/verified/restart_a_sample132.s) | [restart_a_sample132_mem.s](round4/verified/restart_a_sample132_mem.s) | 32 |
| [restart_a_sample133.s](round4/verified/restart_a_sample133.s) | [restart_a_sample133_mem.s](round4/verified/restart_a_sample133_mem.s) | 32 |
| [restart_a_sample134.s](round4/verified/restart_a_sample134.s) | [restart_a_sample134_mem.s](round4/verified/restart_a_sample134_mem.s) | 32 |
| [restart_a_sample135.s](round4/verified/restart_a_sample135.s) | [restart_a_sample135_mem.s](round4/verified/restart_a_sample135_mem.s) | 32 |
| [restart_a_sample136.s](round4/verified/restart_a_sample136.s) | [restart_a_sample136_mem.s](round4/verified/restart_a_sample136_mem.s) | 32 |
| [restart_a_sample137.s](round4/verified/restart_a_sample137.s) | [restart_a_sample137_mem.s](round4/verified/restart_a_sample137_mem.s) | 32 |
| [restart_a_sample138.s](round4/verified/restart_a_sample138.s) | [restart_a_sample138_mem.s](round4/verified/restart_a_sample138_mem.s) | 32 |
| [restart_a_sample139.s](round4/verified/restart_a_sample139.s) | [restart_a_sample139_mem.s](round4/verified/restart_a_sample139_mem.s) | 32 |
| [restart_a_sample14.s](round4/verified/restart_a_sample14.s) | [restart_a_sample14_mem.s](round4/verified/restart_a_sample14_mem.s) | 32 |
| [restart_a_sample140.s](round4/verified/restart_a_sample140.s) | [restart_a_sample140_mem.s](round4/verified/restart_a_sample140_mem.s) | 32 |
| [restart_a_sample141.s](round4/verified/restart_a_sample141.s) | [restart_a_sample141_mem.s](round4/verified/restart_a_sample141_mem.s) | 32 |
| [restart_a_sample142.s](round4/verified/restart_a_sample142.s) | [restart_a_sample142_mem.s](round4/verified/restart_a_sample142_mem.s) | 32 |
| [restart_a_sample143.s](round4/verified/restart_a_sample143.s) | [restart_a_sample143_mem.s](round4/verified/restart_a_sample143_mem.s) | 32 |
| [restart_a_sample144.s](round4/verified/restart_a_sample144.s) | [restart_a_sample144_mem.s](round4/verified/restart_a_sample144_mem.s) | 32 |
| [restart_a_sample145.s](round4/verified/restart_a_sample145.s) | [restart_a_sample145_mem.s](round4/verified/restart_a_sample145_mem.s) | 32 |
| [restart_a_sample146.s](round4/verified/restart_a_sample146.s) | [restart_a_sample146_mem.s](round4/verified/restart_a_sample146_mem.s) | 32 |
| [restart_a_sample147.s](round4/verified/restart_a_sample147.s) | [restart_a_sample147_mem.s](round4/verified/restart_a_sample147_mem.s) | 32 |
| [restart_a_sample148.s](round4/verified/restart_a_sample148.s) | [restart_a_sample148_mem.s](round4/verified/restart_a_sample148_mem.s) | 32 |
| [restart_a_sample149.s](round4/verified/restart_a_sample149.s) | [restart_a_sample149_mem.s](round4/verified/restart_a_sample149_mem.s) | 32 |
| [restart_a_sample15.s](round4/verified/restart_a_sample15.s) | [restart_a_sample15_mem.s](round4/verified/restart_a_sample15_mem.s) | 32 |
| [restart_a_sample150.s](round4/verified/restart_a_sample150.s) | [restart_a_sample150_mem.s](round4/verified/restart_a_sample150_mem.s) | 32 |
| [restart_a_sample151.s](round4/verified/restart_a_sample151.s) | [restart_a_sample151_mem.s](round4/verified/restart_a_sample151_mem.s) | 32 |
| [restart_a_sample152.s](round4/verified/restart_a_sample152.s) | [restart_a_sample152_mem.s](round4/verified/restart_a_sample152_mem.s) | 32 |
| [restart_a_sample153.s](round4/verified/restart_a_sample153.s) | [restart_a_sample153_mem.s](round4/verified/restart_a_sample153_mem.s) | 32 |
| [restart_a_sample154.s](round4/verified/restart_a_sample154.s) | [restart_a_sample154_mem.s](round4/verified/restart_a_sample154_mem.s) | 32 |
| [restart_a_sample155.s](round4/verified/restart_a_sample155.s) | [restart_a_sample155_mem.s](round4/verified/restart_a_sample155_mem.s) | 32 |
| [restart_a_sample156.s](round4/verified/restart_a_sample156.s) | [restart_a_sample156_mem.s](round4/verified/restart_a_sample156_mem.s) | 32 |
| [restart_a_sample157.s](round4/verified/restart_a_sample157.s) | [restart_a_sample157_mem.s](round4/verified/restart_a_sample157_mem.s) | 32 |
| [restart_a_sample158.s](round4/verified/restart_a_sample158.s) | [restart_a_sample158_mem.s](round4/verified/restart_a_sample158_mem.s) | 32 |
| [restart_a_sample159.s](round4/verified/restart_a_sample159.s) | [restart_a_sample159_mem.s](round4/verified/restart_a_sample159_mem.s) | 32 |
| [restart_a_sample16.s](round4/verified/restart_a_sample16.s) | [restart_a_sample16_mem.s](round4/verified/restart_a_sample16_mem.s) | 32 |
| [restart_a_sample160.s](round4/verified/restart_a_sample160.s) | [restart_a_sample160_mem.s](round4/verified/restart_a_sample160_mem.s) | 32 |
| [restart_a_sample161.s](round4/verified/restart_a_sample161.s) | [restart_a_sample161_mem.s](round4/verified/restart_a_sample161_mem.s) | 32 |
| [restart_a_sample162.s](round4/verified/restart_a_sample162.s) | [restart_a_sample162_mem.s](round4/verified/restart_a_sample162_mem.s) | 32 |
| [restart_a_sample163.s](round4/verified/restart_a_sample163.s) | [restart_a_sample163_mem.s](round4/verified/restart_a_sample163_mem.s) | 32 |
| [restart_a_sample164.s](round4/verified/restart_a_sample164.s) | [restart_a_sample164_mem.s](round4/verified/restart_a_sample164_mem.s) | 32 |
| [restart_a_sample165.s](round4/verified/restart_a_sample165.s) | [restart_a_sample165_mem.s](round4/verified/restart_a_sample165_mem.s) | 32 |
| [restart_a_sample166.s](round4/verified/restart_a_sample166.s) | [restart_a_sample166_mem.s](round4/verified/restart_a_sample166_mem.s) | 32 |
| [restart_a_sample167.s](round4/verified/restart_a_sample167.s) | [restart_a_sample167_mem.s](round4/verified/restart_a_sample167_mem.s) | 32 |
| [restart_a_sample168.s](round4/verified/restart_a_sample168.s) | [restart_a_sample168_mem.s](round4/verified/restart_a_sample168_mem.s) | 32 |
| [restart_a_sample169.s](round4/verified/restart_a_sample169.s) | [restart_a_sample169_mem.s](round4/verified/restart_a_sample169_mem.s) | 32 |
| [restart_a_sample17.s](round4/verified/restart_a_sample17.s) | [restart_a_sample17_mem.s](round4/verified/restart_a_sample17_mem.s) | 32 |
| [restart_a_sample170.s](round4/verified/restart_a_sample170.s) | [restart_a_sample170_mem.s](round4/verified/restart_a_sample170_mem.s) | 32 |
| [restart_a_sample171.s](round4/verified/restart_a_sample171.s) | [restart_a_sample171_mem.s](round4/verified/restart_a_sample171_mem.s) | 32 |
| [restart_a_sample172.s](round4/verified/restart_a_sample172.s) | [restart_a_sample172_mem.s](round4/verified/restart_a_sample172_mem.s) | 32 |
| [restart_a_sample173.s](round4/verified/restart_a_sample173.s) | [restart_a_sample173_mem.s](round4/verified/restart_a_sample173_mem.s) | 32 |
| [restart_a_sample174.s](round4/verified/restart_a_sample174.s) | [restart_a_sample174_mem.s](round4/verified/restart_a_sample174_mem.s) | 32 |
| [restart_a_sample175.s](round4/verified/restart_a_sample175.s) | [restart_a_sample175_mem.s](round4/verified/restart_a_sample175_mem.s) | 32 |
| [restart_a_sample176.s](round4/verified/restart_a_sample176.s) | [restart_a_sample176_mem.s](round4/verified/restart_a_sample176_mem.s) | 32 |
| [restart_a_sample177.s](round4/verified/restart_a_sample177.s) | [restart_a_sample177_mem.s](round4/verified/restart_a_sample177_mem.s) | 32 |
| [restart_a_sample178.s](round4/verified/restart_a_sample178.s) | [restart_a_sample178_mem.s](round4/verified/restart_a_sample178_mem.s) | 32 |
| [restart_a_sample179.s](round4/verified/restart_a_sample179.s) | [restart_a_sample179_mem.s](round4/verified/restart_a_sample179_mem.s) | 32 |
| [restart_a_sample18.s](round4/verified/restart_a_sample18.s) | [restart_a_sample18_mem.s](round4/verified/restart_a_sample18_mem.s) | 32 |
| [restart_a_sample180.s](round4/verified/restart_a_sample180.s) | [restart_a_sample180_mem.s](round4/verified/restart_a_sample180_mem.s) | 32 |
| [restart_a_sample181.s](round4/verified/restart_a_sample181.s) | [restart_a_sample181_mem.s](round4/verified/restart_a_sample181_mem.s) | 32 |
| [restart_a_sample182.s](round4/verified/restart_a_sample182.s) | [restart_a_sample182_mem.s](round4/verified/restart_a_sample182_mem.s) | 32 |
| [restart_a_sample183.s](round4/verified/restart_a_sample183.s) | [restart_a_sample183_mem.s](round4/verified/restart_a_sample183_mem.s) | 32 |
| [restart_a_sample184.s](round4/verified/restart_a_sample184.s) | [restart_a_sample184_mem.s](round4/verified/restart_a_sample184_mem.s) | 32 |
| [restart_a_sample185.s](round4/verified/restart_a_sample185.s) | [restart_a_sample185_mem.s](round4/verified/restart_a_sample185_mem.s) | 32 |
| [restart_a_sample186.s](round4/verified/restart_a_sample186.s) | [restart_a_sample186_mem.s](round4/verified/restart_a_sample186_mem.s) | 32 |
| [restart_a_sample187.s](round4/verified/restart_a_sample187.s) | [restart_a_sample187_mem.s](round4/verified/restart_a_sample187_mem.s) | 32 |
| [restart_a_sample188.s](round4/verified/restart_a_sample188.s) | [restart_a_sample188_mem.s](round4/verified/restart_a_sample188_mem.s) | 32 |
| [restart_a_sample189.s](round4/verified/restart_a_sample189.s) | [restart_a_sample189_mem.s](round4/verified/restart_a_sample189_mem.s) | 32 |
| [restart_a_sample19.s](round4/verified/restart_a_sample19.s) | [restart_a_sample19_mem.s](round4/verified/restart_a_sample19_mem.s) | 32 |
| [restart_a_sample190.s](round4/verified/restart_a_sample190.s) | [restart_a_sample190_mem.s](round4/verified/restart_a_sample190_mem.s) | 32 |
| [restart_a_sample191.s](round4/verified/restart_a_sample191.s) | [restart_a_sample191_mem.s](round4/verified/restart_a_sample191_mem.s) | 32 |
| [restart_a_sample192.s](round4/verified/restart_a_sample192.s) | [restart_a_sample192_mem.s](round4/verified/restart_a_sample192_mem.s) | 32 |
| [restart_a_sample193.s](round4/verified/restart_a_sample193.s) | [restart_a_sample193_mem.s](round4/verified/restart_a_sample193_mem.s) | 32 |
| [restart_a_sample194.s](round4/verified/restart_a_sample194.s) | [restart_a_sample194_mem.s](round4/verified/restart_a_sample194_mem.s) | 32 |
| [restart_a_sample195.s](round4/verified/restart_a_sample195.s) | [restart_a_sample195_mem.s](round4/verified/restart_a_sample195_mem.s) | 32 |
| [restart_a_sample196.s](round4/verified/restart_a_sample196.s) | [restart_a_sample196_mem.s](round4/verified/restart_a_sample196_mem.s) | 32 |
| [restart_a_sample197.s](round4/verified/restart_a_sample197.s) | [restart_a_sample197_mem.s](round4/verified/restart_a_sample197_mem.s) | 32 |
| [restart_a_sample198.s](round4/verified/restart_a_sample198.s) | [restart_a_sample198_mem.s](round4/verified/restart_a_sample198_mem.s) | 32 |
| [restart_a_sample199.s](round4/verified/restart_a_sample199.s) | [restart_a_sample199_mem.s](round4/verified/restart_a_sample199_mem.s) | 32 |
| [restart_a_sample2.s](round4/verified/restart_a_sample2.s) | [restart_a_sample2_mem.s](round4/verified/restart_a_sample2_mem.s) | 32 |
| [restart_a_sample20.s](round4/verified/restart_a_sample20.s) | [restart_a_sample20_mem.s](round4/verified/restart_a_sample20_mem.s) | 32 |
| [restart_a_sample200.s](round4/verified/restart_a_sample200.s) | [restart_a_sample200_mem.s](round4/verified/restart_a_sample200_mem.s) | 32 |
| [restart_a_sample201.s](round4/verified/restart_a_sample201.s) | [restart_a_sample201_mem.s](round4/verified/restart_a_sample201_mem.s) | 32 |
| [restart_a_sample202.s](round4/verified/restart_a_sample202.s) | [restart_a_sample202_mem.s](round4/verified/restart_a_sample202_mem.s) | 32 |
| [restart_a_sample203.s](round4/verified/restart_a_sample203.s) | [restart_a_sample203_mem.s](round4/verified/restart_a_sample203_mem.s) | 32 |
| [restart_a_sample204.s](round4/verified/restart_a_sample204.s) | [restart_a_sample204_mem.s](round4/verified/restart_a_sample204_mem.s) | 32 |
| [restart_a_sample205.s](round4/verified/restart_a_sample205.s) | [restart_a_sample205_mem.s](round4/verified/restart_a_sample205_mem.s) | 32 |
| [restart_a_sample206.s](round4/verified/restart_a_sample206.s) | [restart_a_sample206_mem.s](round4/verified/restart_a_sample206_mem.s) | 32 |
| [restart_a_sample207.s](round4/verified/restart_a_sample207.s) | [restart_a_sample207_mem.s](round4/verified/restart_a_sample207_mem.s) | 32 |
| [restart_a_sample208.s](round4/verified/restart_a_sample208.s) | [restart_a_sample208_mem.s](round4/verified/restart_a_sample208_mem.s) | 32 |
| [restart_a_sample209.s](round4/verified/restart_a_sample209.s) | [restart_a_sample209_mem.s](round4/verified/restart_a_sample209_mem.s) | 32 |
| [restart_a_sample21.s](round4/verified/restart_a_sample21.s) | [restart_a_sample21_mem.s](round4/verified/restart_a_sample21_mem.s) | 32 |
| [restart_a_sample210.s](round4/verified/restart_a_sample210.s) | [restart_a_sample210_mem.s](round4/verified/restart_a_sample210_mem.s) | 32 |
| [restart_a_sample211.s](round4/verified/restart_a_sample211.s) | [restart_a_sample211_mem.s](round4/verified/restart_a_sample211_mem.s) | 32 |
| [restart_a_sample212.s](round4/verified/restart_a_sample212.s) | [restart_a_sample212_mem.s](round4/verified/restart_a_sample212_mem.s) | 32 |
| [restart_a_sample213.s](round4/verified/restart_a_sample213.s) | [restart_a_sample213_mem.s](round4/verified/restart_a_sample213_mem.s) | 32 |
| [restart_a_sample214.s](round4/verified/restart_a_sample214.s) | [restart_a_sample214_mem.s](round4/verified/restart_a_sample214_mem.s) | 32 |
| [restart_a_sample215.s](round4/verified/restart_a_sample215.s) | [restart_a_sample215_mem.s](round4/verified/restart_a_sample215_mem.s) | 32 |
| [restart_a_sample216.s](round4/verified/restart_a_sample216.s) | [restart_a_sample216_mem.s](round4/verified/restart_a_sample216_mem.s) | 32 |
| [restart_a_sample217.s](round4/verified/restart_a_sample217.s) | [restart_a_sample217_mem.s](round4/verified/restart_a_sample217_mem.s) | 32 |
| [restart_a_sample218.s](round4/verified/restart_a_sample218.s) | [restart_a_sample218_mem.s](round4/verified/restart_a_sample218_mem.s) | 32 |
| [restart_a_sample219.s](round4/verified/restart_a_sample219.s) | [restart_a_sample219_mem.s](round4/verified/restart_a_sample219_mem.s) | 32 |
| [restart_a_sample22.s](round4/verified/restart_a_sample22.s) | [restart_a_sample22_mem.s](round4/verified/restart_a_sample22_mem.s) | 32 |
| [restart_a_sample220.s](round4/verified/restart_a_sample220.s) | [restart_a_sample220_mem.s](round4/verified/restart_a_sample220_mem.s) | 32 |
| [restart_a_sample221.s](round4/verified/restart_a_sample221.s) | [restart_a_sample221_mem.s](round4/verified/restart_a_sample221_mem.s) | 32 |
| [restart_a_sample222.s](round4/verified/restart_a_sample222.s) | [restart_a_sample222_mem.s](round4/verified/restart_a_sample222_mem.s) | 32 |
| [restart_a_sample223.s](round4/verified/restart_a_sample223.s) | [restart_a_sample223_mem.s](round4/verified/restart_a_sample223_mem.s) | 32 |
| [restart_a_sample224.s](round4/verified/restart_a_sample224.s) | [restart_a_sample224_mem.s](round4/verified/restart_a_sample224_mem.s) | 32 |
| [restart_a_sample225.s](round4/verified/restart_a_sample225.s) | [restart_a_sample225_mem.s](round4/verified/restart_a_sample225_mem.s) | 32 |
| [restart_a_sample226.s](round4/verified/restart_a_sample226.s) | [restart_a_sample226_mem.s](round4/verified/restart_a_sample226_mem.s) | 32 |
| [restart_a_sample227.s](round4/verified/restart_a_sample227.s) | [restart_a_sample227_mem.s](round4/verified/restart_a_sample227_mem.s) | 32 |
| [restart_a_sample228.s](round4/verified/restart_a_sample228.s) | [restart_a_sample228_mem.s](round4/verified/restart_a_sample228_mem.s) | 32 |
| [restart_a_sample229.s](round4/verified/restart_a_sample229.s) | [restart_a_sample229_mem.s](round4/verified/restart_a_sample229_mem.s) | 32 |
| [restart_a_sample23.s](round4/verified/restart_a_sample23.s) | [restart_a_sample23_mem.s](round4/verified/restart_a_sample23_mem.s) | 32 |
| [restart_a_sample230.s](round4/verified/restart_a_sample230.s) | [restart_a_sample230_mem.s](round4/verified/restart_a_sample230_mem.s) | 32 |
| [restart_a_sample231.s](round4/verified/restart_a_sample231.s) | [restart_a_sample231_mem.s](round4/verified/restart_a_sample231_mem.s) | 32 |
| [restart_a_sample232.s](round4/verified/restart_a_sample232.s) | [restart_a_sample232_mem.s](round4/verified/restart_a_sample232_mem.s) | 32 |
| [restart_a_sample233.s](round4/verified/restart_a_sample233.s) | [restart_a_sample233_mem.s](round4/verified/restart_a_sample233_mem.s) | 32 |
| [restart_a_sample234.s](round4/verified/restart_a_sample234.s) | [restart_a_sample234_mem.s](round4/verified/restart_a_sample234_mem.s) | 32 |
| [restart_a_sample235.s](round4/verified/restart_a_sample235.s) | [restart_a_sample235_mem.s](round4/verified/restart_a_sample235_mem.s) | 32 |
| [restart_a_sample236.s](round4/verified/restart_a_sample236.s) | [restart_a_sample236_mem.s](round4/verified/restart_a_sample236_mem.s) | 32 |
| [restart_a_sample237.s](round4/verified/restart_a_sample237.s) | [restart_a_sample237_mem.s](round4/verified/restart_a_sample237_mem.s) | 32 |
| [restart_a_sample238.s](round4/verified/restart_a_sample238.s) | [restart_a_sample238_mem.s](round4/verified/restart_a_sample238_mem.s) | 32 |
| [restart_a_sample239.s](round4/verified/restart_a_sample239.s) | [restart_a_sample239_mem.s](round4/verified/restart_a_sample239_mem.s) | 32 |
| [restart_a_sample24.s](round4/verified/restart_a_sample24.s) | [restart_a_sample24_mem.s](round4/verified/restart_a_sample24_mem.s) | 32 |
| [restart_a_sample240.s](round4/verified/restart_a_sample240.s) | [restart_a_sample240_mem.s](round4/verified/restart_a_sample240_mem.s) | 32 |
| [restart_a_sample241.s](round4/verified/restart_a_sample241.s) | [restart_a_sample241_mem.s](round4/verified/restart_a_sample241_mem.s) | 32 |
| [restart_a_sample242.s](round4/verified/restart_a_sample242.s) | [restart_a_sample242_mem.s](round4/verified/restart_a_sample242_mem.s) | 32 |
| [restart_a_sample243.s](round4/verified/restart_a_sample243.s) | [restart_a_sample243_mem.s](round4/verified/restart_a_sample243_mem.s) | 32 |
| [restart_a_sample244.s](round4/verified/restart_a_sample244.s) | [restart_a_sample244_mem.s](round4/verified/restart_a_sample244_mem.s) | 32 |
| [restart_a_sample245.s](round4/verified/restart_a_sample245.s) | [restart_a_sample245_mem.s](round4/verified/restart_a_sample245_mem.s) | 32 |
| [restart_a_sample246.s](round4/verified/restart_a_sample246.s) | [restart_a_sample246_mem.s](round4/verified/restart_a_sample246_mem.s) | 32 |
| [restart_a_sample247.s](round4/verified/restart_a_sample247.s) | [restart_a_sample247_mem.s](round4/verified/restart_a_sample247_mem.s) | 32 |
| [restart_a_sample248.s](round4/verified/restart_a_sample248.s) | [restart_a_sample248_mem.s](round4/verified/restart_a_sample248_mem.s) | 32 |
| [restart_a_sample249.s](round4/verified/restart_a_sample249.s) | [restart_a_sample249_mem.s](round4/verified/restart_a_sample249_mem.s) | 32 |
| [restart_a_sample25.s](round4/verified/restart_a_sample25.s) | [restart_a_sample25_mem.s](round4/verified/restart_a_sample25_mem.s) | 32 |
| [restart_a_sample250.s](round4/verified/restart_a_sample250.s) | [restart_a_sample250_mem.s](round4/verified/restart_a_sample250_mem.s) | 32 |
| [restart_a_sample251.s](round4/verified/restart_a_sample251.s) | [restart_a_sample251_mem.s](round4/verified/restart_a_sample251_mem.s) | 32 |
| [restart_a_sample252.s](round4/verified/restart_a_sample252.s) | [restart_a_sample252_mem.s](round4/verified/restart_a_sample252_mem.s) | 32 |
| [restart_a_sample253.s](round4/verified/restart_a_sample253.s) | [restart_a_sample253_mem.s](round4/verified/restart_a_sample253_mem.s) | 32 |
| [restart_a_sample254.s](round4/verified/restart_a_sample254.s) | [restart_a_sample254_mem.s](round4/verified/restart_a_sample254_mem.s) | 32 |
| [restart_a_sample255.s](round4/verified/restart_a_sample255.s) | [restart_a_sample255_mem.s](round4/verified/restart_a_sample255_mem.s) | 32 |
| [restart_a_sample256.s](round4/verified/restart_a_sample256.s) | [restart_a_sample256_mem.s](round4/verified/restart_a_sample256_mem.s) | 32 |
| [restart_a_sample257.s](round4/verified/restart_a_sample257.s) | [restart_a_sample257_mem.s](round4/verified/restart_a_sample257_mem.s) | 32 |
| [restart_a_sample258.s](round4/verified/restart_a_sample258.s) | [restart_a_sample258_mem.s](round4/verified/restart_a_sample258_mem.s) | 32 |
| [restart_a_sample259.s](round4/verified/restart_a_sample259.s) | [restart_a_sample259_mem.s](round4/verified/restart_a_sample259_mem.s) | 32 |
| [restart_a_sample26.s](round4/verified/restart_a_sample26.s) | [restart_a_sample26_mem.s](round4/verified/restart_a_sample26_mem.s) | 32 |
| [restart_a_sample260.s](round4/verified/restart_a_sample260.s) | [restart_a_sample260_mem.s](round4/verified/restart_a_sample260_mem.s) | 32 |
| [restart_a_sample261.s](round4/verified/restart_a_sample261.s) | [restart_a_sample261_mem.s](round4/verified/restart_a_sample261_mem.s) | 32 |
| [restart_a_sample262.s](round4/verified/restart_a_sample262.s) | [restart_a_sample262_mem.s](round4/verified/restart_a_sample262_mem.s) | 32 |
| [restart_a_sample263.s](round4/verified/restart_a_sample263.s) | [restart_a_sample263_mem.s](round4/verified/restart_a_sample263_mem.s) | 32 |
| [restart_a_sample264.s](round4/verified/restart_a_sample264.s) | [restart_a_sample264_mem.s](round4/verified/restart_a_sample264_mem.s) | 32 |
| [restart_a_sample265.s](round4/verified/restart_a_sample265.s) | [restart_a_sample265_mem.s](round4/verified/restart_a_sample265_mem.s) | 32 |
| [restart_a_sample266.s](round4/verified/restart_a_sample266.s) | [restart_a_sample266_mem.s](round4/verified/restart_a_sample266_mem.s) | 32 |
| [restart_a_sample267.s](round4/verified/restart_a_sample267.s) | [restart_a_sample267_mem.s](round4/verified/restart_a_sample267_mem.s) | 32 |
| [restart_a_sample268.s](round4/verified/restart_a_sample268.s) | [restart_a_sample268_mem.s](round4/verified/restart_a_sample268_mem.s) | 32 |
| [restart_a_sample269.s](round4/verified/restart_a_sample269.s) | [restart_a_sample269_mem.s](round4/verified/restart_a_sample269_mem.s) | 32 |
| [restart_a_sample27.s](round4/verified/restart_a_sample27.s) | [restart_a_sample27_mem.s](round4/verified/restart_a_sample27_mem.s) | 32 |
| [restart_a_sample270.s](round4/verified/restart_a_sample270.s) | [restart_a_sample270_mem.s](round4/verified/restart_a_sample270_mem.s) | 32 |
| [restart_a_sample271.s](round4/verified/restart_a_sample271.s) | [restart_a_sample271_mem.s](round4/verified/restart_a_sample271_mem.s) | 32 |
| [restart_a_sample272.s](round4/verified/restart_a_sample272.s) | [restart_a_sample272_mem.s](round4/verified/restart_a_sample272_mem.s) | 32 |
| [restart_a_sample273.s](round4/verified/restart_a_sample273.s) | [restart_a_sample273_mem.s](round4/verified/restart_a_sample273_mem.s) | 32 |
| [restart_a_sample274.s](round4/verified/restart_a_sample274.s) | [restart_a_sample274_mem.s](round4/verified/restart_a_sample274_mem.s) | 32 |
| [restart_a_sample275.s](round4/verified/restart_a_sample275.s) | [restart_a_sample275_mem.s](round4/verified/restart_a_sample275_mem.s) | 32 |
| [restart_a_sample276.s](round4/verified/restart_a_sample276.s) | [restart_a_sample276_mem.s](round4/verified/restart_a_sample276_mem.s) | 32 |
| [restart_a_sample277.s](round4/verified/restart_a_sample277.s) | [restart_a_sample277_mem.s](round4/verified/restart_a_sample277_mem.s) | 32 |
| [restart_a_sample278.s](round4/verified/restart_a_sample278.s) | [restart_a_sample278_mem.s](round4/verified/restart_a_sample278_mem.s) | 32 |
| [restart_a_sample279.s](round4/verified/restart_a_sample279.s) | [restart_a_sample279_mem.s](round4/verified/restart_a_sample279_mem.s) | 32 |
| [restart_a_sample28.s](round4/verified/restart_a_sample28.s) | [restart_a_sample28_mem.s](round4/verified/restart_a_sample28_mem.s) | 32 |
| [restart_a_sample280.s](round4/verified/restart_a_sample280.s) | [restart_a_sample280_mem.s](round4/verified/restart_a_sample280_mem.s) | 32 |
| [restart_a_sample281.s](round4/verified/restart_a_sample281.s) | [restart_a_sample281_mem.s](round4/verified/restart_a_sample281_mem.s) | 32 |
| [restart_a_sample282.s](round4/verified/restart_a_sample282.s) | [restart_a_sample282_mem.s](round4/verified/restart_a_sample282_mem.s) | 32 |
| [restart_a_sample283.s](round4/verified/restart_a_sample283.s) | [restart_a_sample283_mem.s](round4/verified/restart_a_sample283_mem.s) | 32 |
| [restart_a_sample284.s](round4/verified/restart_a_sample284.s) | [restart_a_sample284_mem.s](round4/verified/restart_a_sample284_mem.s) | 32 |
| [restart_a_sample285.s](round4/verified/restart_a_sample285.s) | [restart_a_sample285_mem.s](round4/verified/restart_a_sample285_mem.s) | 32 |
| [restart_a_sample286.s](round4/verified/restart_a_sample286.s) | [restart_a_sample286_mem.s](round4/verified/restart_a_sample286_mem.s) | 32 |
| [restart_a_sample287.s](round4/verified/restart_a_sample287.s) | [restart_a_sample287_mem.s](round4/verified/restart_a_sample287_mem.s) | 32 |
| [restart_a_sample288.s](round4/verified/restart_a_sample288.s) | [restart_a_sample288_mem.s](round4/verified/restart_a_sample288_mem.s) | 32 |
| [restart_a_sample289.s](round4/verified/restart_a_sample289.s) | [restart_a_sample289_mem.s](round4/verified/restart_a_sample289_mem.s) | 32 |
| [restart_a_sample29.s](round4/verified/restart_a_sample29.s) | [restart_a_sample29_mem.s](round4/verified/restart_a_sample29_mem.s) | 32 |
| [restart_a_sample290.s](round4/verified/restart_a_sample290.s) | [restart_a_sample290_mem.s](round4/verified/restart_a_sample290_mem.s) | 32 |
| [restart_a_sample291.s](round4/verified/restart_a_sample291.s) | [restart_a_sample291_mem.s](round4/verified/restart_a_sample291_mem.s) | 32 |
| [restart_a_sample292.s](round4/verified/restart_a_sample292.s) | [restart_a_sample292_mem.s](round4/verified/restart_a_sample292_mem.s) | 32 |
| [restart_a_sample293.s](round4/verified/restart_a_sample293.s) | [restart_a_sample293_mem.s](round4/verified/restart_a_sample293_mem.s) | 32 |
| [restart_a_sample294.s](round4/verified/restart_a_sample294.s) | [restart_a_sample294_mem.s](round4/verified/restart_a_sample294_mem.s) | 32 |
| [restart_a_sample295.s](round4/verified/restart_a_sample295.s) | [restart_a_sample295_mem.s](round4/verified/restart_a_sample295_mem.s) | 32 |
| [restart_a_sample296.s](round4/verified/restart_a_sample296.s) | [restart_a_sample296_mem.s](round4/verified/restart_a_sample296_mem.s) | 32 |
| [restart_a_sample297.s](round4/verified/restart_a_sample297.s) | [restart_a_sample297_mem.s](round4/verified/restart_a_sample297_mem.s) | 32 |
| [restart_a_sample298.s](round4/verified/restart_a_sample298.s) | [restart_a_sample298_mem.s](round4/verified/restart_a_sample298_mem.s) | 32 |
| [restart_a_sample299.s](round4/verified/restart_a_sample299.s) | [restart_a_sample299_mem.s](round4/verified/restart_a_sample299_mem.s) | 32 |
| [restart_a_sample3.s](round4/verified/restart_a_sample3.s) | [restart_a_sample3_mem.s](round4/verified/restart_a_sample3_mem.s) | 32 |
| [restart_a_sample30.s](round4/verified/restart_a_sample30.s) | [restart_a_sample30_mem.s](round4/verified/restart_a_sample30_mem.s) | 32 |
| [restart_a_sample300.s](round4/verified/restart_a_sample300.s) | [restart_a_sample300_mem.s](round4/verified/restart_a_sample300_mem.s) | 32 |
| [restart_a_sample301.s](round4/verified/restart_a_sample301.s) | [restart_a_sample301_mem.s](round4/verified/restart_a_sample301_mem.s) | 32 |
| [restart_a_sample302.s](round4/verified/restart_a_sample302.s) | [restart_a_sample302_mem.s](round4/verified/restart_a_sample302_mem.s) | 32 |
| [restart_a_sample303.s](round4/verified/restart_a_sample303.s) | [restart_a_sample303_mem.s](round4/verified/restart_a_sample303_mem.s) | 32 |
| [restart_a_sample304.s](round4/verified/restart_a_sample304.s) | [restart_a_sample304_mem.s](round4/verified/restart_a_sample304_mem.s) | 32 |
| [restart_a_sample305.s](round4/verified/restart_a_sample305.s) | [restart_a_sample305_mem.s](round4/verified/restart_a_sample305_mem.s) | 32 |
| [restart_a_sample306.s](round4/verified/restart_a_sample306.s) | [restart_a_sample306_mem.s](round4/verified/restart_a_sample306_mem.s) | 32 |
| [restart_a_sample307.s](round4/verified/restart_a_sample307.s) | [restart_a_sample307_mem.s](round4/verified/restart_a_sample307_mem.s) | 32 |
| [restart_a_sample308.s](round4/verified/restart_a_sample308.s) | [restart_a_sample308_mem.s](round4/verified/restart_a_sample308_mem.s) | 32 |
| [restart_a_sample309.s](round4/verified/restart_a_sample309.s) | [restart_a_sample309_mem.s](round4/verified/restart_a_sample309_mem.s) | 32 |
| [restart_a_sample31.s](round4/verified/restart_a_sample31.s) | [restart_a_sample31_mem.s](round4/verified/restart_a_sample31_mem.s) | 32 |
| [restart_a_sample310.s](round4/verified/restart_a_sample310.s) | [restart_a_sample310_mem.s](round4/verified/restart_a_sample310_mem.s) | 32 |
| [restart_a_sample311.s](round4/verified/restart_a_sample311.s) | [restart_a_sample311_mem.s](round4/verified/restart_a_sample311_mem.s) | 32 |
| [restart_a_sample312.s](round4/verified/restart_a_sample312.s) | [restart_a_sample312_mem.s](round4/verified/restart_a_sample312_mem.s) | 32 |
| [restart_a_sample313.s](round4/verified/restart_a_sample313.s) | [restart_a_sample313_mem.s](round4/verified/restart_a_sample313_mem.s) | 32 |
| [restart_a_sample314.s](round4/verified/restart_a_sample314.s) | [restart_a_sample314_mem.s](round4/verified/restart_a_sample314_mem.s) | 32 |
| [restart_a_sample315.s](round4/verified/restart_a_sample315.s) | [restart_a_sample315_mem.s](round4/verified/restart_a_sample315_mem.s) | 32 |
| [restart_a_sample316.s](round4/verified/restart_a_sample316.s) | [restart_a_sample316_mem.s](round4/verified/restart_a_sample316_mem.s) | 32 |
| [restart_a_sample317.s](round4/verified/restart_a_sample317.s) | [restart_a_sample317_mem.s](round4/verified/restart_a_sample317_mem.s) | 32 |
| [restart_a_sample318.s](round4/verified/restart_a_sample318.s) | [restart_a_sample318_mem.s](round4/verified/restart_a_sample318_mem.s) | 32 |
| [restart_a_sample319.s](round4/verified/restart_a_sample319.s) | [restart_a_sample319_mem.s](round4/verified/restart_a_sample319_mem.s) | 32 |
| [restart_a_sample32.s](round4/verified/restart_a_sample32.s) | [restart_a_sample32_mem.s](round4/verified/restart_a_sample32_mem.s) | 32 |
| [restart_a_sample320.s](round4/verified/restart_a_sample320.s) | [restart_a_sample320_mem.s](round4/verified/restart_a_sample320_mem.s) | 32 |
| [restart_a_sample321.s](round4/verified/restart_a_sample321.s) | [restart_a_sample321_mem.s](round4/verified/restart_a_sample321_mem.s) | 32 |
| [restart_a_sample322.s](round4/verified/restart_a_sample322.s) | [restart_a_sample322_mem.s](round4/verified/restart_a_sample322_mem.s) | 32 |
| [restart_a_sample323.s](round4/verified/restart_a_sample323.s) | [restart_a_sample323_mem.s](round4/verified/restart_a_sample323_mem.s) | 32 |
| [restart_a_sample324.s](round4/verified/restart_a_sample324.s) | [restart_a_sample324_mem.s](round4/verified/restart_a_sample324_mem.s) | 32 |
| [restart_a_sample325.s](round4/verified/restart_a_sample325.s) | [restart_a_sample325_mem.s](round4/verified/restart_a_sample325_mem.s) | 32 |
| [restart_a_sample326.s](round4/verified/restart_a_sample326.s) | [restart_a_sample326_mem.s](round4/verified/restart_a_sample326_mem.s) | 32 |
| [restart_a_sample327.s](round4/verified/restart_a_sample327.s) | [restart_a_sample327_mem.s](round4/verified/restart_a_sample327_mem.s) | 32 |
| [restart_a_sample328.s](round4/verified/restart_a_sample328.s) | [restart_a_sample328_mem.s](round4/verified/restart_a_sample328_mem.s) | 32 |
| [restart_a_sample329.s](round4/verified/restart_a_sample329.s) | [restart_a_sample329_mem.s](round4/verified/restart_a_sample329_mem.s) | 32 |
| [restart_a_sample33.s](round4/verified/restart_a_sample33.s) | [restart_a_sample33_mem.s](round4/verified/restart_a_sample33_mem.s) | 32 |
| [restart_a_sample330.s](round4/verified/restart_a_sample330.s) | [restart_a_sample330_mem.s](round4/verified/restart_a_sample330_mem.s) | 32 |
| [restart_a_sample331.s](round4/verified/restart_a_sample331.s) | [restart_a_sample331_mem.s](round4/verified/restart_a_sample331_mem.s) | 32 |
| [restart_a_sample332.s](round4/verified/restart_a_sample332.s) | [restart_a_sample332_mem.s](round4/verified/restart_a_sample332_mem.s) | 32 |
| [restart_a_sample333.s](round4/verified/restart_a_sample333.s) | [restart_a_sample333_mem.s](round4/verified/restart_a_sample333_mem.s) | 32 |
| [restart_a_sample334.s](round4/verified/restart_a_sample334.s) | [restart_a_sample334_mem.s](round4/verified/restart_a_sample334_mem.s) | 32 |
| [restart_a_sample335.s](round4/verified/restart_a_sample335.s) | [restart_a_sample335_mem.s](round4/verified/restart_a_sample335_mem.s) | 32 |
| [restart_a_sample336.s](round4/verified/restart_a_sample336.s) | [restart_a_sample336_mem.s](round4/verified/restart_a_sample336_mem.s) | 32 |
| [restart_a_sample337.s](round4/verified/restart_a_sample337.s) | [restart_a_sample337_mem.s](round4/verified/restart_a_sample337_mem.s) | 32 |
| [restart_a_sample338.s](round4/verified/restart_a_sample338.s) | [restart_a_sample338_mem.s](round4/verified/restart_a_sample338_mem.s) | 32 |
| [restart_a_sample339.s](round4/verified/restart_a_sample339.s) | [restart_a_sample339_mem.s](round4/verified/restart_a_sample339_mem.s) | 32 |
| [restart_a_sample34.s](round4/verified/restart_a_sample34.s) | [restart_a_sample34_mem.s](round4/verified/restart_a_sample34_mem.s) | 32 |
| [restart_a_sample340.s](round4/verified/restart_a_sample340.s) | [restart_a_sample340_mem.s](round4/verified/restart_a_sample340_mem.s) | 32 |
| [restart_a_sample341.s](round4/verified/restart_a_sample341.s) | [restart_a_sample341_mem.s](round4/verified/restart_a_sample341_mem.s) | 32 |
| [restart_a_sample342.s](round4/verified/restart_a_sample342.s) | [restart_a_sample342_mem.s](round4/verified/restart_a_sample342_mem.s) | 32 |
| [restart_a_sample343.s](round4/verified/restart_a_sample343.s) | [restart_a_sample343_mem.s](round4/verified/restart_a_sample343_mem.s) | 32 |
| [restart_a_sample344.s](round4/verified/restart_a_sample344.s) | [restart_a_sample344_mem.s](round4/verified/restart_a_sample344_mem.s) | 32 |
| [restart_a_sample345.s](round4/verified/restart_a_sample345.s) | [restart_a_sample345_mem.s](round4/verified/restart_a_sample345_mem.s) | 32 |
| [restart_a_sample346.s](round4/verified/restart_a_sample346.s) | [restart_a_sample346_mem.s](round4/verified/restart_a_sample346_mem.s) | 32 |
| [restart_a_sample347.s](round4/verified/restart_a_sample347.s) | [restart_a_sample347_mem.s](round4/verified/restart_a_sample347_mem.s) | 32 |
| [restart_a_sample348.s](round4/verified/restart_a_sample348.s) | [restart_a_sample348_mem.s](round4/verified/restart_a_sample348_mem.s) | 32 |
| [restart_a_sample349.s](round4/verified/restart_a_sample349.s) | [restart_a_sample349_mem.s](round4/verified/restart_a_sample349_mem.s) | 32 |
| [restart_a_sample35.s](round4/verified/restart_a_sample35.s) | [restart_a_sample35_mem.s](round4/verified/restart_a_sample35_mem.s) | 32 |
| [restart_a_sample350.s](round4/verified/restart_a_sample350.s) | [restart_a_sample350_mem.s](round4/verified/restart_a_sample350_mem.s) | 32 |
| [restart_a_sample351.s](round4/verified/restart_a_sample351.s) | [restart_a_sample351_mem.s](round4/verified/restart_a_sample351_mem.s) | 32 |
| [restart_a_sample352.s](round4/verified/restart_a_sample352.s) | [restart_a_sample352_mem.s](round4/verified/restart_a_sample352_mem.s) | 32 |
| [restart_a_sample353.s](round4/verified/restart_a_sample353.s) | [restart_a_sample353_mem.s](round4/verified/restart_a_sample353_mem.s) | 32 |
| [restart_a_sample354.s](round4/verified/restart_a_sample354.s) | [restart_a_sample354_mem.s](round4/verified/restart_a_sample354_mem.s) | 32 |
| [restart_a_sample355.s](round4/verified/restart_a_sample355.s) | [restart_a_sample355_mem.s](round4/verified/restart_a_sample355_mem.s) | 32 |
| [restart_a_sample356.s](round4/verified/restart_a_sample356.s) | [restart_a_sample356_mem.s](round4/verified/restart_a_sample356_mem.s) | 32 |
| [restart_a_sample357.s](round4/verified/restart_a_sample357.s) | [restart_a_sample357_mem.s](round4/verified/restart_a_sample357_mem.s) | 32 |
| [restart_a_sample358.s](round4/verified/restart_a_sample358.s) | [restart_a_sample358_mem.s](round4/verified/restart_a_sample358_mem.s) | 32 |
| [restart_a_sample359.s](round4/verified/restart_a_sample359.s) | [restart_a_sample359_mem.s](round4/verified/restart_a_sample359_mem.s) | 32 |
| [restart_a_sample36.s](round4/verified/restart_a_sample36.s) | [restart_a_sample36_mem.s](round4/verified/restart_a_sample36_mem.s) | 32 |
| [restart_a_sample360.s](round4/verified/restart_a_sample360.s) | [restart_a_sample360_mem.s](round4/verified/restart_a_sample360_mem.s) | 32 |
| [restart_a_sample361.s](round4/verified/restart_a_sample361.s) | [restart_a_sample361_mem.s](round4/verified/restart_a_sample361_mem.s) | 32 |
| [restart_a_sample362.s](round4/verified/restart_a_sample362.s) | [restart_a_sample362_mem.s](round4/verified/restart_a_sample362_mem.s) | 32 |
| [restart_a_sample363.s](round4/verified/restart_a_sample363.s) | [restart_a_sample363_mem.s](round4/verified/restart_a_sample363_mem.s) | 32 |
| [restart_a_sample364.s](round4/verified/restart_a_sample364.s) | [restart_a_sample364_mem.s](round4/verified/restart_a_sample364_mem.s) | 32 |
| [restart_a_sample365.s](round4/verified/restart_a_sample365.s) | [restart_a_sample365_mem.s](round4/verified/restart_a_sample365_mem.s) | 32 |
| [restart_a_sample366.s](round4/verified/restart_a_sample366.s) | [restart_a_sample366_mem.s](round4/verified/restart_a_sample366_mem.s) | 32 |
| [restart_a_sample367.s](round4/verified/restart_a_sample367.s) | [restart_a_sample367_mem.s](round4/verified/restart_a_sample367_mem.s) | 32 |
| [restart_a_sample368.s](round4/verified/restart_a_sample368.s) | [restart_a_sample368_mem.s](round4/verified/restart_a_sample368_mem.s) | 32 |
| [restart_a_sample369.s](round4/verified/restart_a_sample369.s) | [restart_a_sample369_mem.s](round4/verified/restart_a_sample369_mem.s) | 32 |
| [restart_a_sample37.s](round4/verified/restart_a_sample37.s) | [restart_a_sample37_mem.s](round4/verified/restart_a_sample37_mem.s) | 32 |
| [restart_a_sample370.s](round4/verified/restart_a_sample370.s) | [restart_a_sample370_mem.s](round4/verified/restart_a_sample370_mem.s) | 32 |
| [restart_a_sample371.s](round4/verified/restart_a_sample371.s) | [restart_a_sample371_mem.s](round4/verified/restart_a_sample371_mem.s) | 32 |
| [restart_a_sample372.s](round4/verified/restart_a_sample372.s) | [restart_a_sample372_mem.s](round4/verified/restart_a_sample372_mem.s) | 32 |
| [restart_a_sample373.s](round4/verified/restart_a_sample373.s) | [restart_a_sample373_mem.s](round4/verified/restart_a_sample373_mem.s) | 32 |
| [restart_a_sample374.s](round4/verified/restart_a_sample374.s) | [restart_a_sample374_mem.s](round4/verified/restart_a_sample374_mem.s) | 32 |
| [restart_a_sample375.s](round4/verified/restart_a_sample375.s) | [restart_a_sample375_mem.s](round4/verified/restart_a_sample375_mem.s) | 32 |
| [restart_a_sample376.s](round4/verified/restart_a_sample376.s) | [restart_a_sample376_mem.s](round4/verified/restart_a_sample376_mem.s) | 32 |
| [restart_a_sample377.s](round4/verified/restart_a_sample377.s) | [restart_a_sample377_mem.s](round4/verified/restart_a_sample377_mem.s) | 32 |
| [restart_a_sample378.s](round4/verified/restart_a_sample378.s) | [restart_a_sample378_mem.s](round4/verified/restart_a_sample378_mem.s) | 32 |
| [restart_a_sample379.s](round4/verified/restart_a_sample379.s) | [restart_a_sample379_mem.s](round4/verified/restart_a_sample379_mem.s) | 32 |
| [restart_a_sample38.s](round4/verified/restart_a_sample38.s) | [restart_a_sample38_mem.s](round4/verified/restart_a_sample38_mem.s) | 32 |
| [restart_a_sample380.s](round4/verified/restart_a_sample380.s) | [restart_a_sample380_mem.s](round4/verified/restart_a_sample380_mem.s) | 32 |
| [restart_a_sample381.s](round4/verified/restart_a_sample381.s) | [restart_a_sample381_mem.s](round4/verified/restart_a_sample381_mem.s) | 32 |
| [restart_a_sample382.s](round4/verified/restart_a_sample382.s) | [restart_a_sample382_mem.s](round4/verified/restart_a_sample382_mem.s) | 32 |
| [restart_a_sample383.s](round4/verified/restart_a_sample383.s) | [restart_a_sample383_mem.s](round4/verified/restart_a_sample383_mem.s) | 32 |
| [restart_a_sample384.s](round4/verified/restart_a_sample384.s) | [restart_a_sample384_mem.s](round4/verified/restart_a_sample384_mem.s) | 32 |
| [restart_a_sample385.s](round4/verified/restart_a_sample385.s) | [restart_a_sample385_mem.s](round4/verified/restart_a_sample385_mem.s) | 32 |
| [restart_a_sample386.s](round4/verified/restart_a_sample386.s) | [restart_a_sample386_mem.s](round4/verified/restart_a_sample386_mem.s) | 32 |
| [restart_a_sample387.s](round4/verified/restart_a_sample387.s) | [restart_a_sample387_mem.s](round4/verified/restart_a_sample387_mem.s) | 32 |
| [restart_a_sample388.s](round4/verified/restart_a_sample388.s) | [restart_a_sample388_mem.s](round4/verified/restart_a_sample388_mem.s) | 32 |
| [restart_a_sample389.s](round4/verified/restart_a_sample389.s) | [restart_a_sample389_mem.s](round4/verified/restart_a_sample389_mem.s) | 32 |
| [restart_a_sample39.s](round4/verified/restart_a_sample39.s) | [restart_a_sample39_mem.s](round4/verified/restart_a_sample39_mem.s) | 32 |
| [restart_a_sample390.s](round4/verified/restart_a_sample390.s) | [restart_a_sample390_mem.s](round4/verified/restart_a_sample390_mem.s) | 32 |
| [restart_a_sample391.s](round4/verified/restart_a_sample391.s) | [restart_a_sample391_mem.s](round4/verified/restart_a_sample391_mem.s) | 32 |
| [restart_a_sample392.s](round4/verified/restart_a_sample392.s) | [restart_a_sample392_mem.s](round4/verified/restart_a_sample392_mem.s) | 32 |
| [restart_a_sample393.s](round4/verified/restart_a_sample393.s) | [restart_a_sample393_mem.s](round4/verified/restart_a_sample393_mem.s) | 32 |
| [restart_a_sample394.s](round4/verified/restart_a_sample394.s) | [restart_a_sample394_mem.s](round4/verified/restart_a_sample394_mem.s) | 32 |
| [restart_a_sample395.s](round4/verified/restart_a_sample395.s) | [restart_a_sample395_mem.s](round4/verified/restart_a_sample395_mem.s) | 32 |
| [restart_a_sample396.s](round4/verified/restart_a_sample396.s) | [restart_a_sample396_mem.s](round4/verified/restart_a_sample396_mem.s) | 32 |
| [restart_a_sample397.s](round4/verified/restart_a_sample397.s) | [restart_a_sample397_mem.s](round4/verified/restart_a_sample397_mem.s) | 32 |
| [restart_a_sample398.s](round4/verified/restart_a_sample398.s) | [restart_a_sample398_mem.s](round4/verified/restart_a_sample398_mem.s) | 32 |
| [restart_a_sample399.s](round4/verified/restart_a_sample399.s) | [restart_a_sample399_mem.s](round4/verified/restart_a_sample399_mem.s) | 32 |
| [restart_a_sample4.s](round4/verified/restart_a_sample4.s) | [restart_a_sample4_mem.s](round4/verified/restart_a_sample4_mem.s) | 32 |
| [restart_a_sample40.s](round4/verified/restart_a_sample40.s) | [restart_a_sample40_mem.s](round4/verified/restart_a_sample40_mem.s) | 32 |
| [restart_a_sample400.s](round4/verified/restart_a_sample400.s) | [restart_a_sample400_mem.s](round4/verified/restart_a_sample400_mem.s) | 32 |
| [restart_a_sample401.s](round4/verified/restart_a_sample401.s) | [restart_a_sample401_mem.s](round4/verified/restart_a_sample401_mem.s) | 32 |
| [restart_a_sample402.s](round4/verified/restart_a_sample402.s) | [restart_a_sample402_mem.s](round4/verified/restart_a_sample402_mem.s) | 32 |
| [restart_a_sample403.s](round4/verified/restart_a_sample403.s) | [restart_a_sample403_mem.s](round4/verified/restart_a_sample403_mem.s) | 32 |
| [restart_a_sample404.s](round4/verified/restart_a_sample404.s) | [restart_a_sample404_mem.s](round4/verified/restart_a_sample404_mem.s) | 32 |
| [restart_a_sample405.s](round4/verified/restart_a_sample405.s) | [restart_a_sample405_mem.s](round4/verified/restart_a_sample405_mem.s) | 32 |
| [restart_a_sample406.s](round4/verified/restart_a_sample406.s) | [restart_a_sample406_mem.s](round4/verified/restart_a_sample406_mem.s) | 32 |
| [restart_a_sample407.s](round4/verified/restart_a_sample407.s) | [restart_a_sample407_mem.s](round4/verified/restart_a_sample407_mem.s) | 32 |
| [restart_a_sample408.s](round4/verified/restart_a_sample408.s) | [restart_a_sample408_mem.s](round4/verified/restart_a_sample408_mem.s) | 32 |
| [restart_a_sample409.s](round4/verified/restart_a_sample409.s) | [restart_a_sample409_mem.s](round4/verified/restart_a_sample409_mem.s) | 32 |
| [restart_a_sample41.s](round4/verified/restart_a_sample41.s) | [restart_a_sample41_mem.s](round4/verified/restart_a_sample41_mem.s) | 32 |
| [restart_a_sample410.s](round4/verified/restart_a_sample410.s) | [restart_a_sample410_mem.s](round4/verified/restart_a_sample410_mem.s) | 32 |
| [restart_a_sample411.s](round4/verified/restart_a_sample411.s) | [restart_a_sample411_mem.s](round4/verified/restart_a_sample411_mem.s) | 32 |
| [restart_a_sample412.s](round4/verified/restart_a_sample412.s) | [restart_a_sample412_mem.s](round4/verified/restart_a_sample412_mem.s) | 32 |
| [restart_a_sample413.s](round4/verified/restart_a_sample413.s) | [restart_a_sample413_mem.s](round4/verified/restart_a_sample413_mem.s) | 32 |
| [restart_a_sample414.s](round4/verified/restart_a_sample414.s) | [restart_a_sample414_mem.s](round4/verified/restart_a_sample414_mem.s) | 32 |
| [restart_a_sample415.s](round4/verified/restart_a_sample415.s) | [restart_a_sample415_mem.s](round4/verified/restart_a_sample415_mem.s) | 32 |
| [restart_a_sample416.s](round4/verified/restart_a_sample416.s) | [restart_a_sample416_mem.s](round4/verified/restart_a_sample416_mem.s) | 32 |
| [restart_a_sample417.s](round4/verified/restart_a_sample417.s) | [restart_a_sample417_mem.s](round4/verified/restart_a_sample417_mem.s) | 32 |
| [restart_a_sample418.s](round4/verified/restart_a_sample418.s) | [restart_a_sample418_mem.s](round4/verified/restart_a_sample418_mem.s) | 32 |
| [restart_a_sample419.s](round4/verified/restart_a_sample419.s) | [restart_a_sample419_mem.s](round4/verified/restart_a_sample419_mem.s) | 32 |
| [restart_a_sample42.s](round4/verified/restart_a_sample42.s) | [restart_a_sample42_mem.s](round4/verified/restart_a_sample42_mem.s) | 32 |
| [restart_a_sample420.s](round4/verified/restart_a_sample420.s) | [restart_a_sample420_mem.s](round4/verified/restart_a_sample420_mem.s) | 32 |
| [restart_a_sample421.s](round4/verified/restart_a_sample421.s) | [restart_a_sample421_mem.s](round4/verified/restart_a_sample421_mem.s) | 32 |
| [restart_a_sample422.s](round4/verified/restart_a_sample422.s) | [restart_a_sample422_mem.s](round4/verified/restart_a_sample422_mem.s) | 32 |
| [restart_a_sample423.s](round4/verified/restart_a_sample423.s) | [restart_a_sample423_mem.s](round4/verified/restart_a_sample423_mem.s) | 32 |
| [restart_a_sample424.s](round4/verified/restart_a_sample424.s) | [restart_a_sample424_mem.s](round4/verified/restart_a_sample424_mem.s) | 32 |
| [restart_a_sample425.s](round4/verified/restart_a_sample425.s) | [restart_a_sample425_mem.s](round4/verified/restart_a_sample425_mem.s) | 32 |
| [restart_a_sample426.s](round4/verified/restart_a_sample426.s) | [restart_a_sample426_mem.s](round4/verified/restart_a_sample426_mem.s) | 32 |
| [restart_a_sample427.s](round4/verified/restart_a_sample427.s) | [restart_a_sample427_mem.s](round4/verified/restart_a_sample427_mem.s) | 32 |
| [restart_a_sample428.s](round4/verified/restart_a_sample428.s) | [restart_a_sample428_mem.s](round4/verified/restart_a_sample428_mem.s) | 32 |
| [restart_a_sample429.s](round4/verified/restart_a_sample429.s) | [restart_a_sample429_mem.s](round4/verified/restart_a_sample429_mem.s) | 32 |
| [restart_a_sample43.s](round4/verified/restart_a_sample43.s) | [restart_a_sample43_mem.s](round4/verified/restart_a_sample43_mem.s) | 32 |
| [restart_a_sample430.s](round4/verified/restart_a_sample430.s) | [restart_a_sample430_mem.s](round4/verified/restart_a_sample430_mem.s) | 32 |
| [restart_a_sample431.s](round4/verified/restart_a_sample431.s) | [restart_a_sample431_mem.s](round4/verified/restart_a_sample431_mem.s) | 32 |
| [restart_a_sample432.s](round4/verified/restart_a_sample432.s) | [restart_a_sample432_mem.s](round4/verified/restart_a_sample432_mem.s) | 32 |
| [restart_a_sample433.s](round4/verified/restart_a_sample433.s) | [restart_a_sample433_mem.s](round4/verified/restart_a_sample433_mem.s) | 32 |
| [restart_a_sample434.s](round4/verified/restart_a_sample434.s) | [restart_a_sample434_mem.s](round4/verified/restart_a_sample434_mem.s) | 32 |
| [restart_a_sample435.s](round4/verified/restart_a_sample435.s) | [restart_a_sample435_mem.s](round4/verified/restart_a_sample435_mem.s) | 32 |
| [restart_a_sample436.s](round4/verified/restart_a_sample436.s) | [restart_a_sample436_mem.s](round4/verified/restart_a_sample436_mem.s) | 32 |
| [restart_a_sample437.s](round4/verified/restart_a_sample437.s) | [restart_a_sample437_mem.s](round4/verified/restart_a_sample437_mem.s) | 32 |
| [restart_a_sample438.s](round4/verified/restart_a_sample438.s) | [restart_a_sample438_mem.s](round4/verified/restart_a_sample438_mem.s) | 32 |
| [restart_a_sample439.s](round4/verified/restart_a_sample439.s) | [restart_a_sample439_mem.s](round4/verified/restart_a_sample439_mem.s) | 32 |
| [restart_a_sample44.s](round4/verified/restart_a_sample44.s) | [restart_a_sample44_mem.s](round4/verified/restart_a_sample44_mem.s) | 32 |
| [restart_a_sample440.s](round4/verified/restart_a_sample440.s) | [restart_a_sample440_mem.s](round4/verified/restart_a_sample440_mem.s) | 32 |
| [restart_a_sample441.s](round4/verified/restart_a_sample441.s) | [restart_a_sample441_mem.s](round4/verified/restart_a_sample441_mem.s) | 32 |
| [restart_a_sample442.s](round4/verified/restart_a_sample442.s) | [restart_a_sample442_mem.s](round4/verified/restart_a_sample442_mem.s) | 32 |
| [restart_a_sample443.s](round4/verified/restart_a_sample443.s) | [restart_a_sample443_mem.s](round4/verified/restart_a_sample443_mem.s) | 32 |
| [restart_a_sample444.s](round4/verified/restart_a_sample444.s) | [restart_a_sample444_mem.s](round4/verified/restart_a_sample444_mem.s) | 32 |
| [restart_a_sample445.s](round4/verified/restart_a_sample445.s) | [restart_a_sample445_mem.s](round4/verified/restart_a_sample445_mem.s) | 32 |
| [restart_a_sample446.s](round4/verified/restart_a_sample446.s) | [restart_a_sample446_mem.s](round4/verified/restart_a_sample446_mem.s) | 32 |
| [restart_a_sample447.s](round4/verified/restart_a_sample447.s) | [restart_a_sample447_mem.s](round4/verified/restart_a_sample447_mem.s) | 32 |
| [restart_a_sample448.s](round4/verified/restart_a_sample448.s) | [restart_a_sample448_mem.s](round4/verified/restart_a_sample448_mem.s) | 32 |
| [restart_a_sample449.s](round4/verified/restart_a_sample449.s) | [restart_a_sample449_mem.s](round4/verified/restart_a_sample449_mem.s) | 32 |
| [restart_a_sample45.s](round4/verified/restart_a_sample45.s) | [restart_a_sample45_mem.s](round4/verified/restart_a_sample45_mem.s) | 32 |
| [restart_a_sample450.s](round4/verified/restart_a_sample450.s) | [restart_a_sample450_mem.s](round4/verified/restart_a_sample450_mem.s) | 32 |
| [restart_a_sample451.s](round4/verified/restart_a_sample451.s) | [restart_a_sample451_mem.s](round4/verified/restart_a_sample451_mem.s) | 32 |
| [restart_a_sample452.s](round4/verified/restart_a_sample452.s) | [restart_a_sample452_mem.s](round4/verified/restart_a_sample452_mem.s) | 32 |
| [restart_a_sample453.s](round4/verified/restart_a_sample453.s) | [restart_a_sample453_mem.s](round4/verified/restart_a_sample453_mem.s) | 32 |
| [restart_a_sample454.s](round4/verified/restart_a_sample454.s) | [restart_a_sample454_mem.s](round4/verified/restart_a_sample454_mem.s) | 32 |
| [restart_a_sample455.s](round4/verified/restart_a_sample455.s) | [restart_a_sample455_mem.s](round4/verified/restart_a_sample455_mem.s) | 32 |
| [restart_a_sample456.s](round4/verified/restart_a_sample456.s) | [restart_a_sample456_mem.s](round4/verified/restart_a_sample456_mem.s) | 32 |
| [restart_a_sample457.s](round4/verified/restart_a_sample457.s) | [restart_a_sample457_mem.s](round4/verified/restart_a_sample457_mem.s) | 32 |
| [restart_a_sample458.s](round4/verified/restart_a_sample458.s) | [restart_a_sample458_mem.s](round4/verified/restart_a_sample458_mem.s) | 32 |
| [restart_a_sample459.s](round4/verified/restart_a_sample459.s) | [restart_a_sample459_mem.s](round4/verified/restart_a_sample459_mem.s) | 32 |
| [restart_a_sample46.s](round4/verified/restart_a_sample46.s) | [restart_a_sample46_mem.s](round4/verified/restart_a_sample46_mem.s) | 32 |
| [restart_a_sample460.s](round4/verified/restart_a_sample460.s) | [restart_a_sample460_mem.s](round4/verified/restart_a_sample460_mem.s) | 32 |
| [restart_a_sample461.s](round4/verified/restart_a_sample461.s) | [restart_a_sample461_mem.s](round4/verified/restart_a_sample461_mem.s) | 32 |
| [restart_a_sample462.s](round4/verified/restart_a_sample462.s) | [restart_a_sample462_mem.s](round4/verified/restart_a_sample462_mem.s) | 32 |
| [restart_a_sample463.s](round4/verified/restart_a_sample463.s) | [restart_a_sample463_mem.s](round4/verified/restart_a_sample463_mem.s) | 32 |
| [restart_a_sample464.s](round4/verified/restart_a_sample464.s) | [restart_a_sample464_mem.s](round4/verified/restart_a_sample464_mem.s) | 32 |
| [restart_a_sample465.s](round4/verified/restart_a_sample465.s) | [restart_a_sample465_mem.s](round4/verified/restart_a_sample465_mem.s) | 32 |
| [restart_a_sample466.s](round4/verified/restart_a_sample466.s) | [restart_a_sample466_mem.s](round4/verified/restart_a_sample466_mem.s) | 32 |
| [restart_a_sample467.s](round4/verified/restart_a_sample467.s) | [restart_a_sample467_mem.s](round4/verified/restart_a_sample467_mem.s) | 32 |
| [restart_a_sample468.s](round4/verified/restart_a_sample468.s) | [restart_a_sample468_mem.s](round4/verified/restart_a_sample468_mem.s) | 32 |
| [restart_a_sample469.s](round4/verified/restart_a_sample469.s) | [restart_a_sample469_mem.s](round4/verified/restart_a_sample469_mem.s) | 32 |
| [restart_a_sample47.s](round4/verified/restart_a_sample47.s) | [restart_a_sample47_mem.s](round4/verified/restart_a_sample47_mem.s) | 32 |
| [restart_a_sample470.s](round4/verified/restart_a_sample470.s) | [restart_a_sample470_mem.s](round4/verified/restart_a_sample470_mem.s) | 32 |
| [restart_a_sample471.s](round4/verified/restart_a_sample471.s) | [restart_a_sample471_mem.s](round4/verified/restart_a_sample471_mem.s) | 32 |
| [restart_a_sample472.s](round4/verified/restart_a_sample472.s) | [restart_a_sample472_mem.s](round4/verified/restart_a_sample472_mem.s) | 32 |
| [restart_a_sample473.s](round4/verified/restart_a_sample473.s) | [restart_a_sample473_mem.s](round4/verified/restart_a_sample473_mem.s) | 32 |
| [restart_a_sample474.s](round4/verified/restart_a_sample474.s) | [restart_a_sample474_mem.s](round4/verified/restart_a_sample474_mem.s) | 32 |
| [restart_a_sample475.s](round4/verified/restart_a_sample475.s) | [restart_a_sample475_mem.s](round4/verified/restart_a_sample475_mem.s) | 32 |
| [restart_a_sample476.s](round4/verified/restart_a_sample476.s) | [restart_a_sample476_mem.s](round4/verified/restart_a_sample476_mem.s) | 32 |
| [restart_a_sample477.s](round4/verified/restart_a_sample477.s) | [restart_a_sample477_mem.s](round4/verified/restart_a_sample477_mem.s) | 32 |
| [restart_a_sample478.s](round4/verified/restart_a_sample478.s) | [restart_a_sample478_mem.s](round4/verified/restart_a_sample478_mem.s) | 32 |
| [restart_a_sample479.s](round4/verified/restart_a_sample479.s) | [restart_a_sample479_mem.s](round4/verified/restart_a_sample479_mem.s) | 32 |
| [restart_a_sample48.s](round4/verified/restart_a_sample48.s) | [restart_a_sample48_mem.s](round4/verified/restart_a_sample48_mem.s) | 32 |
| [restart_a_sample480.s](round4/verified/restart_a_sample480.s) | [restart_a_sample480_mem.s](round4/verified/restart_a_sample480_mem.s) | 32 |
| [restart_a_sample481.s](round4/verified/restart_a_sample481.s) | [restart_a_sample481_mem.s](round4/verified/restart_a_sample481_mem.s) | 32 |
| [restart_a_sample482.s](round4/verified/restart_a_sample482.s) | [restart_a_sample482_mem.s](round4/verified/restart_a_sample482_mem.s) | 32 |
| [restart_a_sample483.s](round4/verified/restart_a_sample483.s) | [restart_a_sample483_mem.s](round4/verified/restart_a_sample483_mem.s) | 32 |
| [restart_a_sample484.s](round4/verified/restart_a_sample484.s) | [restart_a_sample484_mem.s](round4/verified/restart_a_sample484_mem.s) | 32 |
| [restart_a_sample485.s](round4/verified/restart_a_sample485.s) | [restart_a_sample485_mem.s](round4/verified/restart_a_sample485_mem.s) | 32 |
| [restart_a_sample486.s](round4/verified/restart_a_sample486.s) | [restart_a_sample486_mem.s](round4/verified/restart_a_sample486_mem.s) | 32 |
| [restart_a_sample487.s](round4/verified/restart_a_sample487.s) | [restart_a_sample487_mem.s](round4/verified/restart_a_sample487_mem.s) | 32 |
| [restart_a_sample488.s](round4/verified/restart_a_sample488.s) | [restart_a_sample488_mem.s](round4/verified/restart_a_sample488_mem.s) | 32 |
| [restart_a_sample489.s](round4/verified/restart_a_sample489.s) | [restart_a_sample489_mem.s](round4/verified/restart_a_sample489_mem.s) | 32 |
| [restart_a_sample49.s](round4/verified/restart_a_sample49.s) | [restart_a_sample49_mem.s](round4/verified/restart_a_sample49_mem.s) | 32 |
| [restart_a_sample490.s](round4/verified/restart_a_sample490.s) | [restart_a_sample490_mem.s](round4/verified/restart_a_sample490_mem.s) | 32 |
| [restart_a_sample491.s](round4/verified/restart_a_sample491.s) | [restart_a_sample491_mem.s](round4/verified/restart_a_sample491_mem.s) | 32 |
| [restart_a_sample492.s](round4/verified/restart_a_sample492.s) | [restart_a_sample492_mem.s](round4/verified/restart_a_sample492_mem.s) | 32 |
| [restart_a_sample493.s](round4/verified/restart_a_sample493.s) | [restart_a_sample493_mem.s](round4/verified/restart_a_sample493_mem.s) | 32 |
| [restart_a_sample494.s](round4/verified/restart_a_sample494.s) | [restart_a_sample494_mem.s](round4/verified/restart_a_sample494_mem.s) | 32 |
| [restart_a_sample495.s](round4/verified/restart_a_sample495.s) | [restart_a_sample495_mem.s](round4/verified/restart_a_sample495_mem.s) | 32 |
| [restart_a_sample496.s](round4/verified/restart_a_sample496.s) | [restart_a_sample496_mem.s](round4/verified/restart_a_sample496_mem.s) | 32 |
| [restart_a_sample497.s](round4/verified/restart_a_sample497.s) | [restart_a_sample497_mem.s](round4/verified/restart_a_sample497_mem.s) | 32 |
| [restart_a_sample498.s](round4/verified/restart_a_sample498.s) | [restart_a_sample498_mem.s](round4/verified/restart_a_sample498_mem.s) | 32 |
| [restart_a_sample499.s](round4/verified/restart_a_sample499.s) | [restart_a_sample499_mem.s](round4/verified/restart_a_sample499_mem.s) | 32 |
| [restart_a_sample5.s](round4/verified/restart_a_sample5.s) | [restart_a_sample5_mem.s](round4/verified/restart_a_sample5_mem.s) | 32 |
| [restart_a_sample50.s](round4/verified/restart_a_sample50.s) | [restart_a_sample50_mem.s](round4/verified/restart_a_sample50_mem.s) | 32 |
| [restart_a_sample500.s](round4/verified/restart_a_sample500.s) | [restart_a_sample500_mem.s](round4/verified/restart_a_sample500_mem.s) | 32 |
| [restart_a_sample501.s](round4/verified/restart_a_sample501.s) | [restart_a_sample501_mem.s](round4/verified/restart_a_sample501_mem.s) | 32 |
| [restart_a_sample502.s](round4/verified/restart_a_sample502.s) | [restart_a_sample502_mem.s](round4/verified/restart_a_sample502_mem.s) | 32 |
| [restart_a_sample503.s](round4/verified/restart_a_sample503.s) | [restart_a_sample503_mem.s](round4/verified/restart_a_sample503_mem.s) | 32 |
| [restart_a_sample504.s](round4/verified/restart_a_sample504.s) | [restart_a_sample504_mem.s](round4/verified/restart_a_sample504_mem.s) | 32 |
| [restart_a_sample505.s](round4/verified/restart_a_sample505.s) | [restart_a_sample505_mem.s](round4/verified/restart_a_sample505_mem.s) | 32 |
| [restart_a_sample506.s](round4/verified/restart_a_sample506.s) | [restart_a_sample506_mem.s](round4/verified/restart_a_sample506_mem.s) | 32 |
| [restart_a_sample507.s](round4/verified/restart_a_sample507.s) | [restart_a_sample507_mem.s](round4/verified/restart_a_sample507_mem.s) | 32 |
| [restart_a_sample508.s](round4/verified/restart_a_sample508.s) | [restart_a_sample508_mem.s](round4/verified/restart_a_sample508_mem.s) | 32 |
| [restart_a_sample509.s](round4/verified/restart_a_sample509.s) | [restart_a_sample509_mem.s](round4/verified/restart_a_sample509_mem.s) | 32 |
| [restart_a_sample51.s](round4/verified/restart_a_sample51.s) | [restart_a_sample51_mem.s](round4/verified/restart_a_sample51_mem.s) | 32 |
| [restart_a_sample510.s](round4/verified/restart_a_sample510.s) | [restart_a_sample510_mem.s](round4/verified/restart_a_sample510_mem.s) | 32 |
| [restart_a_sample511.s](round4/verified/restart_a_sample511.s) | [restart_a_sample511_mem.s](round4/verified/restart_a_sample511_mem.s) | 32 |
| [restart_a_sample512.s](round4/verified/restart_a_sample512.s) | [restart_a_sample512_mem.s](round4/verified/restart_a_sample512_mem.s) | 32 |
| [restart_a_sample513.s](round4/verified/restart_a_sample513.s) | [restart_a_sample513_mem.s](round4/verified/restart_a_sample513_mem.s) | 32 |
| [restart_a_sample514.s](round4/verified/restart_a_sample514.s) | [restart_a_sample514_mem.s](round4/verified/restart_a_sample514_mem.s) | 32 |
| [restart_a_sample515.s](round4/verified/restart_a_sample515.s) | [restart_a_sample515_mem.s](round4/verified/restart_a_sample515_mem.s) | 32 |
| [restart_a_sample52.s](round4/verified/restart_a_sample52.s) | [restart_a_sample52_mem.s](round4/verified/restart_a_sample52_mem.s) | 32 |
| [restart_a_sample53.s](round4/verified/restart_a_sample53.s) | [restart_a_sample53_mem.s](round4/verified/restart_a_sample53_mem.s) | 32 |
| [restart_a_sample54.s](round4/verified/restart_a_sample54.s) | [restart_a_sample54_mem.s](round4/verified/restart_a_sample54_mem.s) | 32 |
| [restart_a_sample55.s](round4/verified/restart_a_sample55.s) | [restart_a_sample55_mem.s](round4/verified/restart_a_sample55_mem.s) | 32 |
| [restart_a_sample56.s](round4/verified/restart_a_sample56.s) | [restart_a_sample56_mem.s](round4/verified/restart_a_sample56_mem.s) | 32 |
| [restart_a_sample57.s](round4/verified/restart_a_sample57.s) | [restart_a_sample57_mem.s](round4/verified/restart_a_sample57_mem.s) | 32 |
| [restart_a_sample58.s](round4/verified/restart_a_sample58.s) | [restart_a_sample58_mem.s](round4/verified/restart_a_sample58_mem.s) | 32 |
| [restart_a_sample59.s](round4/verified/restart_a_sample59.s) | [restart_a_sample59_mem.s](round4/verified/restart_a_sample59_mem.s) | 32 |
| [restart_a_sample6.s](round4/verified/restart_a_sample6.s) | [restart_a_sample6_mem.s](round4/verified/restart_a_sample6_mem.s) | 32 |
| [restart_a_sample60.s](round4/verified/restart_a_sample60.s) | [restart_a_sample60_mem.s](round4/verified/restart_a_sample60_mem.s) | 32 |
| [restart_a_sample61.s](round4/verified/restart_a_sample61.s) | [restart_a_sample61_mem.s](round4/verified/restart_a_sample61_mem.s) | 32 |
| [restart_a_sample62.s](round4/verified/restart_a_sample62.s) | [restart_a_sample62_mem.s](round4/verified/restart_a_sample62_mem.s) | 32 |
| [restart_a_sample63.s](round4/verified/restart_a_sample63.s) | [restart_a_sample63_mem.s](round4/verified/restart_a_sample63_mem.s) | 32 |
| [restart_a_sample64.s](round4/verified/restart_a_sample64.s) | [restart_a_sample64_mem.s](round4/verified/restart_a_sample64_mem.s) | 32 |
| [restart_a_sample65.s](round4/verified/restart_a_sample65.s) | [restart_a_sample65_mem.s](round4/verified/restart_a_sample65_mem.s) | 32 |
| [restart_a_sample66.s](round4/verified/restart_a_sample66.s) | [restart_a_sample66_mem.s](round4/verified/restart_a_sample66_mem.s) | 32 |
| [restart_a_sample67.s](round4/verified/restart_a_sample67.s) | [restart_a_sample67_mem.s](round4/verified/restart_a_sample67_mem.s) | 32 |
| [restart_a_sample68.s](round4/verified/restart_a_sample68.s) | [restart_a_sample68_mem.s](round4/verified/restart_a_sample68_mem.s) | 32 |
| [restart_a_sample69.s](round4/verified/restart_a_sample69.s) | [restart_a_sample69_mem.s](round4/verified/restart_a_sample69_mem.s) | 32 |
| [restart_a_sample7.s](round4/verified/restart_a_sample7.s) | [restart_a_sample7_mem.s](round4/verified/restart_a_sample7_mem.s) | 32 |
| [restart_a_sample70.s](round4/verified/restart_a_sample70.s) | [restart_a_sample70_mem.s](round4/verified/restart_a_sample70_mem.s) | 32 |
| [restart_a_sample71.s](round4/verified/restart_a_sample71.s) | [restart_a_sample71_mem.s](round4/verified/restart_a_sample71_mem.s) | 32 |
| [restart_a_sample72.s](round4/verified/restart_a_sample72.s) | [restart_a_sample72_mem.s](round4/verified/restart_a_sample72_mem.s) | 32 |
| [restart_a_sample73.s](round4/verified/restart_a_sample73.s) | [restart_a_sample73_mem.s](round4/verified/restart_a_sample73_mem.s) | 32 |
| [restart_a_sample74.s](round4/verified/restart_a_sample74.s) | [restart_a_sample74_mem.s](round4/verified/restart_a_sample74_mem.s) | 32 |
| [restart_a_sample75.s](round4/verified/restart_a_sample75.s) | [restart_a_sample75_mem.s](round4/verified/restart_a_sample75_mem.s) | 32 |
| [restart_a_sample76.s](round4/verified/restart_a_sample76.s) | [restart_a_sample76_mem.s](round4/verified/restart_a_sample76_mem.s) | 32 |
| [restart_a_sample77.s](round4/verified/restart_a_sample77.s) | [restart_a_sample77_mem.s](round4/verified/restart_a_sample77_mem.s) | 32 |
| [restart_a_sample78.s](round4/verified/restart_a_sample78.s) | [restart_a_sample78_mem.s](round4/verified/restart_a_sample78_mem.s) | 32 |
| [restart_a_sample79.s](round4/verified/restart_a_sample79.s) | [restart_a_sample79_mem.s](round4/verified/restart_a_sample79_mem.s) | 32 |
| [restart_a_sample8.s](round4/verified/restart_a_sample8.s) | [restart_a_sample8_mem.s](round4/verified/restart_a_sample8_mem.s) | 32 |
| [restart_a_sample80.s](round4/verified/restart_a_sample80.s) | [restart_a_sample80_mem.s](round4/verified/restart_a_sample80_mem.s) | 32 |
| [restart_a_sample81.s](round4/verified/restart_a_sample81.s) | [restart_a_sample81_mem.s](round4/verified/restart_a_sample81_mem.s) | 32 |
| [restart_a_sample82.s](round4/verified/restart_a_sample82.s) | [restart_a_sample82_mem.s](round4/verified/restart_a_sample82_mem.s) | 32 |
| [restart_a_sample83.s](round4/verified/restart_a_sample83.s) | [restart_a_sample83_mem.s](round4/verified/restart_a_sample83_mem.s) | 32 |
| [restart_a_sample84.s](round4/verified/restart_a_sample84.s) | [restart_a_sample84_mem.s](round4/verified/restart_a_sample84_mem.s) | 32 |
| [restart_a_sample85.s](round4/verified/restart_a_sample85.s) | [restart_a_sample85_mem.s](round4/verified/restart_a_sample85_mem.s) | 32 |
| [restart_a_sample86.s](round4/verified/restart_a_sample86.s) | [restart_a_sample86_mem.s](round4/verified/restart_a_sample86_mem.s) | 32 |
| [restart_a_sample87.s](round4/verified/restart_a_sample87.s) | [restart_a_sample87_mem.s](round4/verified/restart_a_sample87_mem.s) | 32 |
| [restart_a_sample88.s](round4/verified/restart_a_sample88.s) | [restart_a_sample88_mem.s](round4/verified/restart_a_sample88_mem.s) | 32 |
| [restart_a_sample89.s](round4/verified/restart_a_sample89.s) | [restart_a_sample89_mem.s](round4/verified/restart_a_sample89_mem.s) | 32 |
| [restart_a_sample9.s](round4/verified/restart_a_sample9.s) | [restart_a_sample9_mem.s](round4/verified/restart_a_sample9_mem.s) | 32 |
| [restart_a_sample90.s](round4/verified/restart_a_sample90.s) | [restart_a_sample90_mem.s](round4/verified/restart_a_sample90_mem.s) | 32 |
| [restart_a_sample91.s](round4/verified/restart_a_sample91.s) | [restart_a_sample91_mem.s](round4/verified/restart_a_sample91_mem.s) | 32 |
| [restart_a_sample92.s](round4/verified/restart_a_sample92.s) | [restart_a_sample92_mem.s](round4/verified/restart_a_sample92_mem.s) | 32 |
| [restart_a_sample93.s](round4/verified/restart_a_sample93.s) | [restart_a_sample93_mem.s](round4/verified/restart_a_sample93_mem.s) | 32 |
| [restart_a_sample94.s](round4/verified/restart_a_sample94.s) | [restart_a_sample94_mem.s](round4/verified/restart_a_sample94_mem.s) | 32 |
| [restart_a_sample95.s](round4/verified/restart_a_sample95.s) | [restart_a_sample95_mem.s](round4/verified/restart_a_sample95_mem.s) | 32 |
| [restart_a_sample96.s](round4/verified/restart_a_sample96.s) | [restart_a_sample96_mem.s](round4/verified/restart_a_sample96_mem.s) | 32 |
| [restart_a_sample97.s](round4/verified/restart_a_sample97.s) | [restart_a_sample97_mem.s](round4/verified/restart_a_sample97_mem.s) | 32 |
| [restart_a_sample98.s](round4/verified/restart_a_sample98.s) | [restart_a_sample98_mem.s](round4/verified/restart_a_sample98_mem.s) | 32 |
| [restart_a_sample99.s](round4/verified/restart_a_sample99.s) | [restart_a_sample99_mem.s](round4/verified/restart_a_sample99_mem.s) | 32 |
| [sat_control32.s](round4/verified/sat_control32.s) | [sat_control32_mem.s](round4/verified/sat_control32_mem.s) | 32 |

### Limits

These are bounded neighborhood results and stochastic observations. No global lower bound follows. The conservative simulator can reject valid programs that depend on scratch-value correlations. No such rejection is treated as a strict PASS.

### Conclusion

The requested k<=31 core remains unfound. All round-4 jobs have finished.


## Round 5: pair fusion with flag and source rewrites

### Purpose

Find k<=31 by sharing the work of two instruction events. Read all previous results first. This round uses a new trace-preserving rewrite search. It does not rerun the excluded network, routing, lattice, or Hamming-distance searches.

No program with k<=31 received a strict judge PASS. The best verified core remains k=32. Its memory version has 42 instructions.

### Terms

Core length k counts MOV, CMP, and CMOV instructions. Output records have no cost. A value column lists one register value for each of the 541 weak input orders. A flag column lists each comparison outcome. A terminal state reaches the end of the rewritten program with the required edit counts. A terminal state can still lack required output values. Search-node counts include visits before duplicate states are merged. They are not counts of distinct programs. A SAT query asks whether Boolean constraints have a satisfying assignment. UNSAT means the solver found no assignment for the encoded query.

### Method

The frozen source set has 143 w6 round-2 variants and the w5 palette form. All 144 cores have k=32. Source paths, instruction lists, and SHA-256 hashes are in `round5/manifest.json`.

The rules remove two distinct instruction events and insert at most one instruction at any gap. Every surviving write keeps its destination and its original full value column. Its opcode can become MOV or any supported CMOV. Its source can use any available register. Thus one fusion can repair many later consumers. The inserted write can construct any original value column. One fresh scratch register is available. Outputs can select new snapshots.

The fixed-flag version preserves each surviving comparison column. It can change comparison operands. The free-flag version compares any available register pair at every surviving comparison. It can change every comparison column. Both operand orders are covered. Instructions with identical full effects share one state. The exact rule set and its limits are in `round5/RULES.md`; the implementation is `round5/src/rewrite.cpp`.

The retiming scan removes one instruction and inserts at most one instruction. It tests moving a conditional operation across comparisons, replacing it with MOV, and repairing later sources and predicates. It retained one changed k=32 form per seed. The shorter-program scan then ran again from all 144 retained forms. Their paths and hashes are in `round5/retimed_manifest.json`.

All search, compiler, simulator-check, and judge jobs use nice level 19. At most two CPU jobs run together. CPU affinity is 76–77. Search and SAT processes have a 2,800 MiB address-space limit. Every new file is inside w5.

### Result

The CMOV-pair audit tested 30,931 pairs and 61,862 flag choices. It found 63 necessary value witnesses for 49 different pairs in 13 seeds. Each witness also passed with reversed comparison operands and reversed predicates. These are value witnesses only. They do not establish a correct complete program. See `round5/pair_audit.json`.

The separate alternate-flag audit found 98 witnesses. Their replacement opcode counts are `{'mov': 98}`. These witnesses only copy a value that is already present. They yielded no shorter complete program in the completed rewrite scans. See `round5/candidates/fuse_audit.txt`.

Every scan in the table finished all its seeds. No seed hit its time or state limit. None of the three shorter-program scans supplied all five output columns.

| Completed scan | Seeds | Search-node visits | Insertions tried | Terminal states |
|---|---:|---:|---:|---:|
| Fixed flags; two removals and one insertion | 144 | 49,396,829 | 5,050,837 | 1,993,608 |
| Free comparisons; original seeds | 144 | 549,550,656 | 159,082,788 | 1,788,952 |
| Free comparisons; retained retiming forms | 144 | 558,938,447 | 161,855,513 | 1,802,326 |

The retiming scan visited 16,696,345 nodes. It had 17,915 successful edit paths, including paths that reconstruct the original instruction list. Of these paths, 10,971 changed the instruction list. These counts include duplicate programs. The 144 retained forms passed both strict judges.

The independent transition check sampled all 144 seeds. It checked 57,600 conditional-move queries and 39,655 comparison reversals. No mismatch occurred. The exact relaxed SAT-candidate evaluator also matched the reference scalar interpreter on 32 random programs, 256 input cases, and 41,472 register values. These are test results, not proofs of the implementation. Logs: `round5/logs/check.log` and `round5/logs/test_relaxed.log`. The duplicate-CMOV removal control passed both strict judges at k=32 and memory length 42.

The SAT repair tested all 49 audited pairs from the 13 seeds with a witness. It first tested one shortest pair per seed, then tested the remaining 36 pairs. It deleted both CMOVs and inserted one write at the earlier gap. It freed write sources, write opcodes, and comparison operands in the surrounding window. Surviving write destinations stayed fixed. The inserted write had a free destination. These queries could create new intermediate value columns. Outside instructions and comparison positions stayed fixed. Outputs were free snapshots.

SAT status counts: `{'UNSAT': 18, 'UNKNOWN_WALL_LIMIT': 31}`. Each query had a 15-second wall limit. An UNSAT result excludes only its stated finite query. A wall limit is UNKNOWN. Commands, windows, encoded case counts, and logs are in `round5/sat_results_*.json` and `round5/logs/fusion_sat_*.log`. The k=32 SAT control passed both strict judges.

The final judge ledger contains 292 strict PASS files. Every out file below has k=32. Every corresponding memory file has 42 instructions. Each path, model, hash, and judge log is also in `round5/verified_integrity.json`.

| Out PASS file | Memory PASS file |
|---|---|
| [control_0_neutral.s](round5/verified/control_0_neutral.s) | [control_0_neutral_mem.s](round5/verified/control_0_neutral_mem.s) |
| [fusion_sat_control32.s](round5/verified/fusion_sat_control32.s) | [fusion_sat_control32_mem.s](round5/verified/fusion_sat_control32_mem.s) |
| [retime_0_neutral.s](round5/verified/retime_0_neutral.s) | [retime_0_neutral_mem.s](round5/verified/retime_0_neutral_mem.s) |
| [retime_100_neutral.s](round5/verified/retime_100_neutral.s) | [retime_100_neutral_mem.s](round5/verified/retime_100_neutral_mem.s) |
| [retime_101_neutral.s](round5/verified/retime_101_neutral.s) | [retime_101_neutral_mem.s](round5/verified/retime_101_neutral_mem.s) |
| [retime_102_neutral.s](round5/verified/retime_102_neutral.s) | [retime_102_neutral_mem.s](round5/verified/retime_102_neutral_mem.s) |
| [retime_103_neutral.s](round5/verified/retime_103_neutral.s) | [retime_103_neutral_mem.s](round5/verified/retime_103_neutral_mem.s) |
| [retime_104_neutral.s](round5/verified/retime_104_neutral.s) | [retime_104_neutral_mem.s](round5/verified/retime_104_neutral_mem.s) |
| [retime_105_neutral.s](round5/verified/retime_105_neutral.s) | [retime_105_neutral_mem.s](round5/verified/retime_105_neutral_mem.s) |
| [retime_106_neutral.s](round5/verified/retime_106_neutral.s) | [retime_106_neutral_mem.s](round5/verified/retime_106_neutral_mem.s) |
| [retime_107_neutral.s](round5/verified/retime_107_neutral.s) | [retime_107_neutral_mem.s](round5/verified/retime_107_neutral_mem.s) |
| [retime_108_neutral.s](round5/verified/retime_108_neutral.s) | [retime_108_neutral_mem.s](round5/verified/retime_108_neutral_mem.s) |
| [retime_109_neutral.s](round5/verified/retime_109_neutral.s) | [retime_109_neutral_mem.s](round5/verified/retime_109_neutral_mem.s) |
| [retime_10_neutral.s](round5/verified/retime_10_neutral.s) | [retime_10_neutral_mem.s](round5/verified/retime_10_neutral_mem.s) |
| [retime_110_neutral.s](round5/verified/retime_110_neutral.s) | [retime_110_neutral_mem.s](round5/verified/retime_110_neutral_mem.s) |
| [retime_111_neutral.s](round5/verified/retime_111_neutral.s) | [retime_111_neutral_mem.s](round5/verified/retime_111_neutral_mem.s) |
| [retime_112_neutral.s](round5/verified/retime_112_neutral.s) | [retime_112_neutral_mem.s](round5/verified/retime_112_neutral_mem.s) |
| [retime_113_neutral.s](round5/verified/retime_113_neutral.s) | [retime_113_neutral_mem.s](round5/verified/retime_113_neutral_mem.s) |
| [retime_114_neutral.s](round5/verified/retime_114_neutral.s) | [retime_114_neutral_mem.s](round5/verified/retime_114_neutral_mem.s) |
| [retime_115_neutral.s](round5/verified/retime_115_neutral.s) | [retime_115_neutral_mem.s](round5/verified/retime_115_neutral_mem.s) |
| [retime_116_neutral.s](round5/verified/retime_116_neutral.s) | [retime_116_neutral_mem.s](round5/verified/retime_116_neutral_mem.s) |
| [retime_117_neutral.s](round5/verified/retime_117_neutral.s) | [retime_117_neutral_mem.s](round5/verified/retime_117_neutral_mem.s) |
| [retime_118_neutral.s](round5/verified/retime_118_neutral.s) | [retime_118_neutral_mem.s](round5/verified/retime_118_neutral_mem.s) |
| [retime_119_neutral.s](round5/verified/retime_119_neutral.s) | [retime_119_neutral_mem.s](round5/verified/retime_119_neutral_mem.s) |
| [retime_11_neutral.s](round5/verified/retime_11_neutral.s) | [retime_11_neutral_mem.s](round5/verified/retime_11_neutral_mem.s) |
| [retime_120_neutral.s](round5/verified/retime_120_neutral.s) | [retime_120_neutral_mem.s](round5/verified/retime_120_neutral_mem.s) |
| [retime_121_neutral.s](round5/verified/retime_121_neutral.s) | [retime_121_neutral_mem.s](round5/verified/retime_121_neutral_mem.s) |
| [retime_122_neutral.s](round5/verified/retime_122_neutral.s) | [retime_122_neutral_mem.s](round5/verified/retime_122_neutral_mem.s) |
| [retime_123_neutral.s](round5/verified/retime_123_neutral.s) | [retime_123_neutral_mem.s](round5/verified/retime_123_neutral_mem.s) |
| [retime_124_neutral.s](round5/verified/retime_124_neutral.s) | [retime_124_neutral_mem.s](round5/verified/retime_124_neutral_mem.s) |
| [retime_125_neutral.s](round5/verified/retime_125_neutral.s) | [retime_125_neutral_mem.s](round5/verified/retime_125_neutral_mem.s) |
| [retime_126_neutral.s](round5/verified/retime_126_neutral.s) | [retime_126_neutral_mem.s](round5/verified/retime_126_neutral_mem.s) |
| [retime_127_neutral.s](round5/verified/retime_127_neutral.s) | [retime_127_neutral_mem.s](round5/verified/retime_127_neutral_mem.s) |
| [retime_128_neutral.s](round5/verified/retime_128_neutral.s) | [retime_128_neutral_mem.s](round5/verified/retime_128_neutral_mem.s) |
| [retime_129_neutral.s](round5/verified/retime_129_neutral.s) | [retime_129_neutral_mem.s](round5/verified/retime_129_neutral_mem.s) |
| [retime_12_neutral.s](round5/verified/retime_12_neutral.s) | [retime_12_neutral_mem.s](round5/verified/retime_12_neutral_mem.s) |
| [retime_130_neutral.s](round5/verified/retime_130_neutral.s) | [retime_130_neutral_mem.s](round5/verified/retime_130_neutral_mem.s) |
| [retime_131_neutral.s](round5/verified/retime_131_neutral.s) | [retime_131_neutral_mem.s](round5/verified/retime_131_neutral_mem.s) |
| [retime_132_neutral.s](round5/verified/retime_132_neutral.s) | [retime_132_neutral_mem.s](round5/verified/retime_132_neutral_mem.s) |
| [retime_133_neutral.s](round5/verified/retime_133_neutral.s) | [retime_133_neutral_mem.s](round5/verified/retime_133_neutral_mem.s) |
| [retime_134_neutral.s](round5/verified/retime_134_neutral.s) | [retime_134_neutral_mem.s](round5/verified/retime_134_neutral_mem.s) |
| [retime_135_neutral.s](round5/verified/retime_135_neutral.s) | [retime_135_neutral_mem.s](round5/verified/retime_135_neutral_mem.s) |
| [retime_136_neutral.s](round5/verified/retime_136_neutral.s) | [retime_136_neutral_mem.s](round5/verified/retime_136_neutral_mem.s) |
| [retime_137_neutral.s](round5/verified/retime_137_neutral.s) | [retime_137_neutral_mem.s](round5/verified/retime_137_neutral_mem.s) |
| [retime_138_neutral.s](round5/verified/retime_138_neutral.s) | [retime_138_neutral_mem.s](round5/verified/retime_138_neutral_mem.s) |
| [retime_139_neutral.s](round5/verified/retime_139_neutral.s) | [retime_139_neutral_mem.s](round5/verified/retime_139_neutral_mem.s) |
| [retime_13_neutral.s](round5/verified/retime_13_neutral.s) | [retime_13_neutral_mem.s](round5/verified/retime_13_neutral_mem.s) |
| [retime_140_neutral.s](round5/verified/retime_140_neutral.s) | [retime_140_neutral_mem.s](round5/verified/retime_140_neutral_mem.s) |
| [retime_141_neutral.s](round5/verified/retime_141_neutral.s) | [retime_141_neutral_mem.s](round5/verified/retime_141_neutral_mem.s) |
| [retime_142_neutral.s](round5/verified/retime_142_neutral.s) | [retime_142_neutral_mem.s](round5/verified/retime_142_neutral_mem.s) |
| [retime_143_neutral.s](round5/verified/retime_143_neutral.s) | [retime_143_neutral_mem.s](round5/verified/retime_143_neutral_mem.s) |
| [retime_14_neutral.s](round5/verified/retime_14_neutral.s) | [retime_14_neutral_mem.s](round5/verified/retime_14_neutral_mem.s) |
| [retime_15_neutral.s](round5/verified/retime_15_neutral.s) | [retime_15_neutral_mem.s](round5/verified/retime_15_neutral_mem.s) |
| [retime_16_neutral.s](round5/verified/retime_16_neutral.s) | [retime_16_neutral_mem.s](round5/verified/retime_16_neutral_mem.s) |
| [retime_17_neutral.s](round5/verified/retime_17_neutral.s) | [retime_17_neutral_mem.s](round5/verified/retime_17_neutral_mem.s) |
| [retime_18_neutral.s](round5/verified/retime_18_neutral.s) | [retime_18_neutral_mem.s](round5/verified/retime_18_neutral_mem.s) |
| [retime_19_neutral.s](round5/verified/retime_19_neutral.s) | [retime_19_neutral_mem.s](round5/verified/retime_19_neutral_mem.s) |
| [retime_1_neutral.s](round5/verified/retime_1_neutral.s) | [retime_1_neutral_mem.s](round5/verified/retime_1_neutral_mem.s) |
| [retime_20_neutral.s](round5/verified/retime_20_neutral.s) | [retime_20_neutral_mem.s](round5/verified/retime_20_neutral_mem.s) |
| [retime_21_neutral.s](round5/verified/retime_21_neutral.s) | [retime_21_neutral_mem.s](round5/verified/retime_21_neutral_mem.s) |
| [retime_22_neutral.s](round5/verified/retime_22_neutral.s) | [retime_22_neutral_mem.s](round5/verified/retime_22_neutral_mem.s) |
| [retime_23_neutral.s](round5/verified/retime_23_neutral.s) | [retime_23_neutral_mem.s](round5/verified/retime_23_neutral_mem.s) |
| [retime_24_neutral.s](round5/verified/retime_24_neutral.s) | [retime_24_neutral_mem.s](round5/verified/retime_24_neutral_mem.s) |
| [retime_25_neutral.s](round5/verified/retime_25_neutral.s) | [retime_25_neutral_mem.s](round5/verified/retime_25_neutral_mem.s) |
| [retime_26_neutral.s](round5/verified/retime_26_neutral.s) | [retime_26_neutral_mem.s](round5/verified/retime_26_neutral_mem.s) |
| [retime_27_neutral.s](round5/verified/retime_27_neutral.s) | [retime_27_neutral_mem.s](round5/verified/retime_27_neutral_mem.s) |
| [retime_28_neutral.s](round5/verified/retime_28_neutral.s) | [retime_28_neutral_mem.s](round5/verified/retime_28_neutral_mem.s) |
| [retime_29_neutral.s](round5/verified/retime_29_neutral.s) | [retime_29_neutral_mem.s](round5/verified/retime_29_neutral_mem.s) |
| [retime_2_neutral.s](round5/verified/retime_2_neutral.s) | [retime_2_neutral_mem.s](round5/verified/retime_2_neutral_mem.s) |
| [retime_30_neutral.s](round5/verified/retime_30_neutral.s) | [retime_30_neutral_mem.s](round5/verified/retime_30_neutral_mem.s) |
| [retime_31_neutral.s](round5/verified/retime_31_neutral.s) | [retime_31_neutral_mem.s](round5/verified/retime_31_neutral_mem.s) |
| [retime_32_neutral.s](round5/verified/retime_32_neutral.s) | [retime_32_neutral_mem.s](round5/verified/retime_32_neutral_mem.s) |
| [retime_33_neutral.s](round5/verified/retime_33_neutral.s) | [retime_33_neutral_mem.s](round5/verified/retime_33_neutral_mem.s) |
| [retime_34_neutral.s](round5/verified/retime_34_neutral.s) | [retime_34_neutral_mem.s](round5/verified/retime_34_neutral_mem.s) |
| [retime_35_neutral.s](round5/verified/retime_35_neutral.s) | [retime_35_neutral_mem.s](round5/verified/retime_35_neutral_mem.s) |
| [retime_36_neutral.s](round5/verified/retime_36_neutral.s) | [retime_36_neutral_mem.s](round5/verified/retime_36_neutral_mem.s) |
| [retime_37_neutral.s](round5/verified/retime_37_neutral.s) | [retime_37_neutral_mem.s](round5/verified/retime_37_neutral_mem.s) |
| [retime_38_neutral.s](round5/verified/retime_38_neutral.s) | [retime_38_neutral_mem.s](round5/verified/retime_38_neutral_mem.s) |
| [retime_39_neutral.s](round5/verified/retime_39_neutral.s) | [retime_39_neutral_mem.s](round5/verified/retime_39_neutral_mem.s) |
| [retime_3_neutral.s](round5/verified/retime_3_neutral.s) | [retime_3_neutral_mem.s](round5/verified/retime_3_neutral_mem.s) |
| [retime_40_neutral.s](round5/verified/retime_40_neutral.s) | [retime_40_neutral_mem.s](round5/verified/retime_40_neutral_mem.s) |
| [retime_41_neutral.s](round5/verified/retime_41_neutral.s) | [retime_41_neutral_mem.s](round5/verified/retime_41_neutral_mem.s) |
| [retime_42_neutral.s](round5/verified/retime_42_neutral.s) | [retime_42_neutral_mem.s](round5/verified/retime_42_neutral_mem.s) |
| [retime_43_neutral.s](round5/verified/retime_43_neutral.s) | [retime_43_neutral_mem.s](round5/verified/retime_43_neutral_mem.s) |
| [retime_44_neutral.s](round5/verified/retime_44_neutral.s) | [retime_44_neutral_mem.s](round5/verified/retime_44_neutral_mem.s) |
| [retime_45_neutral.s](round5/verified/retime_45_neutral.s) | [retime_45_neutral_mem.s](round5/verified/retime_45_neutral_mem.s) |
| [retime_46_neutral.s](round5/verified/retime_46_neutral.s) | [retime_46_neutral_mem.s](round5/verified/retime_46_neutral_mem.s) |
| [retime_47_neutral.s](round5/verified/retime_47_neutral.s) | [retime_47_neutral_mem.s](round5/verified/retime_47_neutral_mem.s) |
| [retime_48_neutral.s](round5/verified/retime_48_neutral.s) | [retime_48_neutral_mem.s](round5/verified/retime_48_neutral_mem.s) |
| [retime_49_neutral.s](round5/verified/retime_49_neutral.s) | [retime_49_neutral_mem.s](round5/verified/retime_49_neutral_mem.s) |
| [retime_4_neutral.s](round5/verified/retime_4_neutral.s) | [retime_4_neutral_mem.s](round5/verified/retime_4_neutral_mem.s) |
| [retime_50_neutral.s](round5/verified/retime_50_neutral.s) | [retime_50_neutral_mem.s](round5/verified/retime_50_neutral_mem.s) |
| [retime_51_neutral.s](round5/verified/retime_51_neutral.s) | [retime_51_neutral_mem.s](round5/verified/retime_51_neutral_mem.s) |
| [retime_52_neutral.s](round5/verified/retime_52_neutral.s) | [retime_52_neutral_mem.s](round5/verified/retime_52_neutral_mem.s) |
| [retime_53_neutral.s](round5/verified/retime_53_neutral.s) | [retime_53_neutral_mem.s](round5/verified/retime_53_neutral_mem.s) |
| [retime_54_neutral.s](round5/verified/retime_54_neutral.s) | [retime_54_neutral_mem.s](round5/verified/retime_54_neutral_mem.s) |
| [retime_55_neutral.s](round5/verified/retime_55_neutral.s) | [retime_55_neutral_mem.s](round5/verified/retime_55_neutral_mem.s) |
| [retime_56_neutral.s](round5/verified/retime_56_neutral.s) | [retime_56_neutral_mem.s](round5/verified/retime_56_neutral_mem.s) |
| [retime_57_neutral.s](round5/verified/retime_57_neutral.s) | [retime_57_neutral_mem.s](round5/verified/retime_57_neutral_mem.s) |
| [retime_58_neutral.s](round5/verified/retime_58_neutral.s) | [retime_58_neutral_mem.s](round5/verified/retime_58_neutral_mem.s) |
| [retime_59_neutral.s](round5/verified/retime_59_neutral.s) | [retime_59_neutral_mem.s](round5/verified/retime_59_neutral_mem.s) |
| [retime_5_neutral.s](round5/verified/retime_5_neutral.s) | [retime_5_neutral_mem.s](round5/verified/retime_5_neutral_mem.s) |
| [retime_60_neutral.s](round5/verified/retime_60_neutral.s) | [retime_60_neutral_mem.s](round5/verified/retime_60_neutral_mem.s) |
| [retime_61_neutral.s](round5/verified/retime_61_neutral.s) | [retime_61_neutral_mem.s](round5/verified/retime_61_neutral_mem.s) |
| [retime_62_neutral.s](round5/verified/retime_62_neutral.s) | [retime_62_neutral_mem.s](round5/verified/retime_62_neutral_mem.s) |
| [retime_63_neutral.s](round5/verified/retime_63_neutral.s) | [retime_63_neutral_mem.s](round5/verified/retime_63_neutral_mem.s) |
| [retime_64_neutral.s](round5/verified/retime_64_neutral.s) | [retime_64_neutral_mem.s](round5/verified/retime_64_neutral_mem.s) |
| [retime_65_neutral.s](round5/verified/retime_65_neutral.s) | [retime_65_neutral_mem.s](round5/verified/retime_65_neutral_mem.s) |
| [retime_66_neutral.s](round5/verified/retime_66_neutral.s) | [retime_66_neutral_mem.s](round5/verified/retime_66_neutral_mem.s) |
| [retime_67_neutral.s](round5/verified/retime_67_neutral.s) | [retime_67_neutral_mem.s](round5/verified/retime_67_neutral_mem.s) |
| [retime_68_neutral.s](round5/verified/retime_68_neutral.s) | [retime_68_neutral_mem.s](round5/verified/retime_68_neutral_mem.s) |
| [retime_69_neutral.s](round5/verified/retime_69_neutral.s) | [retime_69_neutral_mem.s](round5/verified/retime_69_neutral_mem.s) |
| [retime_6_neutral.s](round5/verified/retime_6_neutral.s) | [retime_6_neutral_mem.s](round5/verified/retime_6_neutral_mem.s) |
| [retime_70_neutral.s](round5/verified/retime_70_neutral.s) | [retime_70_neutral_mem.s](round5/verified/retime_70_neutral_mem.s) |
| [retime_71_neutral.s](round5/verified/retime_71_neutral.s) | [retime_71_neutral_mem.s](round5/verified/retime_71_neutral_mem.s) |
| [retime_72_neutral.s](round5/verified/retime_72_neutral.s) | [retime_72_neutral_mem.s](round5/verified/retime_72_neutral_mem.s) |
| [retime_73_neutral.s](round5/verified/retime_73_neutral.s) | [retime_73_neutral_mem.s](round5/verified/retime_73_neutral_mem.s) |
| [retime_74_neutral.s](round5/verified/retime_74_neutral.s) | [retime_74_neutral_mem.s](round5/verified/retime_74_neutral_mem.s) |
| [retime_75_neutral.s](round5/verified/retime_75_neutral.s) | [retime_75_neutral_mem.s](round5/verified/retime_75_neutral_mem.s) |
| [retime_76_neutral.s](round5/verified/retime_76_neutral.s) | [retime_76_neutral_mem.s](round5/verified/retime_76_neutral_mem.s) |
| [retime_77_neutral.s](round5/verified/retime_77_neutral.s) | [retime_77_neutral_mem.s](round5/verified/retime_77_neutral_mem.s) |
| [retime_78_neutral.s](round5/verified/retime_78_neutral.s) | [retime_78_neutral_mem.s](round5/verified/retime_78_neutral_mem.s) |
| [retime_79_neutral.s](round5/verified/retime_79_neutral.s) | [retime_79_neutral_mem.s](round5/verified/retime_79_neutral_mem.s) |
| [retime_7_neutral.s](round5/verified/retime_7_neutral.s) | [retime_7_neutral_mem.s](round5/verified/retime_7_neutral_mem.s) |
| [retime_80_neutral.s](round5/verified/retime_80_neutral.s) | [retime_80_neutral_mem.s](round5/verified/retime_80_neutral_mem.s) |
| [retime_81_neutral.s](round5/verified/retime_81_neutral.s) | [retime_81_neutral_mem.s](round5/verified/retime_81_neutral_mem.s) |
| [retime_82_neutral.s](round5/verified/retime_82_neutral.s) | [retime_82_neutral_mem.s](round5/verified/retime_82_neutral_mem.s) |
| [retime_83_neutral.s](round5/verified/retime_83_neutral.s) | [retime_83_neutral_mem.s](round5/verified/retime_83_neutral_mem.s) |
| [retime_84_neutral.s](round5/verified/retime_84_neutral.s) | [retime_84_neutral_mem.s](round5/verified/retime_84_neutral_mem.s) |
| [retime_85_neutral.s](round5/verified/retime_85_neutral.s) | [retime_85_neutral_mem.s](round5/verified/retime_85_neutral_mem.s) |
| [retime_86_neutral.s](round5/verified/retime_86_neutral.s) | [retime_86_neutral_mem.s](round5/verified/retime_86_neutral_mem.s) |
| [retime_87_neutral.s](round5/verified/retime_87_neutral.s) | [retime_87_neutral_mem.s](round5/verified/retime_87_neutral_mem.s) |
| [retime_88_neutral.s](round5/verified/retime_88_neutral.s) | [retime_88_neutral_mem.s](round5/verified/retime_88_neutral_mem.s) |
| [retime_89_neutral.s](round5/verified/retime_89_neutral.s) | [retime_89_neutral_mem.s](round5/verified/retime_89_neutral_mem.s) |
| [retime_8_neutral.s](round5/verified/retime_8_neutral.s) | [retime_8_neutral_mem.s](round5/verified/retime_8_neutral_mem.s) |
| [retime_90_neutral.s](round5/verified/retime_90_neutral.s) | [retime_90_neutral_mem.s](round5/verified/retime_90_neutral_mem.s) |
| [retime_91_neutral.s](round5/verified/retime_91_neutral.s) | [retime_91_neutral_mem.s](round5/verified/retime_91_neutral_mem.s) |
| [retime_92_neutral.s](round5/verified/retime_92_neutral.s) | [retime_92_neutral_mem.s](round5/verified/retime_92_neutral_mem.s) |
| [retime_93_neutral.s](round5/verified/retime_93_neutral.s) | [retime_93_neutral_mem.s](round5/verified/retime_93_neutral_mem.s) |
| [retime_94_neutral.s](round5/verified/retime_94_neutral.s) | [retime_94_neutral_mem.s](round5/verified/retime_94_neutral_mem.s) |
| [retime_95_neutral.s](round5/verified/retime_95_neutral.s) | [retime_95_neutral_mem.s](round5/verified/retime_95_neutral_mem.s) |
| [retime_96_neutral.s](round5/verified/retime_96_neutral.s) | [retime_96_neutral_mem.s](round5/verified/retime_96_neutral_mem.s) |
| [retime_97_neutral.s](round5/verified/retime_97_neutral.s) | [retime_97_neutral_mem.s](round5/verified/retime_97_neutral_mem.s) |
| [retime_98_neutral.s](round5/verified/retime_98_neutral.s) | [retime_98_neutral_mem.s](round5/verified/retime_98_neutral_mem.s) |
| [retime_99_neutral.s](round5/verified/retime_99_neutral.s) | [retime_99_neutral_mem.s](round5/verified/retime_99_neutral_mem.s) |
| [retime_9_neutral.s](round5/verified/retime_9_neutral.s) | [retime_9_neutral_mem.s](round5/verified/retime_9_neutral_mem.s) |

### Limits

The completed rewrite scans cover their finite value sets and edit pattern. They preserve the full value column of every surviving write. They exclude neither new value functions nor arbitrary changes to intermediate computations. Comparisons with unresolved scratch relations are outside the rewrite rules. The SAT queries fix scratch to 7 and initial flags to equal. A solver timeout gives no exclusion. No global instruction lower bound follows.

### Conclusion

The apparent pair savings did not produce a strict PASS core with k<=31. The target memory length of at most 41 remains open. All round-5 jobs have finished.


## Round 6: repair from approximate output snapshots

### Purpose

Find a k=31 rewrite that fails at most 20 weak orders. Then repair it with two free instruction slots. Read rounds 1–5 before starting. No k<=31 program has received a strict PASS in this round.

### Method

A failure mask lists the weak orders on which one output snapshot has the wrong value. The new terminal collector retains every observed value column in its merged-state key. It then tests unions of five output failure masks. This extends the round-5 rewrite search to approximate outputs. The original exact-output mask alone cannot preserve this history.

The independent packed evaluator permits changed intermediate values. It checks all 541 weak orders with scratch=7 and equal initial flags. It tests single deletions with every following block predicate, and CMOV-pair fusion with one MOV or CMOV at either removed event. The inserted write can use either removed destination, any seed source or one fresh register, and any supported predicate. Other instructions stay fixed. Outputs are free snapshots. See `round6/METHOD.md` and `round6/src/near_flags.cpp` for the finite rule sets.

All compute jobs use nice level 19. At most two compute jobs run together. CPU affinity is 76–77. Search and SAT processes have a 2,800 MiB address-space limit. All writes stay in w5.

### Completed rewrite results

Every scan below completed all 144 seeds. No scan reached a state or time limit. No terminal rewrite supplied output snapshots whose combined failure set had at most 20 weak orders.

| Scan | Search-node visits or edit tests | Terminal states |
|---|---:|---:|
| Original seeds; history-aware terminal collection | 551,473,134 | 1,791,564 |
| Retiming forms; history-aware terminal collection | 560,825,380 | 1,804,654 |
| Single deletion and following-block predicates | 756,708 | — |
| Two CMOV removals and one fused write | 5,760,620 | — |

Search-node visits and edit tests are different quantities. Edit-test counts include duplicate paths. The finite terminal rules preserve each surviving write's full seed value column. They permit arbitrary surviving comparison columns. The independent scans permit changed write columns but retain their stated edit limits. These are scoped negatives, not a lower bound for arbitrary programs. Logs and counts are in `round6/summary.json` and `round6/logs/`.

The reference interpreter confirmed the scorer's complete failure set for the known 14-order failure on all 541 weak orders. The scorer control, constant SAT control, and variable two-slot SAT control each passed both strict judges at k=32 and memory length 42. Their six PASS paths are recorded in `round6/judge_ledger.jsonl`. They do not meet the requested length.

### SAT repair status

No new rewrite met the requested 20-order trigger. Further queries therefore use the frozen w6 nine-order and 14-order failures. Both input copies received strict judge FAIL. Their source hashes and full failure sets are in `round6/seeds/` and `round6/input_audit.json`.

The expanded repair leaves every existing CMOV predicate free. It also permits two instruction positions to choose any of the six opcodes and any operands. Other operands and MOV/CMP positions stay fixed. One fresh register and free output snapshots are available. This differs from the earlier ordinary two-instruction replacement search. It starts with every actual failing weak order plus twelve sampled strict orders. Counterexamples extend the same solver.

The full-position query for the nine-order seed reached its 180-second wall limit. Its result is UNKNOWN. Decomposed queries for all 465 position pairs per seed have finished. The first 20 nine-order queries use a three-second limit; later queries use two seconds. Only completed UNSAT queries count as exclusions. A time limit remains UNKNOWN. The commands and individual results are in `round6/*_slots_*.json`.


### Round-6 final SAT result

All 930 fixed-pair queries have finished or reached their wall limit. The table counts individual queries. Each UNSAT entry excludes only its stated position pair, free-predicate rules, finite register alphabet, and encoded weak orders. UNKNOWN entries give no exclusion.

| Input | Position-pair queries | UNSAT | UNKNOWN wall limit | Proposals |
|---|---:|---:|---:|---:|
| near9 | 465 | 100 | 365 | 0 |
| near14 | 465 | 31 | 434 | 0 |

The nine-order full-position query also remains UNKNOWN at its 180-second wall limit. No complete exclusion of either expanded repair neighborhood follows. The scratch value is 7 and initial flags are equal in SAT. A successful relaxed proposal still needs both strict judges.

The separate guide-input audit checked 4,328 symbolic executions: both seeds, all 541 weak orders, and all four initial flag states. Distinct scratch symbols caused no unresolved comparisons and reached no output. The observed failure sets still had exactly nine and 14 weak orders. See `round6/symbolic_input_check.json`.

Four selected unresolved position pairs received longer checks with all 541 weak orders and a 60-second wall limit. The individual refinements are listed below. Their counts overlap the short-query table.

| Input | Free positions, zero-based | Refinement result |
|---|---|---|
| near9 | [13, 20] | UNKNOWN_WALL_LIMIT |
| near9 | [15, 20] | UNSAT |
| near14 | [13, 20] | UNKNOWN_WALL_LIMIT |
| near14 | [14, 20] | UNSAT |

Every new strict PASS file is listed below. The controls have k=32 and memory length 42. The variable two-slot control changes predicates outside the two free slots and passed both strict judges. The reference scorer check covers all 541 weak orders of the known 14-order failure. These checks are test results, not an encoding proof.

| Strict PASS file | Model | Length | Judge log |
|---|---|---:|---|
| [sat_control32.s](round6/verified/sat_control32.s) | out | 32 | `round6/logs/judge_sat_control32.log` |
| [sat_control32_mem.s](round6/verified/sat_control32_mem.s) | mem | 42 | `round6/logs/judge_sat_control32_mem.log` |
| [scorer_control_0.s](round6/verified/scorer_control_0.s) | out | 32 | `round6/logs/judge_scorer_control_0.log` |
| [scorer_control_0_mem.s](round6/verified/scorer_control_0_mem.s) | mem | 42 | `round6/logs/judge_scorer_control_0_mem.log` |
| [slots_control32.s](round6/verified/slots_control32.s) | out | 32 | `round6/logs/judge_slots_control32.log` |
| [slots_control32_mem.s](round6/verified/slots_control32_mem.s) | mem | 42 | `round6/logs/judge_slots_control32_mem.log` |

### Round-6 limits

The completed terminal scans cover their finite original-value columns and effect-state representatives. The independent scans cover their stated deletions, fusion positions, and register choices. None is a search over arbitrary programs. A completed UNSAT result is a bounded negative. A wall limit is UNKNOWN. No global lower bound follows.

### Round-6 conclusion

No k<=31 program received a strict judge PASS. The target memory length of at most 41 remains open. All round-6 jobs have finished.

The final commands, status counts, source integrity checks, strict PASS hashes, and logs are in `round6/final_summary.json`.


## Round 7: longer Kissat repair of unresolved instruction pairs

### Purpose

Read rounds 1–6 first. Refine the 797 unresolved two-slot queries from round 6. No k<=31 program has received a strict judge PASS in this round.

### Method

The queue contains 364 position pairs from near9 and 433 from near14. It excludes the two additional completed UNSAT pairs in the round-6 focused checks. All nine-order queries come first. Within each failure-count group, pairs nearest [13,20] come first. See `round7/queue.json`. Each pair gets a 1,200-second shared wall budget across solver calls. The batch runs one query at a time, with nice level 19, pinned to CPU 76. Each query has a 2,800 MiB address-space limit. The runner also checks combined parent and Kissat resident memory. All writes stay in w5.

Kissat replaces CaDiCaL in the unchanged round-6 constraint relation. Two selected instruction positions can choose any supported opcode and operands. Every other CMOV can choose any supported condition. Other operands and MOV/CMP positions stay fixed. The register alphabet contains every seed register and one fresh register. Outputs can choose any register snapshot. The first query encodes the actual failing weak orders and twelve sampled strict orders. Counterexamples add constraints after each proposal. Scratch is fixed to 7 and initial flags are equal. SAT models are checked against every emitted clause before decoding. Every proposed program then needs both strict judges. An UNSAT result excludes only the stated finite relaxed query. A wall or memory limit is UNKNOWN.

Assumption tags: [G1,G2,G3,A2,A11]. This tests the local-repair assumption A11 with the finite register limit A2. It does not test global optimality or remove the register limit. No assumption has been contradicted by the current result.

### Verified control

The external Kissat control returned a k=32 proposal after three solver calls. The proposal changed CMOV conditions outside the two free positions. Its out and memory forms both received strict PASS:

- `round7/verified/kissat_slots_control32.s`: out, k=32.
- `round7/verified/kissat_slots_control32_mem.s`: mem, L=42.

The full judge output is in `round7/logs/judge_kissat_slots_control32.log` and `round7/logs/judge_kissat_slots_control32_mem.log`. The ledger is `round7/judge_ledger.jsonl`. This is a control result, not a shorter program or an encoding proof.

### Execution records

The 797-query batch has finished. `round7/results.json` records all query results. `round7/progress.json` records the final counts. Each query retains its solver logs and formula hash. The active-query file was removed when the last query finished. Only completed UNSAT queries count as bounded negatives. No limited or unstarted query remains in this batch.

### Round-7 nine-order seed completed

All 364 previously unresolved near9 pairs returned UNSAT in the longer Kissat run. Together with the 101 completed round-6 exclusions, this covers all 465 position pairs for near9 under the stated two-slot, free-predicate relation and R=8. No query reached its wall or memory limit. Each longer query used the initial 20 weak orders; no counterexample refinement was needed. This is a complete exclusion of this finite repair neighborhood, not a global program lower bound. Tags: [G1,G2,G3,A2,A11]. The final table below includes the completed near14 results.


### Round-7 final result

The batch finished 797 of 797 planned longer queries. Counts: `{'UNSAT': 797}`. Unstarted pairs: 0. No limited or unstarted query counts as an exclusion.

| Input | Longer queries completed | UNSAT | Other results |
|---|---:|---:|---:|
| near9 | 364 | 364 | 0 |
| near14 | 433 | 433 | 0 |

Combined round-6 and round-7 pair counts: `{'near9': {'UNSAT': 465}, 'near14': {'UNSAT': 465}}`. Each seed has 465 possible pairs. UNSAT excludes only the encoded finite repair relation. It does not exclude a repair with other free operands, extra registers, or more free positions.

The sum of query wall times is 2411.85 seconds. The longest query took 29.56 seconds. The maximum observed combined parent and solver memory was 69,820 KiB.

The batch made 832 solver calls. Counterexample refinement occurred in 29 queries. The largest encoded case set had 38 weak orders.

The final audit checked every reported UNSAT record against its Kissat exit code, UNSAT output, and saved log hashes. It checked retained PASS file hashes and seed integrity. The formula hash and encoded case count for each negative are in `round7/unsat_integrity.json`. Complete counts and PASS paths are in `round7/final_summary.json`.

Assumption tags: [G1,G2,G3,A2,A11]. These are bounded local-repair results. They do not establish a global instruction lower bound. No assumption was contradicted. All round-7 jobs have finished.

No k<=31 program received a strict judge PASS in this round. The target memory length of at most 41 remains open.


## Round 8: three-instruction windows on the median accumulator chain

Read rounds 1–7 before starting. No k<=31 program has received a strict PASS in this round so far.

The frozen set contains the same 144 k=32 variants. Each has exactly one median-valued write snapshot across all 541 weak orders. The median accumulator chain follows prior destination definitions through CMOV and source definitions through MOV. It has two to eight instructions per variant. This is one backward path, not the full dependency tree.

The new queue has 1,720 consecutive width-three windows that contain a chain instruction. Each window becomes two arbitrary instructions. Every outside CMOV predicate is also free. Other outside operands and MOV/CMP opcodes stay fixed. Every seed register and two fresh registers are available. Outputs are free snapshots. This is a different, wider relation than an ordinary fixed-suffix window or the completed near-miss pair repair. See `round8/METHOD.md`, `round8/median_audit.json`, and `round8/queue.json`.

Each Kissat query gets a shared 1,200-second wall budget. One query runs at a time, nice level 19, on one CPU. Address space is limited to 2,800 MiB per process. The runner checks combined encoder and solver resident memory. Scratch is fixed to 7 and initial flags to equal in SAT. Successful relaxed proposals require both strict judges. Completed UNSAT queries exclude only their finite relation. Limits are UNKNOWN. Unstarted queries give no exclusion.

The batch is in progress. Counts and individual results are in `round8/progress.json` and `round8/results.json`. Assumption tags: [G1,G2,G3,A2,A11]. No assumption has been contradicted.


### Round-8 final result

The batch finished 1720 of 1720 planned queries. Status counts: `{'UNSAT': 1720}`. Unstarted queries: 0. A completed solver UNSAT is a bounded exclusion. An equivalent query inherits that exclusion only through an audited input/scratch register bijection. Any limited or unstarted query remains unknown.

The sum of query wall times is 5762.99 seconds. The longest query took 31.35 seconds. The maximum observed combined encoder and solver resident memory was 75,844 KiB. The batch made 1799 solver calls. Counterexample refinement occurred in 40 queries.

The control received strict PASS in both models:

- `round8/verified/window_control32.s`: out, k=32.
- `round8/verified/window_control32_mem.s`: mem, L=42.

The exact judge output is in `round8/logs/judge_window_control32.log` and `round8/logs/judge_window_control32_mem.log`. The control tests an actual free two-slot replacement after duplicate-CMP insertion. It does not meet k<=31 and is not an encoding proof.

The final audit checked each solver UNSAT against Kissat exit code 20, its UNSAT status line, and retained log hashes. For each inherited exclusion, it independently checked a complete register bijection, preservation of the input/scratch boundary, and equality of every constrained instruction under that mapping. All inherited exclusions reference a direct solver UNSAT. It checked every source hash and retained strict PASS hash. Formula hashes and encoded case counts are in `round8/unsat_integrity.json`. Register maps are in `round8/equivalence_integrity.json`. Complete counts and PASS paths are in `round8/final_summary.json`.

Assumption tags: [G1,G2,G3,A2,A11]. These results concern the selected finite local repairs. They do not establish a global lower bound. No assumption was contradicted. All round-8 jobs have finished.

No k<=31 program received a strict judge PASS in this round. The target memory length of at most 41 remains open.

All 1,720 exclusions came from direct Kissat UNSAT results. The equivalent-query count is zero. No query was limited or left unstarted. After the CPU-load check, later queries and the waiting batch parent used CPU 77, still one CPU at nice level 19. Later initial formulas used twelve sampled strict orders and the all-equal order; all proposals still received the full 541-order counterexample check. The changes and their points in the run are recorded in `round8/METHOD.md`.


## Round 9: four-instruction windows on twenty variants

Read rounds 1–8 first. The queue contains 580 queries: all 29 width-four windows on twenty selected k=32 sources. Each window becomes three arbitrary instructions. Outside CMOV conditions are free. Other outside operands and MOV/CMP instructions stay fixed. Each source has three extra registers. Outputs are free snapshots.

Selection ranks the 144 frozen sources by distinct unordered CMP register-pair count, with source index as the tie breaker. This measures register-pair reuse, not semantic equivalence. The selected indices are 87, 101, 110, 14, 35, 37, 49, 54, 55, 85, 134, 136, 0, 2, 3, 6, 7, 9, 10, and 12. The source hashes and complete ranking are in `round9/manifest.json` and `round9/selection.json`.

Kissat gets 900 seconds per query across all refinements. One query runs at a time, nice level 19, on CPU 77. Each process has a 2,800 MiB address-space limit. The wrapper also checks combined encoder and solver memory. SAT uses scratch=7 and equal initial flags. A candidate must pass both strict judges. Completed UNSAT results exclude only the finite encoded relation. Limits remain UNKNOWN. Unstarted queries give no exclusion.

The width-four control received strict PASS in both models: `round9/verified/window4_control32.s` (out, k=32) and `round9/verified/window4_control32_mem.s` (mem, L=42). Judge logs are in `round9/logs/judge_window4_control32*.log`. This tests the replacement relation, not an encoding proof.

The batch is in progress. Records are in `round9/results.json`, `round9/progress.json`, and `round9/logs/`. Method: `round9/METHOD.md`. Assumption tags: [G1,G2,G3,A2,A11]. No assumption has been contradicted.


### Round-9 final result

The batch finished 580 of 580 planned width-four queries. Status counts: `{'UNSAT': 580}`. Unstarted queries: 0. Only completed UNSAT results count as bounded exclusions. A limited query remains UNKNOWN.

The sum of query wall times is 5374.70 seconds. The longest query took 47.22 seconds. The maximum observed combined encoder and solver resident memory was 68,036 KiB. The batch made 640 solver calls. Counterexample refinement occurred in 27 queries.

The final audit checked the twenty-source selection and all 29 windows per source. It checked each reported UNSAT against Kissat exit code 20, its UNSAT status line, and the retained log hashes. It checked every source hash and strict PASS file hash. Formula hashes and case counts are in `round9/unsat_integrity.json`. Complete counts and all strict PASS paths are in `round9/final_summary.json`. The judge ledger is `round9/judge_ledger.jsonl`.

The control has strict PASS in both models: `round9/verified/window4_control32.s` (out, k=32) and `round9/verified/window4_control32_mem.s` (mem, L=42). Its judge logs are `round9/logs/judge_window4_control32.log` and `round9/logs/judge_window4_control32_mem.log`.

Assumption tags: [G1,G2,G3,A2,A11]. The result covers this finite local-repair relation and register alphabet. It does not establish a global lower bound. No assumption was contradicted. All round-9 jobs have finished.

No k<=31 program received a strict judge PASS in this round. The target memory length of at most 41 remains open.


## Round 10: c=8 structures with multiple companion selections

Read rounds 1–9 and the w11, w12, and w13 briefs first. This round searches eight-comparison conditional wire permutations with at least two companion-pair swaps. Each special comparison swaps both the compared pair and one other disjoint pair. Every comparison reads defined input-derived values. The first comparison is an ordinary compare-exchange of inputs 0 and 1. This finite action family differs from the two-column work of w11, the unknown-scratch comparisons of w12, and the saved single-special-step c=8 cases of w13. See `round10/METHOD.md`.

The pair-swap generator completed its stated finite family. Raw sorting paths by companion-swap count: two, 582; three, 444; four, 108; five through seven, zero. Symmetry reduction retained 95, 68, and 14 skeletons, respectively. All 177 source recipes sort all 541 weak orders in the independent Python check. Their exact comparison operand columns match a second interpreter. A source-recipe check is not a strict judge PASS for assembly.

The known c=8 index has 370 source records and 232 canonical comparison classes. None of the 177 skeletons matches it. None matches the 22 saved c=8 classes in w13. Input renaming, value reversal, and independent comparison-operand reversal are identified. The shared ASCII-digit canonical SHA-256 agreed with w13 on the pilot. The broad routing queue has 138 cases whose minimum changed-block distance from the known c=8 index is at least four. Distances are relative to this finite index only. The runner checks current w13 closed hashes before each query.

The k=31 DAG routing batch is in progress. It permits arbitrary defined conditional values and unbounded register names for each fixed comparison skeleton. A completed NONE is a finite skeleton exclusion. A node or wall limit is UNKNOWN. All compute runs use nice level 19, CPU 77, one job at a time, and a 2,800 MiB address-space limit. Records: `round10/far31_results.jsonl`, `round10/far31_progress.json`, and `round10/logs/far31/`.

Assumption tags: [G1,G2,G3,A4,A6]. This attacks fixed-family coverage. No global lower bound follows. No assumption has been contradicted by the current results. No k<=31 program has received a strict judge PASS in this round.

### Round-10 pair-swap routing result

The 138-case queue finished. Status counts: {'UNKNOWN_NODE_LIMIT': 15, 'NONE': 123}. Completed routing calls: 143,665,901. Total query wall time: 248.81 seconds. Maximum observed routing child memory: 55,920 KiB. The 15 limited cases remain UNKNOWN. The 123 NONE results exclude their fixed comparison skeletons in the stated fully defined DAG model.

The independent exact path-count program matched every two-through-seven companion-swap count. See `round10/generation_crosscheck.json`. Its one-swap count is a control only; no one-swap skeleton routing was repeated.

The fixed-source-DAG copy check tested 354 layouts across all 177 source recipes. Its costs were k=38 for 190 layouts, k=41 for 136, and k=44 for 28. It tests the source value graph only. It does not replace the unrestricted intermediate-column DAG search.

Strict PASS controls: `round10/verified/pair_layouts_control_k38.s` (out, k=38) and `round10/verified/pair_layouts_control_k38_mem.s` (mem, L=48). The logs are `round10/logs/judge_pair_layouts_control_k38.log` and `round10/logs/judge_pair_layouts_control_k38_mem.log`. These source controls are longer than the existing baseline. They are not a target result. A separate K=40 router control attempt reached its 3,000,000-node limit and remains UNKNOWN.

### Round-10 companion rotations

The action extension permits either three-value rotation on the three companion wires. At least two comparisons still move companions. The finite generator completed. Raw path counts for two, three, and four companion operations are 966, 744, and 180. Counts for five through seven are zero. Independent path counting matched each count. After symmetry and overlap removal, the extension gives 114 additional classes. All 114 differ from every indexed c=8 source in at least four comparison blocks. Their 541-order source checks passed. They received no duplicate routing from the pair-swap queue. Exact k=31 routing is in progress in `round10/rotations31_results.jsonl`.

### Round-10 first family completed

All 114 new rotation classes returned NONE at k=31. They made 48,476,654 routing calls. A larger budget resolved all 15 previously limited pair-swap cases with NONE. That refinement made 73,544,436 calls and took 125.35 query wall seconds. Maximum observed child memory was 91,700 KiB. Thus all 252 distance-at-least-four structures in the ordinary-first-comparison family have completed NONE. The 39 structures at distance two or three were not routed. The source generation covers 291 canonical classes. The no-key-swap companion extension adds no source recipe under the stated no-stationary-step rule. Its independent path counts match.

This complete result applies only to the stated action family and fixed comparison operand skeletons. It does not exclude arbitrary c=8 programs. Tags: [G1,G2,G3,A4,A6]. No assumption was contradicted.

### Round-10 first-comparison companion operations

The next extension lets the first comparison swap a companion pair or rotate all three companion wires. The compared input pair stays 0 and 1. Later comparisons can use all previous pair-swap and rotation actions. At least two comparisons move companions, including the first. One initial pair swap and one rotation direction represent the first-action choices under input renaming. The next index pass will remove all prior, known, and w13 matches before routing. This is a new conditional value structure at the first comparison.

The first-companion extension completed generation. Initial pair-swap cases give 712 classes. Initial rotation cases give 344 classes. Each family has raw sorting-path counts 318, 966, 744, and 180 for two through five companion operations; six through eight give zero. Independent path counting matched both families. Their 541-order source checks passed. None matches the 232 known c=8 classes or w13’s 22 saved c=8 classes.

The final source union has 1,347 canonical classes. Of these, 1,269 have distance at least four from the finite known c=8 index. The new routing queue has 1,017 cases after the 252 completed exclusions are removed. The remaining 78 classes have distance two or three and are outside the selected routing scope. The new records are `round10/first31_results.jsonl` and `round10/first31_progress.json`. The batch runs one job at a time under the same CPU and memory limits.

A larger prior-index check also found no canonical match against w13’s complete saved c=8 prior index (156 classes, drawn from the external source lists and earlier skeleton files). This covers more than the 22 newly generated w13 c=8 classes. The source index hash and overlap result are in `round10/full_prior_overlap.json`. Distance values still refer to the explicitly documented 232-class source index.

### Round-10 final result

No k<=31 program received a strict judge PASS. The target memory length of at most 41 remains open.

All 1,269 selected c=8 comparison skeletons completed exact routing at K=31 with NONE in the stated fully defined DAG representation. No selected target skeleton remains limited or unstarted. This is a finite fixed-skeleton result. It is not a global instruction lower bound.

| Target batch | Queries | Initial NONE | Initial node limits | Final disposition |
|---|---:|---:|---:|---|
| Ordinary first comparison, pair swaps | 138 | 123 | 15 | All 138 closed after refinement |
| Additional companion rotations | 114 | 114 | 0 | All 114 closed |
| Pair-swap refinement | 15 | 15 | 0 | Refines the first row |
| Companion operation at the first comparison | 1,017 | 1,007 | 10 | All 1,017 closed after refinement |
| First-comparison refinement | 10 | 10 | 0 | Refines the preceding row |

The five target batches made 537,791,471 recursive router calls in 925.21 query wall seconds. Counts include the 25 limited queries and their later refinements. The separate initial two-million-node pilot and K=40 control attempt are outside this batch count. The pilot’s target class was later closed. The K=40 control attempt remains UNKNOWN and gives no exclusion. Maximum observed routing child memory was 91,700 KiB. All search jobs have finished.

The final source union contains 1,347 canonical classes from 1,815 saved source records. The routing selection leaves 78 classes at distance two or three unsearched. The distance threshold was four relative to the documented 232-class c=8 source index. There is no canonical match against that index, the 22 new w13 c=8 classes, or the broader 156-class prior c=8 index.

The independent lattice check matched every generator count on 848 distinct required value columns. Every source skeleton requires at least five and at most fourteen non-lattice full value columns. Thus these fixed skeletons are outside w11’s exactly-two-column scope. Every comparison reads a defined input-derived value, so w12’s unknown-scratch comparison scope is excluded. Source traces passed the independent 541-order checks. These checks are not assembly judge PASS results.

The final integrity audit matched every completed NONE to its solver exit code, status, node count, source hash, and retained log hash. It checked all retained strict PASS file hashes and judge text. Complete results are in `round10/final_summary.json`; per-exclusion records are in `round10/routing_integrity.json`; direct canonical closure hashes are in `round10/closed.txt`. The source ledger is `round10/generated_manifest.json`. The finite action rules and limits are in `round10/METHOD.md`.

Every new strict PASS assembly file in this round:

- `round10/verified/pair_layouts_control_k38.s`: out model, k=38. Judge: `round10/logs/judge_pair_layouts_control_k38.log`.
- `round10/verified/pair_layouts_control_k38_mem.s`: memory model, L=48. Judge: `round10/logs/judge_pair_layouts_control_k38_mem.log`.

These controls are longer than the existing k=32 baseline. No shorter upper bound follows. Tags: [G1,G2,G3,A4,A6]. No assumption was contradicted. A fully general c=8 or k<=31 program remains outside this finite result.
