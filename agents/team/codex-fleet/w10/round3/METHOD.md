# Round 3: A15, free comparison outcomes

The target query is sort4, k=19, c=5, with a required partial scratch value.
It encodes all 24 strict input orders. It leaves every comparison outcome,
comparison operand, data block size, and data instruction free. It retains the
round-2 ban on comparisons of undefined scratch values. [A15]

`src/partial_sym.py` extends `src/partial_sat.py`. The latter remains unchanged.
The runner uses one CPU job at a time, at nice level 19. Each child inherits a
virtual-memory limit below 3 GB. The sort4 solver has a 3,600-second limit.
The pending sort5 certificate checker has a 1,800-second limit. The checker
retry writes into `round3/`; it preserves the old timeout record in `round2/`.

## Symmetry constraints

1. Scratch names are absent. Each data instruction creates the next numbered
   value node. A conditional write consumes its previous destination node.
   This is the existing creation-order representation. It has no register cap.
2. The first comparison is `cmp P0,P1`, as in the previous free-flag query.
   Every comparison orders its operand node numbers from low to high. To
   reverse an existing comparison, exchange its operands and reverse every
   conditional direction in its data block. Equality inclusion stays unchanged.
3. After fixing the first pair, P2 and P3 can still be exchanged. A fixed
   selector stream visits each data destination and source, then comparison
   operands, then outputs. The first reference to P2 or P3 must select P2.
   This stream is a syntax order. It need not be the execution order.
   Reorienting a P2/P3 comparison after exchange cannot break this rule: if
   that comparison is the first relevant selector pair, it already selects
   P2 first after orientation.
4. A mov has canonical condition selectors. Those selectors have no effect.

Comparison orientation is canonical. The chronological order of comparison
blocks remains free. This method does not claim a canonical representative
for every possible permutation of independent comparison blocks.

## History constraints

A flag history is the sequence of comparison results on one input order.
The encoder tracks whether two input orders have equal histories through
each comparison. A register's **origin identity** is the input cell that
supplied its value. An undefined scratch value has a separate marker.

For equal histories, each data instruction must produce equal origin
identities. The block selector determines the relevant history length.
This follows by induction over execution: initial origin identities agree;
equal histories select the same conditional branches; mov and cmov only copy
origins. The undefined marker is conservative because scratch comparisons
are forbidden and undefined outputs are forbidden.

Two distinct strict input orders must have different final histories.
Otherwise every output snapshot would have the same origin identity on both
orders. Different permutations require different sorted origin sequences.

A history class after j comparisons contains at most 2**(c-j) strict orders.
Here j counts completed comparisons, starting at 1. Within an equal history,
the next comparison selects the same two defined origin identities on every
order. If those identities match, every result is equal. Otherwise, strict
inputs permit only less or greater. Thus each remaining comparison has at
most two successors. The distinct-final-history condition gives the bound.
Sequential unary counters encode these class-size limits.

These are consequences of the bounded program semantics. They do not fix a
lattice term pool, a comparison flag vector, or a data block size. [A4, A15]

## Controls and records

The runner canonicalizes the known k=20 partial and lattice controls. It fixes
each program in the strengthened formula. Both must return SAT. It then
checks every clause of the saved assignment and calls the strict reference
judge in both models on each decoded control.

The new controls passed both strict checks. The partial control has two
partial written columns and one full non-lattice column on all 75 weak
orders. The lattice control has 15 full lattice written columns.

The target query has 19,156 variables and 293,114 clauses. Its formula hash is
`dd810dfdc370f835aa214b0c132dd28bfa46923e37d39a5d89e1cf5648b2b54d`.
The added symmetry constraints contribute 835 clauses. History constraints
contribute 14,016 variables and 151,812 clauses.

The run records contain exact solver results. A time limit means UNKNOWN.
An UNSAT certificate describes the saved bounded formula. It does not prove
the general same-length lattice rewrite claim or exclude all sort5 k=31
programs. A partial requirement on strict orders excludes programs whose
partial entries occur only on ties. [A15]
