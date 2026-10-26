# sat — round 2 report (draft, 2026-10-25)

Task (coordinator): calibrate cube-and-conquer cost on sort4 k=19 exact-c cases (answer known: enum/bounds UNSAT),
then estimate sort5 k=31 cases c = 15, 14, 13 (SORT5_SPLIT.md v2).
Model: M_out (snap), I1, R = n + k, relaxed, n! permutations, nop mode, rules r8 + hcmp (RULES.md v3/v4).

## sort4 k=19, #cmp = 9 (direct SAT)
- 9 block cases (b = one 2, rest 1; #mov = 0, op pattern forced), unsplit c=9, pattern-unit variant: all TIMEOUT 8 h
  (kissat, 1 core each). bounds' set-model tool closes this case in 402 s. => direct SAT is >= 70x slower here.

(estimates follow)
