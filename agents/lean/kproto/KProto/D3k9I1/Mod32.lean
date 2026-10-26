import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk128_ok : (chunk128.toList M 3).all F = true := by decide +kernel
theorem chunk129_ok : (chunk129.toList M 3).all F = true := by decide +kernel
theorem chunk130_ok : (chunk130.toList M 3).all F = true := by decide +kernel
theorem chunk131_ok : (chunk131.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
