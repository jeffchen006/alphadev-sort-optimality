# lean STATUS (2026-10-24)

Lake project `agents/lean` (Lean 4.33.1, core only, no Mathlib). Build: `lake build` (in `agents/lean`).
Axiom check: `lake env lean scratch/ax.lean` → only `propext`, `Classical.choice`, `Quot.sound`.
No `sorry`, no `native_decide`, no `bv_decide` (all program checks are kernel `decide +kernel`).

## Done (round 1)
| file | content |
|---|---|
| `Machine.lean` | abstract machine (Nat-indexed registers, `Ordering` flag), `SortsOK` (= `List.mergeSort`), StrictCorrect, RelaxedCorrect |
| `X86.lean` | x86 layer: BitVec 32, CF/ZF/SF/OF per SDM; `xrun_abs` (simulation), `xeval_eq` (3 flag states exact for l/g/le/ge) |
| `OrderType.lean` | `run_map`, `run_strictMono`, `index_pattern`, `correct_transfer(_all/_allO)` |
| `Reps.lean` | rank vectors, `reps m` (one per weak order type), `strict_iff_reps`, `x86_iff_reps` (Int32 corollary) |
| `Relax.lean` | `x86_to_relaxed` (inputs < INT_MAX, garbage = INT_MAX, flags ZF=1), `relaxed_iff_abs` (T-machine) |
| `Rename.lean` | `register_bound` (R = n + k), `pad`, `lower_bound_chain` (RF model) |
| `Snap.lean` | RS model (snapshot outputs): `xsnap_to_relaxed`, `relaxed_snap_has_cmp`, `register_bound_snap`, `lower_bound_chain_snap` |
| `Checker.lean` | `checkStrictO` (taint + reps), `checkStrictO_sound`, `checkStrict_x86` |
| `Parse.lean`, `Load.lean` | file parser (unverified), `program_file%` elaborator → literal program |
| `Programs.lean` | `alphadev_sort{3,4,5}_x86` : XCorrect (kernel) |
| `AllPrograms.lean` | generated (`tools/gen_all.py 5`): one theorem per file in programs/{.,orig,out,found} with n ≤ 5 |
| `Checks.lean` | Fubini 1/3/13/75/541, negative tests |
| `SortFacts.lean` | rank lemmas for `SortsOK` (`sortsOK_rank_lt/le`, `sortsOK_cnt`, `cnt_ind`) |
| `L5.lean` | **L5** (MM → RS): `MMProg`, translation `tr`, invariant `Inv`, `l5`, `relaxed_chain_snap`, `mm_lower_bound` |
| `L5Strict.lean` | **strict L5**: `l5_sim`, `l5_strict` (XCorrect → XSnap), `mm_lower_bound_strict` |
| `Results.lean` | `alphadev_mm` (MMProg ∧ L = 17/28/42 ∧ XCorrect), `sort3_optimal_of` (shape of the final claim) |

Statements for review: `STATEMENTS.md` (regenerate: `python3 tools/statements.py`). Report: `board/reports/lean_round1.md`.

## Frozen API
- `frozen/v3/` (2026-10-24): v2 + L5Strict (v2 files byte-identical).
- `frozen/v2/` (2026-10-24): v1 + SortFacts + L5 (v1 files byte-identical).
- `frozen/v1/` (2026-10-24): read-only copy of Machine, X86, OrderType, Reps, Relax, Rename, Snap, Checker, Parse, Load;
  `API.md`, `SHA256SUMS`. Users: lean-reflect, lean-lrat (vendor copies), coq (comparison). New API = `frozen/v2` + inbox note.

## Round 3: kernel-only sort3 (folder `kproto/`, on COPIES of lean-reflect's files, sha in kproto/LEANREFLECT_SHA256)
- `KProto/Kernel.lean`, `KernelG.lean`: kernel-reducible forms of lean-reflect's `check` / `checkG` (insertion sort,
  fuel clog2, Nat-coded tree lookup `BT2.find` that re-checks the full key), proved equal; `lower_bound_tree(2|G)`.
- `Gen.lean`, `Gen2.lean` (exes gen, gen2): untrusted certificate → chunked kernel modules; `run3.sh` runs them
  (`lake env lean -j 1 --tstack`, NUMA membind via tools/membind.py, resumable).
- DONE kernel-only: `KProto.Cn3k8I1.lower_bound_kernel_x86 : ∀ p o, p.length ≤ 8 → ¬ XSnap 3 p o` (std axioms only).
- RUNNING: k ≤ 10, set+S3 model, 56816 states → 20481 modules (`KProto/D3k10I1G`, logs/k10g/progress.txt), 4 cores,
  est. 170 CPU-h (asked coordinator for 32 cores).

## Running
- `run3.sh KProto/D3k10I1G k10g 4 0-3 0` (nohup; resumable).

## Remaining sorry
- none.

## Next
- G2 (L5) DONE. Theory review of the l5 / mm_lower_bound text requested.
- G3 only if a final claim uses a non-symmetry rule (asked proofs/sat); Lean routes need none.
- relaxed checker / transition check for sat/enum (task 6); RS T-machine equivalence; `out` file ⇔ `XSnap` lemma.
- checker for n = 6..8 (needs a Fubini-size representative generator).
