import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk448_ok : (chunk448.toList M 3).all F = true := by decide +kernel
theorem chunk449_ok : (chunk449.toList M 3).all F = true := by decide +kernel
theorem chunk450_ok : (chunk450.toList M 3).all F = true := by decide +kernel
theorem chunk451_ok : (chunk451.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
