import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1252_ok : (chunk1252.toList M 3).all F = true := by decide +kernel
theorem chunk1253_ok : (chunk1253.toList M 3).all F = true := by decide +kernel
theorem chunk1254_ok : (chunk1254.toList M 3).all F = true := by decide +kernel
theorem chunk1255_ok : (chunk1255.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
