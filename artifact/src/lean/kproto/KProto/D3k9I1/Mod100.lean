import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk400_ok : (chunk400.toList M 3).all F = true := by decide +kernel
theorem chunk401_ok : (chunk401.toList M 3).all F = true := by decide +kernel
theorem chunk402_ok : (chunk402.toList M 3).all F = true := by decide +kernel
theorem chunk403_ok : (chunk403.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
