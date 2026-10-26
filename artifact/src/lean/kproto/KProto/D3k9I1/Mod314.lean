import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1256_ok : (chunk1256.toList M 3).all F = true := by decide +kernel
theorem chunk1257_ok : (chunk1257.toList M 3).all F = true := by decide +kernel
theorem chunk1258_ok : (chunk1258.toList M 3).all F = true := by decide +kernel
theorem chunk1259_ok : (chunk1259.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
