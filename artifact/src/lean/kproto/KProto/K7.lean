import KProto.HFast
namespace KProto
open LeanReflect
set_option maxRecDepth 1000000
-- only the signatures (stateSig + usig), no grouping
theorem t_sig : (((succsK c3 I1 (rootK c3)).map (fun k =>
    ((List.range c3.m).map (fun i => sigCode (stateSig c3 k i) + listCode (usig c3 k i))).sum)).sum == 12345) = false := by
  decide +kernel
end KProto
