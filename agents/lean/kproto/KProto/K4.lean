import KProto.Measure
namespace KProto
open LeanReflect
set_option maxRecDepth 1000000
theorem s_dead : (((succsK c3 I1 (rootK c3)).map (fun k => if dead c3 k then 1 else 0)).sum == 12345) = false := by decide +kernel
end KProto
