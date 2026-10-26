import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk96_ok : (chunk96.toList M 3).all F = true := by decide +kernel
theorem chunk97_ok : (chunk97.toList M 3).all F = true := by decide +kernel
theorem chunk98_ok : (chunk98.toList M 3).all F = true := by decide +kernel
theorem chunk99_ok : (chunk99.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
