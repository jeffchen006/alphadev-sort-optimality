import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1204_ok : (chunk1204.toList M 3).all F = true := by decide +kernel
theorem chunk1205_ok : (chunk1205.toList M 3).all F = true := by decide +kernel
theorem chunk1206_ok : (chunk1206.toList M 3).all F = true := by decide +kernel
theorem chunk1207_ok : (chunk1207.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
