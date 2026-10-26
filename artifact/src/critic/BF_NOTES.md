# critic brute force (bf.cpp) — model and soundness of each pruning

Build: `g++ -O2 -o bf bf.cpp`. Run: `./bf n {fixed|final|snapshot} {I0|I1} maxk [hplus]`. Logs: `logs/`.
Model: theory's RF / RE / RS (fixed / final / snapshot), T-relaxed (scratch = T > all inputs, cmp(T,T) = eq, flags start eq),
all weak orders, register values stored BY VALUE (rank in the weak order, or T), unbounded registers.
Search: iterative deepening DFS, transposition table (TT) of failed (canonical state, remaining depth); a state is
(multiset of register value vectors, flag vector, [RS] set of targets already seen, bit "last instruction was cmp").
TT key = 128-bit hash (collision risk ~ N²/2^128, N ≤ 1e9: negligible; stated, not excluded).

Each pruning, with its reason:
1. Registers as a multiset (RS/RE): outputs pick any register, scratch all start T ⇒ names do not matter (theory ρ, ι).
   RF: P0..P{n-1} kept in order, only scratch sorted.
2. S_n relabelling of inputs (RS/RE only): acts on the orders; target vectors (sorted values) are invariant. Not in RF.
3. Flags F ≡ swap(F) (lt↔gt): cmp A,B vs cmp B,A; the future is the same up to cmovl↔cmovg, cmovle↔cmovge (I0, I1 closed).
4. mov only into a FRESH register (RS/RE): mov is a full definition; renaming the rest of D's live range to a fresh name keeps
   old D as an extra register, which never hurts in RS/RE. RF: mov may also overwrite P_j.
5. cmov into a fresh register (holds T) and cmov from T are allowed (relaxation is complete for these).
6. Skip no-op instructions (flags unchanged by cmp, cmov that changes nothing) — state unchanged.
7. No cmp directly after cmp (first is dead); the bit is in the TT key (theory L6.3).
8. h = number of missing targets (each needs its own write that produces it; mov copies cannot produce a NEW vector).
   `hplus`: +1 if no missing target can be produced by ONE instruction now (current flags, current registers);
   then the first target-producing write is not the next instruction.
Validation: n=2 gives k=4 in all modes; n=3 with and without `hplus` agree for k ≤ 8 (UNSAT); found programs are
re-checked by progcheck.py (strict): n=3 I0 k=11 witness done (programs/found/critic_sort3_I0_k11_out.s).

## bf_mm.cpp — memory models M_AD ("mem") and MM+ ("memplus")
State = MODEL §4.5 (cells ordered, register multiset, flags up to swap, last-was-cmp bit). Moves: store (cell := register;
never T), load / mov into a fresh register, cmp (registers, T, and in memplus at most one cell), cmov into an existing
register or a fresh T register, source register / T / (memplus) cell. No-ops skipped.
h (option `hc`) = st + hc + max(wr, hc):
- st = #cells not at their goal: each needs its own store.
- wr = #goal vectors of those cells held by no register: each needs its own register write (a store copies a register).
- hc = ceil(log2 max class), classes = permutations with equal (flags, index content of every cell and register). Equal
  class ⇒ equal future up to cmp outcomes; a cmp compares the same content pair on the class (eq on all if equal or
  T,T; else lt/gt), so it splits a class into ≤ 2; at the goal the cells hold σ⁻¹, so all classes are singletons.
- A shortest completion has no dead cmp, so #cmov ≥ #cmp ≥ hc; cmovs are register writes. Stores, cmps and register
  writes are disjoint instruction kinds ⇒ h ≤ dist(state) for every state.
Validation: n=2: mem 8, memplus 7 (with and without hc), = spec's mm_bfs.py.
