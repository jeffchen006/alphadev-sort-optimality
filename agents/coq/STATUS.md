# coq STATUS (2026-10-25 00:40, round 3)

Route: Coq/Rocq verified checker of an untrusted search certificate (Cruz-Filipe / Schneider-Kamp style).
Tools: `TOOLS.md` (Rocq 9.3.0 + stdlib 9.2.0, OCaml 4.14.2, user-local opam in `tools/`). Notes: `NOTES.md`.

## Done
- `src/Machine.v`: machine of MODEL §1–2 + snapshot outputs (M_out, §4.3) — clause-by-clause equal to Lean frozen/v1
  (`NOTES.md` §3; only difference: SortsOK written as Sorted ∧ Permutation, equivalent).
- `src/Vec.v`, `Good.v`, `Prune.v`, `Check.v`, `Sound.v`, `Inst.v`: column machine, symmetries (register renaming,
  flag polarity), prune rules (dead, #undone, cmp classes), representative instructions, checker, soundness.
  Main theorem `Inst.lower_bound`: all_okb … V k = true → ∀ p o, |p| ≤ k → prog_ok iset R p → ¬ RelaxedSnap n p o.
  Corollaries `lower_bound_fixed` (outputs in P_j), `lower_bound_strict`. No Admitted; Print Assumptions = only PrimInt63 primitives (hash).
- Extracted OCaml checker (`extract/v3`): sort3, I1, M_out, R = 13: k = 8 (1094 states) and k = 9 (20,272 states) OK.
- vm_compute route tested: k = 8 as a closed Coq lemma (33 s + 35 s Qed); VM ≈ 30× slower than extracted OCaml.

- sort3 k <= 10 (I1, M_out, R = 13): extracted checker all_okb = true, 437,914 states, 18 min, 0.7 GB, 1 core
  (logs/sort3_I1_k10_v1.log, _v4.log with per-depth counts). Theorem `Sort3.sort3_lb` (premise = that boolean).
  Closed in-kernel theorem for k <= 8: `Sort3.sort3_lb8` (vm_compute). Claims 20:30, 20:58.
- COMPARE.md, NOTES.md (§5 LRAT route feasibility), run_sort3.sh.

- Round 2: proved chunked check (`Inst.lower_bound_par`) + forked driver (`extract/v5`); quick wins 1.45x.
- Round 2: SET MODEL checker (`src/SetModel.v`, `src/SetList.v`): Lemma S, W, P, G, D, H1, und, H2, E3, all proved;
  sort3 k <= 10 for every R >= n: 57,036 states, true (`logs/set2_sort3_I1_k10.log`). Claims 21:57.
- Round 2: sort4 certificate format agreed with lean-reflect; H3' shown necessary (patched enum).

- Round 3: H3' proved (SetModel: covm / nuse_bound / nnon_h3 / h3_bound); set checker now = enum's rules minus NG.
  Own BFS reproduces enum counts exactly: n=3 K=9 135, K=10 2,219; n=4 K=12 17, K=13 247 (K=14 running).
- Round 3: closed Rocq theorem sort3_lb10 by native_compute (2:06 h, build_native/, logs/sort3_k10_native2.log).
- Round 3: lean-reflect's certificate file sort3_I1_k10.cert accepted by the Coq checker (147 s, extract/file1/reader).
- Round 3: speed for n=4: 6 -> 14 states/s (precomputed perms, flag-key canon selection, transposed rows,
  capped cover search). Far from sort4 scale; plan: packed columns + incremental canon + parallel chunks.

## Running (background, 1 core each)
- `logs/sort3_k10_vm.log`: `src/Sort3K10vm.v`, k = 10 premise by vm_compute (closed theorem `sort3_lb10`), est. 8–12 h.


## Next
- H3' proof in the set model (plan in NOTES §6).
- Packed column instance (3-bit lanes) + cached S_n images + parallel chunks; certificate parser (OCaml, untrusted).
- If the vm/native run ends: claim the closed Coq theorem (no extraction in the TCB).
