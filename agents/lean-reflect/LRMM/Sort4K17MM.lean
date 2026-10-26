import LRMM.Sort4MM
import LeanReflect.Sort4K17S
namespace LeanReflect.FP
open SortProof LeanReflect

/-- sort4, MM (AlphaDev) form: no XCorrect MM program of length ≤ 25 (from the k ≤ 17 certificate). -/
theorem sort4_mm_lb25 : ∀ q : Program, MMProg 4 q → q.length ≤ 25 → ¬ XCorrect 4 q :=
  mm_of_strict4 17 sort4_x_lb17

end LeanReflect.FP
