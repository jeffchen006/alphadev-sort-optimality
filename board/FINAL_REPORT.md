# Project A — final report (coordinator, 2026-10-26)
Goal: show that DeepMind AlphaDev's branchless sort3 / sort4 / sort5 kernels (Nature 2023) are the shortest possible, in a
stated model; or find shorter ones. Model (shared/MODEL.md): AlphaDev's own opcodes (mov, cmp, cmovl/le/g/ge), cmp/cmov on
registers only (MM-1, AlphaDev's rule), every instruction counts incl. n loads + n stores, unbounded registers, correct on all
weak orders (ties) for any garbage in scratch registers and flags. Length L = 2n + k (k = register core; Lemma L5, proved in Lean).

## 1. Results
| n | AlphaDev L | result | strength |
|---|---|---|---|
| 3 | 17 | **17 is optimal** (no L <= 16) | ~10 independent proofs: LRAT certificates checked by cake_lpr (3), CakePB chain incl. symmetry breaking (k<=8 full, k=10 cube run), Lean theorems in AlphaDev's own memory model (`sort3_mm_lb`, native_decide; kernel-only `lower_bound_kernel_x86` by agent lean, std axioms only), verified Lean encoder + Lean LRAT (lean-lrat), Rocq checker (coq), two independent searches (enum, critic) |
| 4 | 28 | **28 is optimal** (no L <= 27) | exhaustive search (enum, 1.39e9 states, pruning rules reviewed by theory and Codex); certificate exported (123 GB); Lean check done to k <= 17 (strict); k <= 19 check = TODO (board/TODO.md) |
| 5 | 42 | **42 not beaten; optimality NOT proved** | strong but scoped search evidence (section 2) |
Prior work: AlphaDev claimed sort3 by brute force (no certificate, no model); Ullrich & Hack (CGO 2025) give 11/20 in a weaker model
(I0, permutations, fixed outputs, 1 scratch register). Our sort4 result and all certificates are new.

## 2. sort5: what we know
New positive results
- A second structure reaches 42: **8 cmp + 20 cmov + 4 mov** (Codex fleet, ~160 programs; also 8+22+2). All known k=32 programs:
  274,035 correct programs in 30 value-set classes: every 9-cmp one has cmov+mov = 23, every 8-cmp one 24 ("copies are conserved").
- 868,567 + 25 network families of 9+18+5 programs (one MCMC family + 25 new ones from network term pools).
Exclusions (no k <= 31 = no L <= 41), each within a stated scope (board/ASSUMPTIONS_42.md, board/team/FINAL.md)
- **No pure max/min (lattice) sort5 with L <= 41** — exhaustive (d2, 1.51e9 states, tool judge-reviewed, positive controls 9/9).
- **Garbage never helps** (lemma C1, Codex w12, judge-accepted): any correct program becomes garbage-free with no more
  instructions or cmps. So a 41, if it exists, must write >= 1 non-max/min value; the case of 1-2 such values stays OPEN
  (SAT cannot decide it with current encodings; enumeration ~1e11-1e12 states).
- "sort4 then insert x4" needs >= 32 (insertion >= 12, SAT/DRAT); no 7- or 8-cmp program with all-lattice cmp operands.
- Exact routing / pools: all 177 nine- and 4,609 ten-comparator networks, 16 flag classes x 640 skeletons, 1,476 + 208
  recompute skeletons, all 161 c=8 skeletons, ~44,000 c=8 / c=9 neighbour and pair-tracking pools, 6,075 + parts of 21,392
  non-lattice c=9 skeletons, 952 Ford-Johnson skeletons: none.
- Both best near misses (41 instructions, wrong on 9 / 14 of 541 inputs) are not repairable (all windows <= 7, all edits at
  <= 3-4 positions, all one-cmp neighbour skeletons: UNSAT).
Honest limits: none of this is a proof that 42 is optimal; the proved lower bound for sort5 is only L >= 29 (k >= 19).
A full proof was estimated as out of reach (board/SORT5_PROOF_EFFORT.md); the decisive missing piece is the 1-2 (and >= 3)
non-lattice-value case.

## 3. Side results (paper material)
- Beyond AlphaDev's action space: with memory source operands in cmp/cmov (legal x86, forbidden by AlphaDev): L = 7 / 15 / 26 / 39
  for n = 2..5 (< 8 / 17 / 28 / 42), checked by judge and on hardware.
- Latency: AlphaDev sort3 and sort5 are not Pareto-optimal in (length, dependency depth); a k=32 sort5 with depth 10 (AlphaDev 13);
  min depth sort5 = 6 (U/E), sort4 = 5.
- I2 (+cmove/cmovne/xchg): no gain; xchg redundant (theory L11).
- Semantics trust: abstract model = AMD EPYC 9654 hardware (hundreds of millions of runs) = certified ACL2 x86isa model.
- Literature scan: board/LIT_2026.md (key: Cruz-Filipe & Schneider-Kamp, LPAR 2024).

## 4. Where things are
- Paper draft: agents/theory/paper/main.pdf (15 pp; sort3 theorem, trust-chain table, sort4, latency, beyond-AlphaDev).
- Reproducibility artifact: artifact/ (22 claim scripts; 19 pass here, 3 need more free RAM).
- Programs: programs/ (AlphaDev originals, found/, variants/), board/team/candidates/.
- Team final report (scopes, families, near misses, tools): board/team/FINAL.md
- Team logs: board/claims.md, board/reports/, agents/*/STATUS.md, board/team/ (CLI agent team), agents/team/codex-fleet/.
- Data kept: enum certificates (agents/enum/certs, ~140 GB), d2 lattice data (agents/team/d2-lattice, 58 GB).
- Deferred: board/TODO.md (sort4 k<=19 Lean check; sort5 proof).

## 5. Shutdown (2026-10-26 10:20)
CLI team (tmux sort5team) shut down after FINAL.md; all Codex workers and search jobs stopped; team CPU = 0.
Desktop role sessions are idle (not archived). All data kept.
