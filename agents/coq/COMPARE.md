# Coq vs Lean routes — comparison and recommendation (coq agent, round 1, 2026-10-24)

Claim compared: sort3, M_out (snapshot outputs, MODEL §4.3), I1, relaxed model, no program with k ≤ 10
(=> k_out(3) = 11, L_AD(3) = 17 with spec's Lemma 4.1).

| | Coq (this agent) | Lean A: `lean-reflect` | Lean B: `lean-lrat` |
|---|---|---|---|
| method | verified checker of a search certificate (visited set + budgets); untrusted BFS | verified checker of a search certificate; untrusted BFS | verified CNF encoder + Lean core's verified LRAT checker on cadical's proof |
| proof size | ~1,600 lines Rocq (Machine 120, Vec 290, Good 340, Prune 500, Check 210, Sound 240, Inst 110) | ~1,560 lines Lean (LeanReflect/*) | encoder + soundness (see agents/lean-lrat) |
| rules proved | register renaming, polarity, dead, #undone writes, cmp classes (H1), representative instructions | same family (D, H1, #undone, polarity; key = multiset of non-T columns) | first-touch canon (sat's canon+pcanon) |
| sort3 k ≤ 10 states | 437,914 (register-level state, R = 13) | 437,100 (set-of-columns key) | — (CNF; 32 cubes) |
| sort3 k ≤ 10 time | search 625 s + check 455 s = 18 min, 1 core, 0.7 GB, extracted OCaml | 858 s on 4 cores, native_decide | running (k ≤ 9: 372 s, 4.9 GB, 814 MB LRAT) |
| trust (fast route) | Rocq kernel + extraction + ExtrOcamlNatInt + OCaml | Lean kernel + Lean compiler (native_decide axiom) | Lean kernel + Lean compiler (native_decide axiom) |
| trust (small route) | vm_compute: Rocq kernel + VM, ≈ 30× slower (k = 10 ≈ 8 h, 1 core); native_compute: + OCaml native compiler | kernel `decide`: infeasible at this size | same |
| register bound | theorem for R = n + k (L3 cited, not re-proved in Coq) | any Nat registers (no bound needed) | R = n + k via lean's chain (proved) |
| semantics | own Machine.v, clause-equal to lean frozen/v1 (NOTES §3) | lean frozen/v1 (byte copy) | lean frozen/v1/v2 (byte copy) |

## Round 3 update
- Closed Rocq theorem (no extraction) for sort3 k <= 10: native_compute, 2:06 h, TCB = kernel + native compiler.
- Coq set-model checker = enum's rules minus NG (Lemma S, W, P, G, D, H1, und, H2, E3, H3', all proved);
  own BFS = enum's counts exactly (n=3 K<=10: 2,219; n=4 K<=14: 5,896).
- Two checkers, one file: lean-reflect's sort3_I1_k10.cert accepted by the Coq checker.
- Speed is the open problem for sort4 (n=4 ~14 states/s with list columns).

## Observations
- The two search-certificate checkers (Coq, Lean A) are independent code in two different kernels, with almost the same
  state counts (437,914 vs 437,100; the small difference comes from the key: Coq keeps duplicate and T columns of
  registers, Lean A keeps the set of non-T columns). Per depth the counts are equal except depth 7
  (158,831 vs 158,017); the tails (318, 6, 0) agree with enum too.
- Speed per state is similar (≈ 1–1.5 ms/state single core). The cost is successor generation, not the proof.
- Certificates are not needed as files for sort3: both checkers regenerate the visited set; the "certificate" is
  the closure property checked over that set. For n ≥ 4 a stronger, NP-hard reduction (input relabelling S_n,
  set dominance) would need witnesses from the untrusted search (the precedent's design), see NOTES §2.
- LRAT import in Coq is NOT attractive: SMTCoq checks zChaff/veriT/CVC4 traces, not LRAT; the Coq LRAT checkers
  (Cruz-Filipe et al. CADE 2017; Verimag SatAns-Cert) target Coq 8.5–8.9 and need porting; CoqQFBV uses
  GratChk (Isabelle). Lean core already ships a verified LRAT checker (Std `LRAT.check_sound`), used by lean-lrat.

## Recommendation for the paper
1. Main formal artefact for sort3 (and sort4 if it scales): Lean (one statement down to x86 32-bit semantics via
   lean's X86.lean; lean-reflect + lean-lrat give two different proof methods in one prover).
2. Coq as an independent second kernel for the search-certificate route: same theorem (RelaxedSnap, M_out, I1)
   with independent code and definitions; report state counts side by side as a cross-check. If the native
   switch works, give the Coq result as a closed theorem by native_compute (or vm_compute, 8 h) to avoid
   extraction in the trust base.
3. SAT/LRAT route: keep it in Lean (lean-lrat) and cake_lpr (proofs); do not port a Coq LRAT checker.
4. For sort4/sort5 the search-certificate route needs much stronger symmetry (S_n relabelling, dominance) with
   witnesses; this is where the precedent's "untrusted oracle + reduced witnesses" design pays off.
