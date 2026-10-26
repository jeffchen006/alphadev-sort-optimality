import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1912_ok : (chunk1912.toList M 3).all F = true := by decide +kernel
theorem chunk1913_ok : (chunk1913.toList M 3).all F = true := by decide +kernel
theorem chunk1914_ok : (chunk1914.toList M 3).all F = true := by decide +kernel
theorem chunk1915_ok : (chunk1915.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
