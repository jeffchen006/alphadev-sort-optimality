import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1712_ok : (chunk1712.toList M 3).all F = true := by decide +kernel
theorem chunk1713_ok : (chunk1713.toList M 3).all F = true := by decide +kernel
theorem chunk1714_ok : (chunk1714.toList M 3).all F = true := by decide +kernel
theorem chunk1715_ok : (chunk1715.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
