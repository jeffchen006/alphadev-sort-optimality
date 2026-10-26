# Round 6 search models

The target is a strict-judge PASS with core k <= 31. None of the circuit checks
below is an assembly correctness result.

## Retained model

The first query repeats the open nine-selector class-21 model from round 5.
It uses Kissat with a 1,200-second limit and retains its CNF and DRAT files.
Copies and selector predicates are free. Every historical column is available.
The prefix and common-high scratch assignment remain fixed.

## Output selectors at the end

A rank column maps every strict input permutation to one rank, 0 through 4.
The selector model computes five constant rank columns as its outputs. The
prefix does not read P4. Thus no prefix column is a complete sort5 output.
Each output must be a different selector node.

For a fixed test, follow the selected input of each selector backwards from an
output. This trace ends at one initial value. If the output rank is j, its
trace cannot pass through a different constant output rank k. Acyclicity also
prevents the trace from passing through its own output node again.

Replace every outgoing edge of every output node by one initial node. Keep
all selector predicates fixed. No original output trace uses a replaced edge.
Every output remains correct. Output nodes now have no outgoing edges. They
can move to the last five positions, in rank order. This transformation uses
free predicates and free copies. It does not claim a corresponding assembly
instruction reordering.

The `--sink-outputs` model adds this ordering. The saved positive circuit and
an augmented circuit test the transformation on all 120 strict permutations.
The finite checks do not establish the general statement. The trace argument
above is the reduction argument. DRAT checks validate only the resulting CNF.

## Data-instruction relaxation

`data_bound.py` counts each mov and cmov. It omits comparisons. Each cmov has
an independent predicate for each test. A mov creates a new register. A cmov
consumes its default value node, except when its default is the persistent
common-high scratch node. Sources and comparison values have no term-pool
restriction. Historical nodes may supply free output snapshots.

The model includes unlimited new scratch registers on one permitted assignment:
every initial scratch register has one common value above the inputs. A cmov
using that default can write a fresh register without a mov. Thus an UNSAT
result does not need an assumption that all scratch reads can be eliminated.

All preserved-input prefix classes need at least four new comparisons by the
previous finite initial-state check. A completion with at most 17 instructions
therefore has at most 13 data instructions. An UNSAT result at 13 data
instructions would exclude that fixed prefix at k <= 31. A SAT circuit is only
a witness for this relaxation. Its free predicates may require many actual
comparisons.

## Physical assembly searches

The longer retries use all 120 strict permutations, a free suffix schedule,
unbounded new registers, common-high scratch, history equalities, and value
preservation. Each retry has a 1,200-second Kissat limit. Its selector lower
bound is 9 for a class with a checked transfer witness, and 8 otherwise.

The seven-comparison family uses a prefix with three comparisons and a suffix
with four comparisons. Data-value recomputation is allowed. No fixed value
skeleton or network term pool is imposed on the suffix.

The repeated-comparison family uses such a prefix and five new comparisons.
At least one suffix comparison must reproduce an earlier comparison's complete
flag column on the strict permutations, up to one global permutation of the
less/equal/greater states. The optional sign mode permits only reversal. This condition includes
exact comparison recomputation. It also permits different operand values with
the same flags. The family has eight actual comparisons. It has at most seven
comparison functions up to state relabelling on the strict inputs. The actual
instruction semantics and the final strict judge handle ties. The state-match
condition applies only to strict test rows.

All decoded assembly candidates receive the reference judge with `--strict`.
A target out-model PASS also receives memory conversion and the strict memory
judge. Limited searches remain unknown.

## Limits and assumptions

Searches use one CPU job, nice level 19, and CPU 72. Python address space is
limited to 2,900 MiB. The local wrapper limits each solver and proof checker to
2,400 MiB to leave memory for its Python parent.

The models use G1-G4. A fixed prefix is a local restriction related to A11.
They impose no A4 fixed suffix value skeleton, A8 network term pool, or A2/A7
physical register cap. The common-high assignment is a relaxation, so these
models do not require A15 scratch elimination. No assumption is reported as
challenged without a contradictory verified result.

The completed ten-selector UNSAT certificate raises the transferred gate bound
to eleven for sixteen classes. The data13 query started before this new bound
was available. It retains its original minimum of nine selectors. Its broader
scope is valid. The later physical queries use the new eleven-selector bound.
An eleven-selector follow-up will test whether the bound can increase again.

## No reads from recorded outputs in the data relaxation

The data relaxation can remove outgoing edges of its five selected output
nodes without moving the outputs. Use the same fixed-test rank trace as above.
No selected trace to a different output rank uses such an edge.

Replace an outgoing source read by the persistent high scratch node. Replace an
outgoing cmov default by a fresh high scratch register. The second replacement
has no mov cost in this relaxation. It can increase physical register use, but
registers are unbounded. A self-cmov that results from these replacements can
become a same-cost mov. No final output trace changes. Keeping each output at
its original position avoids the source-lifetime problem with moving physical
output instructions to the end.

The `--no-output-reads` query adds these restrictions. This argument relies on
free selector predicates and fresh high scratch defaults. It is not an assembly
reordering rule. The unchanged data13 query remains a separate recorded run.

## Capacity of a comparison history

The physical queries also use `--capacity`. If r comparisons remain, a current
history can contain at most 2^r strict input orders. Within one history, each
register has one input origin, or the fixed high scratch origin. A comparison
between two such origins has at most two possible outcomes in that history.
If the origins are equal, equality is constant. Thus r comparisons cannot
separate more than 2^r orders. The code adds an at-most count for the history
peers of each test after every suffix comparison. This is a necessary
condition. It adds no fixed comparison-value skeleton or term-pool restriction.

The history encoding also counts comparison results that control a cmov before
the next comparison replaces the flags. A comparison with no such cmov has no
effect on any later data value. Remove every such comparison. The remaining
comparisons must still distinguish the largest initial history group. Thus at
least ceil(log2(group size)) suffix comparison phases must contain a cmov.
For the full strict test set in these classes, this minimum is four. This rule
does not require a fixed number of cmovs in any individual phase.

## Comparison operands outside the completed lattice exclusion

The user supplied this completed exclusion: no c<=8 sorting program can have
only min/max terms as comparison operands. Later queries with at most eight
total comparisons use this fact. The new condition is optional through
`--cmp-escape` or `--no-cmp-escape`. It applies only when the test set contains
all 120 strict permutations. It does not impose a value pool.

A conservative column always holds one input value. For a threshold q, its bit
is true when the column's rank is at least q. A min/max term gives one fixed
bit for each subset of input origins above q. Conversely, consistent bits give
a monotone Boolean function: each permutation gives a maximal chain of these
subsets. The function defines a min/max term. A threshold disagreement on one
subset therefore witnesses a column outside this family. A scratch value is
also an allowed witness.

The code checks the fixed prefix first. If a prefix comparison already has
such a witness, it adds no suffix constraint. Otherwise at least one suffix
comparison operand must have a witness. The encoder supports input-origin bits
and numeric-rank bits. Its controls check 500 generated min/max columns,
conservative non-lattice columns, scratch columns, and the comparison columns
of the previously verified seven-comparison reference. These are property
controls; they do not create an assembly candidate.

This condition relies on the existing c<=8 lattice-comparison exclusion (E7,
A12 scope), supplied in the task. A later UNSAT result using the condition is
not a new independent result for that previously excluded region. Scratch
witnesses remain allowed, so it adds no scratch-elimination assumption (A15).

## Recovery through equality

The later repeat queries use all six permutations of the three comparison
states. The earlier sign-only model allowed two permutations. This extension
includes comparing max(a,b) with a: on distinct a and b, the new states equal
and greater recover the old greater and less decisions. A sign reversal alone
cannot express that relation. The control inserts this comparison after a
min/max update in the known control program. The following comparison replaces
its flags, so the complete control keeps its verified sorting behavior. The
encoder must accept the relabelled flag column, and the strict judge checks
the decoded assembly control. This control runs before the new repeat family.

## Separate graph order and execution order

`physical_dag.py` counts selectors plus copies. Each selector has a free
predicate on each strict test. A graph node uses two earlier graph nodes.
The five outputs are graph sinks and have the last five graph labels. Their
physical execution order is independent. The order variables form a total
order: two clauses for each triple forbid both directed three-cycles. A
computed parent must execute before its user.

Each selector chooses one storage action: copy its default, consume its lower
parent, or consume its upper parent. Consuming the upper parent complements
the free predicate. If a selector consumes a node, every other user of that
node must execute first. A copy costs one additional mov. The all-high scratch
node can supply unlimited fresh defaults. All initial register names remain;
initial duplicate columns are not merged in this physical model.

This model contains every mov/cmov data program after the following reductions.
Fold each mov into an alias of its source graph node. For a graph node, a
conditional overwrite before another user needs a distinct alias. Charge one
copy to each such overwrite. If the last user overwrites the node, it can use
the original register without a copy. Otherwise all overwrites need a copy.
The original aliases provide at least this many copies. Rename the storage
registers and place each charged copy immediately before its overwrite. The
source and default dependencies and the destruction order then hold.

The output-rank trace argument removes outgoing output edges. Replace such a
source edge by the sentinel; replace such a default edge by fresh sentinel
scratch. This step does not add a copy. It preserves each selected final
output trace. Graph labels can then place outputs last, while execution-order
variables keep early output snapshots before source destruction. This step
uses free predicates; it is not a proposed assembly reordering.

The checked eleven-selector bound leaves two cases for at most twelve data
instructions: twelve selectors with no copy, or eleven selectors with at most
one copy. Fewer effective selectors conflict with the separate checked bound.
The two new queries test these cases. A timeout remains unknown. A positive
data graph remains a relaxation witness until actual comparison instructions
and the strict reference judge accept a complete program.

Controls fix the known twelve-selector/four-copy data graph, the thirteen-
selector/no-copy graph, and the fourteen-selector/three-copy scratch graph.
The independent checker simulates the chosen execution order, live nodes,
charged mov instructions, selector predicates, and all output columns. A
negative property control forces two users to consume the same non-sentinel
node; its ordering constraints must conflict. These controls test the encoder.
They do not by themselves establish a new assembly result or a general bound.
