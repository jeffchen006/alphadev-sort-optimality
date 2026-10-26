import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1140_ok : (chunk1140.toList M 3).all F = true := by decide +kernel
theorem chunk1141_ok : (chunk1141.toList M 3).all F = true := by decide +kernel
theorem chunk1142_ok : (chunk1142.toList M 3).all F = true := by decide +kernel
theorem chunk1143_ok : (chunk1143.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
