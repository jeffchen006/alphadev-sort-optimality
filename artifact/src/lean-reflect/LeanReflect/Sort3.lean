import LeanReflect.Ctx3
/-
  MAIN RESULT (sort3). Model: M_out / RS (MODEL.md §4.3), instruction set I1 (mov, cmp, cmovl, cmovg, cmovle, cmovge),
  registers unbounded (any `Nat`), outputs = free snapshots of any register at any time (`o : Snap`),
  counting = number of mov/cmp/cmov. Relaxed semantics (scratch = T, flags = eq) is implied by x86 correctness.
  Trust: Lean kernel + Lean compiler (`native_decide` evaluates the verified checker `checkPar`).
-/
namespace LeanReflect
open SortProof

/-- No program of length ≤ 10 sorts 3 inputs in the relaxed RS model (I1, unbounded registers). -/
theorem sort3_rs_lb : ∀ (p : Program) (o : Snap), p.length ≤ 10 → ¬ RelaxedSnap 3 p o :=
  fun p o hp => lower_bound_par 3 10 4 I1 ctxOK3 swap_I1 (by decide) (by native_decide) p o hp
    (fun i _ => condIn_I1 i)

/-- The x86 form: no program of length ≤ 10 sorts 3 int32 values for all garbage / flag states. -/
theorem sort3_x86_lb : ∀ (p : Program) (o : Snap), p.length ≤ 10 → ¬ XSnap 3 p o :=
  fun p o hp hx => sort3_rs_lb p o hp (xsnap_to_relaxed (by decide) hx)

end LeanReflect
