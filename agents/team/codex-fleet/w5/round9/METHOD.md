# Round 9 method

Read rounds 1–8 before starting. Replace four consecutive instructions with three arbitrary legal instructions. The target core length is 31.

The source set is the frozen 144 cores in round5/manifest.json. Rank each source by the number of distinct unordered register pairs in its CMP instruction sequence. Break ties by source index. This defines the requested low structure diversity selection. It measures register-pair reuse, not semantic equivalence. Select the first 20 sources. Retain all 29 windows per source, for 580 queries. Interleave sources, with later windows first. The selection audit records the complete CMP operand order and all 144 scores.

Inside each replacement, all three instructions can select any of the six legal opcodes and any operands, including equal operands. Outside the window, every CMOV condition is free. Other outside operands and MOV/CMP opcodes stay fixed. Each query has all source registers and three fresh registers. Outputs can select any register snapshot. This does not impose a value palette or fixed comparison skeleton inside the window.

The existing three-bit concrete rank encoder represents the transition relation. Scratch registers start at 7. Initial flags are equal. The initial cases are twelve sampled strict orders and the all-equal order. A common output snapshot must work across all encoded cases. Every relaxed proposal is evaluated on all 541 weak orders. Counterexamples extend the formula. The Kissat wrapper checks each SAT assignment against all emitted clauses before decoding. Every successful proposal requires both strict reference judges.

Each query has a shared 900-second wall limit across formula generation, solver calls, and counterexample refinement. One query runs at a time, at nice level 19, pinned to CPU 77. The waiting batch parent uses the same CPU. Each process has a 2,800 MiB address-space limit. The wrapper also checks the combined encoder and solver resident memory against 2,800,000 KiB. A wall or memory limit is UNKNOWN. Unstarted queries give no exclusion. A direct UNSAT requires Kissat exit code 20 and its UNSAT status line. No results are inherited from earlier rounds.

The positive control duplicates the last CMP of source 0. This gives 33 instructions. It replaces the width-four window beginning at that duplicate with three free instructions. The target control length is 32. Outside predicates and the three extra registers remain free. Both strict judges must pass the result. This tests the actual replacement relation; it is not an encoding proof.

Assumption tags: [G1,G2,G3,A2,A11]. The search tests the finite local-repair relation A11 with the stated register alphabet A2. Source selection is finite. A bounded exclusion does not establish a global lower bound.
