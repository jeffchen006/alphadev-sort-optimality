import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk412_ok : (chunk412.toList M 3).all F = true := by decide +kernel
theorem chunk413_ok : (chunk413.toList M 3).all F = true := by decide +kernel
theorem chunk414_ok : (chunk414.toList M 3).all F = true := by decide +kernel
theorem chunk415_ok : (chunk415.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
