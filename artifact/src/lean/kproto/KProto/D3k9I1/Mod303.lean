import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1212_ok : (chunk1212.toList M 3).all F = true := by decide +kernel
theorem chunk1213_ok : (chunk1213.toList M 3).all F = true := by decide +kernel
theorem chunk1214_ok : (chunk1214.toList M 3).all F = true := by decide +kernel
theorem chunk1215_ok : (chunk1215.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
