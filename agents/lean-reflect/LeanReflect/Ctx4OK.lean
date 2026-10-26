import LeanReflect.PK19
/-
  Facts about the fixed context n = 4 (24 tests), checked by native_decide.
-/
namespace LeanReflect.FP
open SortProof LeanReflect

theorem ctxOK4' : CtxOK (mkCtx 4) := ⟨rfl, rfl, rfl, by decide, by decide, by decide, by decide, by decide⟩
theorem setCtxOK4' : SetCtxOK (mkCtx 4) := ⟨by decide, by decide⟩
theorem groupOK4' : GroupOK (mkCtx 4) (group (mkCtx 4)) := ⟨by decide, by decide⟩

theorem fcok4 : FCOK (mkFC (mkCtx 4)) where
  hm := by native_decide
  hn1 := by native_decide
  hn4 := by native_decide
  mask := by native_decide
  tcode := by native_decide
  tc := by native_decide
  tcWF := by native_decide
  inv := by native_decide
  ptab := rfl
  grp := rfl

theorem inv5_4 : ∀ t < (mkCtx 4).m, ∀ v ≤ 4, (mkFC (mkCtx 4)).inv.getD (t * 8 + v) 0 < 5 := by native_decide

theorem root4_wf : WFkey (mkCtx 4) (keyP (mkCtx 4) (root (mkCtx 4))) := by
  unfold WFkey; native_decide

theorem root4_dec : decodeK (mkCtx 4) (keyP (mkCtx 4) (root (mkCtx 4))) = root (mkCtx 4) := by native_decide

/-- The strict lower bound from a certificate file whose store check returns true. -/
theorem lb_of_storeCheck (path : String) (KB : Nat) (h : storeCheck path KB 16 = true) :
    ∀ (p : Program) (o : Snap), p.length ≤ KB → ¬ XSnap 4 p o :=
  lower_bound_store3 4 KB 16 (by decide) (by decide) (by decide) ctxOK4' setCtxOK4' groupOK4' fcok4 inv5_4 _
    root4_wf root4_dec (storeFile path) h

end LeanReflect.FP
