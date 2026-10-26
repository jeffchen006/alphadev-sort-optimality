import KProto.D3k8I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k8I1
open LeanReflect KProto
theorem chunk20_ok : (chunk20.toList M 3).all F = true := by decide +kernel
theorem chunk21_ok : (chunk21.toList M 3).all F = true := by decide +kernel
theorem chunk22_ok : (chunk22.toList M 3).all F = true := by decide +kernel
theorem chunk23_ok : (chunk23.toList M 3).all F = true := by decide +kernel
end KProto.D3k8I1
