import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk500_ok : (chunk500.toList M 3).all F = true := by decide +kernel
theorem chunk501_ok : (chunk501.toList M 3).all F = true := by decide +kernel
theorem chunk502_ok : (chunk502.toList M 3).all F = true := by decide +kernel
theorem chunk503_ok : (chunk503.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
