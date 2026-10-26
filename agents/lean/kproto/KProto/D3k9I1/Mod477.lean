import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1908_ok : (chunk1908.toList M 3).all F = true := by decide +kernel
theorem chunk1909_ok : (chunk1909.toList M 3).all F = true := by decide +kernel
theorem chunk1910_ok : (chunk1910.toList M 3).all F = true := by decide +kernel
theorem chunk1911_ok : (chunk1911.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
