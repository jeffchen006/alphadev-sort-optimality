import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk72_ok : (chunk72.toList M 3).all F = true := by decide +kernel
theorem chunk73_ok : (chunk73.toList M 3).all F = true := by decide +kernel
theorem chunk74_ok : (chunk74.toList M 3).all F = true := by decide +kernel
theorem chunk75_ok : (chunk75.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
