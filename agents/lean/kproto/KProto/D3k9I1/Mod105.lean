import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk420_ok : (chunk420.toList M 3).all F = true := by decide +kernel
theorem chunk421_ok : (chunk421.toList M 3).all F = true := by decide +kernel
theorem chunk422_ok : (chunk422.toList M 3).all F = true := by decide +kernel
theorem chunk423_ok : (chunk423.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
