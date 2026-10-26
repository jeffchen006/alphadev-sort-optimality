import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk256_ok : (chunk256.toList M 3).all F = true := by decide +kernel
theorem chunk257_ok : (chunk257.toList M 3).all F = true := by decide +kernel
theorem chunk258_ok : (chunk258.toList M 3).all F = true := by decide +kernel
theorem chunk259_ok : (chunk259.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
