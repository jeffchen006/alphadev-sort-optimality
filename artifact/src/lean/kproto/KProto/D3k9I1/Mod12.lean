import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk48_ok : (chunk48.toList M 3).all F = true := by decide +kernel
theorem chunk49_ok : (chunk49.toList M 3).all F = true := by decide +kernel
theorem chunk50_ok : (chunk50.toList M 3).all F = true := by decide +kernel
theorem chunk51_ok : (chunk51.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
