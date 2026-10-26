import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk380_ok : (chunk380.toList M 3).all F = true := by decide +kernel
theorem chunk381_ok : (chunk381.toList M 3).all F = true := by decide +kernel
theorem chunk382_ok : (chunk382.toList M 3).all F = true := by decide +kernel
theorem chunk383_ok : (chunk383.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
