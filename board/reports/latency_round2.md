# latency — round 2 report (2026-10-25 00:20)

## Done
- Certificates: all 11 latency UNSAT CNFs (depth bounds n=3,4,5; joint size bounds n=3) are LRAT-checked by cake_lpr
  (mine: agents/latency/lrat_check.sh, logs/lrat_all.log; proofs agent re-solved independently). Hashes: proofs/SHA256SUMS.
- Lemmas: RULES_LATENCY.md parts A, B, C reviewed SOUND by theory.
- sort5 depth gap: was [5,7], now **[5,6]** (U and E). New witness programs/found/latency_sort5_depth6_k174.s
  (I1, k=174, depth U6/E6, judge --strict PASS); E-only variant k=137. Found by local search over relaxed DAGs
  (rdls.py) + list-scheduling compiler (lsched.py, now with I1 operand choice).
- sort4 Pareto: new point (k=28, depth 5): programs/found/latency_sort4_k28_depth5.s (strict PASS). AlphaDev = (20, 6).
- Team latency definition sent to enum and sat (inbox).

## Numbers (depth U / E / Z2)
| n | AlphaDev | min depth | witness |
|---|---|---|---|
| 3 | 6/6/9 | 4/4/5 (cake_lpr) | k=18 |
| 4 | 6/6/9 | 5/5/6 (cake_lpr) | k=28 (5/5/7), k=86 (5/5/6) |
| 5 | 13/11/16 | 5 or 6 (U,E) | k=174 (6/6/9) |
Pareto n=3: {(11,5), (k4,4)}, 12 <= k4 <= 18 (cake_lpr). Pareto n=4: {(20,6), (k5,5)}, k5 <= 28; lower bound open.

## Running (3 cores, ends by itself; notify-on-exit armed)
- relax.py 5 1 5 --T --perm (UNSAT here => sort5 min depth = 6), 3h40m so far, timeout ~07:40.
- rdls.py sort5 outputs 1, 2 at depth 5, 30 seeds each (a find => min depth = 5).
Stopped (token/CPU budget): n=4 joint K=16/17, register local search, I1 recompile of sort4 depth 5.

## Open
1. sort5: depth 5 or 6.  2. n=4: k5 in [?, 28] (joint K=13..17 not finished).  3. n=3: exact k4.
4. x86 timings of the depth-optimised programs (x86 paused).
