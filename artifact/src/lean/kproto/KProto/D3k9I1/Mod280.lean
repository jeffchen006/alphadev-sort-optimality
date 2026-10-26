import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1120_ok : (chunk1120.toList M 3).all F = true := by decide +kernel
theorem chunk1121_ok : (chunk1121.toList M 3).all F = true := by decide +kernel
theorem chunk1122_ok : (chunk1122.toList M 3).all F = true := by decide +kernel
theorem chunk1123_ok : (chunk1123.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
