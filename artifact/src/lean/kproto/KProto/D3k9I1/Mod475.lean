import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1900_ok : (chunk1900.toList M 3).all F = true := by decide +kernel
theorem chunk1901_ok : (chunk1901.toList M 3).all F = true := by decide +kernel
theorem chunk1902_ok : (chunk1902.toList M 3).all F = true := by decide +kernel
theorem chunk1903_ok : (chunk1903.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
