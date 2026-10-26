# d7-structure log
Codex thread: CODEX_THREAD (one thread, `codex exec resume`). Prompts r<k>_prompt.txt, answers r<k>_out.md.

## Step 1-3 (own data mining, 2026-10-25)
Tools: ana.c (C, per program: value-DAG key mod S5 / S5 x rev, lattice id of each cmov result, mov roles, liveness,
out times, cmp operand terms) -> ana.txt (868,567 lines). gates.py (gate view) -> gdump.txt. vnet.py (canonical gate DAG).
decide.py (which cmp pairs decide which gate, exact on 541 weak orders). mincmp.py (BFS: min cmps for a gate DAG).
Results (all 868,567 programs unless noted):
- register-level value DAGs: 632,807 raw, 528,709 mod S5 (= mod S5 x rev; the collection has no dual pairs).
- c=9; (mov, cmov) = (0..5, 23..18); m+v = 23. No cmov is a no-op. maxlive 6..10 (7-8 typical), 7..10 registers used.
- last out always after the last instruction; out order (first final -> last) is 0,4,3,{1,2} in every program.
- every program creates exactly 18 distinct lattice terms. Each is a GATE min/max(a,b) of the cmov operands' terms
  (non-lattice / garbage-partial cmov results = conditional copies; resolving them gives 0 non-local gates).
- 18 gates = 13 virtual comparators: 5 full + 8 half (4 min, 4 max). 9 cmp: 5 own (full) + 4 shared by 2 halves
  (one own, one BORROWED, borrow shares 1 operand: gate (a,b) with cmp(a, op(b,c)), a <= c). Copies Q = 5 = 1 per full.
- k = c + G + Q = 9 + 18 + 5 in every program.
- ONE gate DAG for all 868,567 (mod S5 x rev); 16 (DAG, borrow placement) classes = d1's 16 skeleton classes.
- mincmp.py on that DAG: min 9 cmps (any block order, borrow by exact decision test). So this DAG cannot give 31.
- d4's correct c=8 k=33 (position33): sort2 + sort3 + merge; merge block uses 3 non-lattice selects (4 cmovs on 1 flag);
  writes 25 (sort2 3, sort3 8, merge 14).

## Codex round 1 (r1_prompt.txt -> r1_out.md; thread CODEX_THREAD; quota 12% before)
Sent: F1-F8 above. Asked: Q>=F model, k=31 gate designs, non-lattice mechanisms, next measures.
Codex view:
- Q >= #full is FALSE in general (checked by Codex, 541 weak orders): zero-copy full comparator "cmp A,B; cmovl A,B;
  cmovl B,C" with C = min(a,d), b <= d (C rebuilds a when a<b); two full comparators sharing one copy (d <= b).
- one cmp can decide 4 gates: cmp A,B; mov T,A; cmovle A,B; cmovle B,T; cmovg N,T; cmovg P,B (a<=d, e<=b,
  N=min(b,d) -> max(a,N), P=max(a,e) -> min(P,b)).
- rule-based bound (1 copy/full, <=2 halves/cmp): k >= 4F + H + ceil(H/2): (6,6) -> 33; (4,10) -> 31; (5,7) -> 31 (needs G=17).
- relaxed search on the 23-term pool (+ each of 155 one-extra terms): always G >= 18, 9 blocks, no (G=18,Q<=4).
- adaptive select fragment: cmp P0,P1; cmovl P3,P2; cmp P3,P4; cmovg P3,P4 -> min(sel, x4): saves 1 cmp + 1 gate locally.
My check: re-ran codex_work/fragments.py (PASS 541) and checked the 4-gate block and zero-copy comparator by hand: correct.
All these are pure-lattice moves -> inside d2's exact search, but NO optimum uses them (0 non-local gates in 868k).
Next (mine): pool_bfs.cpp = exact register BFS restricted to a term pool (every register value in pool; any cmov whose
result is a pool term, incl. rebuilds), bound h = min creations + min cmp blocks (DP over created masks).

## Codex round 2 (r2_prompt.txt -> r2_out.md; quota 12% -> 13%)
Sent: pool_bfs tool + my results (base pool NONE<=31 R=9,10; 155 one-extra NONE). Asked: design pools (lattice or not), run.
Codex: 54 pools, 86 runs (R=9, many R=10), ALL NONE <= 31: merge(2,3) adaptive variants (pos33 routes, reversed /
crossed routes, lattice projections), base DAG + selected pivots / selected cmp operands (1-3 selects), FJ-like c=7
pools (needed 20 creations + 9 blocks, so the 7-cmp design did not materialise), hybrids (merge + sort4 terms).
Codex T3 guess: sort2+sort3+adaptive merge is most promising (relaxed bound 18 creations + 8 blocks = 26).
My check: codex_work/round2_summary.tsv lists the runs; pools saved codex_work/pool_*.txt. Spot check below.

## Pool sweeps (mine, pool_bfs K=31 R=9 unless noted)
- near-miss pools (own_pools.py: program columns + 5 outputs, dedupe): d4 fw37 (21 terms) + 8 distinct near31 pools: NONE.
- nets.py: all comparator networks with 9 comparators that sort 5: 11,790 distinct term pools, 177 mod S5 x rev
  (each 18 terms). The unique optimum DAG's term set = network pool #155 (net9_155): AlphaDev computes the SAME 18 terms
  as a 9-comparator network but gets 8 of them from other operand pairs (halves), which allows the 4 shared flags.
- all 177 network pools: NONE <= 31. K=32 run on all 177: running (bfs_net9_32.txt).
- base + 2 extras: running (bfs_e2.txt).

## judge review of pool_bfs.cpp (2026-10-25): bound admissible; fix: R must be >= 5 + K - minC - minB.
Done: pool_bfs now sets R = max(arg, 5 + K - remC[0] - remB[0]) (abort if > 12), prints "R = ..". Old R=9 outputs moved
to old_R9/. Re-run (run_all.sh): net9 K=31: all 177 R=9 NONE; base+1 extra: all 155 R=9 NONE (auto R = 9 everywhere,
min creations 18, min blocks 9). Queue: net9 K=32 -> base+1 select (7,957) -> base+2 extras (11,935), all auto-R.
- pos33 (c=8 k=33) accounting: 8 cmp + 14 lattice gates + 11 other writes (7 mov + 4 non-lattice merge selects);
  Q = #full fails there (4 full, 11 non-gate writes): merge routing costs 7 extra writes.
- New k=32 family: pool net9_100 (sort3(x0,x1,x2) + sort2(x3,x4) + merge) -> net9_100_k32.s, judge --strict PASS;
  same budget 5 full + 8 half, 4 borrows, 5 copies, but a different DAG than all 868k optima.
- net9 K=32 (auto R=10): 26 / 177 network term sets reach MIN k=32; programs extracted (path2prog.py), all judge --strict
  PASS (fam32/net9_*_k32.s). Value skeletons (prog2skel.py, fam32/sk/): with d1 canon.py, net9_155 = vc10 (the known
  family), 25 NEW classes. Sent to d1 for dagx K=31. All share the budget 9 + 18 (5 full, 8 half, 4 borrows) + 5.
- correction: of 26 families, 24 = (5 full, 8 half, 4 borrows); net9_103 = 1 non-local gate (5,7,3);
  net9_41 = 4 full + 10 half, 5 borrows, c=9, G=18, Q=5 (4 full copies + 1 copy of 012 with fan-out 3) -> the
  closest design to 31 (remove that copy). Pool BFS: not inside its pool. Sent to lead, d4 (satrep/Codex), d1.
- d1 dagx K=31 (out-of-pool routing, per value skeleton): all 25 new fam32 skeletons NONE (d1-skeleton/sk/d7/res).
- Codex r3 (net9_41 copy of 012) started; my analysis: G11=max(012,Y) and borrowed G12 share cmp(012,Y); G14=min(012,34)
  needs flag cmp(G12res,34) so it follows G11; Y is live later (G17) -> G11 must destroy 012 -> copy, unless Y/012 is rebuilt.

## Codex round 3 (r3_prompt.txt -> r3_out.md; quota 13% before) — avoid the 012 copy in net9_41
Codex: 44 pools (net9_41 + 2 extras of many kinds: p=012|34, distributed minima, rebuilds of 012 via 01/02, unions with
aligned net105/109/17/34/43/82, adaptive merge (c=8) variants, nested pivots), all NONE <= 31 (R=9/10).
Reason given (matches mine): cmp(A,T) yields U and V; U must overwrite A because T is needed for OUT3; OUT0 needs A later
under the flag of cmp(V,D) -> copy. Removing the copy costs extra cmps: Codex built a 4-mov, 11-cmp program k=33
(codex_work/r3/avoid_a_copy_33.s, my judge re-run below). A modified solver (<= 4 movs, <= 10 cmps, no recompute) found
nothing at K=32 for that pool.

## Codex round 4 (r4_prompt.txt -> r4_out.md; quota 13% -> 16%) — does c=9 force g+v >= 23?
Codex: UNRESOLVED. No proof, no c=9 design with w<=22.
- Candidate formulas: w >= 2c+n fails at n=3 (AlphaDev sort3: c=3, w=8 < 9). w >= 3c-4 fits n=3,4,5 optima but fails for
  the c=11, w=22 program (avoid_a_copy_33.s: 11 cmp, 18 cmov, 4 mov; pure lattice; every cmp deletion fails).
  So 2 extra cmps can buy 1 write: a real cmp/write trade-off (k=33 there).
- "every block has >= 2 writes" is false in general (c9_onewrite_block.s, redundant cmp, w=25, judge PASS).
- Invariant: on a distinct-input case, the last register copy of a not-yet-output rank cannot be overwritten; but the
  surviving copy may be a useful gate result (zero-copy comparator), so this does not charge 5 extra writes.
- W_min(c+1) <= W_min(c) (append an unused cmp), so no bound can grow with c without restrictions.
- n=4: all 22 term sets of 5- and 6-comparator networks, exact pool BFS (75 weak orders): c<=6 & w<=14 NONE; c=5 & w=15
  -> k=20 (n4_positive20.s PASS). Within those pools a 6th cmp saves no write. Global n=4 relaxations timed out.
My checks: judge PASS for avoid_a_copy_33.s (c=11 w=22), c9_onewrite_block.s, n4_positive20.s; counts confirmed.
Verdict: not settled. c=9 stays open (sampled). Trade-off evidence (c=11 w=22) makes c=10, w<=21 the most plausible
open row; my 4,609 ten-comparator pools (K=32) are queued; d1 gets their skeletons (netsk/).

## Codex c=8 k=32 (board/team/candidates/codex-w6_c8_k32.s, judge PASS) accounting
sort2(x3,x4) + sort3(x0,x1,x2) + adaptive merge (pair tracking: cmp 3|4:0|1|2 drives 4 cmovs; last 2 cmps on non-lattice
values). 8 cmp + 14 lattice gates + 6 non-lattice selects + 4 mov. Drop-one-term test: 18 required creations
(14 lattice + 4 selects), 2 dispensable (copy substitutes). k = 8 + 18 + 6 copies; 31 needs 5 copies.
Copies: 4 for full comparators (3,4),(0,2),(02,1),(012,34); extras: mov S6,S2 (keep 3|4 while S2 -> max) and the temp
select cmovge S0,S6. pool_bfs own pool (25 terms): K=31 NONE (R=10), MIN 32. 270 one-extra lattice pools: running.
- c=11 w=22 program pool (Codex r3): K=31 NONE (R=9), MIN k=32 in its pool.
- base + 2 extras (all 11,935 pairs): NONE <= 31 (auto R=9).
- 10-comparator networks: 449,430 distinct term pools, 4,609 mod S5 x rev (20 terms each). pool_bfs K=32: ALL NONE <= 32
  (auto R=7: every pool needs all 20 creations + 10 cmp blocks = 30, so <= 2 copies; none works). Skeleton files for
  d1 dagx: netsk/sk10_*.txt, sk9_*.txt (one comparator order per term-set class).

## Codex round 5 (r5_prompt.txt -> r5_out.md; quota 19% -> 21%) — fixes for the c=8 k=32 program (w6)
Codex: 376 design pools (other sort3 orders, reversed merge, alternative bounds, trimmed copy substitutes, new final
pivots / pair tracking, early merge, 2-3 extra conditional states at cmp(max34,max012)): all NONE <= 31 (auto R=10).
Used pool_bfs_live.cpp = pool_bfs + a sound prune: per permutation, every output rank not yet captured must still be in a
register (values are only copied). Fix (a): computing max(all) by growing max012 instead keeps max34 but copies max012
-> control32_found.s, c=8 g=19 v=5, k=32 (judge PASS). Fix (b): local SMT, from the state entering the last 2 blocks:
2 cmp + 4 writes UNSAT (that entering state only); 5 writes -> window_tail_w5.s, k=32 PASS.
Codex guess: the pair tracking before the last 2 blocks must change; moving the max only moves the copy.
My check: judge re-run on both files (below); prune rule argued sound by me (mov/cmov never create values).
- pool_bfs v2 = Codex's live-value prune added (sound; same results on 4 test pools, 7-11x faster). v1 kept (pool_bfs_v1).
- v2 (live prune) was in use from ~20:45 to 20:52 untagged; from 20:52 v2 lines are tagged "[v2-live]". Sent to judge for
  review. Untagged lines near the switch (w6s >= ~140, w6x >= ~55, n41 >= ~1400) count as v2 until the judge rules; if
  rejected, rerun all v2 lines with pool_bfs_v1.
- judge (2026-10-25 ~21:00): v2 alive() prune SOUND. v2 results valid; keep [v2-live] tag.
- d1 dagx K=31: all 177 sk9 skeletons NONE; sk10 1,413/4,609 NONE so far (d1-skeleton/sk/net{9,10}/res).
- d1 dagx K=31: all 4,609 sk10 + 177 sk9 skeletons NONE. orders.py: all comparator orders (linear extensions) per class:
  netsk/ord9 (2,332) and netsk/ord10 (35,688) -> sent to d1.
- d4 satrep: net9_41 minus the 012 copy (k=31): no sorter within 3 changes (any slot), none within 4 changes in slots 8..24 (exact SAT, any values). Q=4 any slot running.

## A3 census (red-team, 2026-10-25 night) [A3]
collect.py: every program with 7..32 instructions under agents/team/** and board/team (52,975 files; mem-model files
skipped) -> 637,115 distinct texts; chk.c (upper sim.h wrong_out = strict M_out with free snapshots) -> 274,035 correct,
ALL k=32 (no correct k<=31 anywhere). (Bug found and fixed: chk skipped 201 unparsable programs -> index shift; now
joined by explicit id.) Budgets: every correct c=9 program has g+v=23, every c=8 program g+v=24.
Term-set classes (set of created lattice terms, mod S5 x rev; classes.py -> A3_classes.txt): 30 classes.
- c=8: 3 classes (sizes 250,074 / 1,233 / 174 / ...; mostly fleet/w6 + d4/d6 descendants), 13-14 lattice terms + 4-9 N cols.
- c=9: 26 classes = my 26 network families (MCMC class = net9_155 included) + ONE class found only by fleet/w3
  (w3/programs/known32.s, source "upper_encoding_control", I0, judge PASS): its 18 terms are NOT the term set of any
  9-comparator network; 5 full + 8 half comparators, 5 borrows, one cmp (12 : 0|3|4) decides only borrowed gates.
  Its pool: K=31 NONE (R=9), MIN 32.
- classes seen by one source only: fleet/w3 (1). MCMC 868k (agents/upper, not in this census) = 1 class (net9_155).
- [A8] same-flag select pairs (complementary pair = conditional swap of a pair, lead-approved): gen_swap.py: w6 4,623,
  c8 class2 4,628, class3 4,622 pools (pool + 2 columns); queued (run_swap.sh) after the w6 select sweep.
- w3 class skeleton (fam32/sk/w3_known32.txt) sent to d1 for dagx K=31 + 1-cmp neighbours.
- d1 dagx: w3_known32 skeleton K=32 FOUND, K=31 NONE (184 s); 8,135 one-cmp neighbours running (d1 sk/w3x_n/res).
- completeness audit of all sweeps (missing result lines = transient empty outputs): s1, e1, net9, net9_32 complete;
  re-ran 4 net10_32, 4 e2, 3 n41, 3 s1 missing runs: all NONE. Final: base+1 select 7,957/7,957 NONE (R=9);
  base+2 extras 11,935/11,935 NONE (R=9); net9_41+1 extra 6,739/6,739 NONE (R=9); w6 c=8 + 1 extra 7,666/7,666 NONE (R=10);
  net10 4,609/4,609 NONE <= 32 (R=7).
- 2026-10-26 ~00:45: external pkill -x xargs killed run_c8 (class3 at 1,508/7,667) and the w6 swap stage (2,558/4,623). fill_missing.sh re-runs only missing items (missing != NONE).
- [A8] c=8 sweeps COMPLETE (audited, missing items re-run): class2 + 1 extra 7,713 NONE; class3 + 1 extra 7,667 NONE;
  same-flag select pairs: w6 4,623, class2 4,628, class3 4,622: all NONE <= 31 (auto R=9/10, v2).
- pool_bfs: pool limit raised from 22 to 24 non-input terms (key 5 bits/reg with sentinel 31 and 32-bit masks still fit); base pool check MIN 32.
- [A8] (b) unions of two c=8 class pools (unions.py: pool B mapped by all 240 S5 x rev symmetries, keep unions <= 24
  non-input terms): different classes never fit (overlap too small); 14 distinct unions (c2+c3 and self-unions of
  w6/c2/c3 under symmetries), 26-29 lines: all NONE <= 31 (R=9/10).
- (a) running: w3 + 1 extra (6,709), w3 + same-flag pair (4,305), near misses fw14 (27-line pool, min creations 22 +
  9 blocks -> R=5) + 1 extra (8,787), fresh31_near (min creations 19 + 10 blocks, R=7) + 1 extra (7,036).
- (a) w3 class: own pool + 1 extra 6,709 NONE; + same-flag pair 4,305 NONE (R=9, audited). d1 dagx: w3 skeleton and all
  8,135 one-cmp neighbours K=31 NONE.

## FINAL (2026-10-26, user stopped the project; all d7 jobs stopped, data kept)
- Near-miss sweeps stopped: fw14 + 1 extra 8,783/8,787 done (R=5), fresh31_near + 1 extra 7,031/7,036 done (R=7): all
  done items NONE <= 31; 4 + 5 items not run.
- Summary of d7 results: see STATUS.md. Key files: ana.txt (868k per-program structure), gdump.txt (gate lists),
  fam32/ (26 k=32 families, skeletons fam32/sk), netsk/ (177 + 4,609 network pools, skeletons, all orders ord9/ord10),
  A3_classes.txt (census), bfs_*.txt (all pool_bfs results; [v2-live] tag = v2 prune), codex_work/ + r1..r5 (Codex).
- No candidate <= 31 was ever produced, so nothing was sent to judge as a candidate.
