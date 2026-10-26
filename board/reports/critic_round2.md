# critic — round 2 report (2026-10-24)

## Done
1. **Certificates (n=3, RS, I1, k ≤ 10).** No final cake_lpr result yet. Checked what exists:
   - proofs `symcert/rc_ll_k10_inp`: I regenerated F0 from lean-lrat's verified encoder (sha256 1ebfc073… = theirs), F1
     (canon + pcanon) = theirs clause by clause (sha differs only by a path in a comment), VeriPB: VERIFIED OUTPUT
     DERIVABLE. cadical + cake_lpr on F1 is running (tlim 20 h). Earlier k10 runs on sat's encoder: SOLVER_FAIL(143).
   - sat2 final-subset CNFs `agents/sat2/cert/s3_I1_out_k{1..10}.cnf`: SHA256SUMS OK; my cadical: k=1..8 UNSAT; k=9, 10
     running. These CNFs contain sat2's rules + #cmp ≥ 3 and an unverified encoder: a cake_lpr check on them certifies
     only "this CNF is UNSAT". Sweep k = 1..10 is present (needed, rules remove instructions).
   - The ONLY chain without trusted paper rules is lean-lrat enc (no rules) → cadical → cake_lpr (or Lean verifyCert).
     With canon/pcanon it adds trust in VeriPB (unverified until CakePB runs).
2. **Lean statements** (review R20): lean's `lower_bound_chain_snap` states n, k, R = n+k, iset, RS outputs, x86 32-bit
   strict conclusion — correct. NOT in Lean: L5 (M_AD → RS, +2n, MM-1), symmetry rules. GAP: lean-lrat re-defines
   Snap/RelaxedSnap in its own SnapDefs.lean (same text, separate constants), so no single theorem composes the
   certificate with the x86 chain yet (sent fix to lean + lean-lrat). native_decide (Lean.ofReduceBool) must be listed.
   lean-reflect: prototype, permutations only (sound for lower bounds). coq: no statement yet.
3. **Ullrich & Hack** (R19): spec's reading confirmed from the paper text (fixed outputs r1..rn, I0 explicitly,
   permutations only, m = 1 for n ≤ 5 by the table arithmetic, m = 2 for n = 6) + one more restriction: no reads of
   uninitialized registers. Their n=4 "no 19" is not an AlphaDev bound.
4. **CPU watch:** reported 117 and 141 cores (cap 96, enum 84) to the coordinator and enum; now 78–96.
5. **THREATS.md v2:** 20 threats; CLOSED 12 (T5 closed NEGATIVE: with memory source operands sort2/3/4/5 = 7/15/26/40
   < 8/17/28/42 — critic re-checked all four programs, R22; MM-1 must be in the theorem), PARTIAL 7, OPEN 1 (T20: n=3
   certificate).
6. Other confirmations: proofs VeriPB canon+pcanon (R23), enum PRUNING, sat RULES, bounds BOUNDS (R16–R18),
   bounds mincmov n=3 = 6, x86 opcode tests. theory reviewed my BF_NOTES: sound.

## Numbers (n=3, RS, I1, T-relaxed, 13 weak orders, R unbounded, C = AlphaDev, MM-1)
| tool | result | certificate |
|---|---|---|
| critic bf (IDDFS) | none k ≤ 10 | no (128-bit hash TT) |
| enum (set-model BFS) | none k ≤ 10 (re-run by me) | no |
| sat2 (CEGIS, rules) | UNSAT k = 1..10 | CNFs posted; my cadical k ≤ 8 UNSAT; cake_lpr: not yet |
| proofs (lean-lrat enc + VeriPB canon/pcanon) | F1 solving | pending |

## Open
- T20: n=3 certified result (cake_lpr on rc_ll_k10_inp/F1 or on the rule-free F0).
- Lean composition (one end theorem) and L5 formalization (or paper wording).
- MM+ n=3: is 15 optimal? I run it now (agents/critic/bf_mm.cpp; validated n=2: MM 8, MM+ 7): none for L ≤ 13 so far.

## Next (round 3)
Re-check cake_lpr logs + hashes when they land; finish MM+ n=3; review lean-lrat end theorem when posted.
