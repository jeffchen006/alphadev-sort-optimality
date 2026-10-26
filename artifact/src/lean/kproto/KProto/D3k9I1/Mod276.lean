import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1104_ok : (chunk1104.toList M 3).all F = true := by decide +kernel
theorem chunk1105_ok : (chunk1105.toList M 3).all F = true := by decide +kernel
theorem chunk1106_ok : (chunk1106.toList M 3).all F = true := by decide +kernel
theorem chunk1107_ok : (chunk1107.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
