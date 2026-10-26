# Codex review of the sort4 proof chain (2026-10-25 07:48)
Reviewer: Codex (gpt-6.1-sol, high effort, read-only); triage by claude agent "codex". Inputs: shared/MODEL.md, agents/enum/PRUNING.md v3,
agents/theory/lemmas.md L1-L10, agents/theory/reviews/*, agents/lean-reflect/LeanReflect/NG*.lean, Basic.lean, STATUS.md.
Result: NO unsound rule found, NO counterexample, NO weaker-model statement. Dependencies of the NG theorem: propext, Classical.choice, Quot.sound; no sorry.
Raw output: agents/codex/out1.md.

## Findings (after my check)
1. [Medium, integration] lean-reflect's `SortProof/` is a copy of lean frozen/v2. v2 has L5 only to `RelaxedSnap`.
   `NGMain.lower_bound_strict` (NGMain.lean:10) concludes `¬ XSnap`. The link XSnap -> M_AD (MODEL 4.2) is
   `mm_lower_bound_strict` in lean/frozen/v3/SortProof/L5Strict.lean (exists, takes H : ∀ p o, |p| ≤ K → ... → ¬XSnap).
   Codex did not see v3. Open item: lean-reflect must import v3 (or the final theorem must be stated with it) and use K = 19 (19 + 2n = 27).
   Codex flagged this as "High"; I rate it Medium: the lemma exists, only the final composition is missing.
2. [Medium, pending] The NG certificate is accepted only up to KB = 15 (STATUS.md:32). The sort4 claim needs KB = 19. Known; not a flaw.
3. [Low, doc] L10 text (lemmas.md:395) and Lean (NGDefs: "accessed") agree. But the wording "written register" in PRUNING.md (NG paragraph)
   and the garbage-register definition differ. Example: `mov 4,5; cmp 0,5` is NG-normal in Lean (5 is accessed after the mov
   but never written). This is sound (the ng_rewrite proof is checked in Lean) but enum must accept exactly the Lean class or a subset.
   Enum = Lean counts agree for KB 13, 14 (48 / 379). Action: enum states the NG condition as "accessed".
4. [Low, doc] lemmas.md:490 (appendix): "rank_w(label) = j" fails for tied inputs (all-equal input: every rank is 0). Lean `SortsOK` uses the
   sorted value list, so Lean is correct. Lean tests use strict permutations only (subset: sound). Action: theory fixes the appendix text.
5. [Low, completeness only] PRUNING.md:89 h = hcmp + max(und, hcmp, und + max cover - 2); Lean Basic.lean:211 h = hc + max(und, und + maxCover - 2)
   (no hcmp inside the max). Lean's h is smaller or equal: still admissible. Risk: at KB = 19 the cert from enum may contain prunes that
   the Lean h cannot reproduce -> checker rejects (not unsound). lean-reflect STATUS says "H2 not needed (same counts)" at KB <= 14.
