import KProto.HFast
namespace KProto
open LeanReflect
set_option maxRecDepth 1000000
-- only undone + usig
theorem t_us : (((succsK c3 I1 (rootK c3)).map (fun k =>
    ((List.range c3.m).map (fun i => listCode (usig c3 k i))).sum)).sum == 12345) = false := by
  decide +kernel
end KProto
