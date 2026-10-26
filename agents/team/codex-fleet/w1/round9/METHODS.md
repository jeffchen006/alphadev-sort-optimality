# Purpose

Test median rewrites at core budget k=31. Use all 26 nine-comparison bases
from d7-structure/fam32. Then test the 144 actual eight-comparison bases
from the round 4 input ledger with two added instruction positions.
Read earlier results as input. Do not rerun earlier searches.

# Terms

A dependency cone contains every instruction that can affect an output.
It includes the comparison that supplies each conditional-move condition.
An exclusive instruction affects the median and no other output.
A tail test also edits the specified number of last writes in the median cone.
SAT means Boolean satisfiability. UNSAT means that the finite formula has
no satisfying assignment.

# Method

Each editable instruction can select mov, cmp, cmovl, cmovle, cmovg,
cmovge, or an omitted instruction. It can select any permitted register
operands. Self writes can be omitted. Omitted instructions have canonical
operands. The median can be recorded from any register at any boundary.
The other four outputs keep their base registers and original core boundaries.
Their values must still be correct after every edit.

The initial nine-comparison tests allow 2m fresh register names for m editable
instructions. Each instruction has two operands. Thus this bound covers
every register name that the editable instructions can mention. A fresh
name first occurs before any later fresh name. The order examines the
destination before the source. A strict median output cannot read an
untouched scratch register. These observations remove the register-cap
assumption A2 for the completed fixed-position tests. They do not remove
the local-family assumption A11.

The final search source tightens arbitrary-name queries to 2(m-1) fresh
names at k=31. There are 32-m fixed instructions, so at most m-1 free
instructions can remain. This bound covers their operand occurrences.
Controls at k=32 retain the 2m bound. Both versions cover the same strict
finite families. The result ledgers retain their actual register counts.

The eight-comparison scheduler adds two optional instruction positions.
It retains the original instruction order. The solver can place the two
added positions at any core gaps from the first editable instruction
through the end. It can place both at the same gap. Each original editable
instruction can also change or be omitted. Other original instructions
remain fixed. The sum of all non-omitted instructions is at most 31.
These tests allow the base register names and two fresh names. They use A2.

The smaller tail-three scheduler also has arbitrary-name tests. If it edits
m original positions, it retains 32-m fixed instructions. Its k=31 budget
therefore permits at most m-1 active free instructions, counting additions.
At most 2(m-1) fresh names can occur in these instructions. The tests allow
2m fresh names in the initial runs and the tighter 2(m-1) bound in the final
retry. They normalize first occurrences. Both bounds cover arbitrary
new names within this scheduled family and removes A2 for completed negatives.

An omitted added position has no machine effect. The encoder moves it to
the final gap, after any active additions. This preserves every original
core boundary and each reachable output value. It removes equivalent
schedules without changing the finite program family.

The scheduler has 34 instruction steps. A counter with states 0, 1, and 2
records the number of added positions already consumed. At step t, if the
counter is c, the next original instruction has index t-c. A transition
either consumes that original instruction or consumes an added position.
The final counter is 2. Original output j at boundary b can occur at any
visited state t=b+c, in its original register. This includes outputs before,
between, or after the added positions in the same gap. The median has an
independent global register/boundary choice. All choices are common to all
input cases.

The solver starts with three weak input orders. After each model, a scalar
simulator checks all 541 weak orders. It adds up to eight failed orders.
Each input uses ranks 0 through 4. Every initial scratch register holds 5.
The initial flags represent equality. A strict program must work for this
permitted initialization. Thus UNSAT excludes a strict program in the stated
finite family. A scalar survivor requires the shared strict judge.

The compact encoder executes the unchanged prefix directly. Cases with
identical register and flag states share suffix transitions. Each case still
has its own output requirements. `synth.py`, `fast_synth.py`, `analyze.py`,
and the judge translation in `verify.py` were copied into this round before
changes. Earlier source files remain unchanged.

# Validation

`audit.py` uses an independent scalar simulator. It checks 21,420 complete
register values across 15 inserted-instruction programs. It covers different
gaps, two instructions in one gap, comparisons, all move conditions, omissions,
and changes to the selected original writes. It also checks all 32 Boolean
schedules for a three-instruction example. It repeats all 6,561 two-slot
operand traces for fresh-register naming. These are validation checks.

Positive controls pin the original core and use a budget of 32.
The scheduled controls put the two added omissions at the end.
Every emitted candidate or control must pass the shared strict out judge.
`verify.py` also emits five loads and five stores for the memory judge.
Exact commands, file hashes, logs, and statuses go into `pass_ledger.json`.

# Limits

This work uses model assumptions G1 through G4. It tests finite local
rewrite families under A11. The fixed instructions, their order, and the
four other output registers remain restrictions. The scheduled tests use
two fresh registers. A CPU limit, memory limit, or failed process is unknown.
It is not a completed negative. These tests do not establish a global
lower bound for arbitrary sort5 programs.

Every CPU job runs alone on one CPU with nice level 19. Each search has a
2,800 MiB address-space limit, below 3 GB. `batch.py` starts one search at
a time. Its durable ledger records abnormal exits as unknown.
