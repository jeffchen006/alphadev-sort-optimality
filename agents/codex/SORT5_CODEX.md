# Codex ideas for k_out(5) >= 32 (2026-10-25 07:48)
Codex (gpt-6.1-sol, high, read-only) read board/SORT5_IDEAS.md, BOUNDS.md, SORT5_SPLIT.md, SORT5_PLAN.md. Raw output: out2.md.
Codex states: none of the 5 ideas establishes 32 now; all are sound reductions to test. c = #cmp, W = #mov + #cmov.
Caution from Codex: idea 1 of SORT5_IDEAS (sentinel/max restriction) gives a DIFFERENT machine; its sort4 optimum cannot be replaced by 20 without a proof.

Ranked (my filter: concrete + testable):
1. Comparison tree + routing cost. For each depth-c cmp tree T, bound the writes W(T) needed to supply cmp operands and outputs
   (columns over the 120 perms; flag column fixed per cmp; in-place select cost 1, select into copy cost 2). k >= c + min_T W(T).
   Needed: W >= 25 (c=7), 24 (c=8). Test: recover W = 8 (sort3, c=3), W = 15 (sort4, c=5); prescribed trees first.
2. Exact short suffixes by flag partitions. In a block without cmp, partition perms by lt/eq/gt; each result register equals one entry register
   (or T) on each part -> origin tuple from <= (a+1)^3 choices. Exact completion cost for 1-2 remaining cmp blocks -> reject prefixes. (no "2 cmov per block" assumption.)
   Test: one-block completion of sort3 prefixes, two-block of sort4 prefixes; cost <= known suffix length.
3. Flow LP with synchronised instruction distribution. Transition graphs of small perm subsets share one instruction distribution per position;
   fractional flow = relaxation; LP infeasible at length 31 => bound; certificate = rational dual. Test: pairs/triples of sort3 perms vs independent pattern bounds.
4. Rank-row inclusion dominance (state A dominates B if its row set maps into B's, >= outputs taken, cost <=). Codex test on sort3: NO extra merges up to cost 5. Low value.
5. Comparison relaxation (cmp direction chosen independently per perm, routing kept). Codex 12 s SAT pilot on sort3: inconclusive. Test first on sort3 L=10, sort4 L=19.
Sent to theory: 1, 2, 3.
