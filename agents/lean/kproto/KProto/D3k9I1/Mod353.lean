import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1412_ok : (chunk1412.toList M 3).all F = true := by decide +kernel
theorem chunk1413_ok : (chunk1413.toList M 3).all F = true := by decide +kernel
theorem chunk1414_ok : (chunk1414.toList M 3).all F = true := by decide +kernel
theorem chunk1415_ok : (chunk1415.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
