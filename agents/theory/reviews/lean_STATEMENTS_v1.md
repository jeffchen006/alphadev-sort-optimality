# Review of agents/lean/STATEMENTS.md (v1) — theory, 2026-10-24

**Verdict: the statements say what the paper lemmas say.** Checked against lemmas.md / paper/appendix_proofs.tex:
- SortsOK = by value (mergeSort of the input list), so duplicates are judged by value. OK.
- XState has cf, zf, sf, of; XCorrect / XSnap quantify over every register file and every flag combination: strict model. OK.
  Cond.xeval matches the SDM table; xeval_eq gives the 3-valued flag (L2 remark on 4 real states). OK.
- snapOut = register (o j).1 after the first (o j).2 instructions (`p.take`): exactly RS. Positions > length clamp. OK.
- RelaxedCorrect / RelaxedSnap: any T above all inputs, scratch = T, flag eq. Slightly STRONGER than needed (all T, not only
  INT_MAX) and x86_to_relaxed / xsnap_to_relaxed close the gap with inputs < INT_MAX. Correct = L2.
- register_bound(_snap) via `compact`: unwritten scratch all map to one index; needs a cmp (relaxed_snap_has_cmp) = L3. OK.
- lower_bound_chain_snap: hypothesis = exact length k, registers < n+k, snapshot positions <= k; conclusion = no program of
  length <= k. This is L4a (padding, NO rules). OK for rule-free runs only.
- Order type: run_strictMono, index_pattern, correct_transfer, strict_iff_reps, x86_iff_reps, reps_card (13/75/541) = L1. OK.

Gaps (known): G2 (L5, MM -> RS) and G3 (rules). Two more remarks:
1. The final theorem must be about MM. Proposed statements:
   `def MMProg (n : Nat) (q : Program) : Prop := ∀ i ∈ q, match i with
      | .mov d s => ¬ (d < n ∧ s < n)          -- load, store, or reg-reg move; no mem-to-mem
      | .cmp a b => n ≤ a ∧ n ≤ b              -- MM-1: no memory operand
      | .cmov _ d s => n ≤ d ∧ n ≤ s`
   MM semantics = the existing RF semantics with registers < n read as cells (RelaxedCorrect / XCorrect on q). Then
   `theorem l5 : MMProg n q → RelaxedCorrect n q → ∃ p o, p.length + 2*n ≤ q.length ∧ RelaxedSnap n p o` (n ≥ 2), and
   `theorem main (H : ∀ k' ≤ K, rule-free search hypothesis at k') : ∀ q, MMProg n q → q.length ≤ K + 2*n → ¬ XCorrect n q`.
   Reference implementation of the translation: agents/theory/l5map.py (per-segment registers; tested on all n<=5 programs).
2. Upper bound: alphadev_sortN_x86 uses XCorrectO (outputs at the END = RE core). For the paper, also prove
   `MMProg n q ∧ XCorrect n q` for the memory programs themselves (programs/orig/*, P = cells): that is the claim "L_AD is
   achievable in MM".
