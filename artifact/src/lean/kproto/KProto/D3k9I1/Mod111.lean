import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk444_ok : (chunk444.toList M 3).all F = true := by decide +kernel
theorem chunk445_ok : (chunk445.toList M 3).all F = true := by decide +kernel
theorem chunk446_ok : (chunk446.toList M 3).all F = true := by decide +kernel
theorem chunk447_ok : (chunk447.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
