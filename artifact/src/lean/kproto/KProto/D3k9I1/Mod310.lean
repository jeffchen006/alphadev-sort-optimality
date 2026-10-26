import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1240_ok : (chunk1240.toList M 3).all F = true := by decide +kernel
theorem chunk1241_ok : (chunk1241.toList M 3).all F = true := by decide +kernel
theorem chunk1242_ok : (chunk1242.toList M 3).all F = true := by decide +kernel
theorem chunk1243_ok : (chunk1243.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
