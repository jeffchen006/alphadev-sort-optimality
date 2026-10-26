import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk84_ok : (chunk84.toList M 3).all F = true := by decide +kernel
theorem chunk85_ok : (chunk85.toList M 3).all F = true := by decide +kernel
theorem chunk86_ok : (chunk86.toList M 3).all F = true := by decide +kernel
theorem chunk87_ok : (chunk87.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
