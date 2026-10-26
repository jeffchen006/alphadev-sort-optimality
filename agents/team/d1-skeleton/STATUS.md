# d1-skeleton FINAL STATUS (2026-10-26, project stopped by user decision)
Best k: 32 (no k<=31 found). All results: search, not proof. Every run: dagx K=31, 120 strict perms (sound relaxation).
Tags: A4 = fixed value skeleton (exact cmp operand columns); A5 = lattice operands only; A6 = one comparator order.
No register cap (each copy = fresh register). TIMEOUT = UNKNOWN. Results: <set>/res/<name>.out ("RESULT NONE|FOUND|TIMEOUT").
Tools: dagx.cpp (exact gate-DAG routing + copy scheduling; judge: sound; binary dagx_bin3; alternatives "a:b;c:d"),
  gensk.cpp (lattice skeleton enumeration), neighx.py / neigh.py (one-cmp neighbours), canonx.py (dedupe mod S5 x rev),
  skel.c (skeleton extraction), prog2skel.py, queue5.sh (robust queue), counts.sh. Sanity: sort4 42 skeletons K=20 FOUND / K=19 NONE.

CLOSED (all NONE, 0 FOUND):
- 868,567 k=32 optima = 16 value classes sk/vc01..16 [A4]; flag-class closure over lattice operands sk/flag/fc01..16 (640 each) [A5]
- lattice neighbours of optima + d7 fam32: sk/n1 120, sk/n2 144, sk/n7 392 [A4,A5]; d7 fam32 sk/d7 25 [A4]
- c<=8: no lattice skeleton (refining or not) sorts 5 (gensk, logs/gen_c{5,6,7,8}_b3.log) [A5]
- D3: FJ5 c=7, merge2+3 c=8, sort4-net+bin-insert c=8 (sk/d3_*) [A4]
- c=8 k=32 seeds: 161 distinct (sk/w6_c8, sk/c8u 17, sk/c8r2u 143) + near misses b31a, fw14 [A4]
- one-select one-cmp neighbours: w6_c8 sk/w6n 119; fw14 sk/fw14n 120; fresh31_near sk/fresh31n 4032; w3_known32 sk/w3x_n 8135 [A4]
- c=10: sk/r10 1476 (base + repeated cmp); d7 networks sk/net9 177, sk/net10 4609 (one order each) [A4,A6]
- Codex w8: sk/w8a 3365 (w8 unknowns), sk/w8n41 119 [A4]; d2 TE exceptions sk/te 4 (= class vc02)

OPEN / PARTIAL (stopped mid-queue; NONE so far, rest not run):
- c=8 seed one-select neighbours sk/c8n1 (160 seeds): 2888 NONE, 7 TIMEOUT, 15365 not run
- d6 fam32 select set sk/fam_sel: 173/1428; d4 sets: r3p8 77/300, d4c8 40/647, d4c9 15/637, d4c7 4/34, r4 0/252
- d7 other comparator orders: sk/ord9 159/2332, sk/ord10 0/35688 [A6 lift]
- w8 round-4 first half sk/w8r4u 0/10696 (second half given to Codex w14: out/w8r4u_half2_for_w14.txt); sk/w8b 0/2710 cross-check
- net9_41 flag class (sk/flag/a_fd7_41.txt, 80 lattice alternatives): not finished
- non-lattice operands with the same flags as the optima classes: not covered
