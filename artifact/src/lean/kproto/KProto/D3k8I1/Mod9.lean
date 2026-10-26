import KProto.D3k8I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k8I1
open LeanReflect KProto
theorem chunk36_ok : (chunk36.toList M 3).all F = true := by decide +kernel
theorem chunk37_ok : (chunk37.toList M 3).all F = true := by decide +kernel
theorem chunk38_ok : (chunk38.toList M 3).all F = true := by decide +kernel
theorem chunk39_ok : (chunk39.toList M 3).all F = true := by decide +kernel
end KProto.D3k8I1
