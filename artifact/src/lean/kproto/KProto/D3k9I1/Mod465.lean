import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1860_ok : (chunk1860.toList M 3).all F = true := by decide +kernel
theorem chunk1861_ok : (chunk1861.toList M 3).all F = true := by decide +kernel
theorem chunk1862_ok : (chunk1862.toList M 3).all F = true := by decide +kernel
theorem chunk1863_ok : (chunk1863.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
