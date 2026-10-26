import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1112_ok : (chunk1112.toList M 3).all F = true := by decide +kernel
theorem chunk1113_ok : (chunk1113.toList M 3).all F = true := by decide +kernel
theorem chunk1114_ok : (chunk1114.toList M 3).all F = true := by decide +kernel
theorem chunk1115_ok : (chunk1115.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
