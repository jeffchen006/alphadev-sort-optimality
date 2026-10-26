import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1380_ok : (chunk1380.toList M 3).all F = true := by decide +kernel
theorem chunk1381_ok : (chunk1381.toList M 3).all F = true := by decide +kernel
theorem chunk1382_ok : (chunk1382.toList M 3).all F = true := by decide +kernel
theorem chunk1383_ok : (chunk1383.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
