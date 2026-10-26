import LRMM.Sort4MM
import LeanReflect.Sort4K19
/-
  sort4, AlphaDev (MM) model: no XCorrect MM program of length ≤ 27 (k ≤ 19 certificate + frozen v3 strict L5).
  With AlphaDev's sort4 (L = 28): the MM optimum is 28. Trust: Lean kernel + compiler (native_decide in Sort4K19).
-/
namespace LeanReflect.FP
open SortProof LeanReflect

theorem sort4_mm_lb27 : ∀ q : Program, MMProg 4 q → q.length ≤ 27 → ¬ XCorrect 4 q :=
  mm_of_strict4 19 sort4_x_lb19

end LeanReflect.FP
