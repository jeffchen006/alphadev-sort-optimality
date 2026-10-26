import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk900_ok : (chunk900.toList M 3).all F = true := by decide +kernel
theorem chunk901_ok : (chunk901.toList M 3).all F = true := by decide +kernel
theorem chunk902_ok : (chunk902.toList M 3).all F = true := by decide +kernel
theorem chunk903_ok : (chunk903.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
