# theory — round 3 report (2026-10-24)

## Done
- **SORT5_SPLIT.md v0 (bounds): SOUND against checklist L9.**
  - The cases are c = #cmp = 7..15, each with #cmov ≥ max(12, c).
  - F3 (each cmp has its own cmov in a shortest program, so m ≥ c) is correct.
  - F4 (#cmp does not change when a program is put in canonical form) is correct.
  - Additions asked for:
    - "shortest" means shortest under the full specification (all weak orders);
    - F3/F4 hold for each tool: L6.0's p*, sat's rewriting normal form (for a shortest program no removal step fires), and enum's set model (Lemma S maps each cmp to one cmp).
- **sat RULES v3 (snapshot-move step c4) and cut `hcmp` (parts 1 and 2): SOUND.** sat may use them for the n=3/n=4 certificates.
- **spec's MM+ search abstraction (MODEL §4.5, mm_bfs.py): SOUND and exact.** Its parts: registers as a multiset, writes to a fresh register dominate, flag-polarity symmetry, the all-eq cmp is dominated, no input symmetry, h = #wrong cells.
- **Paper:** `agents/theory/paper/main.tex` now has spec's sections (background, model and counting, MM+ "beyond", related work, bibliography).
  - It is 14 pages, compiles, and has no undefined references. The old version is saved as `main_draft1.tex`.
  - I removed my duplicate model section and lemma. The intro lists all of Ullrich & Hack's restrictions, including "no uninitialised reads" (from critic).
  - In the trust-chain and results tables, the n=3 row is filled as far as the evidence goes.
- **lean:** I relayed the coordinator's "start G2 now", with the spec of the construction (appendix L5 + `l5map.py`).
- **Notes to spec:**
  - add "no uninitialised reads" to `related.tex`;
  - one wording fix in the snapshot-lemma sketch: delete the last load of each segment, not only of segment 0.

## Numbers / state of n = 3 (I1, snapshot outputs)
- No program with k ≤ 10: enum (exact BFS) and critic (IDDFS) agree; both rule sets are reviewed.
- k = 11 is reached: sat finds a program at k = 11, AlphaDev's kernel has k = 11, and the strict judge accepts both.
- Certificate chain:
  - F0 comes from lean-lrat's verified rule-free encoder.
  - canon+pcanon is certified as "F0 SAT ⇒ F1 SAT" by VeriPB 3.0.2. critic re-ran it. VeriPB is an unverified checker; CakePB is pending.
  - **LRAT → cake_lpr for k = 10 has not landed yet.** So the trust-chain row for sort3 is not final.

## Open
- n=3: the cake_lpr result for k = 10 (proofs/sat); then I fill the last cell of the trust-chain table.
- The CakePB build needs the user's OK (proofs).
- lean G2 (L5) has started now. G3 waits for the final rule set of the certified run (canon + pcanon so far).
- n = 4, 5 claims: none yet. The sort5 split runs are not started yet.

## Next
Fill the sort3 row when cake_lpr lands. Review the first n = 4 claim and the Lean G2 statements. Keep the paper results in step with board/claims.md.

## Addendum (2026-10-24 20:12)
- **sort3 is certified.** sat's claim (19:54) is complete and uses only reviewed rules + hcmp: UNSAT for k ≤ 10, checked by cake_lpr. So L_AD(3) = 17 is optimal in MM (MM-1, I1).
  - Lean has both parts: lean-reflect's `sort3_rs_lb` (any registers, length ≤ 10, kernel + native_decide) and lean's `l5` / `sort3_optimal_of`. I asked them for one combined theorem `sort3_mm_optimal`.
  - The paper's sort3 row and the L5 row of the trust-chain table are filled.
- **Reviews:**
  - lean G2 (L5 in Lean): same as my L5.
  - lean-reflect: the statement is correct.
  - enum PRUNING v3 NG (now lemma L10): sound, with a fix to the proof text.
  - latency A1–A5: sound, with one point to state in A3.
  - bounds R2/R4: sound.
- [2026-10-24 20:13] lean frozen/v2 L5 text (`MMInstr`, `l5`, `mm_lower_bound`): CORRECT, same as my L5. lean has been told.
- Paper §"The sort3 bound: independent proofs and their trust bases" lists 7 routes with their exact trust bases:
  - certified: sat + cake_lpr; lean-reflect (kernel + native_decide);
  - partly done: lean-lrat (k ≤ 9 done, k = 10 running);
  - cross-checks: enum, critic, sat2, bounds.
