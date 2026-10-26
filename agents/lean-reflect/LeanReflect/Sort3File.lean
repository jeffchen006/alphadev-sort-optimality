import LeanReflect.FileCert
import LeanReflect.Sort3G
namespace LeanReflect
open SortProof

/-- sort3 from the certificate FILE certs/sort3_I1_k10.cert (format v1). Trust: kernel + compiler + implemented_by. -/
theorem sort3_rs_lb_file : ∀ (p : Program) (o : Snap), p.length ≤ 10 → ¬ RelaxedSnap 3 p o :=
  fun p o hp => lower_bound_file 3 10 I1 ctxOK3 setCtxOK3 groupOK3 swap_I1 (certFile "certs/sort3_I1_k10.cert" 3)
    (by native_decide) p o hp (fun i _ => condIn_I1 i)

end LeanReflect
