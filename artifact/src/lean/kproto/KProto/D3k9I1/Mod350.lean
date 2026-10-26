import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1400_ok : (chunk1400.toList M 3).all F = true := by decide +kernel
theorem chunk1401_ok : (chunk1401.toList M 3).all F = true := by decide +kernel
theorem chunk1402_ok : (chunk1402.toList M 3).all F = true := by decide +kernel
theorem chunk1403_ok : (chunk1403.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
