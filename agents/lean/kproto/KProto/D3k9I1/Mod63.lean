import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk252_ok : (chunk252.toList M 3).all F = true := by decide +kernel
theorem chunk253_ok : (chunk253.toList M 3).all F = true := by decide +kernel
theorem chunk254_ok : (chunk254.toList M 3).all F = true := by decide +kernel
theorem chunk255_ok : (chunk255.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
