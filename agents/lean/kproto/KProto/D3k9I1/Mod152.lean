import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk608_ok : (chunk608.toList M 3).all F = true := by decide +kernel
theorem chunk609_ok : (chunk609.toList M 3).all F = true := by decide +kernel
theorem chunk610_ok : (chunk610.toList M 3).all F = true := by decide +kernel
theorem chunk611_ok : (chunk611.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
