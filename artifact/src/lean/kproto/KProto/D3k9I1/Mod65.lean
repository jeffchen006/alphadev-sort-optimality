import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk260_ok : (chunk260.toList M 3).all F = true := by decide +kernel
theorem chunk261_ok : (chunk261.toList M 3).all F = true := by decide +kernel
theorem chunk262_ok : (chunk262.toList M 3).all F = true := by decide +kernel
theorem chunk263_ok : (chunk263.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
