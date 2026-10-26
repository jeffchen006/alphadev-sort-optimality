import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1440_ok : (chunk1440.toList M 3).all F = true := by decide +kernel
theorem chunk1441_ok : (chunk1441.toList M 3).all F = true := by decide +kernel
theorem chunk1442_ok : (chunk1442.toList M 3).all F = true := by decide +kernel
theorem chunk1443_ok : (chunk1443.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
