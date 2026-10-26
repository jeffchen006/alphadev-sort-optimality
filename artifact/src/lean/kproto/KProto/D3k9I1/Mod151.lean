import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk604_ok : (chunk604.toList M 3).all F = true := by decide +kernel
theorem chunk605_ok : (chunk605.toList M 3).all F = true := by decide +kernel
theorem chunk606_ok : (chunk606.toList M 3).all F = true := by decide +kernel
theorem chunk607_ok : (chunk607.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
