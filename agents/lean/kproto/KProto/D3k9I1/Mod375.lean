import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1500_ok : (chunk1500.toList M 3).all F = true := by decide +kernel
theorem chunk1501_ok : (chunk1501.toList M 3).all F = true := by decide +kernel
theorem chunk1502_ok : (chunk1502.toList M 3).all F = true := by decide +kernel
theorem chunk1503_ok : (chunk1503.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
