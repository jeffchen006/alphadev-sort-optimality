# What a full sort5 proof would cost (theory, 2026-10-25)

**Goal.** k_out(5) ≥ 32: no RS program (snapshot outputs, I1, unbounded registers) of length ≤ 31 sorts 5 inputs, with a
certificate checked by a verified checker. With L5 (Lean `mm_lower_bound` / `l5_strict`) this gives AlphaDev's L = 42 optimal in M_AD.

## 1. Best known route
Exact set-model search (enum: Lemma S, NG strict route, rules E/P/G/D, heuristics H1/H2/H3'), split into the cases
c = #cmp = 7..15 (SORT5_SPLIT, reviewed), with L13 block-boundary subsumption and the h_R pattern database (L12) as extra
pruning; certificate = the state set, checked by lean-reflect (Lean) and coq (Rocq). The SAT route is not competitive
(sat: sort4 k = 19 by cubes ≈ 3e10 core-h).

## 2. Measured data (sources: enum logs, claims.md, bounds/lean-reflect/coq/sort5-lab reports)
| item | n = 4 (done) | n = 5 |
|---|---|---|
| target K / root h (enum) / slack | 19 / 10 / 9 | 31 / 14 (bounds' h: 19) / 17 (12) |
| states | k≤17: 2.56e6, k≤18: 5.58e7, k≤19: 1.39e9 (×20–25 per slack unit) | k ≤ 14 done (sat2); no exact run beyond |
| CPU / RAM | 5,756 s × 40 cores; peak 168 GB (~120 B/state) | — |
| certificate | 48 B/state (k≤18: 2.7 GB); k≤19 ≈ 67 GB | — |
| checker speed | lean-reflect 10–14 states/s/core (lists; target ≥ 1000 packed); coq 14/s; Lean kernel 2 s/state | ~5× slower per state (120 vs 24 perms) |
| case c = min (cmp cap) | bounds, n = 4 analog: ×25–45 per length step, no saving | c = 7, 8 not run |

## 3. Estimate for n = 5 (extrapolation, not measured)
- States: n = 4 needed 1.4e9 at slack 9. Each extra unit of slack costs ×20–25, and n = 5 states branch more
  (at depth 9, n = 4 grows ×15 per level; n = 5 has 5× more permutations and far more columns: 200 selector results at the
  root alone). With enum's h (slack 17): 1.4e9 × 22^8 ≈ 1e20, times the branching penalty → **1e20–1e22 states**. With
  bounds' stronger root h (slack 12): ≈ 1e13 × penalty → **≥ 1e15 states** (sort5-lab's barrier). L13 subsumption is not yet
  measured; a 1e3–1e6 reduction (Codish-style) does not change the order of the verdict.
- CPU at ~1,200 states/core-s (n = 4 rate / 5): 1e15 states ≈ 2.3e8 core-h ≈ **270 years on 96 cores**; 1e20: impossible.
- RAM/disk: ~120 B/state in RAM → 1e15 states = 120 PB (needs disk-based BFS); certificate ≈ 50 B/state = **50 PB**.
- Checking: at 1,000 states/s/core (the packed-checker target, not yet reached) 1e15 states = 3e8 core-h. Out of reach.
- Per case: c ≥ 10 is cheaper (W = #mov + #cmov ≤ 21) but not trivial; **c = 9 (AlphaDev's shape) is the core case**:
  W ≤ 22 must be excluded while every known optimum has W = 23. c = 7, 8 are not cheap either (n = 4 analog shows no saving).

## 4. Missing mathematics (each item would change the estimate)
| item | status | effect if proved |
|---|---|---|
| Write bound W_set ≥ 23 (W = #cmov + charged copies, sort5-lab round 2) | proved only W ≥ 13 (n = 5); W = 23 on every known optimum | closes every case c ≥ 9 by counting (k = c + W ≥ 32); leaves c = 7, 8 (need W ≥ 25 / 24) |
| Per-case write bound W ≥ 32 − c | not proved | closes the matching case without search |
| Conjecture C1: ≥ 2 cmovs per block in a shortest program (m ≥ 2c) | true for n = 3 (exhaustive); not provable by information counting | kills c ≥ 11 (m ≥ 22 → k ≥ 33); c = 9, 10 still open |
| Lattice normal form (all columns are max-min polynomials) | strong data, no proof; a local rewrite counterexample exists | alphabet 7,579 columns; still ≥ 1e16 candidate sets |
| **Lattice normal form (L-NF) + lemma TE** (no garbage reads; every column a max-min polynomial) | TE proved (theory review 2026-10-25); L-NF open (non-lattice cmov → mov rewrite kept 32,576 sampled optima correct; the LOCAL care-set version is false) | **decisive**: in the pure-lattice no-T space n = 4 k ≤ 19 has 11,299 states (vs 1.39e9) and n = 5 is already none ≤ 28 with 13.3e6 states (sort5-lab) — k ≤ 31 would very likely be feasible |
| An admissible h with slack ≤ ~6 along optimal trajectories | root slack now 12–17 | would bring the search near the n = 4 size (≈ 1e9–1e11) |

## 5. Verdict
**Out of reach with the current tools and mathematics; it needs a new idea — and there is one strong candidate.**
If the lattice normal form (L-NF) is proved, the search space collapses (sort5-lab: n = 5 none ≤ 28 in 13.3e6 states), and the
proof becomes feasible (a lattice-space search + certificate of modest size, plus a formal L-NF lemma). Without L-NF: Every search-based route meets ≥ 1e15 states
(centuries of CPU on the team's 96 cores, petabyte certificates). The single most valuable new idea is a **proved write bound**:
W ≥ 23 would settle all cases c ≥ 9 analytically (short proof, easy to check in Lean), and only the cases c = 7, 8 would need a
search; their cost is unknown (the n = 4 analog was not cheaper), so even then the verdict is "possibly feasible", not
"feasible". What would change the verdict: (0) a proof of L-NF (most promising; sort5-lab's data), (1) a proof of W ≥ 23 (or W ≥ 32 − c per case); (2) a measured L13 / h_R reduction of
≥ 1e6 on n = 4; (3) an admissible heuristic with root slack ≤ 6 for n = 5.

Numbers are extrapolations from n = 4 unless marked measured; owners of the data (enum, bounds, sat, sort5-lab, lean-reflect,
coq) please correct them in this file's history via board/inbox/theory.md.
