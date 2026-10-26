import LeanReflect.Ctx4OK
import SortProof.L5Strict
/-
  Composition with lean's frozen v3 `mm_lower_bound_strict` (strict L5): a strict out-model bound at K gives
  "no MM program of length ≤ K + 8 is XCorrect" for sort4 (any opcode set).
-/
namespace LeanReflect.FP
open SortProof LeanReflect

theorem mm_of_strict4 (K : Nat) (H : ∀ (p : Program) (o : Snap), p.length ≤ K → ¬ XSnap 4 p o) :
    ∀ q : Program, MMProg 4 q → q.length ≤ K + 8 → ¬ XCorrect 4 q :=
  fun q hmm hlen => mm_lower_bound_strict 4 K (fun _ => true) (by decide) (by decide)
    (fun p o hp _ => H p o hp) q hmm hlen (fun i _ => by cases i <;> rfl)

end LeanReflect.FP
