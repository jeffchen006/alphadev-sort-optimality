# Lemmas and rules used by the latency agent

Review status: part A SOUND (agents/theory/reviews/latency_RULES_A.md); parts B, C SOUND (agents/theory/reviews/latency_RULES_BC.md).

All in the T-relaxed model of shared/MODEL.md sec. 2 (scratch = T, cmp(T,T) = eq, flags = eq),
any subset of order types (L1b). Depth = critical path of MODEL_LATENCY.md sec. 1.

## A. Relaxed DAG (relax.py) — used for "min depth" lower bounds
- **A1 (relaxation).** A program P of I1 with depth d in model U, E or Z2 maps to an RD DAG with depth <= d
  (Z2: cmp nodes latency 2). Map: each cmp -> cmp node; each cmovcc D,S -> sel node with flag = node of the
  last cmp before it (or the constant eq flags), a = node of D, b = node of S, swapped for cmovle/cmovge,
  cmp operands swapped for cmovg; mov -> no node (the value node of S is reused).  A cmov before the first cmp
  reads constant eq flags: cmovl/g = no-op, cmovle/ge = copy of S; both are free copies in RD.
  Values are equal on every order type (induction on the program).  Depth: sel depth = 1 + max(children)
  <= cmov ready time; copies have depth <= mov ready time.
- **A2 (outputs independent).** RD has free sharing, so a DAG for all outputs exists iff one exists per output.
- **A3 (width bound).** If an RD DAG of depth <= D computes output j, then one exists where the number of value
  (flag) nodes of depth exactly l is <= Wv[l] (Wf[l]) = max number of such nodes in a tree with value root of
  depth D (relax.widths, recursion in its docstring); these are maxima over all trees with root depth <= D (monotone
  in D: a smaller tree is a subtree of a depth-D tree with the same levels; theory review). Proof: unfold the DAG of
  the output into a tree; count; merge equal nodes.
- **A4 (layer 1, 2).** Value nodes of depth <= cl copy an input (flags of depth < cl are the constant eq flags),
  so they are omitted; flag nodes of depth cl+1 compare depth-<=1 values = inputs, so they equal the constants
  cmp(x_i, x_k) (both orientations given).  cmp(x_i, x_i), cmp(x, T), cmp(T, T) are constant flags: a sel on a
  constant flag is a copy (omitted, copies are free).
- **A5 (symmetry).** Nodes of one layer have the same candidate lists: any permutation gives the same DAG, so we
  require nondecreasing index of the flag choice (value nodes) / first operand (flag nodes) inside a layer.
- **A6 (construction, upper bound).** An RD DAG without T maps to a strict I0 program with the same depth in U, E
  (and Z2 when searched with cl = 2): construct.py (tree unrolling, own copy for each destroyed operand,
  `mov t, Pi` has depth <= 1 <= any flags depth; cmp re-issued right before each cmov).  Checked by judge.
- Encoding test: test_relax.py (random RD trees as targets: always SAT).

## B. Register SAT (regsat.py, regcegis.py) and exhaustive search (src/dsearch.cpp) — length at depth <= D
- **B0** Every instruction of depth > D can be deleted (it feeds no output: every reader is deeper); so a shortest
  program of depth <= D has only instructions of depth <= D.
- **R0** no mov r,r / cmovcc r,r (no-ops).  **R1 / S1** scratch-name symmetry (first-use order / multiset).
- **R2** cmp A,B with index(A) < index(B): cmp B,A followed by cmovs = cmp A,B with l<->g, le<->ge (I1 and I0
  closed under this map). Also forbids cmp r,r (constant eq: each cmovle/ge -> mov, cmovl/g deleted, cmp deleted).
- **R3** no cmp right after cmp.  **R4** no cmov before the first cmp (cmovle/ge = mov, not deeper).
- **S2** mov writes a fresh register (renaming, R unbounded).  **S3** registers/flags of depth >= D are dropped as
  operands, AFTER the output check: dsearch.cpp captures outputs (capture()) before normalize() drops them, so a depth-D
  value is still capturable as an output (theory item 1, confirmed in the code).
- **S4** no cmp with constant flags on all order types.  **S5** no instruction that leaves its destination unchanged.
- **S7** mov right before its first use (move it down past instructions that do not touch the copy or the
  original; no flags change).  **S8** adjacent independent cmovs in lexicographic key order (not for the cmov right
  after a mov).
- **Normal form for S7 + S8 + R1 + R2 together** (theory review latency_RULES_BC.md): measure =
  (#misoriented cmps, - sum of mov positions [movs pushed down to their first use], lex order of the cmov sequence).
  R2 flips decrease the first, S7 moves the second, S8 swaps (never with the cmov right after a mov) the third and keep
  S7; renaming (R1) last. Every step keeps length and depth.
- Heuristic in dsearch: uncaptured outputs each need a new cmov; optional proven bounds #cmp >= 3/5/7
  (theory L7) and #cmov >= 6 (n=3, bounds R1) / Huff(n) (bounds B3).

## C. Joint size bound (relax_joint.py) — "length >= K+1 at depth <= D"
- **C1** map of A1, applied to all outputs at once; cmp B,A and cmp A,B are one flag node (sel tests lt or gt);
  distinct sel functions <= #cmov, distinct flag functions (up to orientation) <= #cmp.
- **C2** width: union of per-output trees (A3), per layer the sum of the per-output bounds.
- **C3** no pass-through sel(f,a,a) (roots and children may be taken from any lower layer).
- **C4** symmetry: in a layer, used nodes first, used nodes sorted by flag choice (value) / first operand (flag);
  unused nodes get fixed choices.
- Spot checks (test_joint.py): AlphaDev sort3, SI Sort3_17 (Z2), critic and latency k=11 programs all SAT at their
  own (depth, #cmp+#cmov).
