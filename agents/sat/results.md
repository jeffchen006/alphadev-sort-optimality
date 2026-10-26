# sat — results (round 1)

Model for all lines: MODEL.md §1-2 relaxed (scratch = T, cmp(T,T) = eq, flags eq at start), R = n + k,
k = #mov + #cmp + #cmov, L_AD = 2n + k_out (MODEL §4.3, Lemma 4.1). Output rule: snap = M_out (AlphaDev-valid);
fixed (P_j at end) and free (any register at end) are variants only. Rules: RULES.md v3 (theory: all SOUND incl. hcmp).
"r8" = canon,pcanon,comm,dead,flags,cmpord,movfresh,snapcmov; "h" = r8 + cut hcmp. nop mode = length <= k.
Test set "perm" = all n! permutations (sound subset of weak orders, theory L1b).

## n = 2 (rule check, pysat, full instance)
k_out(2) = k_fixed(2) = k_end(2) = 4 in every variant (I0/I1 x snap/fixed/free, perms and weak orders), for the rule
sets none, all, all-minus-r, only-r (every rule r). `python3 validate.py 2 6 <I> <outmode> <perm|all> 3`.

## n = 3
| variant | k | result | tool | time | certificate |
|---|---|---|---|---|---|
| I1 snap perm, h | 11 | SAT: programs/found/sat_sort3_k11.s (judge --strict PASS; 3 cmp 7 cmov 1 mov) | solve_full.py | 215 s | - |
| I1 snap perm, h | <=10 | UNSAT | cadical | 668 s | LRAT, cake_lpr VERIFIED 310 s |
| I0 snap perm, h | <=10 | UNSAT | cadical | 414 s | LRAT, cake_lpr VERIFIED 209 s |
| I0 snap perm, r8 (no cut) | <=10 | UNSAT | cadical | 1904 s | LRAT, cake_lpr VERIFIED 701 s |
| I1 snap perm, r8 (no cut) | <=10 | UNSAT | cadical | 3950 s | LRAT, cake_lpr VERIFIED 1156 s |
| I1 snap perm, h | <=9 | UNSAT | kissat | 31 s | - |
| I1 fixed perm, canon,comm,dead,flags,cmpord | 11 / <=10 | SAT / UNSAT | kissat | 495 s / 2598 s | - |
| I0 fixed perm, same | 11 / <=10 | SAT / UNSAT | kissat | 640 s / 2204 s | - |
| I1 free (end) perm, canon,pcanon,comm,dead,flags,cmpord,movfresh | 11 / <=10 | SAT / open (kissat timeout 1 h) | kissat | 769 s | - |
| I1 snap perm, rule sets none / all / all-r / only-r (20 sets) | 11 | SAT in all 20; k=10 UNSAT for all 9 all-minus-r sets | validate.py | <= 4.6 h | - |

So k_out(3) = 11 (I0 and I1), k_fixed(3) = 11. Same as enum, critic, sat2, lean-lrat (k<=9), Ullrich-Hack (fixed, I0).

## n = 4 (I1 snap perm, h, 24 permutations, R = n + k)
| k | result | time |
|---|---|---|
| 12 | UNSAT | kissat 289 s |
| 13, 14 | running | |
| 19, split #cmp = 5..9 | running (4 h limit each) | |
| 20 | CEGIS (8 types after 845 s), running | |
