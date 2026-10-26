import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk40_ok : (chunk40.toList M 3).all F = true := by decide +kernel
theorem chunk41_ok : (chunk41.toList M 3).all F = true := by decide +kernel
theorem chunk42_ok : (chunk42.toList M 3).all F = true := by decide +kernel
theorem chunk43_ok : (chunk43.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
