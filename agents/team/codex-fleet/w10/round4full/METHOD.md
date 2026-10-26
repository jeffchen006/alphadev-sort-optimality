# Full-column relaxation of the A15 three-column gap

## Reduction

The general construction in `round4/ONE_COLUMN_LEMMA.md` removes scratch
garbage without adding instructions. It preserves every original defined
entry. Hence it preserves every original full column, every comparison operand
column, every comparison result, and every required final output.

Suppose the original program has at most three written columns with undefined
entries. Suppose every other written column is lattice and every comparison
reads full values. After the construction, at most those three written
versions can be non-lattice. Every originally full lattice column is unchanged.
Every comparison operand remains lattice. The transformed program has the
same core length and comparison count. It has no written value that depends
on initial scratch values.

Thus a fully defined program with at most three non-lattice written columns
is a relaxation of the requested three-partial-column class. The exceptional
columns cannot be used as comparison operands or final outputs. A full
non-lattice solution need not convert back to a partial solution; it is still
a valid main-target candidate if the strict judge accepts it.

## Sharper bound: q partial versions give at most q-1 non-lattice versions

If q is positive, first replace the earliest written column with an undefined
entry. All preceding written columns are full and lattice. The three cases
of the one-column argument therefore replace this first write by a mov whose
result is lattice. This step preserves every original defined entry. That
preservation induction does not require later columns to be full.

Now apply the general garbage-removal construction to the resulting program.
Its already full columns remain unchanged. In particular, the first replacement
stays lattice. Every original full lattice column also remains unchanged.
Only the other q-1 original columns with undefined entries can become full
non-lattice columns. The comparison operands, comparison results, required
outputs, instruction count, and comparison count all remain unchanged.

Thus q<=3 gives at most two full non-lattice written versions. For q=0 the
program is already full and lattice. No converse transformation is assumed.
The initial budget-three probes are still valid larger relaxations. The
subsequent budget-two probes use the sharper bound and cover every original
three-column program within the stated hypotheses.

## Encoder and normal forms

`src/full_gap.py` uses the same counted dataflow semantics as `partial_sat.py`.
All written entries must be defined. An exception selector guards each
column's lattice constraints. At most three selectors can be true. A selected
column can still be lattice. Thus the selectors give an upper bound, not an
assumption that every selected value is non-lattice. Every actual non-lattice
column must have its selector true. Comparisons and outputs cannot select a
tagged column. This is complete for the stated class: tag only actual
non-lattice columns.

Two full-program normal forms remove irrelevant scratch choices. A conditional
first write into unwritten scratch must take on every encoded order; otherwise
its result would be undefined. Replace it with a mov at the same cost. A cmov
from never-written scratch must never take; otherwise its result would be
undefined. Replace it with `mov D,D` at the same cost. A mov from never-written
scratch is impossible in a full program. The existing unbounded-register
normal form gives a fresh name to every mov destination and renames its later
uses. These changes preserve each produced value column and its classification.

No instruction occurs before the first comparison. The first input pair is
fixed only in the free-outcome target. Comparison orientation and input
permutation use the same symmetry rules as the earlier free-outcome formula.

## Queries

Three fixed k=32 controls test the new class. The first-access rewrite of the
original exception is SAT with bound three and UNSAT with bound zero. The
normalized pure lattice program is SAT with bound zero. Every SAT control is
checked against its saved clauses and by the strict judge in both models.

Two targets use n=5, k=31, c=9, 120 strict orders, free data block sizes,
unbounded registers, and a budget of three exceptional full columns. One fixes
the original exception's flag columns. One leaves flag outcomes free. Each
solver has a 600-second limit. An UNSAT result has count zero for its formula.
A limit gives UNKNOWN. A separate checker attempts every UNSAT certificate.

After those targets finish, `src/full_two_run.py` runs the same two flag scopes
with exception budget two and the same 600-second limits. It uses the already
validated encoder without changing its instruction semantics or normal forms.

## Resources and limits

Run `src/full_run.py` only after the earlier queue and its final audit finish.
It runs one CPU job at a time at inherited nice level 19. Each solver has an
address-space cap of 2,400 MiB. The runner and checker have 2,800 MiB caps.
All new files remain in this worker folder.

Fixed flags cover one comparison-outcome family. The free target covers only
c=9 and its declared first-comparison normal form. Comparisons of undefined
values are excluded from the reduction. Strict-order formulas do not validate
a positive sorting candidate on ties; only a strict judge PASS counts.
Neither a limited solver run nor the reduction settles general A15.
