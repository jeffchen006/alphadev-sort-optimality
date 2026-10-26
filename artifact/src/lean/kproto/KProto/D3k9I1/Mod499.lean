import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1996_ok : (chunk1996.toList M 3).all F = true := by decide +kernel
theorem chunk1997_ok : (chunk1997.toList M 3).all F = true := by decide +kernel
theorem chunk1998_ok : (chunk1998.toList M 3).all F = true := by decide +kernel
theorem chunk1999_ok : (chunk1999.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
