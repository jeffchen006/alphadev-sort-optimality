import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk704_ok : (chunk704.toList M 3).all F = true := by decide +kernel
theorem chunk705_ok : (chunk705.toList M 3).all F = true := by decide +kernel
theorem chunk706_ok : (chunk706.toList M 3).all F = true := by decide +kernel
theorem chunk707_ok : (chunk707.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
