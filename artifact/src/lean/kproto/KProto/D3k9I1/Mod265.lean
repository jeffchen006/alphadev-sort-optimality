import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1060_ok : (chunk1060.toList M 3).all F = true := by decide +kernel
theorem chunk1061_ok : (chunk1061.toList M 3).all F = true := by decide +kernel
theorem chunk1062_ok : (chunk1062.toList M 3).all F = true := by decide +kernel
theorem chunk1063_ok : (chunk1063.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
