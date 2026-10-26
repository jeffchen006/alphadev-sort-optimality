# Current compiler: the two-column bound does not follow from its cost proof

The current C1 compiler can output three full non-lattice written versions
from an original program with at most three exceptional written versions.
The control below has two partial versions and one full non-lattice version.
Its normalized program has three full non-lattice versions. Copies count
separately, as required by the C2 encoders.

This is a limit of the current construction. It does not refute a different
same-or-shorter reduction. The control has k=40 before normalization and k=39
after normalization. Both exceed the k<=31 target. It is not a new short sort.

Start with this eight-instruction prefix:

```
cmp P0, P1
mov S90, P2
cmovl S90, P3
cmp S91, S90
cmovl S91, P0
cmp S91, P0
cmovl S91, P0
cmovge S91, P0
```

Let f be P3 when P0<P1, and P2 otherwise. Instruction 3 writes f into S90.
This function is non-lattice. For example, inputs (0,1,2,3,4) and (1,0,2,3,4)
have the same Boolean threshold vector at threshold 3. Their f values are
3 and 2. A min/max expression commutes with taking such a threshold. It
therefore cannot produce those different Boolean results.

Instructions 5 and 7 create partial versions of S91. Instruction 8 makes
S91 equal to the original P0 on every execution. To check the latter claim,
let v be S91 immediately before instruction 6. If v<P0, instruction 7 writes
P0 and instruction 8 keeps it. If v>=P0, instruction 7 keeps v and instruction
8 writes P0. The flags do not change between these two conditional writes.
The proof includes equality. No input register is changed by this prefix.

Append the known pure-lattice k=32 sort5 program in
`w10/programs/exception_0_normalized.s`. Rename every body use of the logical
P0 register to S91, including destinations and output snapshots. S91 starts
that body with the original P0 value. Thus the combined program sorts.

The C1 compiler binds initial S91 to f at instruction 4. It removes that
comparison and skips instruction 5 under its chosen equality result. The
normalized prefix is

```
cmp P0, P1
mov S0, P2
cmovl S0, P3
cmp S0, P0
mov S1, S0
cmovl S1, P0
cmovge S1, P0
```

Here S0=f. The fifth instruction copies f, so it is another non-lattice
written version. The sixth instruction writes max(f,P0), which is also
non-lattice. The same two strict input vectors above establish this: their
f values exceed P0, so taking max with P0 leaves both witness values intact.
The seventh instruction restores P0 into S1. Its result is
lattice. The two saved original instructions pay for the additional copy
and leave one instruction saved. This satisfies the cost theorem while
exceeding C2's exceptional-column budget.

All original instructions remain live under ordinary backward analysis of
data and flags. Thus removing instructions with unused results alone does
not remove this example. A stronger semantic rewrite can replace the entire
prefix with `mov S91,P0`. That rewrite confirms that this control does not
refute the existence of a better reduction.

`src/check_c1_live_growth.py` checks every weak order of the five inputs and
the one relevant initial garbage value: 4683 joint weak orders. It keeps
value provenance while it computes comparisons by signed value. Other
initial scratch values are overwritten before use. It independently checks
the lattice property by threshold consistency on all 541 input weak orders.
It also checks the C1 specialization on all 541 input weak orders.

Verified counts are original q=2, r=1, k=40; normalized q=0, r=3, k=39.
The reference strict judge passed the original and normalized programs in
both out and memory models. Exact output is in `logs/c1_live_growth_judge.log`.
The program paths, witnesses, and hashes are in `analysis/c1_live_growth.json`.
The four PASS paths are listed in RESULTS.md.

An earlier control with a dead prefix gives original q=1, r=1, k=38 and
normalized q=0, r=3, k=38. Its records are in `analysis/c1_column_growth.json`.
It provides a simpler check of copy-count growth. The live control above
removes the ordinary instruction-liveness objection.

Both scope gaps in GAPS.md remain open. No UNSAT decision is made here.
