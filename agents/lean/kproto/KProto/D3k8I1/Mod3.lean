import KProto.D3k8I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k8I1
open LeanReflect KProto
theorem chunk12_ok : (chunk12.toList M 3).all F = true := by decide +kernel
theorem chunk13_ok : (chunk13.toList M 3).all F = true := by decide +kernel
theorem chunk14_ok : (chunk14.toList M 3).all F = true := by decide +kernel
theorem chunk15_ok : (chunk15.toList M 3).all F = true := by decide +kernel
end KProto.D3k8I1
