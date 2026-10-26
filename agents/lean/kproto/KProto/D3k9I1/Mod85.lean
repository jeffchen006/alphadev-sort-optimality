import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk340_ok : (chunk340.toList M 3).all F = true := by decide +kernel
theorem chunk341_ok : (chunk341.toList M 3).all F = true := by decide +kernel
theorem chunk342_ok : (chunk342.toList M 3).all F = true := by decide +kernel
theorem chunk343_ok : (chunk343.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
