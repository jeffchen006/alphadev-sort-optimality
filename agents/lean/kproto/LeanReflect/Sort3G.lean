import LeanReflect.SymSound
import LeanReflect.Ctx3
import SortProof.Snap
/-
  sort3 again, with the smaller certificate: set model (Lemma S) + rule G (S_3 input relabelling).
  56816 states (multiset model: 437100). Trust: Lean kernel + Lean compiler (native_decide).
-/
namespace LeanReflect
open SortProof

theorem setCtxOK3 : SetCtxOK (mkCtx 3) := ⟨by decide, by decide⟩
theorem groupOK3 : GroupOK (mkCtx 3) (group (mkCtx 3)) := ⟨by decide, by decide⟩

theorem sort3_rs_lb_G : ∀ (p : Program) (o : Snap), p.length ≤ 10 → ¬ RelaxedSnap 3 p o :=
  fun p o hp => certOKG_sound 3 10 I1 ctxOK3 setCtxOK3 groupOK3 swap_I1 (by native_decide) p o hp
    (fun i _ => condIn_I1 i)

end LeanReflect
