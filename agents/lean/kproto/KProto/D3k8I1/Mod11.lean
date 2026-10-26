import KProto.D3k8I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k8I1
open LeanReflect KProto
theorem chunk44_ok : (chunk44.toList M 3).all F = true := by decide +kernel
theorem chunk45_ok : (chunk45.toList M 3).all F = true := by decide +kernel
theorem chunk46_ok : (chunk46.toList M 3).all F = true := by decide +kernel
theorem chunk47_ok : (chunk47.toList M 3).all F = true := by decide +kernel
end KProto.D3k8I1
