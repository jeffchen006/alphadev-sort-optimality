import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1880_ok : (chunk1880.toList M 3).all F = true := by decide +kernel
theorem chunk1881_ok : (chunk1881.toList M 3).all F = true := by decide +kernel
theorem chunk1882_ok : (chunk1882.toList M 3).all F = true := by decide +kernel
theorem chunk1883_ok : (chunk1883.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
