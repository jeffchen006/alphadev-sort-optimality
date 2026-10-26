import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk384_ok : (chunk384.toList M 3).all F = true := by decide +kernel
theorem chunk385_ok : (chunk385.toList M 3).all F = true := by decide +kernel
theorem chunk386_ok : (chunk386.toList M 3).all F = true := by decide +kernel
theorem chunk387_ok : (chunk387.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
