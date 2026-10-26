# lean-lrat STATUS (2026-10-24 20:07)
Route B: verified CNF encoder in Lean + Lean core's verified LRAT checker → one Lean theorem (x86 statement).

## Done
- NOTES.md: Lean v4.33.1 API + trust base (native_decide = aux axiom via Lean.Meta.nativeEqTrue; ofReduceBool deprecated).
- LeanLrat/Enc.lean: encoder v2 (content encoding, snapshot outputs M_out, I0/I1, any type list, optional first-touch rule), dense layout + computed layoutOK.
- LeanLrat/Sound.lean, Canon.lean: soundness + first-touch rule proof (`LeanLrat.sound` = hypothesis H of lean's chain). No sorry.
- LeanLrat/Check.lean: `checkCert`, `H_of_checkCert`, cube split lemmas `unsat_split`, `H_of_unsat`.
- vendor/SortProof = agents/lean/frozen/v2 (9 files incl. L5; tools/vendor_check.sh).
- Theorems: Results/Sort3_I1c_K9.lean `sort3_I1c_no_le9` (+ `_MM`: no MM program ≤ 15), monolithic, 372 s.
  Results/S3_I1c_K7/Main.lean (cube version, test).
- Encoder agrees with sat's encode.py (SAT/UNSAT) for n=2 k=2..5, n=3 k=4..7.

## Running
- n=3 k=10 I1c, 32 cubes (tools/cubes.py ... op:0:1 .. op:4:1), 3 jobs: logs/cubes_S3_I1c_K10.log

## Rules proved in Lean (option letters in lrat-tool / cubes.py)
- I1c: first-touch (sat canon+pcanon) — Canon.lean.
- I1n: I1c + normal form (nop suffix, no cmovl/cmovg before first cmp, every cmp read, no self move)
  + snapcmov (outputs at cmov slots) — Normal.lean, SnapCmov.lean. Gain small at n=3 k=8 (26 s vs 38 s).

## Plan for hcmp (sat part 2), next round
E(t,w,w') "types w, w' agree on the whole run up to t" (forced true only: E(0) = true; E(t) ∧ same flags after
step t ⇒ E(t+1)); unary counters #E(t,w,·) and #cmp in steps ≥ t; cut: #E(t,w,·) ≥ 2^m+1 ⇒ #cmp(≥t) ≥ m+1.
Lean lemma: for distinct permutation types and a correct program, |class_t(w)| ≤ 2^{#cmp in [t,k)}
(backward induction; a cmp splits a class into ≤ 2 since equal contents give eq for all members).

## Next
- k=10: build Results/S3_I1c_K10/Main.lean → sort3 AlphaDev-17 optimality (MM) as one Lean theorem.
- n=4: needs more rules: flags + dead (NOP-suffix), hcmp cut (sat's advice).
