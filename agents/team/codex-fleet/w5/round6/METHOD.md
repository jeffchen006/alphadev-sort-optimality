# Round 6 method

The input list is the frozen 144-seed manifest from round 5. The second list has
the 144 retained retiming forms from that round. No source file is changed.

The terminal rewrite collector preserves the round-5 rules. It adds the set of
all value columns observed along each path to the merged-state key. This set
matters for approximate output snapshots. The previous exact-output bitmask
alone cannot preserve that information. At a terminal state, the collector
tests every combination of output columns that can fail at most 20 weak orders.
For each output, a failure mask contained in another mask dominates that mask.
The collector uses this dominance rule before testing unions of five masks.
It records one program per retained effect state, rather than all instruction
lists that reach an identical state. Surviving writes retain their seed column.

The independent packed evaluator permits changed intermediate columns. It
checks all 541 weak orders with scratch=7 and equal initial flags. It selects
output snapshots with the same failure-mask dominance rule. It tests:

1. Each single deletion. If it deletes CMP, it also enumerates MOV and all four
   predicates for every write before the next CMP. Operands stay fixed.
2. Each CMOV pair. It removes both events and inserts one MOV or CMOV at either
   original gap. The inserted destination is either removed destination. Its
   source can be any seed register or one fresh scratch register. All conditions
   and self operands are included. Comparisons and other instructions stay fixed.

Both scans count duplicate edit paths. Only emitted instruction lists are
deduplicated. No emitted near miss meets the strict acceptance criterion.

SAT repairs start with every actual failed weak order plus twelve sampled strict
orders. Additional counterexamples extend the same solver. Output snapshots are
free. The two-slot query allows any instruction at two positions and any of the
four CMOV conditions at every other surviving CMOV. Other operands and MOV/CMP
opcodes stay fixed. The finite register alphabet has all used registers and one
fresh register. These conditions differ from an ordinary two-instruction edit
bound. The full query chooses both positions; decomposed queries fix each pair.

SAT fixes scratch to 7 and initial flags to equal. An UNSAT result excludes only
the specified relaxed query. A time limit is UNKNOWN. Every proposal needs the
strict out judge and the strict memory judge. Only a strict PASS can count as a
sort5 result. The scorer, constant SAT control, and variable two-slot SAT control
have retained k=32 controls. Their strict judge logs are in logs/.

All compute jobs use nice level 19. At most two compute jobs run together on
CPUs 76-77. Search and SAT jobs have a 2,800 MiB address-space limit. Every write
is inside this worker folder. The bounded scans establish no global lower bound.
