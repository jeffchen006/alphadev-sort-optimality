import KProto.Measure
namespace KProto
open LeanReflect
set_option maxRecDepth 1000000
theorem k4s : (((succsK c3 I1 k4).map (fun k => hK c3 k + (if dead c3 k then 1 else 0))).sum == 12345) = false := by
  decide +kernel
end KProto
