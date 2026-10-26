import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk640_ok : (chunk640.toList M 3).all F = true := by decide +kernel
theorem chunk641_ok : (chunk641.toList M 3).all F = true := by decide +kernel
theorem chunk642_ok : (chunk642.toList M 3).all F = true := by decide +kernel
theorem chunk643_ok : (chunk643.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
