# lean-lrat — round 1 report (Lean route B: verified CNF encoder + Lean's own verified LRAT checker)

## Main result: AlphaDev sort3 = 17 is optimal, as one Lean theorem (two independent builds)
1. `agents/lean-lrat/Results/S3_I1c_K10/Main.lean` (first-touch rule only, 32 cubes):
   - `sort3_I1c_no_le10 : ∀ p o, p.length ≤ 10 → (∀ i ∈ p, i.inSet (isetOf true)) → ¬ XSnap 3 p o`
   - `sort3_I1c_no_le10_MM : ∀ q, MMProg 3 q → q.length ≤ 10 + 2*3 → … → ¬ XCorrect 3 q`
   - 32 cube LRATs (split on "step t is a cmp", t = 0..4), 22.6 GB trimmed, 2.84 core-h cadical, leaf checks
     ~1.4 h, max 24 GB RAM; joined in the kernel by `unsat_split`. Axioms: 3 std + 33 native_decide.
2. `agents/lean-lrat/dev/Results/Sort3_I1nh_K10.lean` (all rules, 6 permutation types, ONE certificate):
   - `sort3_I1_no_le10`, `sort3_I1_MM_no_le16` (same statements). LRAT 887 MB, cadical 556 s, Lean check
     433 s / 10.7 GB. Axioms: propext, Classical.choice, Quot.sound + 3 native_decide (layout, perm, cert).
   Statement meaning: x86-64 32-bit semantics of lean's frozen v2 (vendored byte copy); I1 = mov, cmp,
   cmovl/g/le/ge; any registers; XSnap = free snapshot outputs (M_out), XCorrect+MMProg = memory model M_AD
   (MM-1, every instruction incl. loads/stores counts) via lean's L5 `mm_lower_bound`; all garbage/flag states.
   Also: `sort3_I1c_no_le9` monolithic; proofs' cake_lpr verified my k=7,8,9 files.

## Done
- NOTES.md: Lean v4.33.1 API/trust base. `verifyCert`/`LRAT.check` (+ soundness), `CNF.dimacs`, `LRAT.trim`;
  `native_decide` adds an aux axiom via `Lean.Meta.nativeEqTrue` (`Lean.ofReduceBool` deprecated, unused).
  Trust: kernel + Lean compiler/runtime for the aux axioms. Untrusted: cadical, trim, DIMACS file (the check
  recomputes the CNF from the verified encoder), scripts.
- Encoder `enc n k i1 canon types norm hc` (content encoding, M_out snapshots, I0/I1, R = n+k, any type list),
  soundness = exactly hypothesis H of lean's chain. No sorry; main lemmas: 3 standard axioms only.
- Rules / cuts PROVED in Lean: first-touch (= sat canon+pcanon), normal form (nop suffix, no cmovl/g before
  first cmp, every cmp read, no self moves), snapcmov, hcmp part 2 (`class_bound`: agreeing permutation types
  ≤ 2^(#cmp in suffix)). theory confirmed the statements.
- Tools: `lrat-tool dimacs|cube|trim|check|names|var`, `tools/solve.sh`, `mkresult.sh`, `cubes.py`.
- Cross-check: my CNF = sat's CNF on SAT/UNSAT (n=2 k=2..5, n=3 k=4..7).

## Numbers (cadical 3.0.1, 1 core, machine load ~190/192)
| n | k | encoding | types | solve | trimmed LRAT |
|---|---|---|---|---|---|
| 3 | 8 | first-touch | 13 weak | 38 s | 87 MB |
| 3 | 9 | first-touch | 13 weak | 419 s | 814 MB |
| 3 | 10 | first-touch, 32 cubes | 13 weak | 10230 s total | 22.6 GB |
| 3 | 8 | all rules + hcmp | 6 perm | 4 s | — |
| 3 | 9 | all rules + hcmp | 6 perm | 25 s | — |
| 3 | 10 | all rules + hcmp | 6 perm | 556 s | 887 MB |
| 4 | 10 / 11 / 12 | all rules + hcmp | 24 perm | 21 s / 1865 s / 852 s | – / 1.8 GB / 119 MB |
| 4 | 13 | same | 24 perm | running (1 h limit) | |
CNF size: n=4 k=19 (24 perm, first-touch) 0.48 M clauses; n=5 k=31 (120 perm) 0.9 M vars, 6.9 M clauses.

## Open problems / next
- sort4 (UNSAT at k=19 needed): far from reach with current rules (k=12 takes 15 min). Next: hcmp part 1
  (counting Q ≤ M, W ≤ M), sat's comm/dead/cmpord/movfresh with Lean proofs, cube-and-conquer on many cores.
- sort5: not reachable now.
- Merge `dev/` into the main project (kept separate so the k=10 cube build stayed valid).
- native_decide aux axioms cannot be re-checked by an external kernel checker; cake_lpr (proofs) is the
  independent second check of the same LRAT files.
