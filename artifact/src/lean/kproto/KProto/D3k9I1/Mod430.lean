import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1720_ok : (chunk1720.toList M 3).all F = true := by decide +kernel
theorem chunk1721_ok : (chunk1721.toList M 3).all F = true := by decide +kernel
theorem chunk1722_ok : (chunk1722.toList M 3).all F = true := by decide +kernel
theorem chunk1723_ok : (chunk1723.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
