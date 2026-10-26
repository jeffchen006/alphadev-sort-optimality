import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1180_ok : (chunk1180.toList M 3).all F = true := by decide +kernel
theorem chunk1181_ok : (chunk1181.toList M 3).all F = true := by decide +kernel
theorem chunk1182_ok : (chunk1182.toList M 3).all F = true := by decide +kernel
theorem chunk1183_ok : (chunk1183.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
