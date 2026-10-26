# sort5 discovery team — FINAL report (sort5-lead, 2026-10-26 ~10:30)
Goal: a sort5 program shorter than AlphaDev's: strict-correct in M_AD(5, I1), L <= 41, i.e. register core k_out <= 31
(M_out, shared/MODEL.md 4.2-4.3), MM-1 kept. Project stopped by user decision 2026-10-26 ~10:00.

## 1. Result in one line
NO program with k_out <= 31 was found. Best: many k = 32 programs (= AlphaDev's 42) in 30 term-set classes, incl. the first
c=8 programs at k=32. Best k=31 near misses fail 9/541 and 14/541 weak orders. Nothing below is a proof of optimality;
every negative is a search result with the scope stated.

## 2. Programs found (all strict-judge PASS; board/team/candidates.md is the judge log)
| what | budget c+g+v | where |
|---|---|---|
| 868,567 MCMC optima (one gate DAG mod S5 x rev; 16 flag-skeleton classes) | 9+18+5 | agents/upper/runs/r4/s5k32_coll.txt.gz |
| 25 new c=9 families from 9-comparator network pools (+1 known) | 9+18+5 (net9_41: 4 full+10 half, 5 borrows) | agents/team/d7-structure/fam32/ |
| 1 c=9 class outside all network pools (upper I0 / Codex w3) | 9+18+5 | agents/team/codex-fleet/w3/programs/known32.s |
| first c=8 k=32 (Codex w6) | 8+20+4 | board/team/candidates/codex-w6_c8_k32.s |
| 161 distinct c=8 k=32 value skeletons (Codex w6 18 + round2 143, w5, d4 r4) ; census: c=8 g 19..24, v 5..0 | 8+24 total | codex-fleet/w6/verified, w6/round2/verified, d4-evolve/codex/work/r4_new_correct32.txt |
| c=9 split 9+21+2 (fresh31 repaired), 730 k=32 cores (w1) | g+v = 23 | codex-fleet/w6, w1 |
| correct c=8 k=33 (first c=8) | 8+... | agents/team/d4-evolve/codex/work/position33_valid.txt |
Census (d7, all team folders): 274,035 correct programs <= 32 instr, ALL k=32; 30 term-set classes (c=8: 3, c=9: 27);
every c=9 program has g+v = 23, every c=8 program g+v = 24 (agents/team/d7-structure/A3_classes.txt).

## 3. Near misses (k=31, not correct)
- fresh31_near (Codex w6): c=9, fails 9/541 (only output 2): codex-fleet/w6/round5/candidates/fresh31_near.s.
  Closed locally: all windows w=4..7 -> any <= w instr UNSAT (d6); no fix within 3 changes (d4 satrep, any slot);
  all 2-pos, 3-pos, 4-pos edits + 19-instr suffix UNSAT (Codex w7, checked certificates); skeleton + all 4,032 one-select
  neighbours: no k=31 routing (d1 dagx).
- fw14 (d4 evo): c=8, fails 14/541: agents/team/d4-evolve/runs/fw14.txt. No fix within 4 changes (satrep Q=4, 12 h);
  all windows w=4..7 UNSAT (also with 4 extra temps); skeleton + 120 one-select + 3,881 two-select neighbours: no routing.
- net9_41 (k=32 with one forced extra copy): copy-free k=31 version: no fix within 3 changes (any slot), 4 changes in slots
  8..24; skeleton + flag class no routing; 44 Codex pools; copy shown forced.

## 4. Searches and their exact scopes (tags = board/ASSUMPTIONS_42.md)
Tools (all judge-reviewed SOUND within scope): dagx (d1; exact routing for a FIXED value skeleton, no register cap, 120 perms),
pool_bfs v1/v2 (d7; exact BFS with every value in a term pool, auto register cap), winsat (d6; window SAT+CEGIS, 541 weak
orders, strict), satrep / rep2 (d4; Hamming-Q repair), lat_d2 (d2; exact pure-lattice BFS), gensk (d1; skeleton enumeration).
- [A15] NO pure-lattice, no-garbage-column program with k <= 31 exists (d2, 1.51e9 states, last layer depth 29;
  120 perms, relaxed, unbounded registers <= 16 cols; positive control 9/9; judge SOUND). agents/team/d2-lattice (logs/k31_ext.log, ext31/).
- [A12] No sort5 skeleton with c <= 8 whose cmp operands are all lattice terms exists, refining or not (gensk, no cap; judge).
- [A4] dagx K=31 NONE for: all 16 optimum flag classes over all lattice operands (640 each); 656 + 8,135 neighbours;
  25 fam32 families + 392 neighbours; 177 nine- and 4,609 ten-comparator network skeletons (one order each); 1,476 c=10
  recompute-instead-of-copy skeletons; all 161 c=8 k=32 skeletons + 119 neighbours; d4 near-miss skeletons; Codex w8's
  6,075 + 119 non-lattice c=9 skeletons; template t1 (2,328) and pair-tracking prefix (7,664) (d5).
- [A8] pool_bfs NONE <= 31: 177 nine-comparator pools; base DAG + any 1 select (7,957) / any 2 lattice extras (11,935);
  net9_41 + 1 extra; all 3 c=8 classes + 1 extra (23,046) and + same-flag select pairs (13,873); w3 class + 1 extra and pairs;
  4,609 ten-comparator pools: none even <= 32.
- [A11] local: all windows w<=7 (w<=8 for the first c=8 k=32) on the first c=8 k=32 and 17 other c=8 programs; satrep
  Q=3 on all 32 deletions of two c=8 k=32 programs; MAP-Elites / QD / evo (1e8-1e9 children) floor 9-14 at k=31.
- Insertion bound (Codex w3, checked by d5; DRAT): after ANY prefix that never reads x4, inserting x4 needs >= 12
  instructions, so "sort4 then insert x4" has k >= 32 (no interleaving).
- w1 (Codex): network + skipped-mov family (149,040 sequences) needs >= 5 movs; judge re-implementation agrees (A10 holds),
  but the family has no borrowed flags / half comparators, so it excludes all known optima (A9 challenged).

## 5. Lemmas (judge-reviewed, as proof sketches with stated hypotheses)
- C1 (Codex w12, codex-fleet/w12/lemma.md): every strict-correct program maps to a GARBAGE-FREE program with no greater k
  and no more cmps (judge: SOUND; independent test 5,606 programs, 0 failures).
- w10 one-column lemma (codex-fleet/w10/round4/ONE_COLUMN_LEMMA.md): q garbage-partial columns -> <= q-1 non-lattice
  columns (hypotheses: cmps read defined values, other full columns lattice); q=1 -> pure lattice, so d2 covers it.
- T-elimination data (d2): 99.8% of sampled lattice+T optima map into the pure-lattice space; the 4 exceptions closed by dagx.
- Structure (d7): every known optimum = c + G + Q = 9 + 18 (5 full + 8 half comparators, 4 borrowed flags) + 5 copies.

## 6. Direction (a) (stop criterion, board/team/DIRECTION_A.md)
Scope after C1: garbage-free programs, k <= 31, <= 2 non-lattice written values (copies counted), c = 7..15.
- 0 non-lattice values: CLOSED (d2 + C1).
- 1-2 non-lattice values: OPEN. SAT encoders V1/V2 judge-reviewed SOUND, but 0/1,929 V2 cases decided (all UNKNOWN at 1 h,
  incl. a control the BFS decides; same encoding cannot close sort4 k=19); exact BFS with 1/2 escape columns ~2e11 / 3e12
  states. Not feasible with current tools. Calibration run stopped at project end.

## 7. Open gaps (for anyone who continues)
1. Garbage-free programs with 1-2 non-lattice written values (needs a new method; data: agents/team/d2-lattice/STATUS.md).
2. Programs with >= 3 non-lattice written values (not searched exhaustively anywhere).
3. Bridge B1: no bound links a program's partial-column count to the non-lattice count of C1's output.
4. dagx results hold per value skeleton (A4); flag-class closure covers lattice operands only (A5); one comparator order
   per network class (A6; d1 had the other 2,332 + 35,688 orders queued, not run).
5. Evidence E1-E10 in board/ASSUMPTIONS_42.md (statuses and change log there) - nothing is a proof that 42 is optimal.

## 8. Where things are
- Board: board/team/STATUS.md (final table), board/team/DIRECTION_A.md, board/ASSUMPTIONS_42.md, board/BREAK42.md,
  board/team/candidates.md (judge log), board/team/candidates/.
- Per teammate (final STATUS.md in each): agents/team/{d1-skeleton, d2-lattice, d4-evolve, d5-extend, d6-qd, d7-structure,
  judge, codex-fleet}/; Codex workers: agents/team/codex-fleet/w1..w14 (RESULTS.md each).
- Kept data: d2 ext31 (49 GB) and c2/ (manifests, calib/), all certificates and programs. Nothing was deleted at wrap-up.
