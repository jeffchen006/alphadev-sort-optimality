# bounds — round 3 report (2026-10-24)

Scope: T-relaxed, M_out snapshot outputs, I1, permutations, any R. c = #cmp, m = #cmov, v = #mov, W = m + v, k = c + W.
Files: `agents/bounds/SORT5_SPLIT.md` v2 (plan table), `agents/bounds/BOUNDS.md`, tool `agents/bounds/rsearch.cpp`.

## Done
1. **Per-case cost table for the sort5 split** (`SORT5_SPLIT.md` v2). Knuth random-probe estimates (3000 probes) of the
   search tree of my exact set-model tool, k ≤ 31, exactly c cmps:
   | c | 15 | 14 | 13 | 12 | 11 | 7 | 10 | 9 | 8 |
   |---|---|---|---|---|---|---|---|---|---|
   | est. tree | 1e20 | 3e22 | 4e23 | 7e25 | 4e28 | 6e28 | 3e29 | 2e30 | 1e31 |
   Order of magnitude only (rel. stderr 0.3–0.8); calibrated on n = 4 (memo gains 10–35×).
   **Tool per case: sat (cube-and-conquer) for all nine cases; my tool closes none.** Proposed order: c = 15, 14, 13, 12
   (small, give certificates and a CNF-cost calibration), then 11, 7, 10, 9, 8. c = 7 is not the easy case: its comparison
   tree is nearly forced, but W ≤ 24 leaves the most room for writes. Sent to sat, sat2, enum.
2. **New mode "exactly c cmps"** (EXACTC; remaining cost ≥ c_left + max(c_left, Huffman, MCUT − m_used)), sound for
   shortest programs (F3). n = 3: c = 3 → 11, c = 4 → 12, c = 5 → > 12.
3. **n = 4 split case c = 9 closed:** no program with exactly 9 cmp and length ≤ 19 (with #cmov ≥ 10, so v = 0 forced);
   150 M calls, 402 s. n = 4 case range is c = 5..9 (c + max(10, c) ≤ 19). Case c = 8 running (≈ 20 h by estimate);
   c ≤ 7 out of reach for my tool (estimates 3e13–2e15 tree nodes).
4. Answers: theory (R4 checks the last block — yes); sat (its NF deletions do not change c for a SHORTEST program — agreed
   with theory's review).

## Addendum (21:40)
- sat's own cost data: sort4 k ≤ 19 is out of reach for CNF (single kissat > 18× per step; cube-and-conquer estimate for
  case #cmp = 9, #cmov ≥ 10: ~3e10 core-h). My set-model search closed that same case in 402 s on 1 core. So for these
  counting cases a semantic search with strong bounds beats CNF by many orders; I sent the three prunes (exact c, global
  #cmov cut, entropy term) to enum for its 40-core engine, and agree with sat's "semantic cubes" plan. sat also prefers enum
  (cmp cap) for sort5 case c = 7. Revised tool column: enum/semantic search first for every case, sat as the certificate
  route where it can run.
- spec's artifact `s3_12_bounds.sh` (my sort3 claims) PASSES (142 s); I proposed 3 more claim scripts (n=4 #cmov ≥ 10,
  sort4 case c = 9, the 7-cmp sort5 program).
- n = 4 case c = 8: length ≤ 18 none (290 s); length 19 running (> 50 min).

- upper's samples (1.48 M sort4 k=20, 1.25 M sort5 k=32 correct programs): always c = 5 / 9, every block ≥ 2 cmov; best
  found with c ≤ 8 is k = 41 (c = 7: 52). Evidence (not a bound) that cases c = 7, 8 are far from k = 31 and that "m ≥ 2c"
  (proved only for n = 3) holds; that rule would close sort5 cases c ≥ 11.

## Addendum 2 (resume, 23:40)
- **Semantic cubes** added to my tool (env NSPLIT / ISPLIT / KSPLIT): job i owns frontier states (first node with budget
  ≤ KSPLIT) whose hash % N = i; coverage and memo argument in SORT5_SPLIT.md §Semantic cubes (sent to theory for review).
  Test: sort4 case c = 9 in 4 jobs, all none, 756 s total (1.9 × single run), wall time / 4. Ready for peers with cores.
- enum's own sort4 BFS (no split): 1.4e9 states after 1 h at depth 11 of 19, hundreds of GB — the per-case DFS with
  strong bounds is the cheaper route; enum has not run R2 (busy with that run).
- sort4 case c = 8: length ≤ 18 none; length 19 still running (2.5 h of ~20 h estimated).

## Not done
- R2 for n = 4 (W ≥ 15 ⇒ k ≥ 20) with enum's engine: request sent; enum has not answered yet (busy with sort4).
- SAT cross-check of "≥ 2 cmov per block" for n = 3 (`exact.py`, cmp = 4, cmov ≤ 7, k = 11): timed out after 3000 s,
  inconclusive. The claim stands on the exact set-model search (theory reviewed the argument).
- No new analytic bound for n = 5. The estimates show why: the write part of every bound is weak (Huffman 12 vs AlphaDev 18 cmov).

## Next
1. sat: run c = 15 → 12 for n = 5; report CNF time per case; I recalibrate the table.
2. enum: R2 n = 4 in its engine; then n = 5 W ≥ 23 would close c ≥ 9 at once.
3. Me: finish n = 4 case c = 8; look for an admissible copy (mov) term and a block rule for n = 4.
