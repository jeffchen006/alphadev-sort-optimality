# Purpose

Test copy removal in the 143 new eight-comparison, 32-instruction programs in
`../w6/round2/verified`. This work does not repeat the round 1 network search,
the round 2 omitted-comparator search, or the earlier fixed-operand `dagx` runs.

# Terms

A **value column** contains one register value for each of the 541 weak input
orders. A weak input order permits equal inputs. A **case mask** selects some
of these orders. A column agrees with a required value on a mask when all
selected entries agree. The value 7 denotes unknown scratch data in the search.
It is not an available numeric constant in an emitted program.

A **write event** is a position occupied by `mov` or a conditional move in the
base program. A **comparison event** is a base `cmp` position. Every base has
24 write events and eight comparison events. The search can skip a write event.
It keeps the order of comparison events. A retained write event can use `mov`
or any of the four permitted conditional moves, with any source and destination.

# Method

`analyze.py` simulates every base on all 541 weak orders. Each write receives a
new value identifier. The script then works backward from the five outputs.
For a conditional move with required result mask M and taken-condition mask T,
it propagates `M & T` to the source and `M & ~T` to the old destination.
It requires the condition only where the result is needed and the original two
alternatives differ. For a mov, it propagates M to the source.

The script checks that no required value entry is unknown. It records the
required masks at each event boundary. Comparison operands do not become exact
value requirements merely because the original comparison reads them.

`reuse.cpp` searches forward. A state contains a multiset of register columns,
the current flags, and a minimum instruction cost. Register names have no role
in the state. Equal columns can have multiple physical copies. A write can use
an existing register or a fresh scratch register. A conditional write to a fresh
register can leave unknown entries outside its required mask.

The search tries every distinct destination column, source column, and permitted
write opcode. It checks the required result mask and the boundary requirements.
It tries all register pairs at comparison events. In the predicate-preserving
modes, the pair must give the required conditions, possibly with the comparison
direction reversed. The conditional-move opcode choices compensate for this
direction. The pair need not hold the original operand columns.

The remaining number of comparisons is a cost bound. A second bound counts
distinct fully required future columns that are currently absent. One write
can create at most one such column. Deleted targets are excluded from this
bound. In early-output modes, completed output columns are also excluded.

The register limit is 36 in the completed searches. A program with eight
comparisons and core length at most 31 can execute at most 23 writes. Thus five
input registers and 23 fresh write destinations fit within that limit. The
column and state resource limits are reported as LIMIT if reached. Width 0
disables beam truncation. A CPU limit also produces LIMIT, never NONE.

The modes used in this round are:

| Mode | Intermediate requirements | Comparison conditions | Extra freedom |
| --- | --- | --- | --- |
| 0 | Keep required value available through its original uses | Preserve required predicates | Any register reuse |
| 1 | Same as 0, except one internal write target | Same as 0 | Omit that write and waive its value |
| 2 | Require each masked value only at its creation event | Same as 0 | Allow later reconstruction |
| 3 | Same as 2, except one internal write target | Same as 0 | Omit that write and waive its value |
| 5 | Same as 0, except one input value column and all equal copies | Same as 0 | Waive that value's requirements |
| 20 | Same creation masks as 2 | All operands and condition outcomes free | Permit earlier outputs |
| 22 | Same creation masks as 2, except one copy target | All operands and condition outcomes free | Omit that copy and permit earlier outputs |

An output is free and can use any register. Modes 0--5 retain the base output
times. Modes 20 and 22 record an output as soon as any full register column
equals that sorted output. They can then reuse its register. They also waive
later creation requirements for that completed output column. Each output must
still be available no later than its base output time.

For modes 1 and 3, each base has 19 internal write targets. The five writes that
feed its explicit outputs are not waived. A redundant output write can already
be skipped in mode 2 when the output exists elsewhere.

Mode 22 selects the actual copy positions. These are the 397 base movs and
232 conditional writes whose old destination is never needed when their
condition is false. Each selected write is omitted in a separate search.

`crosscheck.py` independently implements mode 0 with Python integer bitsets.
It does not use the C++ future-full-column cost bound. It identifies opposite
flag orientations directly. Thus its retained state count can differ from the
C++ count. It checks every base at the 31-instruction bound.

`structure.py` groups exact comparison outcome tables. It tries all input
renamings after fixing the first pair, reversal of input order, and independent
reversal of comparison direction. It compares complete table strings. SHA-256
values in its output identify tables; they do not replace the equality check.

The lattice test asks whether a full column can be expressed using only min
and max of the five inputs. It obtains a Boolean table on binary inputs,
checks monotonicity, and checks every threshold of every weak input order.
This test is used only to describe the bases, not to prune routing searches.

# Verification

Every emitted candidate requires the shared strict judge. All 143 ordinary
32-instruction controls passed that judge. The additional exact and early-output
controls were judged separately. The judge logs and the JSON control ledger
record their paths and outputs. Memory forms add five loads and replace the five
free outputs with stores. Each memory form has its own strict judge check.

All CPU jobs use one process at a time, nice level 19, and one CPU. Resource
files from `/usr/bin/time -v` retain elapsed time and maximum resident memory.

# Limits

These searches do not enumerate all 31-instruction programs. They retain base
event positions and some base masked value requirements. They do not permit a
new comparison schedule or unrestricted changes to every intermediate value.
The earlier-output modes retain the original output deadlines.

The unknown-value simulator is conservative. It does not retain all correlations
between scratch values or comparisons that read unknown entries. It can reject
a valid program that relies on such correlations. Thus a completed NONE is a
result for the defined finite abstract search, not a general lower bound for
real programs. A resource-limited run gives no exclusion even for that search.

The independent implementation, positive controls, and strict judge checks are
validation evidence. They are not a formal certificate of completeness.
