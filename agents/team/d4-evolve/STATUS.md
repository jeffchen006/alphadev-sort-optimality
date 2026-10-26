# d4-evolve FINAL STATUS (2026-10-26, project stopped by user)
Result: NO k <= 31 program found. All jobs stopped; data kept. Paths are relative to agents/team/d4-evolve/.

## Near misses (k=31, strict scorer = d4eval)
| name | c m v | fail_weak/541 | path | exact repair results (satrep) |
|---|---|---|---|---|
| fresh31 (Codex w6) | 9 20 2 | 9 (output 2 only) | runs/fresh31.txt | Q=3 UNSAT (15 types); Q=4 stopped, unknown |
| fw14 (my macro evo on w6 seeds) | 8 22 1 | 14 (iff {x0,x4}={strict min,max}) | runs/fw14.txt | rep2: none (2 subs); Q=3 UNSAT (2 and 4 fresh regs); Q=4 UNSAT (17 types, 12 h); dagx K=31 on its value skeleton NONE |
| b31a (Codex w6) | 8 22 1 | 30 | runs/b31a.txt | Q=3 UNSAT; Q=4 stopped, unknown |
| fw37 family (my MAP-Elites) | 9 20 2 | 37 | runs/fw37.txt | Q=3 UNSAT on 3 programs |
| d6 best29 | 9 19 3 | 29 | runs/d6_best29.txt | Q=3 UNSAT; Q=4 timeout (unknown) |
| codex30 + pad slot | 8 16 7 | 39 | runs/codex30pad.txt | Q=3 UNSAT |

## Correct programs found by this agent's runs (judge strict PASS)
- c=8 k=33: codex/work/position33_valid.txt (Codex r1; first correct c=8). dagx K=31 on its skeleton: NONE.
- c=8 k=32: codex/work/r4_new_correct32.txt (4 programs, Codex r4).
- c=7 / c=8 pair-tracking: codex/work/r3_designs.txt (20,669 correct, best k: c=8 44, c=7 52).

## Exact negative results (search, not proof)
Scope: satrep = SAT (agents/sat/encode.py, relaxed T model => UNSAT sound for strict), program fixed except <= Q
changed slots (any position, any instruction, registers used + 2 fresh unless stated), exactly K=31 slots, free outs,
CEGIS. rep2 = exhaustive 1-2 substitutions, strict 3-valued sim, NOP allowed. (judge reviewed both: sound.)
- rep2: 113 distinct (fail set, c) groups with fail <= 41 (runs/r1/rep_in1.txt): no sorter within 2 substitutions.
- satrep Q=3: 64 of these 113 groups UNSAT (fail 37/39/41, c=8 and c=9); logs/satrep_q3_*.log.
- codex-w6 c=8 k=32: all 32 single deletions Q=3 UNSAT (logs/satrep_w6_s*.log). Q=4 on best 3: stopped, unknown.
- r4 correct #0 (c=8 k=32): all 32 single deletions Q=3 UNSAT (31 in logs/satrep_r4c0.log + the fw14 one).
- net9_41 (d7) minus the min(x0,x1,x2) copy: Q=3 UNSAT; Q=4 in slots 8..24 UNSAT; Q=4 any slot stopped, unknown.
- pos33 minus 2 (interleave test, Q=4 in slots 4..18): 5 of 58 cases UNSAT, rest not run.
- MAP-Elites (src/evo.c, 1.5e8+ children, seeds: all deletions of 20k k=32 optima, Codex seeds): floor 37 (c=9);
  with pair-swap macros + crossover on 170 c=8 k=32 seeds: floor 14.
- Codex rounds r1-r4 (codex/r*_prompt.txt, r*_out.md, work/*report.md): templates (merge, insertion, FJ, cond.
  permutation; 6e8 programs), pos33 copy-alias UNSATs (CakeML-checked), pair tracking, fw14 targeted fixes: no k<=31.
- merge(2,3) min-k SAT (src/merge_min.py, merge_cegis.py): did not finish (unknown).
Tools: src/evo.c, src/rep2.c, src/satrep.py, src/skel.py (value skeletons in dagx format: runs/skel*, sent to d1/d5).
