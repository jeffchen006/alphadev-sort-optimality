import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk820_ok : (chunk820.toList M 3).all F = true := by decide +kernel
theorem chunk821_ok : (chunk821.toList M 3).all F = true := by decide +kernel
theorem chunk822_ok : (chunk822.toList M 3).all F = true := by decide +kernel
theorem chunk823_ok : (chunk823.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
