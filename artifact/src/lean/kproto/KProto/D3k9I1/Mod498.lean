import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1992_ok : (chunk1992.toList M 3).all F = true := by decide +kernel
theorem chunk1993_ok : (chunk1993.toList M 3).all F = true := by decide +kernel
theorem chunk1994_ok : (chunk1994.toList M 3).all F = true := by decide +kernel
theorem chunk1995_ok : (chunk1995.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
