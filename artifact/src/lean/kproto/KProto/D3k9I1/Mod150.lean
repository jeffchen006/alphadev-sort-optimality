import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk600_ok : (chunk600.toList M 3).all F = true := by decide +kernel
theorem chunk601_ok : (chunk601.toList M 3).all F = true := by decide +kernel
theorem chunk602_ok : (chunk602.toList M 3).all F = true := by decide +kernel
theorem chunk603_ok : (chunk603.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
