import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1080_ok : (chunk1080.toList M 3).all F = true := by decide +kernel
theorem chunk1081_ok : (chunk1081.toList M 3).all F = true := by decide +kernel
theorem chunk1082_ok : (chunk1082.toList M 3).all F = true := by decide +kernel
theorem chunk1083_ok : (chunk1083.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
