import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1624_ok : (chunk1624.toList M 3).all F = true := by decide +kernel
theorem chunk1625_ok : (chunk1625.toList M 3).all F = true := by decide +kernel
theorem chunk1626_ok : (chunk1626.toList M 3).all F = true := by decide +kernel
theorem chunk1627_ok : (chunk1627.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
