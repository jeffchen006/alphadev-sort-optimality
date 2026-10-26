import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1024_ok : (chunk1024.toList M 3).all F = true := by decide +kernel
theorem chunk1025_ok : (chunk1025.toList M 3).all F = true := by decide +kernel
theorem chunk1026_ok : (chunk1026.toList M 3).all F = true := by decide +kernel
theorem chunk1027_ok : (chunk1027.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
