import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk60_ok : (chunk60.toList M 3).all F = true := by decide +kernel
theorem chunk61_ok : (chunk61.toList M 3).all F = true := by decide +kernel
theorem chunk62_ok : (chunk62.toList M 3).all F = true := by decide +kernel
theorem chunk63_ok : (chunk63.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
