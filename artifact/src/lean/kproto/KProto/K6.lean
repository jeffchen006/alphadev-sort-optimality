import KProto.Measure
namespace KProto
open LeanReflect
set_option maxRecDepth 1000000
theorem t_h1 : (((succsK c3 I1 (rootK c3)).map (fun k => hK c3 k)).sum == 12345) = false := by decide +kernel
end KProto
