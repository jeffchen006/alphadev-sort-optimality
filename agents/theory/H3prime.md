# H3' as a precise lemma for an op sequence (theory, 2026-10-24; for coq and lean-reflect)

## Setting
- W = the test types; Ws ⊆ W = the STRICT permutations in W (H3' uses only these). Columns: maps W -> {0..n-1} ∪ {T}.
- Set-model state s = (A, f, done): A a finite set of non-T columns, f a flag vector, done ⊆ {0..n-1}.
  U(s) = undone outputs. Invariant of reachable states: j ∈ done iff t_j was in A at some earlier time (t_j = target column).
- Ops: cmp (A unchanged); cmov ops with result M = (f holds ? S : D) pointwise, S ∈ A ∪ {T}, D ∈ A ∪ {T}:
  in place (A' = A \ {D} ∪ {M}), on T (A' = A ∪ {M}), copy (A' = A ∪ {M}); done' = done ∪ {j : t_j = M}.
  (Ops with M ∈ A or M all-T are allowed in the lemma; the search may prune them separately.)
- cover_j(A) = min |C| over C ⊆ A with ∀ p ∈ Ws, ∃ c ∈ C, c(p) = t_j(p); +∞ if no such C.

## Lemma H3'
Φ(s) := |U(s)| + max_{j ∈ U(s)} (cover_j(A) − 2), with max over the empty set := 0.
For every op sequence σ from s that ends in a state with U = ∅: #(cmov ops in σ) ≥ Φ(s).

## Proof (induction over σ; per-op invariant: Φ drops by ≤ 1 on a cmov op and by 0 on a cmp)
Facts, for a cmov op s -> s' with result M from S, D:
- (F0) For j ∈ U(s): cover_j(A) ≥ 2. (cover_j = 1 means t_j ∈ A, so j ∈ done.) Hence the max term is ≥ 0 when U ≠ ∅.
- (F1) cover_j(A') ≥ cover_j(A) − 1 for every j. Take an optimal cover C' of t_j by A'. Note A' \ {M} ⊆ A (all three op
  kinds). If M ∉ C', C' is a cover by A. If M ∈ C', let C = (C' \ {M}) ∪ ({S, D} ∩ A): at each p ∈ Ws covered by M,
  M(p) = t_j(p) ≠ T, so the side chosen at p (S or D) is a non-T column of A with the same value. |C| ≤ |C'| + 1.
- (F2) If M = t_k for some k ∈ U(s), then for every j ≠ k: cover_j(A') ≥ cover_j(A). Reason: on every p ∈ Ws,
  t_k(p) ≠ t_j(p) (distinct ranks on a permutation), so M covers no point of t_j; drop M from any cover by A'; the rest is ⊆ A.
- (F3) If M = t_k, k ∈ U(s), then cover_k(A) ≤ 2 (the non-T ones of S, D cover t_k, as in F1), so cover_k(A) − 2 ≤ 0.
Cases:
- cmp: A, done unchanged: Φ' = Φ.
- cmov creating t_k (k ∈ U): U' = U \ {k} (M equals at most one target). By F2 the terms of j ∈ U' do not decrease; by F3 and
  F0 the term of k is ≤ 0 ≤ max over U' (if U' ≠ ∅) — so the max over U' ≥ the max over U, and Φ' ≥ Φ − 1.
  If U' = ∅: Φ' = 0 and Φ = 1 + (cover_k − 2) ≤ 1. OK.
- other cmov: U' = U; by F1 every term drops by ≤ 1, so the max drops by ≤ 1: Φ' ≥ Φ − 1.
At the end U = ∅, Φ = 0. So #cmov ops ≥ Φ(s0). □

## Use in the heuristic
h(s) = hcmp + max(und, hcmp, Φ(s))-style combination as in PRUNING.md: cost ≥ #cmp + #cmov ops, #cmov ops ≥ Φ(s) (this lemma),
#cmov ops ≥ hcmp on a minimum-cost completion (H2). Copy ops cost 2 but count as ONE cmov op here (the bound is on cmov ops).

## On coq's proposed invariant
"cover of t_j decreases by at most 1 per in-place/copy op" = F1: correct (also for on-T ops; T covers nothing).
"only the op that creates t_j itself ..." : the needed extra facts are F2 (creating t_k never lowers cover_j for j ≠ k) and
F3 (at creation cover_k ≤ 2), combined in the potential Φ above. Strict permutations are essential for F2 (on a weak order
with ties t_k(p) = t_j(p) is possible); with WEAK=1 compute cover on the strict subset Ws only.
