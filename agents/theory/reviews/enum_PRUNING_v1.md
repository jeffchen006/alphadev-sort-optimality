# Review of agents/enum/PRUNING.md v1 (+ src/enum_out.cpp) — theory, 2026-10-24

**Verdict: SOUND.** Every rule is state-based (no syntactic prefix rule), so exact dedup on (A, f, done) is safe
(the pitfall of lemmas.md L6.3 does not apply). Code matches the text on the points checked: cmp generation (a<b, T as
index c, one all-eq representative, polarity canonicalized), cmov generation (E2 `!ch`, E3 `allT`/`exists`, in place on T,
copy cost 2), `doneAfter`, rule D (needMask), H1 key (flag, index content with T -> N, taken outputs' indices), H3 loop.

## Lemma S (set model = M_out with unbounded registers): CORRECT
Checked all cases of the potential argument. Precise invariant to write down: (i) every register holds a column in
A ∪ {all-T}; (ii) flags equal; (iii) done_set ⊇ done_reg. With (i), the old content X of a cmov destination is in A, so the
case split is complete. Φ = #non-T registers − #distinct non-T register columns ≥ 0 (pigeonhole).
Add: **Φ_0 = 0 needs the n input columns to be distinct**; true when W contains the strict permutations (both of your
W options). With a CEGIS-style W this would need a check.
Nice by-product for the paper: in M_out, `mov` is needed only as the first half of a copy.

## Lemma M: CORRECT (B's program runs on A; every op keeps A ⊇ B, same f, done ⊇).

## Rules W, E1–E4, P, G, D: CORRECT
- E3 uses Lemma M (child ⊆ parent, same f, same done, higher cost).
- E4/P: dist(A, f, done) = dist(A, −f, done) because I0 and I1 are closed under l<->g, le<->ge and the start flag is all-eq.
- G: W must be closed under S_n (all weak orders: yes; all permutations: yes); t_j and the input set are S_n-invariant
  because outputs are judged by value. (G is only valid because outputs are snapshots/by value; in RF it would not be.)
- D: values are only copied; T is not an input value.

## Heuristics: ADMISSIBLE for the minimum-cost completion (which is all the f-bounded search needs)
- H1: decision-tree argument (= lemmas.md L7 / bounds B1, refined to a class). Taken outputs' indices in the key are
  necessary (else two perms in one class could end in the same leaf). Correct.
- H2: "und" correct (each undone target needs its own creating cmov; distinct targets). "#cmov ≥ #cmp" holds for a
  **minimum-cost** completion only (no useless cmp); please say so in the text — the admissibility proof uses P*'s suffix,
  which is minimum-cost, so this is fine.
- H3: write the gate-count step for DAGs with reuse: in the ancestor DAG of the sink, #edges = 2G and every node except the
  sink has out-degree ≥ 1, so 2G ≥ (L + G) − 1, G ≥ L − 1. T leaves do not cover any input value; your cover uses A only. Correct.
- h = hcmp + max(und, hcmp, cov): cmps and cmovs are disjoint, copy costs ≥ 1 cmov. Correct.

## Minor
- `recover()`: the T register name `S<nextS+1>` can later be written by a copy; only the printed witness is affected
  (relaxed semantics: read before write = T). Witnesses pass the strict judge anyway; not a soundness issue.
- Claim lines: add the chain step "=> no MM program of length ≤ K+2n (L5, MM-1), AlphaDev counting" so n, k, R, I, C are
  all explicit.

## How enum's result enters the chain
"none ≤ K" in relaxed M_out over W ⊇ permutations => (L1b, L2) no strict M_out program of length ≤ K => (L5, MM-1) no MM
program of length ≤ K + 2n. No padding/sweep issue: the cost-bounded BFS covers every length ≤ K.
