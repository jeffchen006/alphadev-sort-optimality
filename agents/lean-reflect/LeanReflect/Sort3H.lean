import LeanReflect.FileCert
import LeanReflect.Sort3G
/-
  sort3, third certificate: set model + G + H3' (cover bound), 2215 states, read from the file
  certs/sort3_I1_k10_h3.cert (format v1). Trust: kernel + compiler (native_decide; file read via implemented_by).
-/
namespace LeanReflect
open SortProof

theorem sort3_rs_lb_H : ∀ (p : Program) (o : Snap), p.length ≤ 10 → ¬ RelaxedSnap 3 p o :=
  fun p o hp => lower_bound_file 3 10 I1 ctxOK3 setCtxOK3 groupOK3 swap_I1 (certFile "certs/sort3_I1_k10_h3.cert" 3)
    (by native_decide) p o hp (fun i _ => condIn_I1 i)

/-- Same, with the certificate computed inside Lean (no file). -/
theorem sort3_rs_lb_H' : ∀ (p : Program) (o : Snap), p.length ≤ 10 → ¬ RelaxedSnap 3 p o :=
  fun p o hp => certOKG_sound 3 10 I1 ctxOK3 setCtxOK3 groupOK3 swap_I1 (by native_decide) p o hp
    (fun i _ => condIn_I1 i)

end LeanReflect
