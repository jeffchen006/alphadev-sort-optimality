import KProto.D3k8I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k8I1
open LeanReflect KProto
theorem chunk32_ok : (chunk32.toList M 3).all F = true := by decide +kernel
theorem chunk33_ok : (chunk33.toList M 3).all F = true := by decide +kernel
theorem chunk34_ok : (chunk34.toList M 3).all F = true := by decide +kernel
theorem chunk35_ok : (chunk35.toList M 3).all F = true := by decide +kernel
end KProto.D3k8I1
