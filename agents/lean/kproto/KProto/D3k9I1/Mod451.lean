import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1804_ok : (chunk1804.toList M 3).all F = true := by decide +kernel
theorem chunk1805_ok : (chunk1805.toList M 3).all F = true := by decide +kernel
theorem chunk1806_ok : (chunk1806.toList M 3).all F = true := by decide +kernel
theorem chunk1807_ok : (chunk1807.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
