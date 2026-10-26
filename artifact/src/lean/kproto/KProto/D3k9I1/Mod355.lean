import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1420_ok : (chunk1420.toList M 3).all F = true := by decide +kernel
theorem chunk1421_ok : (chunk1421.toList M 3).all F = true := by decide +kernel
theorem chunk1422_ok : (chunk1422.toList M 3).all F = true := by decide +kernel
theorem chunk1423_ok : (chunk1423.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
