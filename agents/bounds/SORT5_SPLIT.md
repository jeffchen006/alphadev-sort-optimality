# sort5 case split by #cmp (bounds agent) — v2, 2026-10-24 (v2: per-case cost table)
Review: theory — SOUND (agents/theory/reviews/bounds_SORT5_SPLIT_v0.md); v1 adds theory's two points (marked [v1]).

## Goal
Prove k_out(5) ≥ 32 in M_out(5, R = 5 + 31, I1), T-relaxed (MODEL §2), test set = 120 permutations (L1b), outputs =
snapshots, lengths ≤ 31 (k-sweep k' = 1..31, or NOP-suffix encoding, theory L4).
Notation: c = #cmp, m = #cmov, v = #mov, W = m + v, k = c + W.

## Facts used (all reviewed)
- F1 (B1, theory L7): every correct program has c ≥ ⌈log2 120⌉ = 7.
- F2 (B3, theory review): every correct program has m ≥ Huff(5) = 12.
- F3 (N2, S-rule): every SHORTEST correct program has every cmp followed by ≥ 1 cmov before the next cmp / end, so m ≥ c.
  (S-rule: deleting a cmp whose flags are dead gives a shorter correct program. Holds for every shortest program.)
- F4: c is invariant under every operation of theory's master lemma L6.0 (ρ scratch rename, ι input rename, σ swap of
  independent neighbours, φ cmp mirror, μ pre-cmp cmovle/ge → mov): none adds or removes a cmp. So c(p*) = c(p) for the
  canonical representative p* that the rules of sat / enum keep.

## Split
Suppose a correct program of length ≤ 31 exists. Let p be a shortest one (length k0 ≤ 31) [v1: shortest among programs
correct on ALL weak orders, i.e. the full spec; the deletion argument of F3 keeps full correctness] and p* its canonical form (L6.0).
Then c := c(p*) = c(p) (F4), 7 ≤ c (F1), m ≥ max(12, c) (F2, F3), so c + max(12, c) ≤ 31, i.e. **7 ≤ c ≤ 15**.
Cases (complete, disjoint): **Case c**, c = 7..15: "a correct program of length ≤ 31 with exactly c cmp exists".
Implied constraints valid inside Case c (all hold for p*): #cmp = c; #cmov ≥ max(12, c); #mov + #cmov ≤ 31 − c;
plus every reviewed rule the tool already uses.

| case | W = m + v ≤ | m range | how to close | note |
|---|---|---|---|---|
| c = 7 | 24 | 12..24 | sat with #cmp = 7 (+ enum with a cmp cap and H1: every class at depth d has ≤ 2^(7−d) perms) | comparisons nearly forced (merge insertion); see cost note: my tool alone is too slow |
| c = 8 | 23 | 12..23 | same as c = 7 | slack 256 vs 120 |
| c = 9 | 22 | 12..22 | sat / enum with #cmp = 9 | AlphaDev has (9, 18, 5) = 32: this is the hard case |
| c = 10..15 | 21..16 | max(12,c)..31−c | sat / enum with #cmp = c; W ≤ 31 − c gets small | m ≥ c leaves little room for c ≥ 13 |

Certificates: one UNSAT certificate (LRAT/DRAT for sat, a checkable log for enum) per case + this coverage argument.

## Per tool (F3, F4) [v1]
- sat (rewriting normal form NF): for a SHORTEST p no removal step can fire (it would give a shorter correct program), so NF
  only renames, swaps, mirrors, replaces pre-cmp cmovle/ge by mov and moves snapshots: #cmp unchanged, NF(p) is shortest, F3
  holds for it.
- enum (set model): Lemma S maps cmps 1:1; the image of p has cost ≤ L = optimum, so it is a minimum-cost set program; it has
  no useless cmp (m ≥ c); #cmov ≥ 12 because a set program maps back to a register program with the same cmovs (B3).
- theory: H1 "a class at depth d has ≤ 2^(c−d) perms" holds for EVERY correct program with exactly c cmps.

## Per-case cost estimates and tool (v2)
Method: Knuth random-probe estimate (3000 probes) of the search-TREE size of my exact set-model tool (`rsearch` mode 5,
EXACTC=1 = exactly c cmps; pruning: classes H1, remaining cmps each need a cmov, Huffman/entropy H3/H3', dead values),
budget k ≤ 31. Relative std. error 0.3–0.8 (order of magnitude only). Calibration (n = 4, cap c ≤ 5): estimate 6.9e6 /
9.8e8 tree nodes at k = 15 / 16 vs real 0.64 M / 27.8 M search calls with memo ⇒ memo gains 10–35×. Real CNF/SAT cost
is NOT predicted by this; the column "rel." compares cases only.

| c | W = #mov+#cmov ≤ | #cmov ≥ | est. tree (n=5, k ≤ 31) | rel. | proposed tool | order |
|---|---|---|---|---|---|---|
| 15 | 16 | 15 | 1.3e20 | 1 | sat (pilot: smallest case; m ∈ {15,16}, v ≤ 1) | 1 |
| 14 | 17 | 14 | 3.1e22 | 2e2 | sat | 2 |
| 13 | 18 | 13 | 3.8e23 | 3e3 | sat | 3 |
| 12 | 19 | 12 | 6.9e25 | 5e5 | sat (cube-and-conquer) | 4 |
| 11 | 20 | 12 | 4.0e28 | 3e8 | sat C&C | 5 |
| 7 | 24 | 12 | 5.8e28 | 4e8 | sat C&C (+ enum with cmp cap: comparison tree nearly forced) | 6 |
| 10 | 21 | 12 | 3.0e29 | 2e9 | sat C&C | 7 |
| 9 | 22 | 12 | 1.6e30 | 1e10 | sat C&C (AlphaDev's c; hardest with c = 8) | 8 |
| 8 | 23 | 12 | 1.2e31 | 1e11 | sat C&C | 9 |

n = 4 analog (k ≤ 19, exactly c, same estimator): c = 9: 2.2e9, 8: 3.9e11, 7: 3.3e13, 6: 6.7e14, 5: 2.2e15. With the
#cmov ≥ 10 cut (R1), the n = 4 case range is c = 5..9 (c + max(10, c) ≤ 19). Exact runs of the n = 4 cases with my tool:
see §Runs. n = 5 / n = 4 ratio for comparable cases ≈ 1e15–1e20: my tool cannot close any sort5 case; it ranks them.
Reading: the cases with few writes (c ≥ 12) are 3–11 orders of magnitude smaller than c = 8..10; c = 7 is not the easy
case (the comparison tree is nearly forced, but the write part has the most room, W ≤ 24).
Proposal: sat runs c = 15 → 12 first (each result is a real certificate and calibrates the CNF cost per case), then the
rest in the order above; per-case cuts: #cmp = c, #cmov ≥ max(12, c), #mov + #cmov ≤ 31 − c.

## Evidence from upper (search, not a bound; 22:09)
1.48 M sort4 k=20 and 1.25 M sort5 k=32 correct programs (M_out, I1, strict): always c = S(n) (5 / 9), every block ≥ 2 cmov,
(m, v) from (2c, k−3c) to (k−c, 0). Best found with c ≤ 8: k = 41 (c = 8), k = 52 (c = 7). So cases c = 7, 8 are probably far
from feasible at k = 31, and "m ≥ 2c" (proved for n = 3 only) would close cases c ≥ 11.

## Runs
- Split test, n = 4 case c = 9, NSPLIT = 4, KSPLIT = 14: all 4 jobs none (178 / 204 / 171 / 203 s; ~1700 frontier nodes
  each). Total 756 s = 1.9 × the single run (402 s): the memo is shared less. Wall time / 4. Log `logs/split_n4_c9.log`.
- n = 4, case c = 9 (exactly 9 cmp), k ≤ 19, cut #cmov ≥ 10 (so W = 10, v = 0 forced): **none** — 150 M search calls,
  402 s (`EXACTC=1 MCUT=10 ./rsearch 3 4 1 19 9`, log `logs/R3x_n4.log`). Real/estimate: 1.5e8 calls vs 2.2e9 tree (no MCUT in
  the estimator). Case c = 8 started (estimate ×180 ⇒ ≈ 20 h); c ≤ 7 out of reach.

## Semantic cubes (v3, parallel runs of one case)
`rsearch` mode 3 takes NSPLIT, ISPLIT, KSPLIT (env). A node is a FRONTIER node if its parent had budget > KSPLIT and it
has budget ≤ KSPLIT. Job i explores only frontier nodes (canonical state, budget) with hash % NSPLIT = i, everything else
fully. Coverage: every solution path has budget falling from K > KSPLIT to ≥ 0, so it has exactly one frontier node, owned
by exactly one job. Memo soundness: the share of a job is a function of (state, budget) only, so a stored failure in job i
means "no solution inside share i" on every path to that node; below the frontier nothing is filtered. So: all NSPLIT
jobs "none" ⇒ case closed. Test: n = 3 (exactly 4 cmp, k ≤ 11): 4 jobs all none, same as 1 job. n = 4 case c = 9 in 4 jobs:
§Runs. Use: `EXACTC=1 MCUT=10 NSPLIT=N ISPLIT=i KSPLIT=14 ./rsearch 3 4 1 19 c` (n = 4); for n = 5 use MCUT=12.

## L9 checklist (theory)
1. Coverage of the canonical program: the case predicate is "#cmp = c", a count; F4 shows it is the same for p and p*.
   It does not depend on register names, so pcanon / R6 / R1 cannot move p* out of its case.
2. Cases removed by symmetry: none. (c < 7 and c > 15 are removed by F1–F3, not by symmetry.)
3. Same n = 5, lengths ≤ 31 (sweep or NOP suffix), R = 36, I1, M_out, T-relaxed, 120 permutations in every case.
4. Implied constraints: #cmov ≥ max(12, c) holds for p* (F2 for all correct programs; F3 for all shortest ones, and p* is
   shortest). #cmp = c holds by case definition.
5. Per-case bounds are bounds on a shortest program (F3 needs it) — with a NOP-suffix encoding, apply F3 to the real
   (non-NOP) part only.
6. One certificate per case + this file.

## Cost estimates (data so far)
- My exact set-model tool (`rsearch` mode 3, cmp cap 5 = the n = 4 analog of case c = 7): n = 4 none ≤ 13/14/15/16 in
  0.0/0.0/1.6/73 s, growth ×25–45 per length step ⇒ k = 19 ≈ days. So the class-size pruning alone does NOT make the
  minimum-c case cheap: the write part (W) of the bound is too weak (root h = 13 vs 20). Not usable for n = 5.
- R2 (cmp free, min W): n = 3 exact (W = 8, 12 s); n = 4: W ≤ 10 none in 41 s, W ≤ 11 ≈ ×1000 ⇒ out of reach.
- sat2: C1 (#cmp ≥ 7-type cut) speeds n=3 M_out k=8 from 88 s to 6 s (×15); C1+C2: k=10 1506 s vs 1872 s.
- Conclusion: per-case cost must come from sat (CNF with #cmp = c, #cmov ≥ max(12,c), #mov+#cmov ≤ 31−c) — asked sat for n=4
  per-c timings at k = 19 (cases c = 5..). Case c = 9 (AlphaDev's c) is expected to be the hardest (W ≤ 22 vs AlphaDev 23).
- Order proposal: run n = 4 analog first (c = 5, 6, 7 at k = 19) to calibrate, then n = 5 c = 15, 14, ... (small W ⇒ easy)
  down to c = 9, and c = 7, 8.
