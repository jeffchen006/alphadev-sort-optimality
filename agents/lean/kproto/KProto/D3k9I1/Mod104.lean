import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk416_ok : (chunk416.toList M 3).all F = true := by decide +kernel
theorem chunk417_ok : (chunk417.toList M 3).all F = true := by decide +kernel
theorem chunk418_ok : (chunk418.toList M 3).all F = true := by decide +kernel
theorem chunk419_ok : (chunk419.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
