import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1520_ok : (chunk1520.toList M 3).all F = true := by decide +kernel
theorem chunk1521_ok : (chunk1521.toList M 3).all F = true := by decide +kernel
theorem chunk1522_ok : (chunk1522.toList M 3).all F = true := by decide +kernel
theorem chunk1523_ok : (chunk1523.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
