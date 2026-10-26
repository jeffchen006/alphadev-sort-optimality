# theory — round 5 report (2026-10-24 23:24)

## Done
1. **Reviews of the new claims**
   - **lean-reflect** `sort3_mm_lb : ∀ q, MMProg 3 q → q.length ≤ 16 → ¬ XCorrect 3 q` is **exactly MODEL §4.2**:
     - load / store / register mov allowed; cmp and cmov on registers only; no cell-to-cell mov;
     - all 32-bit inputs, garbage and flags; every instruction counts; I1; unbounded registers.
     - Trust: Lean kernel + native_decide.
     - The second proof `sort3_rs_lb_G` (set model + S3 symmetry): the statement is correct.
   - **coq** `lower_bound_set'` (set model; R ≥ n; I1; relaxed; perms): the statement is correct.
     - Trust: Coq kernel + extraction + OCaml (the premise `set_okb` is evaluated by extracted code) + PrimInt63.
     - It is an RS-level result; MM follows by L5.
   - **proofs CakePB** k = 7, 8: a full chain (verified encoder, dominance rules, LRAT) in ONE CakePB-checked proof. This is a pipeline check only; k = 10 needs more memory.
   - **sat 21:19** (no hcmp cut) and **sat2's CNF** (checked by proofs with cake_lpr): both use only reviewed rules. So there are 3 independent cake_lpr certificates for sort3.
   - **x86**: the certified ACL2 x86isa model and real hardware agree on 81 000 vectors. This is semantics validation (testing), not an equivalence proof with the Lean semantics.
   - **lean-lrat**: the class cut (hcmp part 2) and snapcmov are proved in Lean; statements correct.
   - **sat2**: NOP mode and the n=4 cube split (#cmp = 5..9, #cmov ≥ 10) are sound.
   - **latency**: B and C are closed.
2. **Paper**
   - New **Theorem (sort3)**: "In M_AD(3, I1) … no program of length ≤ 16 sorts; AlphaDev's 17 is optimal", quoting `sort3_mm_lb`.
   - The trust table now has 10 routes with their exact trust bases:
     - end-to-end Lean;
     - Lean set model;
     - 3× cake_lpr;
     - Coq;
     - lean-lrat (k = 10 pending);
     - CakePB (k ≤ 8);
     - enum/critic and bounds as cross-checks.
   - The abstract now says "certified by cake_lpr and end-to-end in Lean". The paper is 15 pages and compiles.
3. **H3' for coq** (`agents/theory/H3prime.md`): it is now a potential lemma.
   - Φ = |U| + max_{j∈U}(cover_j − 2). Each cmov lowers Φ by at most 1; a cmp does not change it.
   - The proof uses facts F1 (a cover drops by ≤ 1), F2 (creating t_k never lowers cover_j for j ≠ k on strict permutations) and F3 (cover_k ≤ 2 when t_k is created).
   - Coq's proposed invariant had F1 but needed F2 + F3.
4. **I2 (spec §4.6), new L11**:
   - L5 carries over.
   - xchg is redundant in RS and M_AD (delete it and rename the two registers after it). So M_AD lower bounds in I2 reduce to I1 + cmove/cmovne.
   - Strict checks need 4 initial flag states; the relaxation stays sound.

## Open
- l5_strict (lean) is needed if the sort4 certificate (coq / lean-reflect from enum) uses NG. I asked coq and lean.
- sort4: enum k = 19, sat2 cubes c = 5..9, checkers with H3'. sort5: split runs.
- lean-lrat k = 10 (sort3); CakePB at k = 10 (memory).

## Next
Review the sort4 claims and the sort4 certificate end theorem (relaxed or strict). Write the sort4 theorem text when it lands.
