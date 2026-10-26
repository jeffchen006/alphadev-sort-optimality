import KProto.D3k8I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k8I1G
open LeanReflect KProto
theorem chunk19_ok : (chunk19.toList M 3).all F = true := by decide +kernel
end KProto.D3k8I1G
