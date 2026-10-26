import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk100_ok : (chunk100.toList M 3).all F = true := by decide +kernel
theorem chunk101_ok : (chunk101.toList M 3).all F = true := by decide +kernel
theorem chunk102_ok : (chunk102.toList M 3).all F = true := by decide +kernel
theorem chunk103_ok : (chunk103.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
