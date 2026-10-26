# Purpose

Search for a core with at most 31 instructions. Rewrite the path for output 2
(the median) and output 1 or output 3. Keep the other three outputs fixed.
This round uses both requested collections: the 15 w6 k=31 near misses and
the 16 strict-PASS k=32 repairs used in round 7. It does not repeat the
single-output or one-edit searches.

# Terms

A dependency cone is the set of instructions that can affect an output.
The analysis includes comparison flags and both alternatives of a conditional
move. It can therefore include an instruction whose effect is unnecessary
on some input orders. A pair cone is the union of the two output cones.
An exclusive position belongs to the pair cone and no other output cone.
All positions are zero-based counted instruction positions. Output events
do not count as instructions.

# Method

`prepare.py` loads the original files from the earlier result ledgers. It
checks their hashes and scalar behavior. It creates 62 base/pair cases:
32 cases from the 16 repairs and 30 cases from the 15 near misses.
The two output pairs use zero-based indices (1,2) and (2,3).

`synth.py` extends the round 7 SAT encoder. SAT is Boolean satisfiability.
Each editable position chooses an I1 instruction or an omitted instruction.
It chooses any ordered operand pair from all base registers plus two fresh
registers. A comparison can replace a write, and a write can replace a
comparison. Intermediate values and flags are free in these positions.
The other instructions keep their original operands, positions, and order.
The two changed outputs can independently use any register at any boundary.
Their choices are shared across all input cases. The other three outputs
keep their base registers and events.

The exclusive family edits all exclusive positions. The tail family also
edits the last specified number of writes in the pair cone. The cone family
edits every instruction in the pair cone, including comparisons shared with
other outputs. A k=32 repair must omit at least one instruction. A k=31 near
miss can change all editable positions without an omission. Both families
therefore have a core budget of at most 31.

The encoder uses six concrete values. Inputs have ranks 0 through 4. All
scratch registers start at 5, and initial flags represent equality. The
encoder permits scratch reads and comparisons. This is a permitted strict
initialization. Every strict program must work on it. Thus a completed
UNSAT result excludes strict correctness in the stated finite family.
This initialization does not suffice to validate a positive result.

The solver starts with three simple weak orders and the earlier failed
orders of the corresponding near miss. After a SAT model, a scalar simulator
checks all 541 weak orders. The encoder adds up to eight failed orders and
continues. Every output choice must be the same for all cases. A candidate
that passes this scalar test must then pass the shared strict judge.
The strict judge also checks emitted memory programs.

The retry encoder in `fast_synth.py` computes the unchanged prefix with
concrete scalar values. It starts symbolic transitions at the first editable
position. It retains the prefix snapshots for output choices. If two cases
reach the same register values and flags at that position, they share the
suffix transition variables. Both cases still impose their own output
requirements. Program choices are common to all cases, so identical concrete
states have identical later states. This changes formula size, not the
instruction family.

Self writes can become omitted instructions without changing machine state.
Omitted instructions use canonical operands. These normalizations do not
remove a reachable output snapshot. The instruction budget counts every
remaining move, comparison, and conditional move.

# Validation

Controls pin every editable instruction to the original k=32 repair. They
exercise both independently selected outputs. `audit.py` uses a separate
scalar simulator to check every encoded output selector for eight cases
from the two base collections. Each selector must agree with the exact
register column across the encoded weak orders.

`verify.py` stores exact shared-judge commands and logs for all emitted
controls and candidates. It maps every logical register to a distinct
physical register in the memory form. It emits five loads and one store
for each output event.

# Limits

The two-fresh-register bound is an A2 restriction. The separate unbounded
exclusive tests permit 2m fresh registers for m editable instructions. Each
instruction has two register operands, so at most 2m new register names can
occur. An untouched scratch register cannot be a correct strict output.
Every other new name can be renamed by its first occurrence, destination
before source. The clauses impose that naming order. Thus this finite set
covers arbitrary register names for the exclusive edit family. It does not
assert a bound for arbitrary sort5 programs. `audit_registers.py` checks all
6,561 operand traces for two editable positions, including their renamed
representatives, against these clauses.

The symmetry analysis compares exact instruction templates. It permits input
renaming, scratch renaming, reversal of value order, and reversal of every
comparison operand pair with the corresponding condition reversal. Value
reversal exchanges output j with output 4-j. Only identical templates after
these transformations can share a finite-family negative. This concerns
strict programs. It does not assert that the scratch=5 test cases are
invariant under value reversal.

These are local rewrite
families under A11, using model assumptions G1 through G4. They do not
exhaust all programs or all ways to reschedule a two-output computation.
An unknown result, a CPU limit, a memory limit, or an abnormal process exit
is not a negative result. Search counts and final coverage belong to the
result ledgers. No result is an optimality proof or a global lower bound.

Every CPU job runs alone, on one CPU, with `nice -n 19`. Each search has a
2,800 MiB address-space limit. The batch driver starts a new process for
each test and records process failures as unknown.
