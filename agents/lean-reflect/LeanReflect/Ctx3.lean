import LeanReflect.Sound
namespace LeanReflect

theorem ctxOK3 : CtxOK (mkCtx 3) :=
  ⟨rfl, rfl, rfl, by decide, by decide, by decide, by decide, by decide⟩

end LeanReflect
