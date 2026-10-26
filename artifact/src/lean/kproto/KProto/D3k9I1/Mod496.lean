import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1984_ok : (chunk1984.toList M 3).all F = true := by decide +kernel
theorem chunk1985_ok : (chunk1985.toList M 3).all F = true := by decide +kernel
theorem chunk1986_ok : (chunk1986.toList M 3).all F = true := by decide +kernel
theorem chunk1987_ok : (chunk1987.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
