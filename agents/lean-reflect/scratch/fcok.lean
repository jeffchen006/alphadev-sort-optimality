import LeanReflect.PlaneDefs
import LeanReflect.Ctx3
open LeanReflect LeanReflect.FP
example : FCOK (mkFC (mkCtx 4)) := ⟨by decide, by decide, by decide, rfl, by native_decide, by native_decide, by native_decide, by native_decide, rfl, rfl⟩
