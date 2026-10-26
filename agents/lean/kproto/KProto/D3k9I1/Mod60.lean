import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk240_ok : (chunk240.toList M 3).all F = true := by decide +kernel
theorem chunk241_ok : (chunk241.toList M 3).all F = true := by decide +kernel
theorem chunk242_ok : (chunk242.toList M 3).all F = true := by decide +kernel
theorem chunk243_ok : (chunk243.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
