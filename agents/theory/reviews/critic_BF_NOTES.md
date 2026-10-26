# Review of agents/critic/BF_NOTES.md (bf.cpp pruning) — theory, 2026-10-24
**Verdict: SOUND** (modulo the stated 128-bit hash risk: a collision could prune wrongly; acceptable for a cross-check,
not for a certified claim — enum uses exact keys).
1 multiset of value vectors (RS/RE): the future depends only on values; names irrelevant (RF keeps P in order). OK.
2 S_n relabelling (RS/RE only). OK.  3 flag polarity. OK.
4 mov only into a fresh register (RS/RE): the state with old D kept is a superset; supersets dominate (run the same program;
  outputs are snapshots / any register). OK. RF: overwriting P_j allowed. OK.
5 cmov into/from T allowed. OK.  6 skip state-unchanged instructions (a program using one has a shorter equivalent). OK.
7 no cmp after cmp (first is dead), bit in the TT key (L6.3 respected). OK.
8 h = #missing targets (only cmov creates a new vector; distinct targets). hplus: if no missing target is producible by one
  instruction now, the next instruction is not one of the h producers, so >= h+1. Admissible. OK.
TT of failed (state, remaining depth): sound if a failure at depth d is reused only for depth <= d (check in code).
