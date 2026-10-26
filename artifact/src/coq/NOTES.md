# coq agent — notes (round 1, 2026-10-24)

## 1. Precedent: Cruz-Filipe, Larsen, Schneider-Kamp (sorting networks)
Sources (local copies, pdftotext): `refs/jar2017.txt` = "Formally Proving Size Optimality of Sorting Networks",
JAR 59 (2017), DOI 10.1007/s10817-017-9405-9; `refs/cicm2015.txt` = Cruz-Filipe, Schneider-Kamp, "Optimizing a
certified proof checker for a large-scale computer-generated proof", CICM 2015 (arXiv 1502.08008).

- Result checked: S(9) = 25 comparators (Codish, Cruz-Filipe, Frank, Schneider-Kamp 2014/2016).
- Search = generate-and-prune. Generate: extend every network of layer k by every comparator. Prune: drop a network
  C_b if some kept C_a *subsumes* it: there is a permutation pi of the channels with pi(outputs(C_a)) ⊆ outputs(C_b)
  (Lemma 2: then C_b can be completed to a sorting network only if C_a can, at the same cost).
  Finding pi is NP-complete (their Theorem 2), so the search is expensive (> 10 CPU-years for n = 9).
- Certificate ("oracle") = log of subsumption triples (C_a, C_b, pi), pi written as its image list on [n].
  70 M witnesses, 27 GB for n = 9. Pre-processed (Java, few hours) into "reduced" triples: chains C_a ≥ C_b ≥ C_c
  are composed (forest, compose permutations along paths), and sorted in Generate's order.
- Checker = Coq functions Generate / Prune(oracle) with soundness theorem (an untrusted oracle can only make the
  check fail, never make it wrongly succeed). Checking a triple = test pi is a permutation + test the set inclusion.
  Extracted to Haskell (laziness reduced memory), oracle read by a 53-line Haskell interface.
- Numbers: Coq formalization 6838 lines (102 definitions, 405 lemmas); extracted Haskell ~650 lines; full n = 9
  check 163.8 h (vs. 18 CPU-years for the original search). Optimizations: lexicographic order of the oracle gives
  a one-pass remove_all; subsuming networks kept in a (non-balanced) binary search tree: O(|O| log |R'|).
- Trust base of the precedent: Coq kernel + extraction + Haskell compiler/runtime + the interface program.

## 2. Adaptation to cmov programs (what I built)
State (column machine, `src/Vec.v`): run the machine on W representative inputs at once.
`cols` = one column per register (entry w = value on input w: rank, or T = n), `flags` = one flag per input,
`dn` = done mask of the snapshot outputs (M_out, MODEL §4.3).
No order-type lemma is needed: the lower bound only uses "correct for all inputs ⇒ correct for these W inputs"
(here the 6 strict permutations; sound for I1 too, MODEL §3 L1b).

Certificate V = list of (canonical state, budget b). It is the visited set of a layered BFS with f-bound
(a budget = k − depth). The checker (`src/Check.v`, soundness `src/Sound.v`) tests:
- (C0) every s ∈ V is well formed, *marked* (every target column present in a register is marked done), not all done;
- (C1) for every (s, b+1) ∈ V and every representative instruction i:
  t = markb(canon(step s i)) is in V with budget ≥ b, or prune(t, b) = true;
- (C2) root = markb(canon(vinit)) is in V with budget ≥ k.
Theorem `certifies_sound`: C0–C2 ⇒ no program of length ≤ k (instructions in iset, registers < R) is
RelaxedSnap-correct. Corollaries in `src/Inst.v`: fixed outputs (RelaxedCorrect) and the strict model.

Dedup/subsumption witnesses: NOT needed for sort3. Unlike sorting networks, our symmetry is a register permutation
that the checker can compute itself (canon = sort the columns: O(R log R) column compares, by adjacent swaps, each
proved to be a renaming). So the certificate is just the state list; the "witness" for a duplicate is the lookup
(hash table with exact bucket compare; the hash is untrusted). Witnesses become useful for a stronger, NP-hard
reduction, e.g. the input-relabelling symmetry S_n (enum Rule G: canon over n! relabellings) or set dominance
(enum Lemma M: A ⊇ B); then the certificate should carry (pruned state, dominating state id, register injection
/ relabelling sigma), and the checker re-checks the inclusion in O(R·W). Same design as the precedent's triples.

Rules proved in Coq (all from enum PRUNING.md ideas, re-proved for the register-level state):
- `Good.v`: any injective register renaming (outputs are snapshots, so P registers are not special) and flag
  polarity (lt↔gt, cmovl↔cmovg, cmovle↔cmovge, cmp a b → cmp b a); canon = bubble passes + polarity.
- `Prune.v`: dead (undone target value missing in a row), hw = #undone outputs ≤ #non-cmp instructions left
  (targets are pairwise distinct columns), hc = 2^(b − hw) < class size ⇒ prune, with class key = (flag,
  input index held by each register, input index of each DONE output) — enum's H1. (enum's H2/H3 are not used.)
- `Sound.v` `rinstrs_cover`: an instruction on a register whose column equals an earlier register's column is
  either a no-op or equivalent (renaming by a transposition of the two equal registers) to one on representatives.
- `Vec.v` `relaxed_snap_cols` / `snap_reg_lt`: the link from Machine.v semantics (Z values) to columns.

## 3. Semantics diff: Coq `src/Machine.v` vs Lean `agents/lean/frozen/v1/SortProof/Machine.lean`, `Snap.lean`
| clause | Lean | Coq | same? |
|---|---|---|---|
| registers | Nat index, P_i = i, S_j = n + j | same | yes |
| cond / eval | l: o = lt; g: o = gt; le: o ≠ gt; ge: o ≠ lt | `cond_eval` same table | yes |
| I0 / I1 | `Cond.inI0` (l, g); iset parameter | `cond_inI0`, `cond_inI1`, iset parameter | yes |
| instr, regs, WF R | mov d s / cmp a b / cmov c d s; all regs < R | same (`prog_wf`; `prog_ok iset R` adds iset) | yes |
| state | regs : Nat → α, flag : Ordering | record, comparison | yes |
| step | mov: upd; cmp: flag := ord a b; cmov: if eval then upd | same | yes |
| run | foldl | fold_left | yes |
| SortsOK | map y [0,n) = mergeSort (map x [0,n)) | Sorted Z.le ys ∧ Permutation xs ys | equivalent (sorted permutation is unique; `Vec.sorted_perm_unique`), not the same text |
| StrictCorrect / relaxInit / RelaxedCorrect | as MODEL §1–2, T for r ≥ n, flags eq | same | yes |
| snapshots (RS) | o : Nat → Nat × Nat, `(run (p.take (o j).2) s).regs (o j).1` | `snapOut` with `firstn` | yes |
Values: Lean Int with `compare`, Coq Z with `Z.compare`. cmp(T,T) = eq holds in both (T is a number).
No semantic difference found. Register bound R = n + k: Lean has it (`register_bound_snap`); in Coq the theorem is
stated for R = n + k registers (not re-proved here).

## 4. Trust base of the Coq result
- Rocq 9.3.0 kernel: checks the soundness proofs (Machine/Vec/Good/Prune/Check/Sound/Inst, no axioms, no Admitted).
- Theorem statement: `Inst.lower_bound` with definitions `RelaxedSnap`, `snapOut`, `prog_ok`, `SortsOK` (Machine.v, Vec.v).
- Extraction route (fast): Rocq extraction to OCaml + `ExtrOcamlBasic`, `ExtrOcamlNatInt` (nat = OCaml int; all
  numbers here are < 2^22), `ExtrOCamlInt63` (hash only), 4 typed `Extract Inlined Constant` for Nat.eqb/leb/ltb/compare
  (`extract/Ext.v`), OCaml 4.14.2, the driver `extract/main3.ml` (prints `okb3 i1 k (cert3 i1 k)`).
  The search `cert3` is untrusted: a wrong certificate can only make `okb3` return false.
- vm_compute route (small TCB): same functions evaluated by Rocq's VM inside a `Lemma ... = true`; then the result is
  a closed Coq theorem. Cost: VM ≈ 40× slower than the extracted OCaml in my measurements.

## 5. Route 2 feasibility (SMTCoq / CoqQFBV / Coq LRAT checker) — checked, not built
- SMTCoq (CAV 2017 and later): checks zChaff resolution traces (SAT) and veriT / CVC4 (cvc5) certificates (SMT).
  No LRAT/DRAT input. Our `sat`/`proofs` pipeline makes cadical LRAT; a zChaff-style trace would need a converter.
- Coq LRAT checkers: Cruz-Filipe, Heule, Hunt, Kaufmann, Schneider-Kamp, "Efficient Certified RAT Verification"
  (CADE 2017; checkers in Coq and ACL2; Coq one used for the Pythagorean-triples transformation proof);
  Verimag SatAns-Cert (Boulmé, Vandendorpe; LRAT from drat-trim; tested with Coq 8.7.2–8.9.0, OCaml 4.05–4.07).
  Both need porting to Rocq 9.x.
- CoqQFBV (CAV 2021): verified bit-blasting in Coq; the SAT proof is checked by GratChk (Isabelle/HOL), not by Coq.
- Cost estimate of a Coq LRAT route: port or write an LRAT checker (~1k lines), a verified CNF encoder (like
  lean-lrat's), run by extraction (vm_compute is too slow for 0.8 GB proofs). Lean core already has a verified LRAT
  checker (Std `LRAT.check_sound`) and lean-lrat has the encoder. Verdict: do not duplicate in Coq.

## 6. Round 2: set-model checker (for enum's sort4 certificate)
- `src/SetModel.v` (one Section, abstract column type C with list view `dec`, ~1,440 lines, no Admitted):
  set states (A, flags, done), ops cmp / cmov in place (on T = add) / copy (cost 2);
  Lemma S (`lemma_S`, potential Phi = #non-T registers − #distinct non-T columns); rules W, P (`sgood_neg`),
  G (`sgood_perm`, row permutations checked by `pi_okb`), D (`dead_sound`), und (`undone_ops`), H1 (`class_boundS`),
  H2 (`red_ok`, `red_cmp_le`: drop useless cmps, #cmp ≤ #non-cmp), E3 (`lemma_M`, successor dominated by its parent);
  checker `scheck_sound`; end theorem `scertifies_sound` for EVERY R ≥ n (registers unbounded; Phi(vinit) = 0).
- `src/SetList.v`: list instance (columns = lists of length W as sigma types; no axioms), untrusted budget-bucket BFS,
  `lower_bound_set'` (all side conditions in one boolean `set_okb`).
- Certificate format agreed with lean-reflect (my proposal + 3 additions): kept states + g, text, END sha256 line;
  canonical form is each checker's own.
- Rule dependence (patched enum, `proto/enum_out_rules.cpp`): H3' is necessary for sort4. Proof plan for H3':
  c_j(A) = minimum number of columns of A covering t_j on the strict perms; a cmov step lowers c_j by ≤ 1 (replace M by
  its two operands); a lowering step's new column M has M(p) = j for some strict p, so it creates no other target
  (t_k(p) = k); c_j = 1 when t_j is created; hence #cmov ≥ (c_j − 1) + (|U| − 1). Needs: sublists, decidable cover,
  counting over step indices (~400 lines).
- Speed: list instance with G is ~170–340 states/s (n = 3). sort4 needs packed columns (3-bit lanes, two int63),
  cached S_n images per column, and parallel chunks; estimate below.
