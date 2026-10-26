# ENCODING_CERT — certify "the CNF means the model" (proofs, with lean / lean-lrat)

Version 1, 2026-10-24. Proposal, to agree with `lean` and `lean-lrat`.

## 1. The chain we want (sort n, length k, model M_out snap, I1, R = n + k)
```
 (a0) paper (theory L5): AlphaDev memory model M_AD (length L)  <=  register snapshot model RS, k = L - 2n (MM-1) — NOT yet in Lean
 (a) Lean (lean):      x86 register snapshot programs (XSnap)  <=  relaxed snapshot model (Relax.lean, Snap.lean, Rename.lean: R = n+k)
 (b) Lean (lean-lrat): prog relaxed-correct on types T  =>  enc n k I1 T  is SAT        (Sound.lean, no rules)
 (c) VeriPB/CakePB:    enc SAT  =>  F1 SAT          (symmetry breaking, `dom`/`red`, output DERIVABLE)  [optional]
 (d) cake_lpr and/or Lean verifyCert:  F1 UNSAT  (or enc UNSAT directly when no SB is needed)
```
(a)+(b)+(d) is machine-checked when no symmetry breaking is used; (a0) is paper-only (critic R21). Final n=3 claim
must cite the chain on lean-lrat's enc (symcert/ll_k10 F0 rule-free, or F1 with VeriPB-certified canon), not sat's encoder.
(c) lets the solver use symmetry breaking without any new Lean proof per rule, as long as the rule is a literal
symmetry of `enc` (canon, and pcanon when all types are present).

## 2. Link between the Lean theorem and the files the C/CakeML checkers read
Problem: the Lean theorem is about the Lean term `enc n k i1 T`; cake_lpr reads a DIMACS file.
Options:
1. **Same file, two verified checkers.** `lrat-tool dimacs` writes `enc` as DIMACS; `lrat-tool check` (compiled
   `checkCert`, same code as the theorem) and cake_lpr both check the SAME CNF + LRAT. The theorem's `native_decide`
   instance is the trusted link inside Lean; cake_lpr is an independent second check of the file. Trust for the
   file link: the DIMACS printer `CNF.dimacs` (small, unverified) + Lean compiler.
2. **Kernel-checked printer (stronger).** Prove in Lean `parseDimacs (dimacs c) = some c` (round trip) or make the
   theorem quantify over the parsed file: `parseDimacs file = some c -> c = enc n k i1 T` checked by `decide`
   (cost: kernel evaluation of a 1 MB string; feasible for sort3, maybe sort4).
3. **CNF hash in the claim.** Every claim line states sha256(CNF) and sha256(LRAT); check_unsat.sh logs both.
   Anyone re-runs `lrat-tool dimacs ...` and compares the hash. This is cheap and should be done in all cases.

## 3. sat's / sat2's encoders (fast, unverified) — how to link them
- **Differential test** (done for sat, `enccheck/diff_test.py`, own simulator): random program P + random output
  choice + one order type t: "CNF_t with P fixed by units is SAT" == "simulator says P correct on t".
  sat encode.py (frozen `vendor/sat_2bb2bc0bd534`), n=3, k=2/4/6, modes snap/free/fixed, I1: 13500 cases, 0 mismatch
  (log `enccheck/diff_test_sat_2bb2bc0bd534.log`). Same test for sat2 and for lean-lrat's enc: TODO.
- **Clause-set equality with the verified encoder** where the encodings coincide: not expected (different variable
  orders / aux vars). Instead: **equisatisfiability by cross-check** = both UNSAT at the same k (sat, sat2, lean-lrat, enum).
- Final claims should cite the verified chain (lean-lrat enc + cake_lpr), and use sat/sat2 only for speed/exploration.

## 4. Requests
- lean-lrat: (i) emit a variable-name map next to the DIMACS (`c v <id> dst <t> <r>` etc.), so `symcert` can build the
  scratch-swap witnesses from names and certify canon on top of `enc` (one-hot + pairwise AMO = literal symmetric, I
  check sigma(F0) = F0 by script; VeriPB checks it again). (ii) run `lrat-tool check` on cake_lpr-checked LRAT files
  of `enc` (n=3 k=10) so the same file gets two verified checks. (iii) state the exact trust list of `checkCert`
  (native_decide = `Lean.ofReduceBool` + compiler).
- lean: (i) a Lean statement for "F0 SAT => F1 SAT" is not needed if (c) is done by VeriPB/CakePB; (ii) for rules that
  are not literal symmetries (comm, dead, flags, cmpord, movfresh) a Lean normal-form lemma is the planned path
  (theory G3) — then lean-lrat's encoder must emit the rule clauses too and Sound.lean must use the normal-form lemma.
