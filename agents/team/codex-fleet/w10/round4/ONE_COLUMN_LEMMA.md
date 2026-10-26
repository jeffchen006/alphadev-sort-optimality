# One-column rewrite lemma [A15]

## Purpose and terms

This lemma concerns the semantic gap between full lattice values and partially
defined scratch values. It is a restricted rewrite argument. It is not a
general A15 theorem and is not a solver result.

Fix a set of input weak orders. Include all 541 orders for the sort5 statement.
At each written register version, a **column** records its value on these orders.
An **undefined entry** means the value still comes from an initial scratch
register. It does not mean a particular large integer. A **full column** has
no undefined entries. A **lattice column** agrees with one min/max expression
in the original inputs on every order in the set.

The allowed instructions are mov, cmp, cmovl, cmovle, cmovg, and cmovge. Outputs
are free snapshots, as in the out model. Every comparison must read full
columns. All conditional writes follow a comparison. Thus the flag sequence
depends only on the inputs. These are explicit hypotheses.

## Statement

Suppose a correct program has at most one written column with an undefined
entry. Suppose every other written column is lattice. Then a program of the
same length has the same outputs and every written column is lattice.

The count concerns written register versions. Two writes to one register count
as two columns. The statement includes a completely undefined written column.

## Method

If no written column is undefined, no change is needed. Otherwise let I be
the instruction that creates the unique undefined-containing column C.
Before I, every written value is full. An unwritten scratch register is
completely undefined. Each input register or previously written register is
full and lattice. There are three cases.

1. I conditionally copies a full source S into an unwritten scratch destination.
   Replace I with `mov D,S`. The new column is the old full lattice source.
   It agrees with C at every originally defined entry.
2. I conditionally copies an unwritten scratch source into a full destination D.
   Replace I with `mov D,D`. The new column is the prior full lattice D column.
   It agrees with C at every originally defined entry.
3. I creates a completely undefined column. Replace I with `mov D,R`, where R
   currently holds any full lattice column. Such a register exists before I:
   all input registers start full, and every earlier write is full. If D was
   itself full before I, R can be D. There are no originally defined entries
   of C to preserve.

These cases are exhaustive. If both old destination and source are full, a
mov or cmov cannot create an undefined entry. Before I, no partially defined
source or destination exists. If both are unwritten scratch registers, the
result is completely undefined and case 3 applies. A mov from scratch also
falls under case 3.

Every replacement costs one instruction. It changes no flag.
Every comparison instruction remains in place. Thus the comparison count is
also unchanged.

## Preservation argument

After the replacement, compare the two executions on one fixed input order.
At every point, the new execution agrees with the original execution wherever
the original register entry is defined. This holds immediately after I by the
case construction. Use induction over the remaining instructions.

A comparison reads only originally defined entries. Its operands therefore
agree, and its new flags agree. A mov copies one source entry. A cmov selects
the same source or old destination in both executions because its flags agree.
If the original selected entry is defined, the induction hypothesis gives
the same value in the new execution. Thus the invariant is preserved.

Each required final output snapshot is originally defined. Its new value
therefore agrees. An earlier snapshot that is overwritten need not be preserved.
This argument applies independently to every input order and every allowed
initial scratch assignment.

By hypothesis, every written column other than C is full in the original
program. The invariant therefore preserves each of those columns completely.
Each remains the same lattice function. The replacement makes C lattice in
each of the three cases. Hence every written column is lattice, and the
instruction count is unchanged.

## Limits

The proof requires at most one undefined-containing written version. With two
or more such versions, the invariant still protects all original full columns,
but the newly filled intermediate columns need not be lattice. The recorded
two-column example in RESULTS.md has defined entries with no lattice completion.
That obstruction is why the proof cannot simply be repeated.

The proof also requires all comparisons to read defined values. It does not
cover programs whose comparison outcomes depend on initial scratch values.
For a statement on all weak orders, count columns and test lattice functions
on all weak orders. A strict-order count alone does not impose that hypothesis
on tied inputs.

Within these hypotheses, a counterexample to the same-length lattice rewrite
needs at least two undefined-containing written columns. This leaves the new
two-column and three-column SAT searches relevant. No unrestricted A15 claim
is established here.

## Extension: no direct dependency between columns with undefined entries

The same-length rewrite also applies to any number of undefined-containing
written columns if no such write directly reads another such column.
For a mov, count its source as a read. For a cmov, count both its source and
its old destination as reads. Comparisons must still read only full columns.
Every original full written column must still be lattice.

Replace the undefined-containing writes in execution order. Maintain two
invariants: every newly written column is full and lattice, and every original
defined entry agrees with the new execution. Original full writes stay
unchanged. They select originally defined entries because their results are
full. Their new values therefore agree at every order. Their lattice property
is preserved.

At an undefined-containing write, the no-dependency condition means every
read operand is either an original full column or an unwritten scratch value.
Apply the same three cases as above. A full operand is unchanged and lattice.
If the result is completely undefined, choose any current new full lattice
register as the replacement source. One exists: P0 starts full, and each new
write to P0 is full by the induction. This source need not have been full in
the original execution, because that original result has no defined entry
to preserve.

Each replacement makes its result full and lattice. It agrees at every
originally defined entry. Comparisons retain their input-dependent flags by
the same preservation induction. Every required final output remains unchanged. Each
replacement still costs one instruction.

Thus a counterexample within these hypotheses must contain a direct read from
one undefined-containing written version into another such written version.
The current SAT formulas do not impose this additional necessary condition.
Their saved three-column scopes remain unchanged.

## General removal of scratch garbage, without a lattice guarantee

There is a separate same-length construction when every comparison reads
defined values. It permits arbitrary dependencies between partial columns.
It preserves each original defined entry, including every original full
comparison operand. It does not require original full columns to be lattice.
It does not guarantee that new full columns are lattice.

Track which physical registers have had a write. Treat each input register as
already written. Process instructions in execution order. At each data write:

1. If its source register has never had a write, change that source to P0.
2. If it is a cmov and its destination register has never had a write, change
   that cmov to a mov with the adjusted source.
3. Mark the destination as written. Keep all other operands and instructions.

P0 in rule 1 means its current value in the new execution. It need not retain
its initial input. It is always full in the new execution: it starts full,
and the construction makes every written result full.

Proof of full results: an adjusted source is either P0 or an already written
register. Both are full by induction. A mov therefore writes a full value.
A retained cmov has an already written, full old destination and a full
source. Its result is full. A first conditional write becomes a mov, so its
unknown old destination cannot remain in the result. These cases cover every
data instruction.

Proof of preservation: before the first change, both executions agree. An
unwritten original source is undefined on every input order, so rule 1 cannot
change an originally defined selected entry. At a first conditional write,
the original false branch leaves its unwritten destination undefined. Rule 2
therefore also changes only entries with no required agreement. Every retained
data instruction selects the same source or old destination in both executions
because the comparison flags agree. When its original selected entry is
defined, the induction hypothesis gives agreement. Each comparison reads only
originally defined operands, so its operand values and its flags agree. Thus
the invariant holds for every later instruction. Each required final output
is originally defined and remains unchanged.

No instruction is added or removed. Each adjusted instruction remains in I1.
The construction preserves the comparison instructions, their operand value
columns, and their outcomes. It also preserves the comparison count and core
length. The result has no written column that depends on initial scratch
values.

This construction explains why eliminating scratch garbage is weaker than
A15. The second partial column of the original exception has defined entries
with no lattice completion. A construction that preserves all those entries
must turn that column into a full non-lattice column. Later output-preserving
changes may still make the whole program lattice, as in the known k=32
normalization. The general same-length lattice rewrite remains unresolved.
