# critic — round 3 report (2026-10-24)

## Done
1. **n=3 certificate status (brief item 1).** No cake_lpr VERIFIED_UNSAT for the target yet:
   - proofs `symcert/rc_ll_k10_inp/F1.cnf` (lean-lrat verified enc + canon/pcanon, VeriPB-derived): cadical running
     (tlim 72000 s). I regenerated F0/F1: same clauses, same F0 sha256; VeriPB DERIVABLE (R23).
   - lean-lrat `n3_I1c_k10` (verified enc with canon INSIDE the Lean encoder, proved sound in Lean): `c UNKNOWN` so far;
     k ≤ 9 LRATs exist (k=9: 854 MB). Test end theorem for k=7 composes cert → x86 in one build.
   - sat2 final CNFs k=1..10: all UNSAT on my re-run (k=10 by kissat, 1383 s). Unverified encoder + paper rules.
   - Sweep / padding: lean-lrat path needs no sweep (no instruction-removing rules; lean pads exactly-K to ≤ K).
     sat2 path sweeps k=1..10 (needed, rules remove instructions): present.
2. **Lean statements (item 2).** NEW and checked: `mm_lower_bound` (lean, L5.lean): rule-free RS hypothesis at K ⇒ no
   MM program (cells only via mov, cmp/cmov on registers = MM-1) of length ≤ K+2n is x86-correct. Builds, axioms
   propext/choice/Quot.sound only. This is exactly the paper's M_AD statement (R24). lean-lrat now vendors lean's files
   byte-equal (incl. Snap, L5); canon is proved in Lean. Left: K=10 instance + end theorem via `mm_lower_bound 3 10`.
   lean-reflect / coq: no new top-level statement.
3. **CPU (item 3):** 141 → 78.9 of 96 (enum pinned to 40).
4. **MM+ sort3 (spec's round-3 question): upper's L=15 is OPTIMAL.** Own C++ search on the exact §4.5 state
   (`agents/critic/bf_mm.cpp`, h in BF_NOTES): no MM+ program for L ≤ 14 (I1, 13 weak orders, unbounded registers,
   T-relaxed); SAT at L=15 with an I0-only witness (`programs/found/critic_sort3_memplus_L15.s`, judge --strict PASS).
   Validation: n=2 MM 8 / MM+ 7; n=3 MM: none ≤ 15 (stopped; L5 + RS gives 17).
5. Confirmed: upper round-1 files (sort5 MM+ 39, RF sort5 k=33, RF sort4 k=20), proofs VeriPB rerun, sat2 CNFs.

## Numbers
| claim | n | model | I | result | status |
|---|---|---|---|---|---|
| AlphaDev optimal | 3 | M_AD (MM-1), L = 2n+k | I1 | no L ≤ 16 | 3 tools agree (critic, enum, sat2); certificate pending |
| MM+ optimum | 3 | MM+ | I1, I0 | L = 15 | critic tool only; second tool + h review asked |
| MM+ upper bounds | 2/3/4/5 | MM+ | I1 | 7/15/26/39 | all strict-checked |

## Open
- T20: the n=3 certificate (either path). T18: one end theorem through `mm_lower_bound 3 10`.
- MM+ n=3 = 15 needs an independent second tool.
- n=4 (k ≤ 19) and n=5 (k ≤ 31): only certificates can be checked by me.

## Next
Re-check the first VERIFIED_UNSAT for n=3 (CNF sha = lean-lrat enc output? K? rules?) and the Lean end theorem.
