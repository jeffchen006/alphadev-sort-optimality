import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1904_ok : (chunk1904.toList M 3).all F = true := by decide +kernel
theorem chunk1905_ok : (chunk1905.toList M 3).all F = true := by decide +kernel
theorem chunk1906_ok : (chunk1906.toList M 3).all F = true := by decide +kernel
theorem chunk1907_ok : (chunk1907.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
