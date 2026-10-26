import KProto.Measure
namespace KProto
open LeanReflect
set_option maxRecDepth 1000000
-- cost of successor generation + h + dead for the root
theorem kr : ((succsK c3 I1 (rootK c3)).map (fun k => hK c3 k + (if dead c3 k then 1 else 0))).sum = 0 ∨ True := by
  exact Or.inr trivial
theorem kr1 : (((succsK c3 I1 (rootK c3)).map (fun k => hK c3 k + (if dead c3 k then 1 else 0))).sum == 12345) = false := by
  decide +kernel
end KProto
