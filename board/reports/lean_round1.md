# lean — round 1 report (2026-10-24)

Project: `agents/lean` (Lean 4.33.1, core only, no Mathlib), 2100 lines, 15 modules.
Build: `cd agents/lean && lake build` (about 8 min cold; most of it is AllPrograms). No `sorry`, no `native_decide`,
no `bv_decide`. Axioms of every main theorem: `propext`, `Classical.choice`, `Quot.sound` (`lake env lean scratch/ax.lean`).
Statements for review: `agents/lean/STATEMENTS.md` (verbatim). Semantics vs Intel SDM: `agents/lean/SEMANTICS.md`.

## Done
1. **Semantics** (`Machine.lean`, `X86.lean`). x86 layer: BitVec 32 registers, CF/ZF/SF/OF set by CMP as in the SDM
   (SUB result, borrow, signed overflow); CMOVL/G/LE/GE conditions from SDM Table B-1. Abstract layer: `Int` values,
   flag = `Ordering`. `xrun_abs`: x86 run = abstract run (exact simulation).
   `xeval_eq`: for l/g/le/ge, the 3 flag states lt/eq/gt are exact for all 16 flag combinations
   (the 4th state ZF=1, SF≠OF acts as lt). So the strict model needs 3 initial flag states, not 4.
2. **Order-type lemma** (`OrderType.lean`, `Reps.lean`). `run_strictMono` (execution commutes with every strictly
   monotone map), `index_pattern` (same order type ⇒ same index map σ), `correct_transfer`.
   Corollary `x86_iff_reps`: for a program on R ≤ 2^31 registers, correct on all Int32 register files and flags
   ⇔ correct on each of the Fubini(R) representatives (`reps R`; |reps| = 1, 3, 13, 75, 541 checked).
3. **Relaxation lemma** (`Relax.lean`). `x86_to_relaxed`: if the program sorts every x86 state with inputs
   < INT_MAX, scratch = INT_MAX (0x7fffffff), flags ZF=1, SF=OF=CF=0 (= eq), then it is relaxed-correct for all `Int`
   inputs and every T above them. `xcorrect_to_relaxed` (from full x86 correctness). `relaxed_iff_abs`: relaxed model
   = the T-machine of MODEL.md §3 (register = "holds x_i" or T; T in an output = wrong).
4. **Register bound** (`Rename.lean`, `Snap.lean`). Renaming `compact` (written scratch registers in order, all
   never-written scratch registers merged). RF: `register_bound` (n ≥ 2 ⇒ some instruction writes a P register).
   RS: `register_bound_snap` (n ≥ 2 ⇒ the program has a cmp). Both: length k program ⇒ registers < n + k, same opcodes.
   Padding with `mov P0, P0`.
5. **Chain theorems.** `lower_bound_chain` (RF) and `lower_bound_chain_snap` (RS, snapshot outputs = MODEL §4.3
   M_out): IF no length-k program on registers < n+k (snapshots: register < n+k, position ≤ k), opcodes in iset,
   is relaxed-correct, THEN no program of length ≤ k with any registers is correct on x86. n ≥ 2, iset a parameter.
6. **Verified checker** (`Checker.lean`). `checkStrictO` = taint check (outputs do not depend on garbage or initial
   flags) + run on `reps n`; `checkStrictO_sound`: true ⇒ correct for all Int states ⇒ (`checkStrictO_x86`) correct on
   x86. Run in the kernel (`decide +kernel`) on literal programs produced by `program_file%` (file read at build time;
   the parser is not verified, `#print` shows the literal).
   Results: `alphadev_sort3_x86`, `alphadev_sort4_x86`, `alphadev_sort5_x86` (programs/alphadev_sort{3,4,5}.s,
   L = 17/28/42, model=mem, M_AD operand rules checked). `AllPrograms.lean`: all 39 files with n ≤ 5 in
   programs/{.,orig,out,found} pass (incl. found/upper_sort5_I0_L42_mem.s and all programs/out/*).
   Negative tests pass (dropped store, changed cmov, garbage read, flag read are rejected).

## Numbers
| n | reps (kernel) | AlphaDev program | strict check |
|---|---|---|---|
| 3 | 13 | 17 instr | pass |
| 4 | 75 | 28 instr | pass |
| 5 | 541 | 42 instr | pass |

Kernel time: `Programs.lean` (all 3 programs) 23-26 s; `AllPrograms.lean` (39 files) 391 s, on a loaded machine.

## Open problems / not covered
- **L5 (MM → RS counting map, L_AD = 2n + k_out)**: not formalized. So the formal chain gives the RS (register,
  snapshot) bound, not yet the AlphaDev memory-model bound. (theory G2.)
- **Symmetry / pruning rules** used by sat/enum: not formalized (theory G3). Asked sat/enum which rules a final claim uses.
- **Encoder correctness**: no link yet from a CNF/UNSAT certificate to the hypothesis `H` of the chain.
- `model=out` files are checked with `out j, S` = `mov O_j, S` into a fresh register; a lemma that this equals
  `XSnap` is easy but not written.
- n = 6..8 programs skipped (representative generation is m^m; needs a Fubini-size generator).
- The file parser and `program_file%` are trusted (unverified), as is the Lean kernel.

## Next (round 2)
1. L5 in the relaxed model (theory G2), so the chain ends at M_AD.
2. Rules that sat/enum use in final claims (G3), after theory review.
3. A kernel-checkable relaxed checker / abstract-state transition check for small k (task 6), or a verified CNF encoder.
4. RS T-machine equivalence (`relaxed_iff_abs` for snapshots) and `out` file ⇔ `XSnap` lemma.
