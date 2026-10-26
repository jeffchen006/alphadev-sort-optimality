import LeanReflect.Ctx4OK
/-
  sort4, k ≤ 19, strict (x86) model: enum's certificate ../enum/certs/sort4_I1_k19_ng1.cert (1.39e9 states), checked
  by the verified store checker (`storeCheck`, native_decide; rules W,P,G,S,D,H1,und,H3',E,NG, raw-key H first).
  MM corollary (L ≤ 27): LRMM/Sort4K19MM.lean.
  Trust: Lean kernel + Lean compiler (native_decide; the file is read by `implemented_by`).
-/
namespace LeanReflect.FP
open SortProof LeanReflect

theorem sort4_x_lb19 : ∀ (p : Program) (o : Snap), p.length ≤ 19 → ¬ XSnap 4 p o :=
  lb_of_storeCheck "../enum/certs/sort4_I1_k19_ng1.cert" 19 (by native_decide)

end LeanReflect.FP
