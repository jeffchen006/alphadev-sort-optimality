# How to break 42 (coordinator, 2026-10-25 19:10) — target k = c + g + v <= 31
c = #cmp, g = #cmov ("gates"), v = #mov (copies). All 26 known k=32 families: c=9, g=18, v=5.
Proved/known floors: c >= 7, g >= 12 (Huffman), c <= 8 needs a non-lattice cmp operand (lead 17:12).

## 1. Budget map: which splits are still open?
| split for k=31 | example design | explored? |
|---|---|---|
| c=9, g=18, v=4 | network with 5 copy-free comparators | 177 nine-comparator pools + 656 neighbours of net9_41: none (search) |
| c=9, g=17, v=5 | one comparator shares a gate / one output never needed | not targeted directly |
| c=10, g+v <= 21 | 10-comparator network with heavy copy reuse, or 1 extra cmp that REPLACES copies (recompute flags instead of keeping a copy) | NOT explored (all pools were 9-comparator) |
| c=8, g+v <= 23 | merge-insertion / sort2+sort3+merge, non-lattice operands | 3 families only; best k=33 |
| c=7, g+v <= 24 | Ford-Johnson (info-tight: 128 leaves for 120 perms) | FJ family only |
Action: fill this table with "exhaustive / sampled / not done" per row, then attack the open rows.

## 2. Copy accounting (theory, decides where to look)
Baseline comparator = mov + cmp + 2 cmov = 4; 9 comparators = 36; AlphaDev 32 = 36 - 4 saved copies.
Also: a copy can be replaced by a cmov into a fresh register (cmp a,b; cmovle m,a; cmovg m,b; cmovg b,a = 4, no mov),
so "copy" and "extra gate" are interchangeable at cost 1. Question to settle exactly: for c = 9 and the
snapshot-output model, is g + v >= 23 forced? (A clean argument would say: every value overwritten while still needed
costs 1, and 9 comparators on 5 wires create >= 23 such events.) If forced, k = 31 needs c != 9: put all effort on rows c=10, c=8.

## 3. Search ideas not yet tried
- Gate sharing: one cmp drives 3-4 gates (conditional swap of TWO register pairs = pair tracking). This is how
  merge insertion keeps partners; it makes c=8 / c=7 designs cheaper. Give the routing SAT a macro "swap pair (a,b) and
  (a',b') on one flag".
- Early snapshot: store an output as soon as it is final, so its register can be reused without a copy.
- Recompute vs copy: allow the same comparison twice (cmp again later) when that removes a copy.
- 10-comparator networks (and 9-comparator non-optimal-depth ones) as skeleton pools for dagx / pool_bfs.
- Non-lattice c=9 skeletons (comparisons between partner values), not only lattice pools.

## 1b. Budget table filled by sort5-lead (2026-10-25 19:04). "exh" = exhaustive in stated space (search, not proof).
Cross-cutting: d2 exact pure-lattice search k<=31 (all programs whose register values are all lattice terms, ANY c/g/v
split) is at depth 20 of ~23, ~15 h left; none <= 27 so far fully closed. dagx (exact routing for a fixed value skeleton,
cmov values unrestricted, judge-reviewed) is the per-skeleton tool.
| split for k=31 | status | what was done | owner next |
|---|---|---|---|
| c=9, g=18, v=4 | SAMPLED (structured) | dagx K=31 none: 16 optima value-skeleton classes, 25 new k=32 families (d7), 656 1/2-cmp neighbours, 2,328 sort4-core template t1 extensions (52% of optima); pool_bfs none: 177 nine-comparator pools, 155 single extra terms, 3,205/7,957 one-select pools, 44 Codex pools around net9_41; satrep: no sorter within 3 changes of net9_41 minus copy; winsat windows w<=7 none | d1 flag-class closure (16 classes x 640 lattice alternatives) running; d2 lattice run |
| c=9, g=17, v=5 | NOT DONE directly | d2 SAT "min gates to sort 5" G=17 running; lattice case covered by d2 run when it ends | d2 |
| c=10, g+v<=21 | pool level EXH: all 4,609 ten-comparator network pools NONE even <=32 (pool_bfs); out-of-pool via dagx: 1,476 recompute-instead-of-copy skeletons (optima + fam32 + 1 repeated cmp) NONE; all 4,609 ten-comparator network value skeletons NONE (one comparator order per class; pool_bfs covers all orders in-pool) | - | d1 (dagx on 10-comparator skeletons + recompute-instead-of-copy), d7 (4,609 ten-comparator pools queued in pool_bfs) |
| c=8, g+v<=23 | lattice: EXH none (gensk, every refining/non-refining lattice skeleton fails to sort); non-lattice: SAMPLED | dagx none: merge2+3, sort4-net+binary insert, pos33 skeleton; pos33 windows (rerun); deleting 2 merge backups of pos33: UNSAT; d4's 647 c=8 near-miss skeletons running in dagx | d4 + d5 (pair-tracking macros) |
| c=7, g+v<=24 | lattice: EXH none; non-lattice: SAMPLED | dagx none: Ford-Johnson; d4's 34 c=7 skeletons queued | d4 + d5 |
| c=11.., | not done; budget g+v<=20 unlikely (g>=12) | - | - |
