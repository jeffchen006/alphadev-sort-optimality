# Review of agents/enum/PRUNING.md v2 (H3', Lemma NG) — theory, 2026-10-24

## H3': SOUND
For undone j, H_j = union over strict p of the active path from the creating gate g_j down to a column of A holding t_j(p).
Its leaves cover t_j pointwise on strict perms, so >= cover_j leaves; every node reaches the sink g_j, so with fan-in 2
(#edges = 2G >= #nodes - 1) G >= cover_j - 1, incl. g_j. A gate of H_j holds t_j(p) at some strict p, and t_k(p) != t_j(p)
there, so it is not the creating gate of another undone k. Hence #cmov >= |U| + max_j (cover_j - 2). Dropping dominated
columns does not change the minimum cover. Correct.

## Lemma NG: the LEMMA is correct; the CONSEQUENCE used by the set model has a GAP
Lemma (strict model): a cmov whose destination D was never accessed (read or written) before time t can be replaced by mov.
Proof is right: S_t does not depend on g_D; choose g_D := S_t (input-dependent choice is allowed under "for all garbage").

Gap: "in P' every cmov into an all-T register writes a register that was written with T before" is FALSE. Case (c):
D is never WRITTEN before t but was READ before t (as a cmp operand, a mov/cmov source). Then D was accessed, NG does not
apply, and in the relaxed run of P' D holds T at t without any earlier write. The register program pays 1 for this cmov;
the set model charges 2 (T-copy); in the potential argument there is no slack (a cmp that read D costs 1 in both models).
So Lemma S with NG (cost_set <= L) is NOT proved, and the claim "no strict-correct program of length <= K" with NG=1 is not
yet valid. (I tried to extend NG to case (c) by a fixed point g_D = S_t(g_D): it does not exist in general, e.g.
S_t = (g_D <= x0 ? x1 : x0) with x0 < x1.)

Fix options:
(A) Extend the set-model state by a counter r = #T registers that were READ but not yet written (a read of T may use an
    already-read T register or a fresh one: increment optional). A cmov into T costs 1 if r > 0 (then r -= 1) and 2
    otherwise. Potential: Phi' = Phi + #written registers holding all-T; case (c) is exactly the r > 0 case. Sound and
    probably still cuts most states (T reads are rare).
(B) Restrict the claim to programs without reads of never-written registers (AlphaDev's own rule, also Ullrich-Hack's).
    Weaker than the MM claim; not my recommendation for the main theorem.
(C) Run the final n = 4 claim with NG = 0 (if the 100x cost is affordable).
Note also: NG makes the claim "no STRICT-correct program"; the chain is then MM strict -> (L5, strict) RS strict -> NG ->
(L2) relaxed set model. L5 holds in the strict semantics (lemmas.md L5), so this chain is fine once the gap is closed.
