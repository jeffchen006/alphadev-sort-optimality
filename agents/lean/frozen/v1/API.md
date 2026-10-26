# SortProof frozen API v1 (2026-10-24) — never edited; a new API = a new folder frozen/v2

Build: `cd agents/lean/frozen/v1 && lake build` (5 s; core Lean 4.33.1, no Mathlib). Integrity: `sha256sum -c SHA256SUMS`.
How to depend (no build race): COPY the files byte-for-byte into your own project (same module names `SortProof.*`),
build in your own `.lake`, and check the copy with `sha256sum -c` against this SHA256SUMS. Do not `require` agents/lean.
Changes in agents/lean/SortProof (the working copy) are NOT API until published as frozen/v<k>; I announce each new
version in your inbox.

## Stable names (v1)
Machine: `Cond` (l g le ge), `Cond.eval`, `Cond.inI0`, `Instr` (mov d s | cmp a b | cmov c d s), `Instr.inSet`,
`Instr.regs`, `Instr.dest?`, `Program := List Instr`, `Program.WF R p`, `State α` (regs : Nat → α, flag : Ordering),
`upd`, `step`, `run ord p s`, `run_nil`, `run_cons`, `run_append`, `State.map`, `SortsOK n x y`, `StrictCorrect`,
`StrictCorrectO`, `relaxInit n x T`, `RelaxedCorrect`.
Registers: `i < n` = P_i, `n + j` = S_j. Flag: one `Ordering`. Values: `Int` with `compare`.
X86: `XState`, `xcmp`, `Cond.xeval`, `xstep`, `xrun`, `XState.flagOrd`, `XState.abs`, `xeval_eq`, `cmp_sf_of`, `cmp_zf`,
`xrun_abs`, `XCorrect`, `XCorrectO`, `strict_to_x86`.
OrderType: `run_map`, `run_strictMono`, `oracleOf`, `symInit`, `run_eq_sym`, `index_pattern`, `sortsOK_transferQ`,
`correct_transfer`, `correct_transfer_allO`, `correct_transfer_all`, `sortsOK_congr`.
Reps: `cnt`, `rank`, `rank_compare`, `allVecs`, `vecRegs`, `rankList`, `reps`, `rankList_mem_reps`, `strict_iff_reps`,
`x86_iff_reps`.
Relax: `strict_to_relaxed`, `xRelaxInit`, `x86_to_relaxed`, `xcorrect_to_relaxed`, `absOrd`, `absInit`, `AbsOK`,
`relaxed_iff_abs`, `bigT`, `sortsOK_no_T`.
Rename: `Instr.rename`, `Program.rename`, `GoodRen`, `run_sim`, `strict_rename`, `relaxed_rename`, `compact`,
`compact_noMerge`, `register_bound`, `pad`, `relaxed_pad`, `lower_bound_chain` (RF).
Snap (RS = M_out): `Snap := Nat → Nat × Nat` (output j = register (o j).1 after the first (o j).2 instructions),
`snapOut`, `StrictSnap`, `RelaxedSnap`, `xsnapOut`, `XSnap`, `xsnap_to_relaxed`, `relaxed_snap_has_cmp`,
`register_bound_snap`, `relaxed_snap_pad`, `lower_bound_chain_snap`.
Checker: `taintOK`, `sortsCheck`, `sortsCheck_iff`, `checkStrictO`, `checkStrictO_sound`, `checkStrict`,
`checkStrict_sound`, `checkStrict_x86`, `checkStrictO_x86`.
Parse/Load (trusted, unverified): `ParsedProg`, `parseProgram`, `program_file%` (needs `import Lean`).
