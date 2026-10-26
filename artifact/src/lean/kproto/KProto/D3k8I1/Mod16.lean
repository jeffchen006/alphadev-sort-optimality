import KProto.D3k8I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k8I1
open LeanReflect KProto
theorem chunk64_ok : (chunk64.toList M 3).all F = true := by decide +kernel
theorem chunk65_ok : (chunk65.toList M 3).all F = true := by decide +kernel
theorem chunk66_ok : (chunk66.toList M 3).all F = true := by decide +kernel
theorem chunk67_ok : (chunk67.toList M 3).all F = true := by decide +kernel
end KProto.D3k8I1
