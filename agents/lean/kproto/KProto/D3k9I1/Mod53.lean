import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk212_ok : (chunk212.toList M 3).all F = true := by decide +kernel
theorem chunk213_ok : (chunk213.toList M 3).all F = true := by decide +kernel
theorem chunk214_ok : (chunk214.toList M 3).all F = true := by decide +kernel
theorem chunk215_ok : (chunk215.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
