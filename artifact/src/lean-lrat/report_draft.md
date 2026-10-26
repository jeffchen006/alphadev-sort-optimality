# lean-lrat — round 1 report (Lean route B: verified encoder + Lean's own verified LRAT checker)

## Result
**sort3: AlphaDev's 17 is optimal — ONE Lean theorem** (`agents/lean-lrat/Results/S3_I1c_K10/Main.lean`):
- `sort3_I1c_no_le10 : ∀ p o, p.length ≤ 10 → (∀ i ∈ p, i.inSet (isetOf true)) → ¬ XSnap 3 p o`
  (RS / M_out: no x86-64 program with ≤ 10 mov/cmp/cmovl/cmovg/cmovle/cmovge, any registers, outputs = free
  snapshots, sorts 3 signed 32-bit inputs for all garbage registers and flags);
- `sort3_I1c_no_le10_MM : ∀ q, MMProg 3 q → q.length ≤ 16 → … → ¬ XCorrect 3 q` (memory model M_AD, MM-1,
  every instruction incl. loads/stores counts; via lean's L5 `mm_lower_bound`).
- `#print axioms`: propext, Classical.choice, Quot.sound + 33 `native_decide` aux axioms (32 cube certificates +
  1 layout check). TODO: build time / memory.
- Certificate: 32 cubes (split on "step t is a cmp", t = 0..4), cadical 3.0.1 LRAT, trimmed by Lean's
  `LRAT.trim`, each checked by Lean core's verified checker `Std.Tactic.BVDecide.LRAT.check`; cubes joined in the
  kernel by `unsat_split`. Sizes: 9 MB … 3.4 GB per cube, total TODO GB; solve time total TODO core-h.

## Done
1. API + trust base (`NOTES.md`). Lean v4.33.1: `Std.Sat.CNF`, `CNF.dimacs`, `LRAT.check` + `check_sound`,
   `Reflect.verifyCert` + `verifyCert_correct`, `LRAT.trim`. `native_decide`/`bv_decide` use
   `Lean.Meta.nativeEqTrue` (compile + run a closed Bool, add an aux axiom `e = true`); `Lean.ofReduceBool` is
   deprecated and NOT used. Trust = kernel + Lean compiler/runtime for the aux axioms. NOT trusted: cadical,
   trim, DIMACS file (the check recomputes the CNF from the verified encoder), scripts.
2. Verified encoder `enc n k i1 canon types norm hc` (`LeanLrat/Enc.lean`): M_out snapshots, I0/I1, content
   values, R = n+k, any list of input types; dense numbering checked by computation.
3. Soundness (no sorry; only propext/Classical.choice/Quot.sound): `Unsat` ⇒ exactly hypothesis H of lean's
   `lower_bound_chain_snap` / `mm_lower_bound` (vendored byte copy of `agents/lean/frozen/v2`).
4. Symmetry rules / cuts PROVED in Lean (no paper review needed for soundness):
   - first-touch = sat canon+pcanon (`Canon.lean`, `canonicalize`: class-preserving register permutation);
   - normal form: nop suffix, no cmovl/cmovg before first cmp, every cmp read, no self moves (`Normal.lean`);
   - snapcmov: outputs at cmov slots (`SnapCmov.lean`);
   - hcmp part 2 (theory L7 per step): class of agreeing permutation types ≤ 2^(#cmp in suffix) (`Hcmp.lean`,
     `class_bound`), with unary counters in the CNF. (rules 2-4: in `dev/`, merged after the k=10 build.)
5. Tools: `lrat-tool dimacs|cube|trim|check|names|var`, `tools/solve.sh`, `tools/mkresult.sh`, `tools/cubes.py`.
6. Cross-checks: my CNF = sat's CNF on SAT/UNSAT (n=2 k=2..5, n=3 k=4..7); proofs' cake_lpr also verified my
   k=7,8,9 certificates; k ≤ 9 also monolithic: `sort3_I1c_no_le9` (814 MB, 372 s, 4.9 GB).

## Numbers (cadical, 1 core, machine load ~190/192)
TODO table

## Open problems / next
- sort4 (k = 19): TODO scaling numbers with all rules. Needs more rules (sat: comm, dead, cmpord, movfresh) and
  hcmp part 1 (counting), plus many cubes on many cores.
- sort5 (k = 31): CNF size measured (120 perms: 0.9 M vars, 6.9 M clauses); not solvable now.
- The aux axioms of native_decide cannot be checked by an external kernel checker (lean4checker); the
  CakeML-verified cake_lpr check by `proofs` is an independent second check of the same LRAT files.
