# C1: remove garbage reads without increasing core length

Status: proof submitted for review. The finite checks are reported in RESULTS.md.
This file does not record judge acceptance or a sort5 lower bound.

## Purpose

Remove comparisons that read initial scratch values. Keep the core length at
most k. Account for the class root when both the root and its copies remain
live. The construction uses the free output snapshots of M_out.

## Terms

A **logical register** is a register of the original program. A **physical
register** is a register used by the new program. Several logical registers
can use one physical register while their values agree.

An **alias class** is a set of logical registers that share one current value.
A **defined class** has a physical register that holds its value. This value
is a function of the original input values. An **unbound class** holds one
remaining free initial scratch variable. It has no physical register.

A **specialization** restricts initial scratch values or initial flags to
one allowed choice. The choice can depend on the input vector. A program
correct for every initial scratch assignment is correct under this choice.

For a partition into alias classes, define

    Phi = sum over nonempty classes A of (|A| - 1).

All classes count, including unbound classes and class roots. E denotes the
number of emitted core instructions. t denotes the number of original core
instructions processed. Free output snapshots do not enter E or t.

## Statement

Let P be a finite straight-line program in M_out(n,I1), with unbounded
registers and core length k. Suppose P computes an input-only total function
F for every input vector, every initial scratch assignment, and every allowed
initial flag assignment. Then there is a program Q with these properties:

1. Q computes F.
2. Q has core length at most k.
3. Every value read by Q is defined. In particular, no cmp reads garbage.
4. Every written value in Q is defined. Unused initial scratch registers need
   no initialization.
5. Q uses no instruction outside I1. Its comparison count does not exceed
   the original comparison count.

The statement covers ties and signed int32 values. It does not assume a
sorting network, a fixed comparison count, or independent garbage choices at
successive comparisons. The proof uses one consistent initial assignment.

## Method

First discard every out that is overwritten by a later out for the same
output index. Keep each last out at its original position. Where an output
has no explicit out, add a free snapshot of its default P register at the end.

Choose initial flags equal. Before the first retained cmp, treat flags as a
known equality result. In this **constant flag mode**, cmovl and cmovg do
nothing. cmovle and cmovge are unconditional copies. These changes cost no
instructions. A retained cmp ends constant flag mode. A removed cmp below
starts constant flag mode again.

Initially, each input logical register is a singleton defined class. Its
physical register is the corresponding P register. Each scratch logical
register is a singleton unbound class. Thus E = Phi = t = 0.

Process instructions in order. The partition and all compiler decisions
depend on the program text. They do not depend on the run-time input values.

### Unconditional copy

For mov D,S, remove D from its old class and put it in S's class. Emit no
instruction. If D and S already share a class, do nothing. A class with no
members can be discarded. This rule also handles a true cmov in constant
flag mode. A false cmov in that mode does nothing.

### Conditional copy with defined operands

Outside constant flag mode, suppose D and S are defined.

If they share a class, emit nothing. Both choices give the same value.

If they have different classes and D's class is a singleton, emit the cmov
on its physical register and S's physical register. Give D a new singleton
class with that result.

If they have different classes and D's class has at least two members,
emit mov T,R followed by the cmov on T. R is the old physical representative
of D's class. T is fresh. Remove D from its old class and give D a new
singleton class represented by T. The other members keep R.

### Conditional copy with an unbound operand

Outside constant flag mode, suppose at least one operand class is unbound.

If both operands already share a class, emit nothing. Otherwise identify
their two class values. When one class is defined, set the free initial
scratch variable of the other class equal to that current defined value.
When both classes are unbound, set their free initial variables equal.
Merge the two classes. Emit nothing.

After this specialization, the old destination and source values agree.
Thus the original conditional copy changes no value, for every flag result.
This argument does not require a particular result of the preceding cmp.

### Comparison with defined operands

Emit cmp on the two physical representatives. End constant flag mode.

### Comparison with an unbound operand

If the operands have different classes, identify their values and merge
their classes as above. If they already share a class, no merge is needed.
The original comparison now has equal operands. Emit nothing. Start
constant flag mode with equality.

### Output

For each required snapshot, emit out on the defined physical representative.
The next proof shows that a required snapshot cannot remain unbound.

## Proof of semantics

Maintain a symbolic restricted execution of the original program. Its still
free initial scratch variables are independent. Every current logical value
is either a defined class value or one such free variable. No defined class
value depends on a still free variable. Every required earlier snapshot has
its represented value. In constant flag mode the logical flags equal eq;
otherwise the emitted physical flags equal the logical flags.

The invariant holds initially. Initial equality flags are one permitted
choice. Inputs are defined. Scratch variables are independent and free.

A coalesced unconditional copy changes only the logical partition. It
preserves the selected value. A retained defined cmov reads the represented
old destination and source. Its emitted flags agree with the logical flags.
A fresh copy before that cmov preserves the other class members. These
operations therefore preserve the invariant.

When an unbound class is identified with a defined class, its variable was
still free. Its chosen defined value depends only on inputs. The choice
therefore gives an allowed initial scratch assignment for every input.
When two unbound classes are identified, their initial variables are simply
restricted to equal values. No earlier constraint prevents that equality.
All prior operations on those still free values were copies or identities;
any comparison or effective conditional selection involving them would
already have bound or merged them by the construction.

These restrictions are global substitutions of initial variables. They are
not new garbage choices made at separate comparisons. Every live copy of
a still free initial scratch variable belongs to one unbound class. Every
later use receives the same substituted value.

After a conditional-copy merge, its two possible selected values agree.
The skipped instruction is therefore an identity under the restriction.
After a comparison merge, the operands agree. Its result is eq. Replacing
its following conditional instructions by their equality actions, until the
next comparison, therefore preserves the restricted execution. Every
retained comparison reads defined values. Its result is emitted exactly.

At each step, the restricted original program still computes F for all
remaining free variables. This follows from the original universal
correctness hypothesis. Consider a required snapshot that was unbound.
Vary its free variable while keeping the input fixed. Its output value
changes. F does not change. This contradicts that correctness hypothesis.
Thus no required snapshot is unbound.

Consequently all required outputs have defined representatives. The emitted
program computes F. Its emitted mov and cmov instructions read only defined
representatives. A fresh scratch register is first written by mov. Thus its
initial contents and the initial flags cannot affect the emitted outputs.

All substituted values stay within int32: each defined value is obtained by
copying an original input value. Equalities, comparisons, and conditional
copies have the specified signed semantics, including ties. No order or
spacing assumption on initial garbage was used.

## Proof of cost

Maintain the prefix invariant

    E + Phi <= t.

The following table gives every transition. A core instruction increments
t by one. A free snapshot changes neither E nor Phi.

| Original action | Emitted core cost | Change in Phi |
|---|---:|---:|
| Copy to another class; old destination was singleton | 0 | +1 |
| Copy to another class; old destination was not singleton | 0 | 0 |
| Identity copy or false constant-mode cmov | 0 | 0 |
| Merge two distinct classes at an unbound read | 0 | +1 |
| Unbound read within one class | 0 | 0 |
| Defined cmp | 1 | 0 |
| Defined cmov with singleton destination class | 1 | 0 |
| Defined cmov that splits a larger destination class | 2 | -1 |

Every row has emitted cost plus change in Phi at most one. The invariant
therefore holds by induction. Since Phi is nonnegative, the final E is at
most k. No prologue initialization or final register reconstruction is
required. Outputs refer directly to their representatives.

There is at most one fresh physical register per class-splitting cmov.
There are at most k such events. Thus n+k physical registers suffice.

## The class-root case

Suppose m unbound logical registers share an initial value because m-1
garbage copies were removed. Their class contributes m-1 to Phi. This
alone does not pay for m initializations. In particular, it does not pay
for one initialization of the root plus m-1 copies. That argument would
have a missing instruction.

The construction does not initialize this class at that stage. When a later
read first identifies it with a defined class, the read itself is removed.
That operation merges two classes and adds one to Phi. A defined physical
representative already exists. No initialization is emitted. Thus the
m unknown members plus the defined anchor have m available saved
instructions. Any member, including the original root or the anchor, can
be the first member split off. At most m splits are possible before the
last member remains. Each split costs one extra mov. The bound covers all
m extra moves. A later read-only use of the root needs no move at all.

For example, keep the root S0, its copy S1, and the defined anchor P0 live:

```
mov S1, S0
cmp S0, P0
cmp P1, P2
cmovg S0, P1
cmovg S1, P2
out 0, S0
out 1, S1
out 2, P0
```

The first copy merges two unbound registers. The second instruction binds
their shared initial value to P0. Both instructions are removed. Phi is
now 2. The next comparison is retained. Each later cmov splits one member
and needs one mov. The result is

```
cmp P1, P2
mov S0, P0
cmovg S0, P1
mov S1, P0
cmovg S1, P2
out 0, S0
out 1, S1
out 2, P0
```

Both versions have k=5. The example checks specialization and cost. Its
original outputs depend on garbage, so it is not a sorting candidate.

## Computer checks

`src/normalize_c1.py` implements the construction. It asserts the prefix
cost inequality after every original core instruction. Its separate
concrete interpreter reconstructs one consistent initial garbage assignment
and compares every final logical register with the represented result.
It does not import the reference judge.

`src/check_c1.py` enumerates every length-three program with two inputs and
two scratch registers. There are 96 allowed instructions and 96^3 = 884736
programs. It checks the three weak input orders for each program. Four
disjoint shards divide the first instruction. All 884736 programs and
2654208 specialization checks finished successfully. No emitted program
exceeded its original core length. This is a finite construction check,
not an UNSAT result for sort5. RESULTS.md gives the shard records.

The targeted root check uses all 125 triples over
{INT_MIN, -1, 0, 1, INT_MAX}. A separate deterministic random check covers
length-31 programs: 10000 programs and 50000 concrete checks, all successful.
These checks support the implementation. They do not replace the proof or
judge review.

`src/check_c1_roots.py` also checks every split order for classes with one
through five unbound members plus a defined anchor. The root, every copy,
and the anchor each receive a later conditional write. Each order is tested
with each of the four cmov conditions, applied uniformly, and all 75 weak
orders of four inputs. All 3488 programs and 261600 input-order checks
passed. Each program emits exactly its original length. Each family uses
exactly m extra moves, including orders in which the root is split last.
The record is `analysis/c1_root_families.json`.

Two sorting controls also passed the reference strict judge before and
after normalization, in both out and memory models: eight PASS records.
The sort2 control has k=9 before and after. It keeps the root and copied
register live through later conditional reads. The sort5 control has k=33
before and after. The files and exact judge output are in RESULTS.md and
`logs/c1_judge_controls.log`. These are controls, not shorter sort5 results.

## Limits and the C2 handoff

This theorem proves no-cost removal of garbage comparisons in M_out. It
does not preserve comparison operand values, comparison count, or each
intermediate column. It can also remove mov instructions and insert mov
instructions later. The free output model is essential to the stated cost
proof. The normal memory translation adds n loads and n stores.

The theorem does not bound the number of non-lattice written columns in Q.
It does not show that non-lattice columns avoid comparison operands.
Both C2 variants permit at most two exceptional written columns. V1 also
requires lattice comparison operands. V2 permits the exceptional columns
as comparison operands. Thus either C2 handoff needs a column-count argument.
The clause '(so (a2) reduces to (a1))' in DIRECTION_A.md is not established
by garbage removal alone. Do not mark the full Direction A scope closed
from this lemma without that scope check and judge acceptance.

`COLUMN_BOUND.md` gives a checked control where this compiler creates three
full non-lattice written versions from two partial and one original full
non-lattice version. Every original instruction is live under ordinary
data/flag liveness. Original k=40 and normalized k=39. Both programs passed
the strict judge in both models. This control exceeds the target length.
It shows that the current construction alone does not supply the missing
column bound. A different semantic rewrite can simplify the control.

No UNSAT result or certificate is claimed in this file. No k<=31 sort5
candidate is claimed.
