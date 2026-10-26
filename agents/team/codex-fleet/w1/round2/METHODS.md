# Purpose

Extend round 1 to six, seven, and eight comparisons. Search partial comparator
outputs and reuse of earlier values. Keep all writes in this worker folder.

# Terms

A **value column** lists one register value on each input order. A **stage**
produces two value columns. A **comparison block** starts with a comparison and
contains every stage before the next comparison. A **copy** is a register `mov`.
A **history class** contains input orders with the same comparison results.

# Method

The 14,904 diagrams in `../networks.txt` are the round 1 term-pair sequences
with their first input pair fixed. This round does not repeat their original
nine-comparison allocation search. It uses their dataflow diagrams as templates.
Each old output gets a new register value, even when the value is not a min/max
function. All older values remain available in the semantic search. Allocation
later decides which copies must remain live.

`omit.cpp` removes enough comparison instructions to leave seven or eight.
A stage with a comparison produces the minimum and maximum of its actual
operand columns. A stage without a comparison uses the current flags. Each
output independently selects one of these four columns:

- Its first operand.
- Its second operand.
- Its first operand when the previous comparison was greater, otherwise its second.
- Its second operand when the previous comparison was greater, otherwise its first.

Thus a stage may produce one full comparator output, two outputs, two copies,
or two different flag-dependent values. If no earlier comparison exists,
only unconditional selections are available.

`extend.cpp` expands the choices at a stage without a comparison. Mode 1 permits
one unrestricted output and one local output. An unrestricted output is
`flag ? S : D`, where `S,D` can be any earlier column. Mode 2 permits both outputs
to be unrestricted. Semantic duplicate columns are merged. The selected flags
come from the last comparison, as required by the instruction model.

The search uses all 120 distinct-value input orders. It stores values in three
bit planes. At each comparison it refines the history classes. If `r` comparisons
remain, it rejects a class with more than `2**r` input orders. Within a history
class, every register holds one fixed input identity. A comparison of different
identities has two possible results on distinct inputs. A comparison of the same
identity has one result. Thus each comparison can at most double the number of
classes. Sorting all five outputs requires distinct histories for all 120 input
orders, even when output snapshots occur early. This also excludes six comparisons
because `2**6 < 120`. The class bound is a necessary condition, not a sorting test.
Every surviving leaf is checked for all five sorted output columns among all
values produced so far. This permits early free `out` instructions.

For all functional eight-comparison plans, `prepare.py` separately simulates all
541 weak orders. It computes exact comparison-structure identifiers using full
strings. It checks all 120 input renamings, value reversal, and independent
comparison operand reversal. It compares these identifiers with the 18 immutable
w6 representatives. It uses no probabilistic fingerprints.

`route.cpp` allocates a fixed sequence of comparison blocks. Every conditional
move produces one specified full column. The destination and source may be any
currently held column. The instruction can use any of the four I1 conditions.
The rule tables check the destination on condition-false cases and the source
on condition-true cases. A write can overwrite an existing copy or first copy
its destination to a fresh register. A state is a multiset of value columns,
encoded with four-bit multiplicities. Equal multisets at one boundary retain
only their smallest cost. A missing future comparison operand must be kept if
no intervening specified output recreates it. The search considers every
permutation of the specified outputs in one comparison block. It can omit an
output instruction if its full value already exists.

The copy normalization from round 1 applies: a copy can be delayed until the
first overwrite of one of its equal copies. The delayed copy can use a fresh
register. A redundant creation of an already existing full column can instead
be a `mov` at the same cost. These rules do not bound the register count except
through the instruction budget.

The 198 local functional plans contain 23 distinct columns each. Consequently,
each of their eighteen non-input columns needs one conditional move in this
allocation family. The target `k=31` allows five copies: `8+18+5=31`.
The `PERMS` build checks allocation on only the 120 distinct orders. A negative
result on this subset also excludes tie-dependent alternatives with the same
strict-order columns. `crossroute.py` is an independent tuple-state allocation
check. It uses threshold sets to construct condition rules.

`audit.py` independently parses and executes a generated witness. It checks all
541 weak orders and four initial flag states. It rejects every uninitialized
scratch read. It emits the memory form with five loads and five stores. The
shared strict judge remains the authority for a retained valid program.

# Limits

This is a finite template family. It does not cover arbitrary programs with
six to eight comparisons. A fixed-column allocation result also excludes only
programs whose intermediate values stay in that specified column set. It does
not exclude additional temporary selection values or new comparison operands.
The semantic stage search uses the greater-than result and its complement.
For seven-comparison plans, comparisons of copied identities can tie even on
distinct input values. The stage search does not independently vary the other
I1 conditions in those cases. The strict-order semantic search can merge plans
with different tie behavior.
The 120-order allocation exclusion covers those variants only when their
strict-order columns match a routed plan. No formal certificate is provided.

## One additional conditional move

`extra.cpp` extends each of the 33 fixed comparison structures with one new
full selected value. It chooses one representative per exact structure class.
For each comparison block, it builds all distinct `gt ? S : D` columns from
inputs and specified target columns produced by that block or an earlier block.
It omits columns already in the original 23-column set. It adds the new column
as a nineteenth target in that block. Allocation searches every target order
and permits arbitrary source and destination reuse, including use of the new
column by later conditional moves. On distinct inputs, the comparison operands
in these base structures never tie. Ordered source/destination pairs therefore
cover all four I1 conditions for creation of the new value.

This extension searches 19 conditional moves and at most four copies at `k=31`.
It retains the original comparison operand columns and eighteen target columns.
It does not change the comparison structures. The driver uses 120 distinct
orders as a relaxation. The final allocator also uses this valid bound: if
all target columns are distinct and absent initially, each remaining target
needs its own conditional move. Its cost bound reserves those instructions
before it expands a register state. The earlier unpruned allocation logs are
retained for comparison. An initial unpruned extra-value run was stopped before
it completed a class. The complete run uses this stronger bound.
