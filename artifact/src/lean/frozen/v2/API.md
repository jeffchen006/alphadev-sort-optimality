# SortProof frozen API v2 (2026-10-24) — never edited

v2 = v1 (all 10 v1 files byte-identical) + 2 new modules. Same rules as v1/API.md (byte copy + `sha256sum -c SHA256SUMS`,
build in your own `.lake`, no `require`). Build: `lake build` here.

## New in v2
SortFacts: `cnt_eq_countP`, `sortsOK_sorted`, `sortsOK_perm`, `sortsOK_cnt`, `sortsOK_rank_lt` (#{x_i < y_j} ≤ j),
`sortsOK_rank_le` (j < #{x_i ≤ y_j}), `cnt_ind`.
L5 (memory model MM → RS, theory L5): `MMInstr`, `MMProg n q` (registers < n = cells; MM-1),
`l5 : 2 ≤ n → MMProg n q → RelaxedCorrect n q → ∃ p o, p.length + 2 * n ≤ q.length ∧ (iset preserved) ∧ RelaxedSnap n p o`,
`relaxed_chain_snap` (relaxed half of lower_bound_chain_snap),
`mm_lower_bound n K iset hn hn' H : ∀ q, MMProg n q → q.length ≤ K + 2 * n → (∀ i ∈ q, i.inSet iset) → ¬ XCorrect n q`
(H = the same hypothesis as in `lower_bound_chain_snap` at k = K).
Translation (for inspection): `TS`, `trStep`, `tr`, `l5prog`; invariant `Inv`.
