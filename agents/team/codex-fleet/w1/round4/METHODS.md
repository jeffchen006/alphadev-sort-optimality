# Purpose

Test delete-two/insert-one changes to the 144 eight-comparison cores and 26
nine-comparison cores. Every base has 32 counted instructions. These are new
edit searches. They do not repeat the earlier network enumeration or dagx runs.

# Terms

A core instruction is a register `mov`, `cmp`, or permitted conditional move.
An output instruction costs zero. A write is a move or conditional move.
A value column lists one register value for each of the 541 weak input orders.
A weak input order permits equal inputs.

# Direct edit method

`prepare.py` records every base, its exact instructions, its register names,
and its SHA-256 hash. The first 143 bases are the w6 round 2 verified cores.
Base 143 is `w6/candidates/c8c_len32_c29288.s`. The last 26 bases are all
`*k32.s` files in `d7-structure/fam32`.

`edit.cpp` chooses all 496 pairs of core instructions. It deletes both.
It then inserts one instruction at every gap. The insertion can use any of
the six permitted opcodes. Both operands can use any base register or one
new register, `S999`. Equal operands are included. Retained instructions keep
their operands and relative order. Deleted register writes do not remove their
register names from the insertion choices.

The fixed-output run retains the original five output instructions. There are
36 gaps after deletion, including gaps before and after output instructions.
The free-output run removes the original outputs. It has 31 insertion gaps.
It permits every output to use any register at any time. Initial inputs and
each register write define all possible new output values. Comparisons do not
change a register. Thus they cannot create a new output value.

The direct search uses a concrete relaxation. Each scratch register starts at
5, above every normalized input value, and initial flags are equal. Every
strictly correct program must work for these initial values. A rejection in
this relaxation is therefore a valid rejection for the strict model within
the stated edit family. No unknown-value abstraction is used in this search.

The search tries the 120 distinct input orders first. It then tries all 421
remaining weak input orders. It rejects a candidate at its first failed case.
The saved `cases.txt` records the exact order. No instruction or state limit,
beam truncation, or timeout is applied to either direct search.

For one concrete case, an inserted write only changes its destination value.
An inserted comparison only changes the flags. Instructions with the same
effect therefore share one suffix simulation for that case. This sharing does
not merge candidate programs across cases. Each candidate keeps its own output
constraints.

For free outputs, each candidate retains five sets of possible output values.
Each set identifies input-register or register-write occurrences. The search
intersects each set across input cases. An empty set rejects the candidate.
This requires the same register and output time to work for every case.
It does not permit the output location to depend on an input case.

# Independent checks

`crosscheck.py` directly executes each candidate program. It does not group
instructions by their effects or reuse prefix states. It checks 12 deletion
pairs from seven bases, including both comparison counts and the additional
eight-comparison base. It compares candidate counts and full candidate-mask
hashes after each of the first eight cases, or until the candidate set is empty.
The hash comparison is validation evidence, not a formal certificate.

The positive control adds one unused copy to a verified 32-instruction base.
It deletes that copy and the first original instruction. Inserting the first
instruction must restore a correct 32-instruction core. Both output modes
regenerate this control. Their outputs receive separate strict judge checks.
The free-output control is also lowered to the memory model and judged.

# Global register reuse method

`reuse.cpp` uses the round 3 masked-column engine with a new driver.
For each ordered pair of write positions, it deletes one position and replaces
the other with an unrestricted write. The unrestricted write can use any live
register, a new register, `mov`, or any permitted conditional move. All other
writes can also change their opcode, source, and destination. They retain their
base masked value requirements at creation. Deleted targets have no creation
requirement. Every output can move to any register and time, including after
its original deadline.

One mode frees comparison operands and outcomes. Another mode permits arbitrary
operands that retain the base required comparison predicates. Both modes retain
the comparison positions and count. The replacement is at a deleted write
position. Unlike the direct edit search, this driver does not try every possible
new insertion position or replace a comparison with a write.

This driver uses unknown scratch values, not the concrete relaxation used by
`edit.cpp`. It can reject real programs that depend on scratch correlations.
Completed negative tests apply to this finite abstract search. They do not give
a general lower bound. CPU, column, and memory limits produce LIMIT. A partial
family with any unresolved LIMIT remains unknown. A completed retry can resolve
a LIMIT for that one test. The original LIMIT remains in its historical log.

The copy-pair mode selects both positions from actual base copies. These are
ordinary moves and conditional writes whose old destination is never required
when the condition is false. Its hold mode also retains the base boundary value
requirements, except for the two selected value identifiers. Its creation mode
requires each retained masked value only at its original creation position.
Hold mode retains base output deadlines for unwaived values. Creation mode
permits later outputs. `reuse_manifest.json` records all selected positions and
the exact test count for each base.

# Resources and limits

All CPU jobs run sequentially, under `nice -n 19`, on CPU 68. Each search
process has a 2,800 MiB virtual-memory limit. Resource logs record peak resident
memory. The searches use one thread.

Neither edit family covers arbitrary 31-instruction programs. The direct
family retains the other 30 instructions exactly. The global reuse family
retains masked intermediate targets and the comparison schedule. The direct
enumeration permits one new register. The abstract global reuse enumeration
permits up to 36 live register copies.
