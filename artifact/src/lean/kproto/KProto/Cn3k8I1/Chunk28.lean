import KProto.Cn3k8I1.Data
set_option maxRecDepth 1000000
namespace KProto.Cn3k8I1
open LeanReflect KProto
theorem chunk28_ok : chunk28.toList.all (stateOK (mkCtx 3) I1 8 (lookT cert)) = true := by decide +kernel
end KProto.Cn3k8I1
