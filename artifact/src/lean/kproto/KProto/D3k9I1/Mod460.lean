import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1840_ok : (chunk1840.toList M 3).all F = true := by decide +kernel
theorem chunk1841_ok : (chunk1841.toList M 3).all F = true := by decide +kernel
theorem chunk1842_ok : (chunk1842.toList M 3).all F = true := by decide +kernel
theorem chunk1843_ok : (chunk1843.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
