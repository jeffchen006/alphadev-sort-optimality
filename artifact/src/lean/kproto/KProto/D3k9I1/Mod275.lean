import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1100_ok : (chunk1100.toList M 3).all F = true := by decide +kernel
theorem chunk1101_ok : (chunk1101.toList M 3).all F = true := by decide +kernel
theorem chunk1102_ok : (chunk1102.toList M 3).all F = true := by decide +kernel
theorem chunk1103_ok : (chunk1103.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
