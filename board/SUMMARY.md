# PROJECT STOPPED 2026-10-26 (user decision). Final report: board/FINAL_REPORT.md ; team report: board/team/FINAL.md

# Coordinator summary (updated 2026-10-25 09:05)

Main claim (MODEL.md v1.7 §4): no M_AD(n, I1) program of length L-1 sorts; L = 17 / 28 / 42; register core k_out = L - 2n
must be shown UNSAT for every k <= 10 / 19 / 31 (snapshot outputs M_out, R unbounded, T-relaxed, MM-1).

| n | target | status | evidence (trust base) |
|---|---|---|---|
| 3 | k <= 10 none | DONE, 6 independent proofs; Lean theorem `sort3_mm_lb` states it directly in AlphaDev's own model M_AD (L <= 16 impossible) | sat (2 certs, one with no cut): CNF + LRAT checked by cake_lpr (encoder: Python, tested) ; lean-reflect: Lean theorem `sort3_x86_lb` (kernel + native_decide) ; lean-lrat: ONE Lean theorem, AlphaDev sort3 = 17 optimal (verified encoder + Lean LRAT checker, built 2 ways) ; coq: Rocq-extracted verified checker, 437,914 states, no Admitted (closed vm_compute run going) ; enum + critic: two search tools ; sat2: CEGIS sweep |
| 4 | k <= 19 none | SEARCH DONE: none <= 19 (enum, 1.39e9 states, rules reviewed) => AlphaDev sort4 = 28 optimal, I1 and I0. NO checked certificate yet (k<=18 certs exported; k=19 cert next) | enum search; checkers: lean-reflect (Lean native), coq (Rocq extracted) |
| 5 | k <= 31 none | open; sat2 k <= 14 none; case split by #cmp (c = 7..15) reviewed | bounds SORT5_SPLIT.md, theory L9 |

Side results
- Lean: L1-L5 chain + `mm_lower_bound` (memory model -> snapshot) proved, no sorry, std axioms (lean frozen/v2).
- MM+ (x86 memory source in cmp/cmov, outside AlphaDev's action space): 7 / 15 / 26 / 39 for n = 2 / 3 / 4 / 5 (< 8/17/28/42).
- Latency: AlphaDev sort3 and sort5 are not Pareto-optimal in (length, depth); upper's I0 sort5 k=32 has depth 11 < 13.
- x86: abstract semantics = AMD EPYC 9654 hardware (hundreds of M runs) = CERTIFIED ACL2 x86isa model (81000 vectors, 48 programs).
- proofs: CakePB verified chain (symmetry breaking + solver proof in ONE verified check) works at n=3, k=7/8; k=10 next.
- Latency: min depth sort5 in [5,7] (U/E); upper sort5 k=32 with depth 10 (AlphaDev 13).
- bounds: #cmp >= 3/5/7, #cmov >= 6 (n=3, exact), >= 10 (n=4), >= 12 (n=5).

Overnight (2026-10-25 01:50): running = enum k<=19 sort4 certificate export (disk-based, ~8-10 h), lean-reflect sort4 Lean
checker, lean kernel-only sort3 (629/640 modules pass, 12 heavy retried). Rocq checks sort4 only to k<=14 (too slow beyond).
sort5: open (needs k<=31; have k<=14; est. search 1e20-1e31). All other sessions paused, on Sonnet (token budget).

Morning (2026-10-25 09:05): sort4 k<=19 export: all depths done (13 = last, 1.393e9 states), writing gz. Codex review of
sort4 chain: no unsound rule; to do: compose lean-reflect NG theorem with lean frozen/v3 strict L5 at K=19.
sort5: idea 1 (global restriction bound) refuted by data (bounds); theory plan SORT5_PLAN.md (L13 subsumption proved,
h_R pattern database, case split c=7..15); sort5-lab (Claude x Codex loop) + codex started. Team RAM cap 300 GB.
