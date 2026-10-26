# coq — round 2 report (2026-10-24 22:00)

## Done
1. **Speed (register checker, sort3).** Quick wins (linear rev, lazy mark, cheaper hash): check 21 s → 14.5 s at k = 9
   (1.4k states/s, 1 core). Proved chunk split (`Inst.lower_bound_par`: N chunks by index mod N, one forked process
   each, `extract/v5`): 3 chunks → 2.6k states/s. The 50k states/s target is NOT reached; see estimate below.
2. **Set-model checker for enum's certificates** (`src/SetModel.v` ~1,440 lines, `src/SetList.v`; no Admitted;
   Print Assumptions = PrimInt63 primitives only):
   - Lemma S formalized (register program of length L → set program of cost ≤ L + Phi, Phi = #non-T registers −
     #distinct non-T columns); Phi(start) = 0 for every R, so the end theorem holds for ALL R ≥ n (no register bound).
   - Rules proved: W, P (polarity), G (S_n relabelling as row permutations, validated by a proved boolean), D, und,
     H1, H2 (useless-cmp deletion ⇒ #cmp ≤ #cmov), E3 (Lemma M: successor dominated by its parent).
   - RESULT: sort3, M_out, I1, every R ≥ n: no program with k ≤ 10. Own BFS certificate 57,036 states, check true
     (search 438 s + check 337 s). Claim 21:57.
3. **Certificate format** agreed with lean-reflect (kept states + g, text, END sha256; each checker canonicalizes).
4. **Rule dependence** (patched copy of enum_out, env NOH3/NOH2): sort3 k ≤ 10: all rules 2,219 states, without H3'
   56,894 (my Coq set checker without H3': 57,036 — cross-check). sort4 KB = 15: all rules 160k states in 15 s,
   without H3' not finished in 300 s. ⇒ both checkers MUST prove H3'. Claim 21:57; messages to enum, lean-reflect, theory.
5. **Closed in-kernel k = 10 (register checker):** vm_compute run at 98 min CPU, still running (`logs/sort3_k10_vm.log`).
   native_compute (switch `rocqn` with rocq-native): k = 9 in 282 s (7× slower than extracted OCaml, ~4.5× faster
   than VM); the k = 10 run failed after 53 min with a stack overflow; restarted with an unlimited stack
   (`logs/sort3_k10_native2.log`).

## Numbers
| checker | model | k ≤ 10 states | time | states/s |
|---|---|---|---|---|
| register (extracted) | R = 13 | 437,914 | 625 + 455 s | ~400 (check ~960) |
| set, list columns, G (extracted) | any R | 57,036 | 438 + 337 s | 169 (check) |
| enum (C++, all rules) | any R | 2,219 | 0.1 s | — |

## Estimate for sort4 (k ≤ 18: 55.8M states; k ≤ 19: > 80M)
Successor evaluations ≈ states × ~1,500 ops ≈ 1e11. enum does ~7M successors/s per thread. A verified OCaml checker
with packed columns (3-bit lanes in two int63), per-column cached S_n images and N parallel chunks could reach
~1 µs/successor → k ≤ 18 in ~20 h on 1 core, ~1.5 h on 16 cores. 50k states/s is not realistic for a verified
single process; "≤ 10× enum's search time on equal cores" is.

## Open problems / next
- H3' proof (plan in `agents/coq/NOTES.md` §6: cover potential drops ≤ 1 per cmov; a lowering op creates no other
  target; ⇒ #cmov ≥ und + max_j(cover_j − 2)).
- Packed column instance + cached S_n images + parallel chunks; OCaml parser for the agreed text format.
- enum: no certificate export yet; asked for state counts per rule set and the export header.
- vm / native closed k = 10 theorem: still running.
