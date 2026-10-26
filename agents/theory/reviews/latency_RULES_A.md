# Review of agents/latency/RULES_LATENCY.md part A (A1-A6) — theory, 2026-10-24
Depth model (MODEL_LATENCY.md §1): RAW edges only (renaming), cmov reads D, S and flags always; inputs ready at 0.
**Verdict: A1-A5 SOUND (one point to state in A3); A6 is an upper-bound construction, checked per instance by the judge.**
- A1: cmp -> flag node; cmovcc -> sel node with the flag of the last cmp (or the constant eq flag before the first cmp);
  le/ge by swapping a,b, g by swapping cmp operands; mov -> reuse of the source node. Values agree on every order type
  (induction); node depth <= ready time (copies are free in RD; sel = lat + max(D, S, flag)). OK. Covers every output
  rule (an output is a node value at some time).
- A2: RD has free sharing, so min depth = max over outputs of the per-output min; one output gives a lower bound. OK.
- A3: unfold into a tree (depths unchanged), count per level, merge equal nodes (counts only drop). OK. State that Wv/Wf
  are maxima over trees with root depth <= D (equivalently = D: a tree of smaller root depth is a subtree of a depth-D tree
  with the same level numbers, so the maximum is monotone in D).
- A4: a sel needs a non-constant flag of depth >= cl, so value nodes of depth <= cl are inputs (or T); flag nodes of depth
  <= cl+1 compare inputs: constants. cmp(x,x), cmp(x,T), cmp(T,T) are constant over all order types, a sel on them is a
  copy. OK.
- A5: nodes in one layer are interchangeable (same candidate lists, parents re-pointed): sorting by one attribute
  (nondecreasing) is a sound symmetry break; it keeps the A3 counts. OK.
- A6: construction (tree unrolling, own copy per destroyed operand, cmp re-issued before each cmov); every produced program
  is judge-checked, so the upper bounds do not depend on A6's proof. OK.
Results 19:55 (min depth n=3: 4 U/E, 5 Z2; n=4: 5 U/E, 6 Z2) follow, given the DRAT checks.
