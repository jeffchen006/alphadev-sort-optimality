import KProto.Measure
namespace KProto
open LeanReflect
set_option maxRecDepth 1000000
theorem s_only : (((succsK c3 I1 (rootK c3)).map (fun k => k.cols.length)).sum == 12345) = false := by decide +kernel
end KProto
