import LeanReflect.Ctx3
namespace LeanReflect
open SortProof

/-- Sanity instance: no RS program of length ≤ 8 sorts 3 (I1). -/
theorem sort3_le8 : ∀ (p : Program) (o : Snap), p.length ≤ 8 → ¬ RelaxedSnap 3 p o :=
  fun p o hp => lower_bound 3 8 I1 ctxOK3 swap_I1 (by native_decide) p o hp (fun i _ => condIn_I1 i)

/-- Same with the parallel checker. -/
theorem sort3_le9_par : ∀ (p : Program) (o : Snap), p.length ≤ 9 → ¬ RelaxedSnap 3 p o :=
  fun p o hp => lower_bound_par 3 9 4 I1 ctxOK3 swap_I1 (by decide) (by native_decide) p o hp (fun i _ => condIn_I1 i)

end LeanReflect
