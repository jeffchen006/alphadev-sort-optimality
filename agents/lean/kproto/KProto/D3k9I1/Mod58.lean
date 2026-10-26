import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk232_ok : (chunk232.toList M 3).all F = true := by decide +kernel
theorem chunk233_ok : (chunk233.toList M 3).all F = true := by decide +kernel
theorem chunk234_ok : (chunk234.toList M 3).all F = true := by decide +kernel
theorem chunk235_ok : (chunk235.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
