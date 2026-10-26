import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk4_ok : (chunk4.toList M 3).all F = true := by decide +kernel
theorem chunk5_ok : (chunk5.toList M 3).all F = true := by decide +kernel
theorem chunk6_ok : (chunk6.toList M 3).all F = true := by decide +kernel
theorem chunk7_ok : (chunk7.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
