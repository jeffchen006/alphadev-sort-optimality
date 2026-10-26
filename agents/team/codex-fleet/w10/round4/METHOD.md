# Round 4: the three-column A15 gap

The earlier RESULTS.md was read before this round. The sort4 round-3 solver
has no final result. Its last saved progress line reports 1,485.49 CPU seconds.
Its saved log has not advanced. A process list in a separate isolated command
does not establish the older session's process state. No pending sort5 retry
record was present. These observations mean incomplete work, not UNSAT.

## Sort4 continuation

The new run uses the exact saved round-3 CNF. It changes no search constraint.
It omits proof output and has a 3,600-second wall limit. The solver also has
its own 3,600-second limit. A wall timeout remains UNKNOWN. The new record
includes child CPU use. The old incomplete run and proof are preserved.

The best verified sort4 upper bound in this worker's files is k=20, with five
comparisons. Fixed-flag sort4 k=19 classes returned UNSAT in round 2. The free
flag k=19 class remains open until the new solver returns a complete result.

## Meaning of three columns

A data column is one written register version across all encoded input orders.
The three-column limit counts written columns with at least one undefined
entry. It does not count register names. A register written twice can contribute
two columns. There is no fixed register cap. Fully undefined written columns
also count. This definition is conservative and explicit.

The `gap` mode permits at most three such columns. Every other written column
must be a full lattice function: one min/max expression in the inputs. A
partial column must contain both defined and undefined entries. At least one
partial column must be read by a later counted instruction. This isolates the
partial-column extension of the pure lattice model. [A15]

The `arbitrary` mode keeps the same three-column limit but permits fully
defined non-lattice columns. This is a larger search class. The `pure` mode
forbids every undefined entry and requires every written column to be lattice.
It is used as a positive control. The already completed pure-lattice k<=31
search is not repeated.

The common brief already excludes c<=8 when every comparison operand is a
lattice term. In gap mode, comparisons must read full columns and every full
column is lattice. Thus the new gap query starts at c=9. The arbitrary mode
can read full non-lattice values, so its c=8 query is outside that closed class.

## Exact counter

`src/partial_gap.py` extends the saved round-2 encoder. For data node g and
input order t, u(g,t) is equivalent to value(g,t) being undefined. A separate
literal h(g) is equivalent to the disjunction of these u(g,t) literals. Every
four-element subset of the h literals is forbidden. Thus at most three h
literals can be true. These are exact equivalences, not optional witnesses.

When h(g) is false, a guarded monotone Boolean truth table constrains the
column to one full lattice function. When h(g) is true, those lattice clauses
do not constrain that column. The encoder still applies the actual mov/cmov
semantics. It does not insert an arbitrary free column.

One witness literal selects a column that has an undefined entry, a defined
entry, and a later read. A counted read can be a source, a prior conditional
destination, or a comparison operand. The existing encoder forbids comparisons
of undefined values. Thus a globally partial column cannot actually be chosen
as a comparison operand.

## Sort5 queries

Three new target queries use k=31, c=9, 120 strict input orders, and at most
three undefined-containing written columns. They leave all 22 data instructions,
comparison operands, output snapshots, and data block sizes free.

1. `gap`, with the nine flag columns of `programs/exception_0_original.s`.
2. `gap`, with free flag columns and first comparison `cmp P0,P1`.
3. `arbitrary`, with the same fixed flag columns as query 1.

The free-flag query orders each comparison's value-node indices. Reversing a
comparison also reverses every conditional direction in its block; equality
inclusion does not change. It fixes unused mov condition selectors. It orders
the first references to P2, P3, and P4 in the selector stream used in round 3.
These inputs can be relabelled because the first pair is P0/P1. A lexicographically
least relabelling has the required first-reference order. Reorienting a
comparison cannot create an earlier violation: if both remaining inputs first
appear in that comparison, the lower renamed input appears first. The fixed
flag queries use none of these extra symmetry constraints because reversing
one of their comparisons would change a fixed flag column.

A fourth query uses c=8 and arbitrary full columns. It fixes the flag columns
of `programs/c8_guard_0_0.s` and leaves its 23 data instructions and block sizes
free. Its new positive control is that fixed k=32 program in arbitrary mode.
The gap mode must reject that same control because it has full non-lattice
columns. This checks that the larger class is reached when requested.

For m=22 data nodes, the number of possible nonempty partial-position sets is
C(22,1)+C(22,2)+C(22,3)=1,793. The number of weakly increasing data-block
assignments is C(30,8)=5,852,925. The formula covers these choices together.
The product is 10,494,294,525 combinations of these two choices. This is a
syntax-space count. It is not a count of feasible or correct programs.
For c=8, the corresponding counts are 2,047 nonempty position sets and
2,035,800 block distributions, giving 4,167,282,600 combinations.

If the fixed-flag free-block gap query reaches its limit, the runner tests the
eight other block vectors obtained by removing one instruction from an
original data block. It omits block 1: that case was already UNSAT in round 2
without the cap. These eight narrower queries retain free data instructions,
operands, outputs, and partial positions. They are new bounded scopes.

If a target formula returns UNSAT, its exhaustive satisfying-program count is
zero within the stated scope. If the run reaches a limit, that count is unknown.
The runner does not count a timeout as zero. It preserves a DRAT certificate
for every complete UNSAT result and tries the separate checker.

## Controls

The new formula fixes the k=32 original partial example and its normalized
pure lattice rewrite. Both must return SAT. Each decoded result is checked
against every saved CNF clause, then by the strict reference judge in both
models. Three negative controls check the new restrictions: the original
partial example with bound one, that example in pure mode, and a known example
with full non-lattice columns in gap mode. Each must return UNSAT.

The original partial control includes the partial column with no lattice
completion documented earlier in RESULTS.md. Its SAT result confirms that
the encoder does not require a partial column to have a lattice completion.
Only full columns receive the guarded lattice restriction in gap mode.

## Limits

The fixed flag queries are restricted to one flag history family. [A4]
All targets use only strict input orders. The partial witness must occur on
those orders. Programs partial only on tied inputs are outside that scope.
Comparisons of undefined scratch values are excluded. No data instruction occurs
before the first comparison. The free flag query fixes the first input pair. These statements
remain search limits even if every bounded formula is UNSAT. [A15]

An UNSAT formula can exclude its bounded class. It does not establish a general
same-length lattice rewrite. Only a strict judge PASS can validate a candidate.
No A15 counterexample has been established when this method file was written.

## Resources and records

All new files are inside w10. CPU jobs run serially at nice level 19. Solver
processes have a 2,400 MiB address-space limit. The runner and certificate
checker have a 2,800 MiB address-space limit. The main records are individual
JSON files, `campaign.log`, and `summary.json`. Each target records its exact
formula hash, variable count, clause count, solver result, and elapsed time.
