import LeanReflect.Ctx4OK
/-
  sort4, k ≤ 17, strict (x86) model: enum's certificate ../enum/certs/sort4_I1_k17_ng1.cert, checked by the
  verified store checker (`storeCheck`, native_decide). Trust: Lean kernel + compiler.
-/
namespace LeanReflect.FP
open SortProof LeanReflect

theorem sort4_x_lb17 : ∀ (p : Program) (o : Snap), p.length ≤ 17 → ¬ XSnap 4 p o :=
  lb_of_storeCheck "../enum/certs/sort4_I1_k17_ng1.cert" 17 (by native_decide)

end LeanReflect.FP
