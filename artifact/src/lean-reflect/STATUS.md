# lean-reflect STATUS (2026-10-24, round 2)

Lean route A: the whole lower bound as one Lean theorem, proof = verified search run inside Lean.
Toolchain leanprover/lean4:v4.33.1, core only (no Mathlib). Build: `lake build LeanReflect`.

## Core semantics (one definition of the machine)
`SortProof/*` = byte copy of `agents/lean/frozen/v2` (v1 + SortFacts + L5) (lean's frozen API). Check: `./check_core.sh` (sha256 against
lean's SHA256SUMS). Statement uses lean's `RelaxedSnap n p o` (RS = M_out, MODEL §4.3) and `XSnap` (x86 strict).

## Files
- `LeanReflect/Basic.lean`  keys, abstract step `succs`, pruning `dead`/`h`, checker `check`, untrusted BFS `search`, `certOK`.
- `LeanReflect/Lemmas.lean` list/count/dc/clog2 lemmas.
- `LeanReflect/Sim.lean`    simulation: concrete multi-state ~ key (`Rel`), `sim` (every concrete instr has an abstract one).
- `LeanReflect/Heur.lean`   Rule D (`not_dead`), write count (`und_le`).
- `LeanReflect/Class.lean`  Rule H1 (`class_le`): cmp classes on strict permutations.
- `LeanReflect/Sound.lean`  `check_sound`, `lower_bound` (certOK = true → ∀ p o, |p| ≤ KB → ¬ RelaxedSnap n p o).
- `LeanReflect/Ctx3.lean`   `CtxOK (mkCtx 3)` by `decide`.
- `LeanReflect/Test8.lean`  sanity: sort3, KB = 8, native_decide.
- `LeanReflect/Positive.lean` upper side, kernel only: AlphaDev sort3/sort4 M_out forms (k = 11 / 20) are `XSnap`.

## Model of the search (all proved in Lean, no sorry)
- Tests = the n! strict permutations (subset of inputs: sound). Relaxed init (scratch = T = n, flags eq).
- Key = (multiset of non-T columns of ALL registers (sorted list), flag vector (polarity-canonical), outputs taken).
  Unbounded registers: no register bound needed (registers = any Nat).
- Pruning: Rule D (dead value), h = H1 (cmp classes, distinct undone-output signatures) + #undone outputs (each needs its
  own write). Closure check: every successor of (k, g) is pruned or is in the map with depth ≤ g + 1.

## Round 2 (new files)
- `SetBasic.lean`/`SetSound.lean`: set model (enum Lemma S) with RelW (key ⊇ register columns) and potential Φ;
  `setStep`, `checkS_sound`, `lower_bound_set`. `SymBasic.lean`/`SymSound.lean`: rule G (S_n input relabelling,
  lexicographic-min canonical image; proof for any lane map), `checkG_sound`, `lower_bound_G`, `certOKG_sound`.
- `Sort3MM.lean`: `sort3_mm_lb : ∀ q, MMProg 3 q → q.length ≤ 16 → ¬ XCorrect 3 q` (AlphaDev model; + lean's L5).
- `Sort3G.lean`: `sort3_rs_lb_G` (set model + G, 56816 states) — building.
- `CertIO.lean` + `certexe`: certificate format v1 (`CERT_FORMAT.md`, agreed with coq) writer/reader; checker = checkG.
- Heuristic lemmas now take `RelW` (weaker), so they serve both models.

## Results
- MAIN: `LeanReflect.sort3_x86_lb : ∀ p o, p.length ≤ 10 → ¬ XSnap 3 p o` and `sort3_rs_lb` (RelaxedSnap).
  native_decide on `certOKPar 3 I1 10 4` (verified checker, 4 Tasks): 437100 states, 858 s build. No sorry.
  Axioms: propext, Classical.choice, Quot.sound, `sort3_rs_lb._native.native_decide.ax_1_1`.
  TRUST = Lean kernel + Lean compiler / native code.
- Sanity: `sort3_le8` (sequential checker), `sort3_le9_par` (parallel checker).
- Positive (kernel only): `LeanReflect.Pos.p3_x86`, `p4_x86` (AlphaDev sort3 k=11 / sort4 k=20 M_out forms).
- n=4: exe, KB=12: 211700 states, none <= 12, 21 min on 4 cores (~23 ms CPU per state; H1 on 24 tests dominates).
  KB=19 is out of reach with this code (see report for estimate).
- Kernel-only (`decide +kernel`) does not reduce the checker (WF recursion in mergeSort/clog2, HashMap).

## Next
- Speed for sort4: packed columns (Nat/UInt64), array rows, O(m log m) class grouping; stronger proved rules
  (enum's set model + subsumption, H2 cmp→cmov, S_n relabelling). Need ~1000x.
- Kernel path: structural sort/log, tree map instead of HashMap; feasible only for small KB.
