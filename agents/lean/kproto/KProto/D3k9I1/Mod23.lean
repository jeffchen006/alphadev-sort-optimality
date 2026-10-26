import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk92_ok : (chunk92.toList M 3).all F = true := by decide +kernel
theorem chunk93_ok : (chunk93.toList M 3).all F = true := by decide +kernel
theorem chunk94_ok : (chunk94.toList M 3).all F = true := by decide +kernel
theorem chunk95_ok : (chunk95.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
