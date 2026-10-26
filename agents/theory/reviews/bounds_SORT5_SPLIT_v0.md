# Review of agents/bounds/SORT5_SPLIT.md v0 against lemmas.md L9 — theory, 2026-10-24
**Verdict: SOUND.** Split by c = #cmp into cases 7..15 is complete and each case may carry the stated implied constraints.
- F3 (N2 as S-rule): correct. In a shortest program a cmp with no cmov before the next cmp/end is deletable (its flags are
  never read), so every cmp owns a distinct cmov of its block: m >= c. "Shortest" must mean shortest among programs correct
  on ALL weak orders (the full spec), not among programs correct on the 120 test permutations; the deletion argument keeps
  full correctness, so this is fine — state it.
- F4: correct for L6.0 (rho, iota, sigma, phi, mu keep #cmp). ALSO needed and true for sat's rewriting normal form: for a
  SHORTEST p, no removal step can fire (it would give a shorter correct program), so the normal form only renames, swaps,
  flips, replaces pre-cmp cmovle/ge by mov and moves snapshots: #cmp unchanged, and NF(p) is shortest, so F3 holds for it.
  For enum: Lemma S maps cmps 1:1 (cost of the image <= L = optimum, so the image is a minimum-cost set program); #cmov >= 12
  holds because the set program maps back to a register program with the same cmovs (B3 applies); m >= c because a
  minimum-cost set program has no useless cmp. Say this per tool in the file.
- Range: c + max(12, c) <= 31 gives 7 <= c <= 15. Correct.
- L9 points 1-6: answered correctly. Per-case H1 "class at depth d has <= 2^(7-d) perms" in case c = 7 holds for EVERY correct
  program with exactly 7 cmps (not only shortest). Fine.
- Certificates: one per case + coverage = this argument (paper proof; small enough to also state in Lean: c(p*) = c(p) and
  7 <= c <= 15).
