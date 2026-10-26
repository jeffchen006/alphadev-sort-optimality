import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1620_ok : (chunk1620.toList M 3).all F = true := by decide +kernel
theorem chunk1621_ok : (chunk1621.toList M 3).all F = true := by decide +kernel
theorem chunk1622_ok : (chunk1622.toList M 3).all F = true := by decide +kernel
theorem chunk1623_ok : (chunk1623.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
