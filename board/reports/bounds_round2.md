# bounds — round 2 report (2026-10-24)

Scope (all items): T-relaxed, M_out snapshot outputs (so also RE/RF), I1 (so I0), test set = permutations, any R.
c = #cmp, m = #cmov, v = #mov, W = m + v, k = c + W. Files: `agents/bounds/BOUNDS.md`, `agents/bounds/SORT5_SPLIT.md`,
tool `agents/bounds/rsearch.cpp` (modes: 1 = R1 min m, 2 = R2 min W with cmp free, 3 = exact set model with cmp cap).

## Done
1. **sort3, second short proof:** R2 (enum's set model, Lemma S, with cmp cost 0) gives W ≥ 8 for every correct program
   (exact search, 12 s); with B1 (c ≥ 3): k_out(3) ≥ 11. My exact set-model mode also gives none ≤ 10, found 11 (0.3 s).
   This is a 4th independent tool that agrees on k_out(3) = 11.
2. **R1 (min #cmov, cmp and mov free):** n = 3: m ≥ 6 (tight). **n = 4: m ≥ 10** (m ≤ 9 none, 340 s; tight, AlphaDev 10). So m ≥ 2·S(n) holds for n = 2, 3, 4.
3. **New pruning term H3'** (entropy when values have copies): E[l_j] ≥ max(1, log2(1/q_max)). Large speed-ups (R1 n=3: 758 → 1
   node; R2 n=3 now 12 s). Sound by the source-coding bound; in BOUNDS.md §H3'.
4. **SORT5_SPLIT.md v1 — reviewed SOUND by theory (L9):** cases c = 7..15; each case: #cmp = c, #cmov ≥ max(12, c),
   #mov + #cmov ≤ 31 − c. Range from B1 (c ≥ 7), B3 (m ≥ 12) and N2 as an S-rule (m ≥ c for every shortest program).
   Per-tool notes (sat NF, enum Lemma S) added after theory's review. Agreement: theory SOUND; sat and enum asked
   (inbox + SendMessage), answers pending at report time.
5. Bug log (posted in BOUNDS.md): two memo bugs in my new tool (flag missing from key; cached failures under cycles), found
   by tracing AlphaDev sort3, fixed before any claim.

## Numbers (cost estimates for the split)
- My exact tool with a cmp cap (n = 4, c ≤ 5, the analog of sort5 case c = 7): none ≤ 16 in 73 s; ×25–45 per step ⇒ k = 19
  needs days. Class-size pruning alone does not make the minimum-c case cheap; the W part of the bound is the weak point.
- R2 n = 4 (target W ≥ 15 ⇒ k ≥ 20): W ≤ 10 none in 41 s, next step ≈ ×1000 ⇒ out of reach with my tool.
- sat2: the C1 cut alone speeds n=3 k=8 ×15. Per-case cost for n = 5 must come from sat (asked for n = 4 per-c timings).
- New exact facts for n = 3 (all correct / shortest programs): m ≥ 6, W ≥ 8, and every block of a SHORTEST program has ≥ 2 cmov
  (mode 4 block tracking: no 1-cmov block at length ≤ 11, one exists at 12). Cross-check running: SAT model
  `exact.py 3 11 7 --perms --cmp 4:4 --cmov 0:7` must be UNSAT (4 blocks with ≤ 7 cmov would need a 1-cmov block).

## Conjecture m ≥ 2·S(n) (S = optimal network size; 6 / 10 / 18)
Status: TRUE for n = 2, 3, 4 by exhaustive R1 search (2, 6, 10); n = 5 (18) out of reach (root bound 12, slack 6).
No general proof. Proved in general: m ≥ Huff(n) (B3: 5 / 8 / 12). The obstacle: one cmov node can serve different outputs on
different permutations, so the per-permutation disjointness (Lemma D) does not give more than the Huffman sum. A per-block form
("each cmp block of a shortest program has ≥ 2 cmov", which would give m ≥ 2c and close cases c ≥ 11 of the split and leave
v ≤ 4 / v ≤ 1 at c = 9 / 10) is open in general; TRUE for n = 3 (R4 search), out of reach for n = 4, 5 with my tool.

## Open / next
1. sat: run the split cases (calibrate on n = 4 per c at k = 19 first).
2. Prove or refute "≥ 2 cmov per block in shortest programs" (exhaustive on n = 3, 4 first).
3. A copy (mov) term for W that is admissible: the missing piece for W ≥ 23 (n = 5).
