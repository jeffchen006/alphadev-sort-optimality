import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1004_ok : (chunk1004.toList M 3).all F = true := by decide +kernel
theorem chunk1005_ok : (chunk1005.toList M 3).all F = true := by decide +kernel
theorem chunk1006_ok : (chunk1006.toList M 3).all F = true := by decide +kernel
theorem chunk1007_ok : (chunk1007.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
