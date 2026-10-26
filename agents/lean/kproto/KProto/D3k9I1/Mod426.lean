import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1704_ok : (chunk1704.toList M 3).all F = true := by decide +kernel
theorem chunk1705_ok : (chunk1705.toList M 3).all F = true := by decide +kernel
theorem chunk1706_ok : (chunk1706.toList M 3).all F = true := by decide +kernel
theorem chunk1707_ok : (chunk1707.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
