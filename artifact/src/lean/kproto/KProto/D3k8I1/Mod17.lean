import KProto.D3k8I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k8I1
open LeanReflect KProto
theorem chunk68_ok : (chunk68.toList M 3).all F = true := by decide +kernel
theorem chunk69_ok : (chunk69.toList M 3).all F = true := by decide +kernel
theorem chunk70_ok : (chunk70.toList M 3).all F = true := by decide +kernel
end KProto.D3k8I1
