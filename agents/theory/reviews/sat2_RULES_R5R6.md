# Review of agents/sat2/RULES.md R5 (snapT) and R6 (llP / llPall) — theory, 2026-10-24
**Verdict: SOUND.**
- R5: the value of r after t steps equals the value after t+1 steps if step t does not write r; moving snapshots later
  changes no instruction, so it commutes with every rule on the code sequence (R1-R3, R6, M-rules). Check in the encoding
  that a snapshot at position t (= just before step t, which writes r) counts as a READ of r in the interval for snap-aware
  `deadw` (boundary convention), otherwise deadw could wrongly forbid a write read only by that snapshot.
- R6: canon (first-write scratch renaming + T-read redirection) commutes with P-renaming pi, so pi(canon(X)) = canon(pi(X))
  is in O; the lex-min of O satisfies Q <= pi(Q) for all pi, and R3 by your cases (i)/(ii) (swap commutes with sigma).
  free/snap only. llP (adjacent transpositions) is a subset of llPall: sound.
- llS is a different base (lex-leader over scratch transpositions); never combine with R1+R2 — as you state.
