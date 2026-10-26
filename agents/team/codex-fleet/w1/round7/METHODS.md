# Purpose

Search for a median-preserving core with at most 31 instructions. The median is
output 2, the third smallest value. This round uses the first strict-PASS
32-instruction repair for each of the 15 w6 representatives and the w9 base.
It does not rerun the earlier one-edit or network searches.

# Terms

A dependency cone is the set of instructions that can affect an output. The
static analysis tracks register definitions and comparison flags. A conditional
move depends on its old destination, its source, and its flags. A comparison
depends on both operands. An ordinary move depends on its source. The analysis
includes both alternatives of every conditional move, even if one alternative
cannot occur. Thus the cone can contain unnecessary dependencies.

A median-only instruction belongs to the median cone and to no other output
cone. Other instructions on the median cone can also affect other outputs.
Instruction indices in the artifacts start at zero.

# Method

The bases and their hashes are in `bases.json`. `analyze.py` reads the earlier
strict-PASS ledger and checks all 541 weak orders again by scalar simulation.
The bases have between one and three median-only instructions. Every such
instruction is a register write. None is a comparison.

`Synth` in `synth.py` uses PySAT with CaDiCaL 1.9.5. Each editable slot chooses
one of the six I1 instructions or an omitted instruction (NOP). Each slot can
choose any source and destination from the base registers and two fresh
registers. A cardinality constraint requires at least one omitted instruction.
The other instruction positions remain fixed. The other four outputs retain
their original registers and positions. The median can use any register at any
instruction boundary. All output choices must work on every encoded case.

The exclusive search edits every median-only instruction at its original
position. The tail search also edits the last six or eight register writes
in the median cone. Some of these writes are shared with other outputs. Their
new values must still make the other four outputs correct. The encoder does
not retain original intermediate value columns. It permits new comparison
instructions in editable write positions, with their actual flag effects.

The full-cone probes edit every instruction in the median dependency cone,
including its comparisons. Bases 0, 10, and 15 receive all 541 weak orders
in their initial formulas. Each probe has a 120-second process CPU budget.
These probes can change both values and flag histories throughout that cone.

The relocation search removes every median-only instruction. It retains the
relative order of every other instruction and every other output event. If
there are m removed instructions, the solver inserts at most m-1 arbitrary I1
instructions in any gaps in that event stream. Each gap has m-1 optional
slots. This includes multiple new instructions in one gap. The median output
can occur at any boundary. Thus all resulting cores have at most 31 counted
instructions. Gap-local NOPs follow active instructions. NOP operands are
canonical. Writes to the same source and destination can become NOPs. These
normalizations do not change reachable machine states or output snapshots.

The SAT encoding represents each concrete register value by one of six values.
Inputs use ranks 0 through 4. Every scratch register starts at 5. Initial flags
represent equality. Scratch values may be read, compared, and copied. This is
one concrete initialization permitted by the strict model. A strict program
must work for this initialization. Thus a completed UNSAT result excludes a
strict program in the stated finite instruction and register family. It does
not assume that scratch values are defined before use. A SAT model is only a
candidate and must pass the strict judge.

The solver starts with the earlier failed weak orders and three simple orders.
After each SAT model, an independent scalar execution tests all 541 weak orders.
The encoder adds up to eight failed cases and continues. UNSAT on any subset
is sufficient for the stated negative result. The scalar execution uses the
same register initialization as the formula. A solver limit is UNKNOWN.

# Validation

`audit.py` compares the fixed and editable instruction transitions with a
separate scalar implementation. It checks the expected register values and
flags and rejects each incorrect value or flag. `check_schedule.py` independently
enumerates every zero- or one-instruction relocation. `check_two.cpp` uses a
separate scalar implementation for the two-instruction relocation of base 10.
It shares simulations only when two concrete instructions have the same state
effect. It tracks common median output occurrences across all weak orders.

The relocation controls place the original median-only instructions back into
the expanded gap stream. They retain a 32-instruction budget. The common strict
judge checks emitted register controls and their translated memory programs.
Controls are validation evidence; they do not establish a shorter sorter.

# Limits

The searches retain the listed other instructions, their order, and the other
four output events. The tested register set contains the base registers plus
two fresh registers. Broader changes to shared instructions remain outside
completed finite families unless their own record says UNSAT. A bounded or
interrupted search is UNKNOWN. No result is a global lower bound for sort5.
These results depend on G1-G4 and the local-search scope A11. The stated
register set is an A2 restriction. No result challenges an assumption.
