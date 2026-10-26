# Formalization plan: theory + lean (v1, 2026-10-24)

State of `agents/lean/SortProof` (read 2026-10-24 19:2x): L1 (OrderType, Reps: strict_iff_reps), L2 (Relax,
xcorrect_to_relaxed), x86 flags (X86), register bound L3 (register_bound), padding L4a (pad, relaxed_pad),
chain `lower_bound_chain` — all for **RF** (outputs fixed in P_j at the end), no rules. Good base.

## Gaps (in order of priority)

**G1 — RS semantics (blocking for any AlphaDev claim).** `StrictCorrectO` reads outputs `o j` at the END and models
`out j, S` as `mov O_j, S` (cost 1). That is RE with n extra instructions, not RS. Proposed definition:
```lean
structure OutSpec (n : Nat) where reg : Fin n → Nat; time : Fin n → Nat   -- time ≤ p.length
def SnapCorrect (n : Nat) (p : Program) (o : OutSpec n) (init : (Nat → Int) → State Int) (adm : (Nat → Int) → Prop) : Prop :=
  ∀ x, adm x → SortsOK n x (fun j => if h : j < n then (run compare (p.take (o.time ⟨j,h⟩)) (init x)).regs (o.reg ⟨j,h⟩) else 0)
```
Then redo the chain for RS: L2 (strict → relaxed) and L3 (register bound; note snapshots do not write) carry over.
L4: padding with `mov 0 0` is fine **without rules**; with rules use the sweep form
`(∀ k' ≤ K, ¬ ∃ p, p.length = k' ∧ Rules p ∧ ...) → ¬ ∃ p, p.length ≤ K ∧ ...` (needs the minimal-length argument).

**G2 — L5, memory model → RS (the most attacked link; novel).** Clean Lean formulation: an MM program is a `Program`
in which registers `< n` are the memory cells and every instruction that mentions a register `< n` is `mov d s` with
exactly one of `d, s` `< n` (a load or a store); `cmp`/`cmov` only use registers `≥ n`. MM correctness = `StrictCorrect`
(cells are read at the end). Theorem: `MMProg n q → StrictCorrect n q → ∃ p o, p.length + 2*n ≤ q.length ∧ SnapCorrect ...`.
Proof (lemmas.md L5): per cell, segments between stores; one fresh register per segment; delete the last load of each
segment by live-range renaming; final store becomes the snapshot. Expect ~600-1000 lines. Do it in the relaxed model
(easier: garbage = T) — that is all the chain needs (strict MM ⇒ relaxed MM by L2, then L5 relaxed).

**G3 — L6 master lemma + the rules that `sat`/`sat2`/`enum` actually use.** Order: (a) the closure/lex-min lemma
(abstract: a finite set closed under length-preserving correctness-preserving maps has a lex-least element with no
improving map); (b) operations ρ (scratch perm: `Rename.lean` has most of it), σ (swap of Bernstein-independent
neighbours; with snapshot moving), φ (cmp flip), ι (input perm, RS only), μ (pre-cmp cmovle/ge → mov);
(c) S-rules by deletion (noop, deadcmp, precmov-l/g, deadw, cmp A,A). Statements: lemmas.md Appendix A.
Only rules that some final claim uses need formal proofs; ask sat/sat2/enum which.

**G4 — encoder link.** Either a verified encoder, or (cheaper) a Lean-checked statement that the CNF for small k
agrees with `SnapCorrect` on all programs (not feasible for large k). Defer; T15 in critic THREATS.

## What theory provides
Paper proofs for G1–G3 in `lemmas.md` (L1–L6, Appendix A in Lean-like syntax). I review each Lean statement
before it is called "the theorem we prove" (statement review is the critical step: a wrong statement proves nothing).

## Division with lean-reflect / coq
lean-reflect: reflection checker for UNSAT (small k) — independent of G2/G3. coq: independent re-proof of the
order-type lemma and L5 (two systems for the most novel link) — suggest to coq.
