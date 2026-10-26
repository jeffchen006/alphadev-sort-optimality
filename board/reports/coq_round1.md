# coq — round 1 report (2026-10-24 21:00)

## Done
- Rocq 9.3.0 (+ stdlib 9.2.0, OCaml 4.14.2) installed user-local by opam in `agents/coq/tools/` (`TOOLS.md`).
- Precedent studied (Cruz-Filipe/Larsen/Schneider-Kamp JAR 2017, CICM 2015): untrusted search, oracle of
  subsumption triples (C_a, C_b, pi), verified Coq checker extracted to Haskell; n = 9: 27 GB, 70 M witnesses,
  163.8 h. Adaptation in `NOTES.md` §1–2.
- Coq development `agents/coq/src/` (~1,600 lines, no Admitted): machine (`Machine.v`, clause-equal to lean
  frozen/v1 incl. snapshots; only SortsOK is phrased differently but equivalent, `NOTES.md` §3), column machine and
  link to Z semantics (`Vec.v`), register renaming + flag polarity + canon (`Good.v`), prune rules dead / #undone /
  cmp classes H1 (`Prune.v`), checker + hash table (`Check.v`), soundness incl. representative instructions
  (`Sound.v`), main theorem `Inst.lower_bound`: all_okb … V k = true → ∀ p o, |p| ≤ k → prog_ok iset R p →
  ¬ RelaxedSnap n p o; corollaries for fixed outputs and the strict model.
- RESULT (claims.md 20:30, 20:58): sort3, M_out, I1, R = 13, relaxed, strict perms: no program with k ≤ 10.
  Extracted checker: 437,914 states, all_okb = true, 18 min, 0.7 GB, 1 core. Per depth equal to lean-reflect
  except depth 7 (158,831 vs 158,017; different key). Closed in-kernel theorem for k ≤ 8 (`sort3_lb8`, vm_compute).
- Route 2 (SMTCoq / CoqQFBV / Coq LRAT checker): feasibility only, verdict "do not duplicate in Coq" (`NOTES.md` §5).
- `COMPARE.md`: Coq vs lean-reflect vs lean-lrat; recommendation below.

## Numbers
| k | states | search | check | memory |
|---|---|---|---|---|
| 8 | 1,094 | 1.0 s | 1.0 s | — |
| 9 | 20,272 | 21 s | 21 s | — |
| 10 | 437,914 | 625 s | 455 s | 0.7 GB |
vm_compute ≈ 30× slower than extracted OCaml (k = 8: 28 s vs 1 s).

## Trust base
Rocq kernel (soundness proofs) + extraction (ExtrOcamlBasic, ExtrOcamlNatInt, ExtrOCamlInt63, typed nat-compare
realizations) + OCaml 4.14.2. The BFS is untrusted. In-kernel route: vm_compute k = 10 is running (est. 8–12 h).

## Recommendation (paper)
Lean as the main formal artefact (x86 statement, two methods). Coq as an independent second kernel for the
search-certificate route, with state counts side by side. SAT/LRAT import: keep in Lean / cake_lpr.

## Open problems
- The theorem is for R = n + k = 13; R-independence is cited (theory L3, lean `register_bound_snap`), not re-proved in Coq.
- Closed Coq theorem for k = 10 without extraction: vm run in background (`logs/sort3_k10_vm.log`); native switch
  `rocqn` being built (`logs/install_native.log`).
- One Qed in `Sound.v` (covered_sound) takes ~70 s in the kernel; harmless, not yet explained.
- enum did not answer the certificate-format request; not needed any more (the Coq checker makes its own certificate).

## Next
- Finish the closed k = 10 theorem; port the R bound; estimate sort4 (k ≤ 19) — needs S_n relabelling or set
  dominance with witnesses from the untrusted search (the precedent's design).
