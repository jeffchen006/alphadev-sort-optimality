import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1812_ok : (chunk1812.toList M 3).all F = true := by decide +kernel
theorem chunk1813_ok : (chunk1813.toList M 3).all F = true := by decide +kernel
theorem chunk1814_ok : (chunk1814.toList M 3).all F = true := by decide +kernel
theorem chunk1815_ok : (chunk1815.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
