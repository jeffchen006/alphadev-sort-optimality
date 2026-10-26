import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk140_ok : (chunk140.toList M 3).all F = true := by decide +kernel
theorem chunk141_ok : (chunk141.toList M 3).all F = true := by decide +kernel
theorem chunk142_ok : (chunk142.toList M 3).all F = true := by decide +kernel
theorem chunk143_ok : (chunk143.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
