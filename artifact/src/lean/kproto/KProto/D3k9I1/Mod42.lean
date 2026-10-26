import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk168_ok : (chunk168.toList M 3).all F = true := by decide +kernel
theorem chunk169_ok : (chunk169.toList M 3).all F = true := by decide +kernel
theorem chunk170_ok : (chunk170.toList M 3).all F = true := by decide +kernel
theorem chunk171_ok : (chunk171.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
