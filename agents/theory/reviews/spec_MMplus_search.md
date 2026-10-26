# Review of the MM+ search abstraction (MODEL.md v1.7 §4.5, agents/spec/tools/mm_bfs.py) — theory, 2026-10-24
**Verdict: SOUND (exact for lower bounds).**
- Registers as a multiset of non-T vectors, T registers an unbounded supply: names do not matter, all registers start T. OK.
- Fresh-register writes for load/mov: a super-multiset state runs every program of the smaller state (outputs are cells,
  written only by stores; extra registers are never read unless chosen). OK.
- cmov D,S with D in place or fresh T; copy-then-cmov is covered by mov + cmov. OK.
- cmp: unordered operand pairs (combinations) and the raw flag vector: dist(cells, regs, f) = dist(cells, regs, -f) because
  I0/I1 are closed under l<->g, le<->ge; so the mirrored cmp is not needed. A cmp of two equal vectors (all-eq flags) is
  dominated (from the old flags, replace cmovle/ge by mov, drop cmovl/g). OK.
- At most one cell operand in cmp; cell only as cmov source; no cmov into a cell. Matches x86. OK.
- No input relabelling (outputs bound to cells). Correct.
- h = #cells not equal to their goal (each needs its own store). Admissible. OK.
