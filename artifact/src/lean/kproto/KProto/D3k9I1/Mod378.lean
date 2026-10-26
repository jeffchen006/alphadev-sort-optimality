import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1512_ok : (chunk1512.toList M 3).all F = true := by decide +kernel
theorem chunk1513_ok : (chunk1513.toList M 3).all F = true := by decide +kernel
theorem chunk1514_ok : (chunk1514.toList M 3).all F = true := by decide +kernel
theorem chunk1515_ok : (chunk1515.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
