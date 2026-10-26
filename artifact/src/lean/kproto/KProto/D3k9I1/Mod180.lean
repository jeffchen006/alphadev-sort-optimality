import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk720_ok : (chunk720.toList M 3).all F = true := by decide +kernel
theorem chunk721_ok : (chunk721.toList M 3).all F = true := by decide +kernel
theorem chunk722_ok : (chunk722.toList M 3).all F = true := by decide +kernel
theorem chunk723_ok : (chunk723.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
