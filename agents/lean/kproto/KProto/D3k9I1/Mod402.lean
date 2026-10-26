import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1608_ok : (chunk1608.toList M 3).all F = true := by decide +kernel
theorem chunk1609_ok : (chunk1609.toList M 3).all F = true := by decide +kernel
theorem chunk1610_ok : (chunk1610.toList M 3).all F = true := by decide +kernel
theorem chunk1611_ok : (chunk1611.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
