# enum: search space and pruning rules (v3, 2026-10-24) — for review by `theory`

Tool: `agents/enum/src/enum_out.cpp` (model M_out, MODEL.md §4.3, R unbounded, relaxed semantics §2).
Notation: W = set of order types searched (all weak orders, or only the strict permutations).
A *column* is a map W -> {0..n-1, T}: the value (dense rank, or T) that one register holds under each order type.
`t_j` = target column (j-th smallest). A state is (A, f, done): A = set of distinct non-T columns, f = flag vector
W -> {lt, eq, gt}, done = set of outputs already taken.
Claim produced: "RESULT none<=K" means: no M_out(n, R = unbounded, I) program of length <= K sorts all inputs of W
under the relaxed semantics. Since W ⊆ all weak orders and the relaxed semantics is a relaxation (§2), this is a lower
bound k_out >= K+1 for the strict model too.

## Lemma NG (flag NG=1) — reads of never-written registers  [v3: corrected; v2 charged 2 per T-cmov, unsound]
Claim with NG=1: "no STRICT-correct M_out program of length <= K" (MODEL §2 strict model: correct for all inputs,
all garbage values, all initial flags). This is the AlphaDev claim itself, not a claim about relaxed-only programs.
"Pristine" register = never written so far. For a strict-correct P we build P* (|P*| <= |P|, strict-correct) by
rewriting, one at a time, an instruction that reads a pristine register S at its FIRST access of S (time t):
 (a) `cmovX S, E`  -> `mov S, E`      choose g_S := E_t   (the cmov leaves S = E_t)
 (b) `cmovX E, S`  -> `mov S, E`      choose g_S := E_t   (E unchanged, S = E_t)
 (c) `mov D, S`    -> `mov S, D`      choose g_S := D_t   (D unchanged, S = D_t)
 (d) `cmp X, S` / `cmp S, X` -> `mov S, X`, and every cmov up to the next cmp is rewritten for flags = eq
     (cmovl/cmovg deleted, cmovle/cmovge -> mov)            choose g_S := X_t  (flags eq, S = X_t)
 (e) `cmp S, S` -> deleted, cmovs up to the next cmp rewritten for eq (S stays pristine).
 Proof scheme: fix input x, the other garbage, initial flags. g_S may depend on them, since S is not accessed before t.
 With that choice the run of P equals the run of the rewritten program at every step (flags may differ only where no
 instruction reads them). P is correct on that run; the rewritten program never reads g_S. So it is correct for all
 garbage. Each rewrite removes one pristine read and adds none, so the process stops.
Left in P*: an instruction that reads TWO pristine registers at the first access of both (`mov A, B`; `cmp A, B` and
`cmovX A, B` reduce to `mov A, B` (+ eq rewrite) with g_B := g_A). We call `mov A, B` (A, B pristine) a GARBAGE MOV:
A and B then hold garbage (T in the relaxed run) and are "garbage registers"; `mov C, G` with G a garbage register makes
C one too. In P* every read of a T value reads a garbage register.
Set model with NG: state gets γ = number of garbage registers that still hold T (capped: 7 = unbounded, a relaxation).
 - garbage mov: cost 1, γ += 2.    - T as cmov source or cmp operand: needs γ >= 1.
 - cmov with destination T (T-cmov): cost 1, needs γ >= 1, γ -= 1.   - copy (mov D,X; cmov D,S): cost 2 as before.
Lemma S with NG: simulate P* as in Lemma S. "Garbage register" = any written register that holds all-T. EVERY instruction
that leaves an all-T value in a register (garbage mov, `mov C, G`, a cmov with all-T result) -> set op "garbage mov"
(cost 1 = its register cost; γ grows by >= the true count); a cmov into a garbage register -> T-cmov (cost 1, γ−1);
all other cases as in Lemma S. (Fix from theory review agents/theory/reviews/enum_PRUNING_v3_NG.md; the generator
already allows a garbage mov at any time, so no code change.)
Invariant γ >= #garbage registers holding T. So set cost <= |P*| <= |P|.

## Rule W — restrict inputs to strict permutations (optional, flag WEAK=0)
A program correct on all weak orders is correct on the subset of permutations. Sound for lower bounds.
`cmp` of two copies of the same input (or T, T) still gives eq (MODEL §4.4 warning respected: semantics unchanged).

## Lemma S — set model = register model (unbounded registers, outputs as free snapshots)
Set-model operations: `cmp a,b` (a, b in A ∪ {T}; cost 1); `cmovX` in place: A := A \ {D} ∪ {M} (cost 1; if D = T:
A := A ∪ {M}); `cmovX` into a copy: A := A ∪ {M} (cost 2 = mov + cmov). M = (X holds ? S : D) pointwise.
An output j is taken (done += j) as soon as t_j ∈ A (taking a snapshot at the first chance is never worse, it is free).
(<=) set program -> register program of equal length: keep one register per column; copy = `mov fresh, D; cmovX fresh, S`;
T = an unused register; a snapshot = `out j, reg`.
(>=) register program of length L -> set program of cost <= L. Invariant: A ⊇ (non-T columns held in registers),
same flags, done_set ⊇ done_reg. Potential Φ = #non-T registers − #distinct non-T columns (Φ0 = 0, Φ >= 0).
Show cost_set + Φ grows by <= 1 per instruction:
- cmp: same cmp in set model (cost 1), Φ unchanged.
- mov D,S: set model does nothing (cost 0); Φ grows by <= 1.
- cmov D,S, result M, old content X of D: M = X: nothing. M ∈ A or M = all-T: nothing (cost 0), Φ grows by <= 1.
  M ∉ A and X = T: in place on T (cost 1), Φ unchanged. M ∉ A, X non-T held by another register too: copy (cost 2), Φ
  drops by 1. M ∉ A, X held only by D: in place (cost 1), Φ unchanged; A \ {X} still covers the registers.
At the end done_set = all. So cost_set <= L − Φ_end <= L.

## Lemma M — monotonicity
If A ⊇ B, same f, done_A ⊇ done_B then dist(A) <= dist(B): run B's program on A; every op keeps the inclusion.

## Rule E — generator restrictions (all are "no change" or "dominated by the parent")
E1 `cmp` whose flag vector equals the current one: no change. E2 cmov with M = D: no change.
E3 M all-T, or M ∈ A already: in place = deletion of D (dominated by the parent, Lemma M, at lower cost); copy = no change.
E4 `cmp a,a` and `cmp T,T` both give all-eq: one representative. `cmp b,a` = polarity mirror of `cmp a,b` (rule P).
No `mov` op and no deletion op exist in the set model (Lemma S).

## Rule P — flag polarity
Negate all flags (lt <-> gt) and swap cmovl <-> cmovg, cmovle <-> cmovge: a cost-preserving bijection of programs
(I0 and I1 are closed under the swap; initial flags eq are fixed). The key stores f in canonical polarity
(first non-eq entry = lt).

## Rule G — input relabelling symmetry S_n (flag SYM=1)
For σ ∈ S_n, (σ·col)(w) = col(w∘σ). The initial set {x_0..x_{n-1}} and every t_j are invariant, cmp/cmov act pointwise
and commute with σ, done is invariant. So dist(σ·s) = dist(s). The key stores one σ-image (chosen by minimal sorted hash
tuple; any choice is sound because the key is an exact image of the state, only dedup strength depends on the choice).

## Exact dedup
Columns and flag vectors are interned with full byte comparison (no hash-only identity). State keys are compared
word by word. Layered BFS with edges of cost 1 and 2 finalises layer g after layers g-1 and g-2 are expanded, so every
state is recorded with its minimal cost among f-bounded paths.

## Rule D — dead states
If for some w ∈ W some value t_j(w) of an undone output j is held by no column, the state cannot reach the goal:
cmov/mov only copy values that exist, T is not an input value.

## Heuristic h = hcmp + max(und, hcmp, und + max_j(cover_j − 2))  (v2) (admissible; cmps and cmovs are disjoint instruction kinds)
H1 (hcmp) Group the strict permutations p ∈ W by key(p) = (f(p), index content of every column at p, and for each
   taken output j the index p^{-1}(j)). Index content: column value v at p -> input index p^{-1}(v) (T -> n).
   For perms in one class, the future (index contents, outputs) depends only on the future flag outcomes; a cmp at p gives
   lt/gt, or eq for the whole class at once (eq iff equal index or T,T, which is class-invariant). At the end all
   outputs are taken and the output index vector p^{-1} differs for p ≠ q. So >= ceil(log2(max class size)) cmps remain.
H2 (und, hcmp) Each undone output needs its own creating cmov (it is absent; only cmov creates a new column).
   A minimum-cost program has no useless cmp (a cmp whose flags no cmov reads before the next cmp/end can be deleted),
   so every remaining cmp is followed by a cmov: #cmov >= #cmp >= hcmp.
H3 (cov) If target t_j cannot be covered pointwise by <= m columns of A, then >= m cmovs remain: the cmov DAG that
   creates t_j has leaves in A that cover t_j, and a fan-in-2 DAG with L leaves and one sink has >= L−1 gates.
   (v1, superseded by H3'.)
H3' (v2) Let cover_j = minimum number of columns of A that cover t_j pointwise on the strict perms (exact, by DFS).
   For each undone j, the "chain DAG" H_j (for each strict p, the path that carries the value t_j(p) from a column of A to
   the creating gate g_j) has >= cover_j leaves, hence >= cover_j − 1 gates (fan-in 2, one sink). Every gate of H_j holds
   t_j(p) at some strict p, so it is not the creating gate g_k of another undone k (t_k(p) ≠ t_j(p) on strict p).
   So H_j has >= cover_j − 2 gates that create no undone target. With the |U| creating gates:
   #cmov >= |U| + max_j (cover_j − 2). (Columns of A whose match set is contained in another one are dropped before the
   DFS; this does not change the minimum.)
Admissibility argument for f-bounded BFS: take a minimum-cost program P* of cost <= K. h(s) <= remaining cost of P* at
each state s on P*, so all of P*'s states pass the bound; dedup keeps a state at its minimal g. So P* (or one of equal
cost) is found.

## Register-model tool (MODE reg, `src/enum_reg.cpp`, outputs = final P_j)
Uses rules W, P, D, H1 (classes keyed by flag + index content of all registers), H2' (#P_j not equal to t_j), and
scratch-register renaming (scratch registers are interchangeable; the state sorts them). R is the parameter NS + n.
