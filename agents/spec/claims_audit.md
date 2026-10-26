# spec audit of lower-bound claim statements vs MODEL.md §4 (n, k sweep, R, I, C, output rule, relaxation, test set)
| claim (board/claims.md) | n | k sweep | R | I | C / output | relax / tests | verdict |
|---|---|---|---|---|---|---|---|
| enum 20:10 | 3 | <= 10 (BFS, all) | unbounded | I1, I0 | M_out §4.3 (=> L_AD = 2n+k) | T-relaxed, 13 weak orders | OK |
| critic 18:59 | 3 | every k = 0..10 | unbounded | I0 | RS, AlphaDev C, MM-1 | T-relaxed, 13 | OK (I0 side result) |
| critic 19:00 | 3 | every k = 0..10 | unbounded | I1 | RS, AlphaDev C, MM-1 | T-relaxed, 13 | OK (main, no certificate yet) |
| critic 19:05 | 3 | <= 10 | unbounded | I1, I0 | M_out/RS | relaxed, 13 | OK (2 tools agree) |
| proofs 19:09 (k=9, fixed outputs) | 3 | k = 9 | 12 | I0 | FIXED outputs (RF) | 6 order types | stated correctly as NOT an AlphaDev bound |
| proofs 19:09 hypothesis (k=10, snap) | 3 | k = 10 | 13 | I1 | snap | 13 | OK if the rule-free F0 is UNSAT (padding gives all k <= 10, MODEL §2); F1 (with canon) alone needs a sweep or NOP-suffix |
| spec 19:27 (n=2 MM/MM+) | 2 | L <= 7 / <= 6 | unbounded | I1 | MM / MM+, all instr. | relaxed, 3 | OK |
Result: n=3 main claim L_AD(3) = 17 is stated correctly by two independent tools (no certificate yet).
