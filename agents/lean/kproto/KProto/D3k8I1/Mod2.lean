import KProto.D3k8I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k8I1
open LeanReflect KProto
theorem chunk8_ok : (chunk8.toList M 3).all F = true := by decide +kernel
theorem chunk9_ok : (chunk9.toList M 3).all F = true := by decide +kernel
theorem chunk10_ok : (chunk10.toList M 3).all F = true := by decide +kernel
theorem chunk11_ok : (chunk11.toList M 3).all F = true := by decide +kernel
end KProto.D3k8I1
