# lean-reflect STATUS (2026-10-25, round 3)

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

## Round 3 (in progress): sort4 k ≤ 19 strict
- DONE (no sorry, standard axioms): `NGDefs` (NG-normal), `NGRewrite` (L10 position-preserving rewrite `NGR.ng_rewrite`,
  by a subagent), `NGBasic` (NG ops = enum NG=1), `NGSound` (`ngStep`, `checkNG_sound`, `lower_bound_NG`),
  `NGMain.lower_bound_strict`: checkNG accepts ⇒ ∀ p o, |p| ≤ KB → ¬ XSnap n p o. H2 not needed (same counts).
- Tests: Lean NG search = enum NG counts (n=4 KB=13/14: 48/379); NG KB=15 cert (7227) accepted (certexe ... ng).
- Speed: list checker 18 st/s/core; bit-plane prototype `FastProto` 605 st/s/core; numeric mirror `FastN` 53 st/s.
- PLAN (fast verified checker): (A) change spec orders to plane-number order (norm: colNum; keyLt flags: flagNum),
  capped cover in h; (B) planes + decode + bit lemmas; (C) fast functions = spec on decode (fused successor loop);
  (D) packed in-RAM store (~36 B/state, 55-60 GB for k ≤ 19), parallel driver, bridge theorem;
  (E) run k ≤ 17, 18, then 19 (needs ~60 GB RAM + 8 cores; asked coordinator).

## Round 3: fast verified checker for enum's sort4 certificates (2026-10-25)
- DONE, no sorry: `PlaneDefs/PlaneBits/PlaneHc/PlaneMain` (bit-plane keys decode to spec keys; canon, norm, merge,
  cmp, hc, cover equal on decode), `PlaneSucc` (fast successor list decodes to `ngSuccs`; `stateOKP2_sound`),
  `PStore` (packed store: 34 B/state + 4 B/slot; `lookF_sound`: a hit re-checks the full decoded record),
  `PCheck` (`lower_bound_store`), `NGSound2` (`checkNG2`: H bound also on the raw successor, before canon;
  proof copied from `checkNG_sound`), `PCheck2` (`lower_bound_store3`), `PlaneHc3` (`hcP3 = hcP2`, arrays),
  `PLoad` (untrusted parallel loader), `PK19`/`Ctx4OK` (`storeCheck`, `lb_of_storeCheck`, n = 4 facts by
  native_decide), `Sort4MM` (`mm_of_strict4`: composition with lean frozen/v3 `mm_lower_bound_strict`).
  `SortProof/L5Strict.lean` = byte copy of lean/frozen/v3 (only new file in v3).
- Exe runs (qexe, same verified functions, 16 threads):
  k ≤ 17: 2,557,816 states, 0 failures, 406 s (+19 s load). k ≤ 18: 55,792,074 states, 0 failures, 6190 s
  (+371 s load), 9013 states/s. H2 not used by my checker (enum's files include H2-pruned states; no failure).
- Theorem runs (native_decide): `Sort4K17S.sort4_x_lb17`, `Sort4K17MM.sort4_mm_lb25`; next `Sort4K19`
  (`sort4_x_lb19`, `sort4_mm_lb27`), estimate ~46 h on 16 threads, ~57 GB RAM.

## Round 2 (new files)
- `SetBasic/SetSound`: set model (enum Lemma S) with RelW (key ⊇ register columns) + potential Φ; `lower_bound_set`.
- `SymBasic/SymSound`: rule G (S_n relabelling, lexicographic-min canonical image; proof for any lane map),
  `checkG` (fast path: #undone / dead on the raw successor first), `checkGPar` (Tasks), `lower_bound_G`.
- `Cover.lean`: rule H3' (cover numbers) proved; `h = hc + max(und, und + maxCover − 2)` (Basic), `h_le` (Sound).
- Fast array paths with proved equalities (`cget_toArray`, `dead_eq`, `stateSigA_eq`, `coversA_eq`, `permCol_eq`).
- `CertIO.lean` + `certexe`: certificate format v1 (`CERT_FORMAT.md`, agreed with coq) writer/reader.
- `FileCert.lean`: theorem with the certificate read from a FILE (`certFile` opaque + implemented_by; `lookIn` re-checks keys).
- `proto/enum_cert.cpp`: copy of coq's patched enum_out with `EXPORT=FILE` (format v1). Same counts as my Lean search.
- Theorems: `Sort3MM.sort3_mm_lb` (AlphaDev model, L ≤ 16 impossible), `Sort3G.sort3_rs_lb_G` (56816 states),
  `Sort3File.sort3_rs_lb_file`, `Sort3H.sort3_rs_lb_H` / `_H'` (H3', 2215 states, 83 s build).

## Results
- sort4 k ≤ 15 (partial): enum-code certificate certs/enum_sort4_I1_k15.cert (160021 states) accepted by checkGPar
  (4006 s, 4 cores); theorem `Sort4K15.sort4_rs_lb15` built (4223 s).
- sort3 with H3': 2215 states (`Sort3H`). All theorems rebuilt on the final `h` (logs/build_final.log); axioms checked (scratch/axall.lean).
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
