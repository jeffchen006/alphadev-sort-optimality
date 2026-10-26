import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk312_ok : (chunk312.toList M 3).all F = true := by decide +kernel
theorem chunk313_ok : (chunk313.toList M 3).all F = true := by decide +kernel
theorem chunk314_ok : (chunk314.toList M 3).all F = true := by decide +kernel
theorem chunk315_ok : (chunk315.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
