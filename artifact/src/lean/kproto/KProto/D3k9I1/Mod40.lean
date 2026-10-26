import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk160_ok : (chunk160.toList M 3).all F = true := by decide +kernel
theorem chunk161_ok : (chunk161.toList M 3).all F = true := by decide +kernel
theorem chunk162_ok : (chunk162.toList M 3).all F = true := by decide +kernel
theorem chunk163_ok : (chunk163.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
