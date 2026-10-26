No strict PASS with core k <= 31 was found.

## Purpose

Repair the supplied 31-instruction near miss. Find a correct core with at most 31 instructions, or establish a precise local exclusion.

## Terms

Core k counts mov, cmp, and conditional moves. Free out instructions select a register value at a specified time. A memory program adds five loads and five stores. A weak order permits equal input values. There are 541 weak orders for five inputs.

A two-position window permits changes at two selected instruction positions. The positions need not be adjacent. All output positions and output registers remain free.

## Method

Read the w6 search results before starting. Do not repeat the supplied network-family searches. Copy the SAT encoder into src/. Use an independent scalar parser and simulator in src/analyze.py. Compare the fixed-program SAT transitions against this simulator on 60 programs and ten input orders per program. All 60 results matched. See logs/encoder_crosscheck.log.

Use the sound initial-state relaxation: every scratch register starts above every input, and the flags start equal. An UNSAT result for this state also excludes a strict program in the same instruction domain. A proposed program must pass shared/judge.py --strict before it counts as a result.

Use exact SAT for arbitrary instruction positions. Permit all six allowed opcodes, both register operands, and free output snapshots. For two changed instructions, use the seven seed registers and four new registers. Four new registers cover all new operand names in two instructions. Number new registers in first-touch order. This removes only register-name symmetry in the relaxed state.

Save the Boolean formula and the DRAT certificate for each completed two-position exclusion. DRAT is a format for checking that a Boolean formula has no solution. Check certificates with the existing drat-trim tool. All 465 two-position certificates passed this check. The audit took 472.6 seconds. See artifacts/pairs_proof_audit.json. The audit records file hashes.

All search commands use nice -n 10. At most eight search processes run at once. Each search process has a memory limit. All writes remain in this worker folder.

## Result

The strict judge rejects seeds/near31.s. The independent simulator finds exactly nine failing weak orders, including four strict orders. Only output 2 fails. The failure condition is exactly:

`x1 > max(x0, x3) and min(x2, x4) > x1`.

See artifacts/near_analysis.json and logs/baseline_judge.log.

The data flow explains the failure. Let `l <= v <= h` be the sorted values of inputs 0, 1, and 3. Let `q <= r` be the sorted values of inputs 2 and 4. Let `M = max(x0, x3)`. After instruction 15, the seed holds `l` twice, `v`, `h`, `q`, `r`, and `M`.

The seed forms a median candidate `A = max(l,q)` when `h >= q`. Otherwise it keeps `A = M`. The required value is `A = min(h,max(l,q))`. The final median is `max(min(r,v),A)`. When `q > h` and input 1 is the triple maximum, the seed keeps `M = v` and loses `h`. The added conditional move copies `h` into this missing branch. This explanation agrees with all 541 independent scalar evaluations. It is not a global length lower bound.

The supplied one-instruction repair passes both strict models. Its core has k=32. Its memory form has 42 instructions. These programs do not meet the requested limit.

The exact search suffix12_dest_r9 returned UNSAT in 270.4 seconds. It fixed instructions 0--11, all comparison positions, and all write destinations. It allowed every later comparison operand, source register, and conditional-move condition to change. It used nine registers and 27 weak orders. There was no bound on the number of changed suffix instructions. See logs/suffix12_dest_r9.log.

A repeat suffix search used eight registers and returned UNSAT in 217.6 seconds. Its 106 MB certificate passed drat-trim in 126.7 seconds. See candidates/suffix12_dest_proof.s.cnf, candidates/suffix12_dest_proof.s.drat, and logs/suffix12_certificate_check.log. This suffix exclusion permits any number of new source registers: every write destination is fixed to an old register, so every new register is read-only. All read-only registers have the same top value in the sound relaxation. They can therefore share one new register.

All 465 two-position windows returned UNSAT. This excludes all replacements of at most two instructions in the 31-instruction seed, with free output snapshots and unbounded registers. Each replacement has at most two operands. Thus two changed instructions can name at most four new registers. The scan supplies all four. No candidate blocking was needed in any two-position formula.

The block-reordering search checked 11,975,040 orderings. It checked all 9! block orders for the near miss, then all 9! orders for each of the 32 single-instruction deletions from the repaired core. Blocks start at cmp instructions. The search preserves instruction order within each block. No ordering passed the 64-case sound filter. The filter contains all nine failing seed cases. The enumerator first checked the repaired core and the failing seed as controls. See src/reorder.cpp, logs/block_reorders.log, and artifacts/block_reorders.json. The order count can include repeated programs.

The separate within-block search checked 3,041,280 instruction orders. It kept the block order fixed and permuted each block's write instructions. It applied the same seed and deletion choices. No ordering passed the same 64-case filter. See logs/inside_reorders.log and artifacts/inside_reorders.json.

The three-position scan completed all 841 windows containing instruction 14 or 21, using zero-based core positions. These are the low-value copy and the median selector. **All 841 returned UNSAT, with checked certificates.** This excludes repairs with at most three instruction substitutions when a changed instruction is 14 or 21. Both other positions can be anywhere. Sources, destinations, opcodes, and output snapshots are free. The register argument below covers unbounded registers.

The first pass returned 851 UNSAT results and seven timeouts. It checked 17 extra windows before the scope was narrowed. All seven retries returned UNSAT. Their certificates also passed. There are 858 completed three-position exclusions in total. The other 3,637 windows are explicitly marked SKIPPED. See logs/triples_scan.log, logs/triples_resume.log, logs/retry_scan.log, and artifacts/final_summary.json. Each per-window JSON record contains the formula and certificate hashes.

The first controller failed during a concurrent update of its resource manifest. The controller now waits when that file is incomplete. The resumed scan preserved all completed results and processed only missing windows. Every selected window has a final record.

The later three-position formulas use 11 registers. Three changed instructions can write at most three new registers. All other new registers remain read-only and share the top value in the relaxation. One further register represents all of those read-only registers. Thus four new registers suffice for this negative search. Earlier formulas supplied six new registers. Both choices cover unbounded registers in the sound relaxation.

The broad monolithic searches any2_unbounded and any3_r7 reached their 900- and 1200-second limits. Both are unresolved. Splitting the two-position search into fixed windows succeeded where its monolithic encoding timed out.

The broad searches any3_unbounded, any4_r8, and suffix16_typed_r10 each reached 1800 seconds. They remain unresolved. The stronger prefix-five search also reached 1800 seconds. It retained only the first five seed instructions, all comparison positions, and all write destinations. Its timeout does not establish an exclusion.

The unrestricted prefix-16 suffix search used ten registers and reached 1800 seconds. The prefix-12 redesign used nine registers, permitted at most eight comparisons, and reached 1800 seconds. A further prefix-16 test fixed the comparison positions and used all 120 strict input orders plus eight other weak orders. It reached 300 seconds. All three results are unresolved. The two duplicate queued suffix jobs were skipped in favor of these parallel runs.

The final source reproduced the first two-position Boolean formula byte for byte. Its SHA-256 hash is recorded in artifacts/reproducibility_check.json. The final C++ source also reproduced the 11,975,040 whole-block ordering count and zero filter passes. See logs/replay_pair00.log and logs/block_reorders_final.log.

### Every strict PASS file

- seeds/repair32.s: k=32, out model. Log: logs/repair32_out_judge.log.
- candidates/control32.s: k=32, out model. Log: candidates/control32.s.judge.log.
- verified/repair32_mem.s: 42 instructions, mem model. Log: logs/repair32_mem_judge.log.

## Limits

No global lower bound is claimed. The three-position exclusion requires a window containing instruction 14 or 21. Fixed comparison positions and fixed write destinations restrict the 19-instruction suffix result. The certificate checker verifies each Boolean formula. It does not formally verify the translation from programs to that formula. The scalar cross-check is a test of that translation. A timeout is unresolved. The best strict-judge result remains k=32, or 42 memory instructions.

## Next round: four-position windows

### Purpose and assumptions

Read the prior results before this round. Do not repeat the two-position or three-position scans. Test assumption A11 with non-contiguous four-position repairs. Test the register limit in A2 with exactly one additional register. The search uses the seven seed registers and one new register. It does not establish a result for unbounded registers. It does not impose the fixed value skeleton in A4, the term pool in A8, or the lattice restrictions in A12 and A15. All writes remain in w7.

### Method

The supplied w6 file and seeds/near31.s are byte-identical. Trace each of the nine failing orders. Track the selected value and the comparison dependencies of each conditional move. The original median value is overwritten at positions 6, 15, and 23 in each failing order. These positions write P1, P3, and S1, respectively. The last remaining copy is lost at position 23. Positions use zero-based core numbering.

Select 299 distinct non-contiguous four-position windows from three families:

- 140 windows use the failing output's dependencies and the median-loss positions after a fixed 12-instruction prefix. The position pool is `[12,13,15,19,21,23,25,27,28,29]`. Each window includes position 15 or 23.
- 55 windows contain `[14,18,21]` or `[14,21,29]`. The fourth position can occur anywhere in the 31-instruction core. These windows test routes through the low-value copy and the final median selector.
- 117 windows contain both median-loss positions `[15,23]`. The other two positions are either both comparisons, or include a median-route position from `[14,18,21]`. The remaining position can occur anywhere in the core.

The family counts include 13 overlaps. The union has 299 windows. The exact list and all nine traces are in round2/selection.json. The controller is src/round2.py.

Within each selected window, permit every allowed opcode and every source and destination register. Preserve all other instructions. Output snapshots remain free. Use the prior exact SAT encoder and its top-scratch initial-state relaxation. Thus a completed UNSAT result excludes a strict program in the stated eight-register window. A solver candidate requires the strict judge before it counts as a result.

Run one CPU job at a time with nice -n 19. Each search process and each certificate checker has a 3 GiB address-space limit. The initial trial used a 20-second limit for 12 windows. The remaining initial scan uses a 10-second limit per window. Record every limit as UNKNOWN. Retain each completed Boolean formula and its DRAT certificate. Check every completed certificate with drat-trim. Store the result and file hashes in round2/quad_*.json.

### Result

No strict PASS with k <= 31 was found. All 299 selected windows were tested. The final result is 296 UNSAT windows with checked certificates and 3 UNKNOWN windows. No selected window remains untested.

| Window family, with overlaps assigned to the first family | Distinct windows | Checked UNSAT | UNKNOWN |
|---|---:|---:|---:|
| Tail dependencies | 140 | 138 | 2 |
| Median routes | 55 | 55 | 0 |
| Additional median-loss windows | 104 | 103 | 1 |
| Total | 299 | 296 | 3 |

The remaining UNKNOWN windows are `[12,15,19,21]`, `[12,15,21,25]`, and `[12,14,15,23]`. Each reached limits with both encoders and all 541 weak orders. These are zero-based core positions.

The search made 360 bounded attempts. Attempt statuses were 296 UNSAT, 64 UNKNOWN. Repeated attempts are not additional distinct windows. Each unresolved window received a retry with all 120 strict input orders in the initial constraints. Those retries used a 30-second limit. Further passes made 12 attempts on 7 remaining windows with all 541 weak orders. Their wall limits were [60.0, 120.0] seconds. Every time limit remains UNKNOWN.

The recorded search time totals 3688.977 seconds. Certificate checks total 744.351 seconds. The largest recorded peak memory use was 884,528 KiB. No candidate-blocking clause was needed. No new strict PASS file was produced.

The source audit found a general type-comparison defect in the selector helper: Python equates Boolean `True` with integer `1`. The helper now checks both type and value. The corrected helper passed 4,096 exhaustive truth-table evaluations. The compact encoder helper also passed 4,096 evaluations. Formula regeneration audited all 360 attempts and found zero affected selector calls. All 296 saved UNSAT formulas were reproduced byte for byte after the correction. The minimum absolute SAT literal used as a selector data argument was 194, above the conflicting value 1. See round2/encoding_audit.json. This audit found no change to a reported exclusion.

The corrected encoder also matched the independent scalar evaluator on 18 programs with four variable-domain positions and eight registers. Three programs used all 541 weak orders. The other 15 used 27 orders each. The comparison checked whether free output snapshots can sort the encoded orders. It is a test of the translation, not a formal proof. The compact encoder matched the scalar evaluator on the same 18 control programs. See round2/variable_domain_crosscheck.json and round2/binary_variable_domain_crosscheck.json.

The compact encoder copies w6/round7/src/binary_encode.py into src/binary_encode.py. Its initialization supports this controller's first-touch selectors. It represents ranks with three bits and shares identical Boolean gates across input orders. Scratch starts at rank 5, above every input rank, and flags start equal. This is another necessary state for strict correctness. The compact queries preserve the same windows, instruction domains, register bound, and free output snapshots.

The compact pass returned two UNSAT results and three UNKNOWN results. For `[12,15,19,21]`, it reduced the formula from 157,791 variables and 1,082,937 clauses to 125,138 variables and 659,646 clauses. Both encoders reached their limits on that window. The smaller formula did not close this remaining query.

The final ledger records the exact window list, attempts, certificate results, unresolved windows, and source hashes: round2/final_summary.json.

### Limits

These results test A11 only in the selected four-position neighborhoods and A2 only at eight registers. This round did not test the other 31,166 four-position windows. They do not establish a result for unbounded registers or unrestricted 31-instruction programs. The certificate checker verifies the Boolean formulas. The encoder checks do not formally verify the translation. No timeout is an exclusion. No assumption in ASSUMPTIONS_42.md is contradicted by these scoped results.

## Next round: five-position windows and long retries

### Purpose and assumptions

Read RESULTS.md before this round. Do not repeat the completed local scans. Test A11 with five-position repairs. Test A2 with eight registers: the seven seed registers and one new register. Keep all other instruction positions fixed. At each selected position, permit all six allowed opcodes and both register operands. Leave output snapshots free across the whole program. Use the same sound initial-state relaxation and the existing audited encoders. These searches do not restrict values to a network term pool or to lattice terms.

### Method

Select 189 distinct non-contiguous five-position windows from the nine failing input orders. Positions use zero-based core numbering.

- Extend each of the three unresolved four-position windows with a fifth position anywhere in the 31-instruction core. This gives 80 distinct windows.
- Extend the median route `[14,18,21,29]` with a fifth position anywhere. This adds 27 windows.
- Change all three positions that overwrite the median, `[6,15,23]`. Choose two further positions from `[12,14,18,19,21,25,27,28,29]`. This gives 36 windows and adds 35 after removal of one overlap.
- Change the median copy and its selection steps, `[14,15,18,21]`. Let the fifth change occur anywhere. This gives 27 windows and adds 26. The initial trial led to this added family. The earlier 142 window indices are unchanged.
- Choose five positions from the final median data flow, `[19,21,23,25,27,28,29]`. This adds 21 windows. These windows keep the first 19 instructions fixed. The earlier 168 window indices are unchanged.

Save the exact selection in round3/selection.json. The controller is src/round3.py. It runs one child process at a time with nice -n 19 and a 3 GiB address-space limit. The initial 12 timeouts have no resource counters because the timeout also stopped the timer. Later attempts record memory high-water marks. The final controller also preserves the timer's CPU counters on a timeout. Every child has the address-space limit. Each completed UNSAT search retains its formula and DRAT certificate. The controller checks each certificate before it reports a checked exclusion. Every time limit is UNKNOWN. A proposed program must pass the strict judge.

Give each of the three unresolved four-position windows a 1800-second retry. Use the compact encoder and all 541 weak orders for these retries. Record new retries in round3, and preserve the previous round's records.

### Result

All three four-position retries returned UNSAT. Each certificate passed the checker. Each retry had a 1800-second limit and included all 541 weak orders.

| Four-position window | Search seconds | Certificate-check seconds | Peak memory, KiB |
|---|---:|---:|---:|
| `[12,15,19,21]` | 52.446 | 17.279 | 516,192 |
| `[12,15,21,25]` | 48.310 | 13.965 | 459,768 |
| `[12,14,15,23]` | 69.024 | 27.211 | 672,500 |

Thus all 299 selected four-position windows are now UNSAT with checked certificates. This closes the three UNKNOWN results from round2. It does not close the other four-position windows or remove the eight-register limit. The new records are round3/quad_0000_0.json through round3/quad_0002_0.json. Each record gives the exact command and both file hashes.

All 21 five-position windows from `[19,21,23,25,27,28,29]` returned UNSAT. Each certificate passed the checker. The window `[23,25,27,28,29]` had a 180-second limit. The other 20 windows had 60-second limits. Every formula in this family included all 541 weak orders. The records are round3/penta_0168_0.json through round3/penta_0188_0.json.

These 21 windows cover every repair that changes at most five of those seven positions. Each smaller set of positions extends to one of the selected five-position windows. The other 24 core positions stay fixed. All eight registers and all allowed opcodes remain available at changed positions. Output snapshots remain free. This is a local exclusion at eight registers.

All 189 selected five-position windows were tested. The final result is 28 UNSAT windows with checked certificates and 161 UNKNOWN windows. No selected window remains untested.

| Five-position family, with overlaps assigned to the first family | Distinct windows | Checked UNSAT | UNKNOWN |
|---|---:|---:|---:|
| Three prior UNKNOWN four-position windows, plus one position anywhere | 80 | 7 | 73 |
| Alternate median route, plus one position anywhere | 27 | 0 | 27 |
| All three median-loss positions, plus two route positions | 35 | 0 | 35 |
| Median copy and selection steps, plus one position anywhere | 26 | 0 | 26 |
| Five positions from the seven final-median positions | 21 | 21 | 0 |
| Total | 189 | 28 | 161 |

The first 12 trials used 27 input orders and a 15-second limit. All 12 remain UNKNOWN. The next 108 searches used all 541 weak orders and 20-second limits. All 108 remain UNKNOWN. The final 48 searches used 128 input orders and 20-second limits. This set contains all 120 strict orders and eight weak orders. Seven of these searches returned UNSAT. Their certificates passed the checker. The other 41 remain UNKNOWN. An UNSAT result on a subset of input orders still excludes strict correctness in the stated window.

The seven additional checked windows are `[12,15,19,21,29]`, `[12,15,19,21,30]`, and `[12,15,21,25,t]` for each `t` in `{26,27,28,29,30}`. See round3/penta_0069_0.json, round3/penta_0070_0.json, and round3/penta_0075_0.json through round3/penta_0079_0.json.

This round made 192 bounded searches: three four-position retries and 189 five-position queries. Their statuses are 31 UNSAT and 161 UNKNOWN. All 31 UNSAT certificates passed the checker. The sum of recorded search times is 3923.746 seconds. The sum of certificate-check times is 329.862 seconds. The largest recorded peak memory use is 672,500 KiB. Each search and certificate check ran alone with nice -n 19.

The final audit matched all 192 records to the selected windows. It checked all 31 saved formula hashes and all 31 certificate hashes. No solver model was returned. No candidate-blocking clause was needed. No candidate reached the strict judge. No new strict PASS file was produced. The best strict result remains k=32. The prior PASS file list above is unchanged.

The final ledger is round3/final_summary.json. It records exact windows, status counts, source hashes, the selection hash, resource totals, and audit results. The audit source is src/round3_report.py. Its log is round3/final_audit.log. The round2 files remain unchanged.

### Limits

These results rely on G1--G4 and test A11 only in the stated local windows. They test A2 only at eight registers. The five-position selection leaves 169,722 other five-position windows untested. The 161 UNKNOWN windows remain unresolved. No timeout is an exclusion. These results do not establish a result for unbounded registers or unrestricted 31-instruction programs.

The certificate checker verifies the Boolean formulas. The prior encoder tests do not formally verify the translation from programs to formulas. No assumption in ASSUMPTIONS_42.md is contradicted by these scoped results.

## Next round: 15-minute Kissat retries

### Purpose and method

Read the prior results before this round. Retry only the 161 five-position windows that remained UNKNOWN in round3. Test A11 in those selected windows and A2 at eight registers. Keep the seed, instruction domains, and free output snapshots from round3. The seven seed registers and one additional register remain available.

Use the audited compact encoder. Include all 120 strict input orders and eight additional weak orders in each initial formula. An UNSAT result on this subset excludes strict correctness in the stated local window. Use the same top-scratch and equal-flags initial state. Export each formula before the solver runs. Order the retries by increasing clause count, then variable count, then the prior window index. This defines smallest-first precisely.

Use external Kissat with a 900-second wall limit for each window. Run one child at a time with nice -n 19 and a 3 GiB address-space limit. Retain the formulas and certificates for completed exclusions. Check each UNSAT certificate with drat-trim. Treat every limit as UNKNOWN. Check each solver candidate with the strict reference judge. If a selected output mapping fails, block only that program and output mapping.

The export control reproduced round3/penta_0069_0.s.cnf byte for byte. Its SHA-256 hash is `2950c2214fb8f7f5c708b73d0ca3fd4d461cbb5cede177d9a7c3aee8f5053357`. The control is round4/control69.s.cnf. The new controller is src/round4.py. The live records are in round4/. The search is in progress. No new result is claimed in this paragraph.

Progress snapshot: 21 of 161 retries are complete. All 21 have checked UNSAT certificates. The combined five-position count is 49 checked UNSAT and 140 unresolved. No new strict PASS file exists. The controller is still running. This snapshot is not a final count.

Progress snapshot: 40 retries are complete; 40 are checked UNSAT. Combined five-position count: 68 checked UNSAT; 121 unresolved. The ledger audit matched all 40 records and both saved hashes for each exclusion. No solver candidate has reached the strict judge. The controller is still running.

Progress snapshot: 60 retries are complete; 60 are checked UNSAT. Combined five-position count: 88 checked UNSAT; 101 unresolved. The ledger audit matched all 60 records and both saved hashes for each exclusion. No solver candidate has reached the strict judge. The controller is still running.
