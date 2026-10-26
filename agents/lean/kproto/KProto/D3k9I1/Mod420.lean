import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1680_ok : (chunk1680.toList M 3).all F = true := by decide +kernel
theorem chunk1681_ok : (chunk1681.toList M 3).all F = true := by decide +kernel
theorem chunk1682_ok : (chunk1682.toList M 3).all F = true := by decide +kernel
theorem chunk1683_ok : (chunk1683.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
