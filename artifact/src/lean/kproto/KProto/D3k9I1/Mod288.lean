import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1152_ok : (chunk1152.toList M 3).all F = true := by decide +kernel
theorem chunk1153_ok : (chunk1153.toList M 3).all F = true := by decide +kernel
theorem chunk1154_ok : (chunk1154.toList M 3).all F = true := by decide +kernel
theorem chunk1155_ok : (chunk1155.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
