import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1408_ok : (chunk1408.toList M 3).all F = true := by decide +kernel
theorem chunk1409_ok : (chunk1409.toList M 3).all F = true := by decide +kernel
theorem chunk1410_ok : (chunk1410.toList M 3).all F = true := by decide +kernel
theorem chunk1411_ok : (chunk1411.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
