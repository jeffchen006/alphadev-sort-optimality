# Round 5 rewrite rules

Purpose: test whether two instruction events can share one instruction after changes to flag use and register sources.

A value column gives one value for each of the 541 weak input orders. Scratch columns use distinct symbolic labels. A comparison that contains an unresolved scratch relation is outside this rule set. Initial flags are unknown. A conditional move before the first comparison must give the same result for every initial flag state.

The value set contains all seed input columns, all seed write-result columns, all output columns, and one distinct column for each scratch register, including one new scratch register. The set is finite. The rules never introduce a value outside this set.

1. Remove two distinct instruction events. They can be MOV, CMP, or CMOV. Insert at most one new instruction at any gap. The shorter-program scan thus has length at most 31.
2. Keep each surviving write destination and its full original value column. Rebuild that write with MOV or any of the four permitted CMOV conditions. Its source can be any available register, including itself. This can repair any number of surviving instructions.
3. In the fixed-flag scan, keep each surviving comparison's full original flag column. Rebuild its operands with any available registers. Both operand orders are covered: reversing the operands and every following predicate has the same value effect, so the canonical original order suffices.
4. In the free-flag scan, each surviving comparison can compare any available register pair. Its full flag column can change. Every later write must still compute its original value column. Both operand orders are explicit.
5. The inserted MOV or CMOV can write any column in the value set to any register. It can use any available source and any supported condition. The inserted CMP can use any available register pair in the free-flag scan. The fixed-flag scan restricts its resulting flags to a seed comparison column.
6. Record an output whenever its complete sorted value column occurs in a register. Output snapshots have no instruction cost. A successful path must supply all five output columns.
7. Instructions with identical value and flag effects lead to one state. The free-flag scan also merges states with the same original position, edit counts, register columns, flags, and available outputs. This removes duplicate paths without removing a possible effect in this rule set.
8. An inserted no-op can be omitted. The search also accepts a path that needs fewer inserted instructions.

The retiming scan changes rule 1 to one removal and at most one insertion. It records a length-32 example for each seed when possible. This scan tests moving a conditional operation across comparison boundaries, converting it to an unconditional operation, and repairing later consumers.

The independent simulator checks each retained result before assembly emission. The strict reference judge remains the acceptance authority. A completed negative result excludes this finite rule set only. It does not exclude programs that change a surviving write's value function or introduce a new value function.

Each process has a 2,800 MiB address-space limit. The free-flag scan stops a seed after 90 seconds or three million merged states. Such a seed has status UNKNOWN. A completed seed has `complete=1`. All process invocations use nice level 19. At most two CPU jobs run at one time.

## Pair value audit and SAT repairs

The pair audit tests each original CMOV pair. It asks whether one instruction can produce the second result at the first instruction, while the first result remains available. It tests the flags at both instructions and both comparison operand orders. This audit uses the concrete scratch sentinel 7 and equal initial flags. A witness passes a necessary value test only. The full rewrite scans test its consumers.

The SAT repairs test all 49 audited pairs. They first test the shortest pair from each seed with a witness. They delete both CMOVs and insert one write at the earlier gap. A window starts one comparison block before the first deleted CMOV and ends after one comparison block following the second deleted CMOV. Inside this window, all write sources and all write opcodes are free. Surviving write destinations stay fixed; the inserted write has a free destination. Every retained comparison has free operands there. Outside the window, instructions stay fixed. Comparison positions and the comparison count stay fixed. Output snapshots are free. The SAT repairs can change surviving value columns and create new value columns.

The SAT encoding fixes scratch to 7 and initial flags to equal. It starts with all 31 one- or two-rank weak orders and 16 strict orders. Counterexamples add further cases. An UNSAT result excludes the stated finite query. A 15-second wall limit is UNKNOWN. Every emitted candidate needs both strict judges.
