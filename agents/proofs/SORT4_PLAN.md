# SORT4_PLAN — certificate for sort4 (target: UNSAT at k = 19, M_out snap, I1, R = n + k)

Version 3, 2026-10-24 23:30 (proofs). Disk: 2.2 TB free on /zdata. Exact k = 19 is enough: Lean `lower_bound_chain_snap` (padding).

## 1. Measured solve times, n = 4 (cadical, 1 core, monolithic UNSAT unless noted)
| encoding | types | rules / cuts | k: time |
|---|---|---|---|
| lean-lrat v2 I1c (Lean-proved rules) | 75 weak orders | canon+pcanon | 6: 7 s, 7: 26 s, 8: 150 s, 9: 854 s (x4-6 per k) |
| sat encode.py | 24 perms | 8 rules + hcmp + class cuts | 12: 289 s (13, 14: running, logs/n4_k1314.txt) |
| sat2 cnf_enc.py (`bench_sort4_best.txt`) | CEGIS subset | all rules + C1 (#cmp >= 5) | 11: 31 s, 12: 454 s, 13: > 3600 s (x15 per k) |
| sat2 CEGIS k = 15..19 (C1 + C2) | 7-10 types | all rules, C1, C2 | SAT calls of 0.4-2 ks each; final UNSAT call not reached |

Extrapolation from k = 12 (300-450 s) to k = 19 (7 more steps):
| growth g per k | total solve | with cake_lpr (x2) |
|---|---|---|
| 4 | 289 * 4^7 = 4.7e6 s = 1.3e3 core-h | 2.6e3 core-h |
| 6 | 8.1e7 s = 2.2e4 core-h | 4.5e4 core-h |
| 15 (sat2 k11->12) | 5e10 s | impossible |
=> Today no encoding is feasible for k = 19. Feasible only if stronger cuts bring g to <= 4 (or lower the k = 12 time a lot).

## 1b. New data from sat (inbox 21:05-21:31)
- sat k=13 (r8 + hcmp, perms, kissat) not done after > 2 h: g(12->13) > 25. With #cmov >= 10 the k=12 case is trivial
  (counting), so the informative range is k = 15..19; sat runs k = 15, 16 with #cmp >= 5, #cmov >= 10, hcmp, class cuts.
- sat Knuth estimate (cube = UP-consistent 8-instruction prefix, leaf = kissat), k = 19: #cmp = 9, #cmov >= 10:
  ~1.5e13 leaves, ~3e10 core-h; #cmp = 5: 1e14-2e15 leaves. Calibration n=3 k=10: estimate 3.1 core-h vs real ~3 core-h.
- => VERDICT: sort4 k <= 19 is NOT reachable with the current encodings (direct or syntactic cubes), by > 6 orders of
  magnitude. cake_lpr on all cubes is then also not feasible (it costs about the same as solving).
  Disk is not the bottleneck: even 1e3 core-h of proofs (10-30 TB) would only work as check-and-delete.
- Needed first: a new method that shrinks the search (sat's idea: semantic cubes = abstract state after d steps, as in
  enum's dedup; bounds' cuts). A certificate for semantic cubes needs the glue "every program reaches one of the listed
  states" — this must be proved (Lean, or a checked enumeration), not only solved.

## 2. Proof size and disk
- LRAT rate (lean-lrat k = 10 leaves, cadical text LRAT): 4-7 MB per solver second raw, 2-3 MB/s after trim;
  binary LRAT is ~2.5x smaller. 1.3e3 core-h -> ~20-30 TB text, ~10 TB binary.
- Free disk on /zdata: 2.3 TB (shared). => Keeping all leaf proofs is NOT feasible. Feasible: check-and-delete per leaf
  (sat's cubes.py does this; log cnf/lrat sha256 + cake_lpr stdout), peak disk = jobs x largest leaf (~10-50 GB).
- cake_lpr time = 0.5-1.7 x solve time (sat leaves 0.3 s / 0.5 s, 18.6 s / 15.7 s; lean-lrat k = 9: 60 s check).
  So cake_lpr on ALL cubes is feasible exactly when the solving is feasible (it doubles CPU at most).
- CakePB (for VeriPB symmetry steps) does not scale: k = 8 n = 3 already uses 67 GB (LRAT 265 MB). For sort4 use
  Lean-proved rules (lean-lrat I1c and G3 rules) + cake_lpr / Lean checkCert, not CakePB.
- Re-check by proofs: `cc_check.py` = glue (summary == F + negated cubes), summary proof, and a random sample of leaves
  rebuilt byte-exact and compared with the logged sha256 + cake_lpr (done for sat n = 3 k = 10: 100/100).

## 3. Certificate structure
1. F = encoding (n=4, k=19, I1, snap, T) with rules R; T = 24 permutations (sound relaxation) or a CEGIS subset.
2. Cube tree (sat's cubes.py) -> each leaf: cadical LRAT -> cake_lpr -> hashes in log -> delete. Summary -> cake_lpr.
3. Lean route (second verified check) needs F = lean-lrat's encoder export: lean-lrat must add the rules below with proofs.
4. Rules to certify for n = 4 (sat/sat2/lean-lrat agree these are needed):
   | rule | certificate |
   |---|---|
   | canon, pcanon | Lean (lean-lrat Canon.lean) |
   | flags, dead (NOP-suffix), hcmp | Lean G3 (lean + theory), not done |
   | C1 (#cmp >= 5), C2 (#cmov >= 10) | bounds lemma; Lean or VeriPB (cardinality = PB constraint) |
   | comm, cmpord, movfresh, snapcmov | Lean G3 or drop |

## 4. Decision
- Measure g with ALL cuts at k = 12, 13, 14 (sat: running; sat2: k = 13 > 1 h). If g <= 4: run (about 4 days on 16
  cores incl. cake_lpr). If g >= 6: sort4 k = 19 is out of reach for the SAT route this way; then need new cuts
  (bounds) or a different method (enum's BFS with certificates, lean-reflect).
