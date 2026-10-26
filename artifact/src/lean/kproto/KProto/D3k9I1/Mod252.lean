import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1008_ok : (chunk1008.toList M 3).all F = true := by decide +kernel
theorem chunk1009_ok : (chunk1009.toList M 3).all F = true := by decide +kernel
theorem chunk1010_ok : (chunk1010.toList M 3).all F = true := by decide +kernel
theorem chunk1011_ok : (chunk1011.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
