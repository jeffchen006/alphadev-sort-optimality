# Purpose

Classify the 15 nine-failure cores from w6 round 6 and the twelve-failure
core `w9/candidates/residual_b_near31_out.s`. Exhaust every single inserted
instruction. Then test every single deletion plus single insertion.

# Terms

A weak order specifies which inputs are less than, equal to, or greater
than the other inputs. A value occurrence identifies one register at one
program position. A free output can select any value occurrence. The same
occurrence must supply that output on every weak order.

# Method

The input manifest records the 16 paths, hashes, register names, and exact
instructions. Each core has 31 counted instructions and five output
instructions. The primary search inserts one counted instruction. Its cores
therefore have length 32. The additional search deletes one counted
instruction and inserts one. Its cores have length 31. Retained instructions
keep their operands and relative order.

Every inserted instruction can use any of the six permitted opcodes and
every ordered pair from the base register names plus `S999`. Equal operands
are included. Eleven bases have seven named registers. Five bases have eight.
The resulting instruction alphabets have 384 and 486 instructions.

The fixed-output mode preserves all five output instructions. It inserts
at all 37 gaps, or at all 36 gaps after a deletion. The free-output mode
removes the output instructions. It inserts at all 32 core gaps, or all
31 gaps after a deletion. Each original core position can be deleted.

The evaluator uses all 541 weak orders. Scratch registers start at 5,
above every normalized input. Initial flags are equal. This is one permitted
concrete initial state. Every strictly correct core must also sort this
state. A completed negative in this relaxation excludes that edit family.
It does not assert that all retained edits are strictly correct.

For each input case, the main implementation groups instructions that have
the same immediate concrete effect. It shares their suffix execution.
It retains a separate candidate identity and output-occurrence intersection
across cases. Free output selection cannot depend on the input case.

`check.cpp` independently constructs and directly executes each full edited
program. It has no prefix cache or effect grouping. It generates the cases
in a different order. The audit compares every surviving edit and every
output-occurrence mask. Both implementations exhaust the four full families.

`verify.py` emits every surviving insertion edit as a program. It selects
the earliest valid output occurrence for each free output. It runs the
shared judge with `--strict --model out` on all 730 emitted cores. For
each base and output mode, it also lowers the first PASS core to memory
and runs `--strict --model mem`. Every command uses the judge's default
20,000 random concrete tests, as well as its symbolic and weak-order checks.
The results are in `pass_ledger.json` and `judges/`.

The classification records every failed case, wrong output, required value,
and first boundary where no register holds that value. Boundary zero is
the input state. Boundary 24 means immediately after counted instruction 24.
The audit also checks that no comparison or output depends on a scratch
value on any of the 541 paths. It verifies each stated failure condition
against the entire case set.

# Limits

These searches test assumption A11: repair near a specified failing core.
They retain the rest of that core. They allow every permitted opcode and
new intermediate values. They do not retain a min/max value skeleton.
The operand alphabet includes one new register. The result is stated for
that explicit alphabet. No global register bound or sorting lower bound
is inferred. G1 through G4 are unchanged.

Every search completes without a time, state, or beam limit. The C++ main
search uses a 2,800 MiB address-space limit. All compiler, search, audit,
and judge jobs run one at a time on CPU 68 under `nice -n 19`.
