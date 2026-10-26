# enum — round 1 report (2026-10-24)

## Result
- **n=4: k_out(4) = 20** in M_out (RS), I1 and I0, R unbounded, strict-correct programs: no program of length <= 19
  (1,393,411,090 states, 5756 s, 40 pinned cores, peak 168 GB). AlphaDev sort4 is a k=20 witness. So L_AD(4) = 28 is
  optimal (Lemma 4.1 / L5, MM-1). Search claim, not yet certificate-checked.
- **n=3: k_out(3) = 11**, I1 and I0, all 13 weak orders (relaxed model, also strict via NG). Agrees with sat, sat2,
  critic, bounds.
- **n=5: open.** Partial: none <= 19 (NG, 120 perms). Not near 31.

## Tool and rules
- `agents/enum/src/enum_out.cpp` (C++/OpenMP; independent of sat). Layered BFS over the "set model": state = set of
  distinct register columns + flags + outputs taken + garbage count γ. Exact dedup (interned columns, full-key compare).
- Rules (all state-based; `agents/enum/PRUNING.md` v3; theory reviewed every one: SOUND):
  W (permutation subset), S (set model = register model, potential proof), M, E1-E4, P (flag polarity), G (S_n input
  relabelling), D (dead state), H1 (cmp >= ceil log2 of max class), H2 (#cmov >= #undone, >= #cmp), H3' (chain-DAG cover:
  #cmov >= #undone + max_j(cover_j - 2)), NG v3 (reads of never-written registers rewritten away in strict-correct
  programs; v2 had a gap that theory found, fixed).
- NG is needed for n=4: the pure relaxed model (ng=0) grows ~30x per bound step; its n=4 bound here is only none <= 16.
  So my n=4 claim is about strict-correct programs (the AlphaDev claim), not about relaxed-only programs.

## Checks
- TRACE: h <= remaining length + Φ on every prefix of the 15 AlphaDev M_out programs and 4 team programs (0 violations).
- HCHECK: incremental h = full h on test runs; state totals unchanged over all refactors.
- Own checker `src/check.py` (relaxed + strict garbage + 4 flag states): all AlphaDev out programs PASS.
- Counter `src/count.cpp`: n=3, register model, R=4, I0, perms, cmp i<j: **5602** programs of length 11 = Ullrich-Hack's
  number (independent repro). Without i<j: 44816; tie-correct (13 weak orders): 16224; I1 perms: 8,786,432.

## Certificates (format v1, agreed with coq + lean-reflect)
- `agents/enum/certs/sort3_I1_k10.cert` (2,219 states), `certs/sort4_I1_k17_ng1.cert` (2.56M states, 127 MB);
  k<=18: `certs/sort4_I1_k18_ng1.cert` (55.8M states, 2.7 GB). k<=19 (1.39e9 states) is too large for the checkers this round.
- Checkers must prove H2, H3' and NG for sort4 (measured: without H3' or NG the search does not finish).

## Re-run
```
cd agents/enum && g++ -O3 -march=native -fopenmp -o bin/enum_out src/enum_out.cpp
./bin/enum_out 3 1 1 10 32 1                                                  # n=3 I1: none<=10 (I0: arg3=0)
NG=1 CMAX=10 NOREC=1 VCAP=1048576 VLOAD=95 ./bin/enum_out 4 0 1 19 40 1       # n=4: none<=19 (~170 GB, ~1.6 h)
```

## Open problems
- n=5: h(root) = 15 vs 32; along AlphaDev sort5 the bound is exact in the last 9 steps but 17 too low at the start; state
  count grows ~18x per unit of slack. Needs much stronger bounds (copy/temporary counting) or the per-#cmp split
  (bounds SORT5_SPLIT) with a cmp cap in enum_out.
- Certificate for k<=19 needs a smaller state space (stronger proved rules) or a distributed checker.
- n=4 count of optimal programs (Ullrich-Hack: 2,233,360 in their model): DP not finished (memory).

## Next
- Add CMPMAX / exact-c, bounds' Huffman term and MCUT (#cmov >= 10 / 12) to h; try sort5 split cases c = 7, 8.
- Export k<=18 certificate; support coq / lean-reflect checks.
