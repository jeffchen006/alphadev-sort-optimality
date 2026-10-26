import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk880_ok : (chunk880.toList M 3).all F = true := by decide +kernel
theorem chunk881_ok : (chunk881.toList M 3).all F = true := by decide +kernel
theorem chunk882_ok : (chunk882.toList M 3).all F = true := by decide +kernel
theorem chunk883_ok : (chunk883.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
