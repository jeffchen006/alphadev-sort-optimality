import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk16_ok : (chunk16.toList M 3).all F = true := by decide +kernel
theorem chunk17_ok : (chunk17.toList M 3).all F = true := by decide +kernel
theorem chunk18_ok : (chunk18.toList M 3).all F = true := by decide +kernel
theorem chunk19_ok : (chunk19.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
