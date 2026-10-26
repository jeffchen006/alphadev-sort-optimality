import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk620_ok : (chunk620.toList M 3).all F = true := by decide +kernel
theorem chunk621_ok : (chunk621.toList M 3).all F = true := by decide +kernel
theorem chunk622_ok : (chunk622.toList M 3).all F = true := by decide +kernel
theorem chunk623_ok : (chunk623.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
