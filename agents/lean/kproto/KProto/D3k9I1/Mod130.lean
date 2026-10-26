import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk520_ok : (chunk520.toList M 3).all F = true := by decide +kernel
theorem chunk521_ok : (chunk521.toList M 3).all F = true := by decide +kernel
theorem chunk522_ok : (chunk522.toList M 3).all F = true := by decide +kernel
theorem chunk523_ok : (chunk523.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
