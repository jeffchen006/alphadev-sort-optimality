import LeanReflect.Sort3
import SortProof.L5
/-
  sort3 in AlphaDev's own model M_AD (MODEL §4.2): memory cells P0..P2, loads/stores counted, MM-1 (no memory operand
  in cmp/cmov), any registers, I1, x86 int32 strict correctness. Combines `sort3_rs_lb` with lean's L5 (`mm_lower_bound`).
  Trust: Lean kernel + Lean compiler (native_decide inside `sort3_rs_lb`).
-/
namespace LeanReflect
open SortProof

/-- No AlphaDev-model (MM) program of length ≤ 16 sorts 3 int32 values on x86: AlphaDev's sort3 (L = 17) is optimal. -/
theorem sort3_mm_lb : ∀ q : Program, MMProg 3 q → q.length ≤ 16 → ¬ XCorrect 3 q :=
  fun q hmm hlen => mm_lower_bound 3 10 (fun _ => true) (by decide) (by decide)
    (fun p o hp _ _ _ _ => sort3_rs_lb p o (by omega)) q hmm hlen (fun i _ => by cases i <;> rfl)

end LeanReflect
