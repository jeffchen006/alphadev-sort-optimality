import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1340_ok : (chunk1340.toList M 3).all F = true := by decide +kernel
theorem chunk1341_ok : (chunk1341.toList M 3).all F = true := by decide +kernel
theorem chunk1342_ok : (chunk1342.toList M 3).all F = true := by decide +kernel
theorem chunk1343_ok : (chunk1343.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
