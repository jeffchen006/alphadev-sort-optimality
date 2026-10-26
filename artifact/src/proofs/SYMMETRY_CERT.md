# SYMMETRY_CERT — how to certify the symmetry breaking (owner: proofs; witness design + soundness: theory)

Version 1, 2026-10-24. Theory's survey and fit table: `agents/theory/veripb_plan.md`.

## 1. The gap
A DRAT/LRAT proof checked by cake_lpr proves only: "the CNF F1 = F0 + SB is UNSAT".
We need: "F0 is UNSAT" (F0 = rule-free encoding of the model). Needed extra fact: **F0 SAT => F1 SAT**.
Today this fact rests on paper proofs (`agents/sat/RULES.md`, `agents/theory/lemmas.md`) and on the encoder code
for each rule. Goal: replace both by a machine-checked certificate.

## 2. Options (ranked)
| # | method | covers | cost | status |
|---|---|---|---|---|
| A | **No rules**: solve F0 directly; DRAT/LRAT + cake_lpr | everything (no SB at all) | solver time grows fast (scratch symmetry k!) | sort3 old model k=9: done (cadical 555 s, cake_lpr 166 s). Target sort3 (I1, snap, k=10): RUNNING |
| B | **VeriPB dominance** (BGMN 2023): proof F0 -> F1 with `dom` steps, `output DERIVABLE FILE`; then cake_lpr on F1 | literal symmetries of F0: scratch renaming (canon), input renaming (pcanon, if one-hot) | small: proof is O(rules), check < 1 s for sort3 | **canon + pcanon: DONE** for sat's and lean-lrat's encoders (§3, §3b) |
| C | satsuma (proof-logging version): automatic symmetry detection, lex-leader + VeriPB proof, or "fix" mode + SR proof (dsr-trim) | all literal symmetries it finds | tool build | build blocked (needs user OK) |
| D | Lean: rule lemma "every program has an equivalent normal-form program, not longer" + verified encoder that emits the rule clauses | all rules incl. comm, dead, flags, cmpord, movfresh | large (Lean formalization) | `lean`/`lean-lrat` plan (ENCODING_CERT.md) |
| E | VeriPB with extension variables for non-permutation rules (comm swap, dead-code removal, cmp flip) | comm, dead, flags, cmpord | very large (witness needs new state vars + subproofs) | not planned |

Decision proposal: A for sort3 (and sort4 if feasible), B for canon/pcanon everywhere, D for the remaining rules
(comm, dead, flags, cmpord, movfresh) used for sort4/sort5. Reported claims say which path certified each rule.

## 3. Method B in detail (implemented: `symcert/canon_pilot.py`)
Inputs: sat's encoder `encode.Enc` (frozen copy `vendor/sat_<sha>`), rules=() and **pairwise at-most-one**
(sat's sequential-counter AMO for rows > 6 literals is not invariant under register swaps; `SymEnc` overrides it).
1. F0 = rule-free CNF. The script builds each adjacent scratch swap sigma_j (S_j <-> S_{j+1}) as a literal map
   (selectors d/s, output map, per-register value rows of every order type) and **checks sigma_j(F0) = F0 as clause sets**.
2. Order `lexsc`: O(u, v) := num(u) >= num(v), num = binary number of the d/s scratch-selector literals, bit order
   (step i, d before s, scratch index) from most to least significant. Transitivity proof: one `pol` step.
3. For each j: `dom C_j : sigma_j` with C_j = O(x, sigma_j x) (column j >=lex column j+1, i.e. S_j is first touched before
   S_{j+1}). Proof goals: the F0 clauses map to F0 clauses (autoproved); strictness goal: one `pol` step.
4. Order unloaded. Fresh vars t[i][j] <-> "S_j touched at a step < i" by `red` (witness t -> 0 / t -> 1), then the canon
   clauses `d[i][S_j] -> t[i][j-1]`, `s[i][S_j] -> t[i][j-1] | d[i][S_{j-1}]` by `rup` (PB propagation on C_{j-1}).
   All of them moved to core (`core id -1`).
5. `output DERIVABLE FILE` against F1.opb (= F1.cnf, checked clause by clause by `symcert/same_clauses.py`).
Meaning (VeriPB soundness, BGMN 2023 Thm.): every step keeps "if F0 is SAT then core u derived is SAT", so
**F0 SAT => F1 SAT**. With cake_lpr "F1 UNSAT" this gives **F0 UNSAT**. (theory: please confirm the DERIVABLE guarantee wording.)

Commands (sort3 target model: n=3, I1, snap outputs, k=10, R=13, all 13 weak orders):
```
python3 symcert/canon_pilot.py --satdir vendor/sat_2bb2bc0bd534 -k 10 --outmode snap --out symcert/k10_I1_snap
tools/bin/veripb symcert/k10_I1_snap/F0.cnf symcert/k10_I1_snap/canon.pbp symcert/k10_I1_snap/F1.opb   # s VERIFIED OUTPUT DERIVABLE (0.15 s)
python3 -I symcert/same_clauses.py symcert/k10_I1_snap/F1.cnf symcert/k10_I1_snap/F1.opb                 # SAME
./check_unsat.sh symcert/k10_I1_snap/F1.cnf                                                              # cake_lpr (running)
```
Numbers: F0 9053 vars / 62102 clauses; F1 9143 / 62632 (350 definition clauses, 180 canon clauses); 9 dom steps.
Negative tests (k=4, all REJECTED by VeriPB, as required): wrong witness (state rows not swapped), an extra
unjustified clause in the output, the canon constraint in the wrong direction.

Limits / trust:
- VeriPB 3.0.2 is not verified. CakePB (verified) exists as prebuilt `.S` (Zenodo 17609070, `cnf/cake_pb_cnf.S` supports
  VeriPB 3.0 syntax); compile = `gcc basis_ffi.c cake_pb_cnf.S` (same as cake_lpr). Blocked by the session permission
  check; needs the user's OK. Then: `veripb --elaborate` -> `cake_pb_cnf F0.cnf canon.elab.pbp F1.cnf`.
- F1 for the solver here is MY F1 (canon only), not sat's CNF with all rules. sat's own canon clauses differ (they also
  delete variables). Either sat adopts F1-style output (F0 + SB clauses on top, same numbering), or I re-derive sat's
  clauses with `rup` from C_j (planned; needs the definitions of sat's aux vars).
- canon here is the variant "first touch, dst before src"; sat's RULES.md canon is the same order. pcanon (inputs) can
  be done the same way only in snap/free modes (input swap must also permute the order types: sigma maps type t to
  t o pi, which is a literal permutation only when ALL types are present, i.e. not for CEGIS subsets).

## 3b. pcanon (input registers) — DONE: `symcert/regcanon.py --inputs`
An input swap tau = (P_a P_b) is a literal symmetry of F0 only together with the type map y -> y o tau
(P' = P with P_a, P_b renamed computes on y what P computes on y o tau), so the witness also maps every per-type
variable (type y -> type y o tau; sat's value 'holds x_u' -> 'holds x_tau(u)'; lean-lrat's rank values unchanged;
snapshot slot "P_r at time 0" -> P_tau(r)). Needs a type set closed under tau (all weak orders / all permutations).
One order for all steps: columns = d/s selectors of ALL registers (step-major, d before s, register-minor).
Result (lean-lrat verified enc, n=3, k=10, I1, snap, 13 types): 11 swaps verified as literal symmetries
(9 scratch + 2 input), 11 `dom` steps, `s VERIFIED OUTPUT DERIVABLE`; F1 = 82679 clauses (455 defs, 220 SB).
Same check passes for sat's encoder (k=4). Files: `symcert/rc_ll_k10_inp/` (sha256.txt). F1 UNSAT run: RUNNING.

## 3c. CakePB (verified) end-to-end — DONE on k=4, k=10 pending the LRAT
`symcert/full_proof.py F0.cnf F1.cnf sb.pbp F1.lrat full.pbp` builds ONE kernel proof: elaborated SB prefix (dom/red/rup)
+ the LRAT of F1 as `rup C : ~ hints` (IDs remapped; F1-only clause IDs read from the prefix's `core id` lines and
checked by VeriPB probes) + `conclusion UNSAT`. Then `tools/bin/cake_pb_cnf F0.cnf full.pbp` -> `s VERIFIED UNSAT`
= F0 UNSAT, checked by CakePB only. With F0 = lean-lrat enc this needs NO unverified checker.
Test n=3 k=4 canon+pcanon (rc_t4): VERIFIED UNSAT (0.9 s); VeriPB agrees. Negative: broken dom witness and a removed
hint are rejected by CakePB.

## 4. Interaction with CEGIS subsets
UNSAT for a subset T of order types implies UNSAT for all types (more types = more clauses). No certificate needed
beyond "F0(T) is a sub-CNF of F0(all)" (true by construction: add_type only adds clauses). But symmetry B must be a
symmetry of F0(T): scratch swaps are (they do not touch types); input swaps are not (they permute types).

## 5. Next
0. theory confirmed (inbox 19:05) the statement: "F0 satisfiable => F0 + SB satisfiable", F0 = rule-free CNF of the
   claimed model; remaining trust = the F0 encoder only (closed by lean-lrat's Sound.lean for its enc).
1. Results of the sort3 target runs (F0 and F1, cadical + kissat paths) -> board/claims.md.
2. With sat: emit their final CNF as F0 + SB with stable numbering; certify canon on THEIR clauses.
3. With theory: witness design for pcanon (needs all types) and a statement for each remaining rule (path D).
4. CakePB / satsuma / dsr-trim builds after the user's OK.
