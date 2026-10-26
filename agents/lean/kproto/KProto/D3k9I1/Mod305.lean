import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1220_ok : (chunk1220.toList M 3).all F = true := by decide +kernel
theorem chunk1221_ok : (chunk1221.toList M 3).all F = true := by decide +kernel
theorem chunk1222_ok : (chunk1222.toList M 3).all F = true := by decide +kernel
theorem chunk1223_ok : (chunk1223.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
