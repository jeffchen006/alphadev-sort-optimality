import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1800_ok : (chunk1800.toList M 3).all F = true := by decide +kernel
theorem chunk1801_ok : (chunk1801.toList M 3).all F = true := by decide +kernel
theorem chunk1802_ok : (chunk1802.toList M 3).all F = true := by decide +kernel
theorem chunk1803_ok : (chunk1803.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
