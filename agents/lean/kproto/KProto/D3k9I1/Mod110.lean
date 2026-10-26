import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk440_ok : (chunk440.toList M 3).all F = true := by decide +kernel
theorem chunk441_ok : (chunk441.toList M 3).all F = true := by decide +kernel
theorem chunk442_ok : (chunk442.toList M 3).all F = true := by decide +kernel
theorem chunk443_ok : (chunk443.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
