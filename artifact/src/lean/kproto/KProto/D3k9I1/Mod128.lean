import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk512_ok : (chunk512.toList M 3).all F = true := by decide +kernel
theorem chunk513_ok : (chunk513.toList M 3).all F = true := by decide +kernel
theorem chunk514_ok : (chunk514.toList M 3).all F = true := by decide +kernel
theorem chunk515_ok : (chunk515.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
