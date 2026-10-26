# Review of agents/sat/RULES.md v3 (step 4 / c4) and cut hcmp — theory, 2026-10-24
**Verdict: SOUND.**
- Step 4 + c4 (least significant): decreases c4 with c1-c3 unchanged; other steps decrease a more significant component. OK.
- hcmp part 1: Q_i <= M_i (each cmp owns a cmov of its block; flags rule), W_i <= M_i (snapcmov: distinct cmov slots),
  Q_i + max(Q_i, W_i) <= k - i. OK.
- hcmp part 2: class E_i (same contents incl. T, same flags, same contents of earlier snapshot slots); inside a class a cmp
  splits into <= 2 (eq / fixed outcomes do not split); distinct permutations need distinct output index vectors; so
  |class| <= 2^{Q_i}. Valid for any test set of permutations (CEGIS subsets too). Encoding: E only forced true; the true
  assignment of a real normal-form program satisfies all clauses, which is all soundness needs. OK.
