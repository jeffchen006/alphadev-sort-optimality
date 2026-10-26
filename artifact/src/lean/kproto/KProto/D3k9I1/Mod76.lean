import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk304_ok : (chunk304.toList M 3).all F = true := by decide +kernel
theorem chunk305_ok : (chunk305.toList M 3).all F = true := by decide +kernel
theorem chunk306_ok : (chunk306.toList M 3).all F = true := by decide +kernel
theorem chunk307_ok : (chunk307.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
