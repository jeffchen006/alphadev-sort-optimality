# bounds — round 1 report (2026-10-24)

Scope of all bounds: T-relaxed (MODEL §2), test set = n! permutations (sound subset), I1 (so also I0), any output rule
(M_out snapshot, RE, RF), any register count R, and ALL correct programs (no canonical form) unless marked "canonical".
k = c + m + v (c = #cmp, m = #cmov, v = #mov). Details and proofs: `agents/bounds/BOUNDS.md`.

## Done
| id | statement | n=3 | n=4 | n=5 | status |
|---|---|---|---|---|---|
| B1 | c ≥ ⌈log2 n!⌉ | 3 | 5 | 7 | verified (theory L7, critic) |
| — | 7-cmp sort5 exists (`fj5_7cmp.s`, 72 instr): "c ≥ 9" (network size) is FALSE | | | | verified (sim + critic) |
| B2 | every adjacent pair (y_j, y_{j+1}) is compared on every permutation | | | | verified (theory review) |
| B3 | m ≥ Huff(n) (Kraft + node-disjoint output paths per permutation) | 5 | 8 | 12 | verified (theory review) |
| R1 | exact min m, relaxation R1 (cmp, mov free; Lemma R1 reviewed) | **6** | running (≥ 8 by B3) | — | n=3 verified (2 own tools agree) |
| B1+B3 | k ≥ c + m | 9 (with R1) | 13 | 19 | |
| N1–N4 | normal form (first instr = cmp of 2 inputs; each cmp followed by ≥1 cmov ⇒ m ≥ c; last write is snapshotted; scratch order) | | | | reviewed; canonical only, k-sweep / NOP suffix (L4); not automatically combinable with other teams' D-rules |
| H | admissible h = c_lb + max(c_lb, und, ⌈Huffman-sum⌉) for M_out search (shortest completion) | root 8 | 13 | 19 | reviewed; enum's root h was 6/10/14 |

Negative results: c ≥ 9 for n=5 false; v ≥ 1 false (n=2 optimum has v = 0: cmov into a T register = conditional copy);
"each cmp block has ≥ 2 cmov" (true in all AlphaDev programs, m = 2c) is NOT proved.

## Numbers vs targets (k_out ≥ 11 / 20 / 32)
AlphaDev (c, m, v): sort3 (3, 6, 2), sort4 (5, 10, 5), sort5-42 (9, 18, 5). Best proved sum so far: 9 / 13 / 19.
The gap for n = 5 is 13: bounds alone do not reduce sort5 to few cases yet. Usable cuts for sat now: c ≥ 7, m ≥ 12 (and,
canonical, m ≥ c); then c ≤ 15 at k = 31.

## Running at report time
- `agents/bounds/mincmov 4 10` (R1, n=4 min #cmov; log `agents/bounds/logs/mincmov_n4_cpp.log`).
- `agents/bounds/minwrite 3 1 9` (R2, n=3 min #mov+#cmov with free cmp; so far W ≤ 6 impossible ⇒ k ≥ 3 + 7 = 10 once W ≤ 6 is posted; target W ≥ 8).
- Asked enum to run R2 in its faster engine (COSTCMP = 0).

## Open problems / next
1. R2 = enum's set model with cmp FREE: exact min W = m + v. If W_min = 8 / 15 (n = 3 / 4), then B1 + R2 = 11 / 20 = exact
   k_out: a short, independent proof for n = 3, 4. For n = 5, W_min ≥ 23 would settle every case with c ≥ 9; the cases c = 7, 8
   are near-tight in B1 (128 / 256 leaves for 120 perms), so a search with cmp counted and class-size pruning (H1) is small.
   Plan: n = 5 split "c ≤ 8" (search, strong H1 pruning) + "c ≥ 9" (needs W ≥ 32 − c).
2. Conjecture: m ≥ 2·S(n) (S = optimal network size: 6 / 10 / 18). True for n = 2, 3 (R1); n = 4 from R1 run.
3. R2 for n = 5 is too big for my tool; needs enum's engine or a smarter decomposition.
