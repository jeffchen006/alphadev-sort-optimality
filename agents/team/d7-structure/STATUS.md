# d7-structure FINAL STATUS (2026-10-26, project stopped by user; all jobs stopped, data kept)
best k: 32 (no correct k <= 31 found anywhere). 25 NEW k=32 network families (fam32/*_k32.s, judge PASS).
Structure facts: every known optimum = c + G + Q (cmp + lattice gates/required creations + copies).
- 868,567 MCMC optima: ONE gate DAG mod S5 x rev: 9 + 18 (5 full + 8 half comparators, 4 borrowed flags) + 5; d1's 16 classes = 16 borrow placements.
- 26 of 177 nine-comparator network term sets reach k=32 (24 = 5 full/8 half/4 borrows; net9_41 = 4 full/10 half/5 borrows + 1 extra copy; net9_103 1 non-local gate).
- c=8 k=32 (w6): 8 + 18 required creations (14 lattice + 4 non-lattice selects) + 6 copies.
Census [A3] (A3_classes.txt): 274,035 correct k<=32 programs in agents/team: all k=32; 30 term-set classes (27 c=9, 3 c=8);
c=9 => g+v=23, c=8 => g+v=24 in all; 1 c=9 class (fleet/w3 known32.s) outside all network term sets.
pool_bfs (exact in pool, auto R, v2 prune judge-OK) — all NONE <= 31 [A8]:
base DAG (R=9,10); +1 lattice (155), +2 lattice (11,935), +1 select (7,957) (R=9); 177 net9 (R=9); 4,609 net10 NONE<=32 (R=7);
net9_41 +1 (6,739, R=9); c=8 classes 3 x (+1: 22,776; +same-flag pair: 13,873) (R=9/10); w3 class +1 (6,709), +pair (4,305) (R=9);
14 c=8 unions; near misses fw14 +1 8,783/8,787 (R=5), fresh31 +1 7,031/7,036 (R=7) (stopped, few missing).
Codex (thread CODEX_THREAD, r1..r5): ~520 design pools NONE; c=9 => g+v>=23 unsettled; c=11 w=22 k=33 exists.
Tools: ana.c gates.py vnet.py decide.py mincmp.py pool_bfs.cpp(v2) path2prog.py prog2skel.py nets.py orders.py collect.py chk.c classes.py. Log: LOG.md.
