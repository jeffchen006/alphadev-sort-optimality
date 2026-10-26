# lean-reflect — round 1 report (2026-10-24)

## Done
1. Dependency: `SortProof/*` = byte copy of `agents/lean/frozen/v1` (agreed with `lean`); `./check_core.sh` checks the sha256.
   No path require, no build race. Statement uses lean's `RelaxedSnap` / `XSnap` (RS = M_out, MODEL §4.3).
2. Verified search (Lean 4.33.1, core only, no `sorry`), `agents/lean-reflect/LeanReflect/`:
   - key = (multiset of non-T columns of all registers, flags up to lt/gt swap, outputs already present); tests = 6 strict
     permutations; registers unbounded (any Nat), so no register-bound lemma is needed.
   - rules, each proved: W (permutation tests), D (dead value), H1 (cmp classes, counted by distinct undone-output
     signatures), #undone writes, polarity. Closure checker `check`, parallel `checkPar` (Tasks), proof `check_sound`.
3. MAIN THEOREM `LeanReflect.sort3_x86_lb : ∀ p o, p.length ≤ 10 → ¬ XSnap 3 p o`
   (also `sort3_rs_lb` for RelaxedSnap). n=3, k ≤ 10, R unbounded, I1, C = #mov/cmp/cmov, outputs = free snapshots.
   With spec's L_AD = 2n + k_out: no AlphaDev-model sort3 with L ≤ 16.
   TRUST: Lean kernel + Lean compiler (native_decide). 437100 states, 858 s on 4 cores.
4. Positive side, kernel only: AlphaDev sort3 (k=11) and sort4 (k=20) M_out forms are `XSnap`-correct
   (`LeanReflect.Pos.p3_x86`, `p4_x86`). So k_out(3) = 11 in Lean.
5. Cross-check: per-depth new states 7, 36, 346, 3667, 43305, 231397, 158017, 318, 6, 0 — same tail (318, 6, 0) as
   enum_out (431473 states, set model); sat, sat2, enum all report none ≤ 10, k=11 SAT. No mismatch.

## Numbers
| run | states | time | result |
|---|---|---|---|
| sort3 KB=8 (native_decide) | 1094 | ~1 s | none ≤ 8 |
| sort3 KB=9 (parallel, native_decide) | 20230 | 31 s | none ≤ 9 |
| sort3 KB=10 (theorem) | 437100 | 858 s, 4 cores | none ≤ 10 |
| sort4 KB=12 (exe only, not a theorem) | 211700 | 21 min, 4 cores | none ≤ 12 |

## Open problems
- sort4 (KB=19) is out of reach: ~23 ms CPU per state for n=4 (H1 on 24 tests dominates); enum already has 7.6M states
  at KB=14 and about ×3–5 per KB, so KB=19 is ~1e9–1e10 states. Estimate: 1e9 states × 23 ms ≈ 250 CPU-days.
  Needs ~1000× (packed columns, array rows, faster class grouping) plus stronger proved rules (set model + subsumption,
  H2, S_n relabelling). sort5 (KB=31): not feasible on this route.
- Kernel-only trust: the checker does not reduce in the kernel (WF recursion, HashMap); even if fixed, 437K states is
  far too many for the kernel. Kernel-only results are possible only for small KB.
- theory: please review the statement of `sort3_x86_lb` and the rule list (sent to board/inbox/theory.md).

## Next
1. Speed-up of the verified checker (target: n=4 KB=15–16 as a step), then decide sort4 with enum's state counts.
2. Prove enum's set-model + subsumption rule in Lean (largest state cut) and H2.
3. Optional: kernel-reducible checker for small KB (structural sort, tree map).

## Re-run
cd agents/lean-reflect && ./check_core.sh && lake build LeanReflect.Sort3 LeanReflect.Positive
