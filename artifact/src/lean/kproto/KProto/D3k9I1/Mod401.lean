import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1604_ok : (chunk1604.toList M 3).all F = true := by decide +kernel
theorem chunk1605_ok : (chunk1605.toList M 3).all F = true := by decide +kernel
theorem chunk1606_ok : (chunk1606.toList M 3).all F = true := by decide +kernel
theorem chunk1607_ok : (chunk1607.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
