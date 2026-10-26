import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1128_ok : (chunk1128.toList M 3).all F = true := by decide +kernel
theorem chunk1129_ok : (chunk1129.toList M 3).all F = true := by decide +kernel
theorem chunk1130_ok : (chunk1130.toList M 3).all F = true := by decide +kernel
theorem chunk1131_ok : (chunk1131.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
