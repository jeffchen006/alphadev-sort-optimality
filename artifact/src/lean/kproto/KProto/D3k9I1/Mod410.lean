import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1640_ok : (chunk1640.toList M 3).all F = true := by decide +kernel
theorem chunk1641_ok : (chunk1641.toList M 3).all F = true := by decide +kernel
theorem chunk1642_ok : (chunk1642.toList M 3).all F = true := by decide +kernel
theorem chunk1643_ok : (chunk1643.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
