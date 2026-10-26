import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1012_ok : (chunk1012.toList M 3).all F = true := by decide +kernel
theorem chunk1013_ok : (chunk1013.toList M 3).all F = true := by decide +kernel
theorem chunk1014_ok : (chunk1014.toList M 3).all F = true := by decide +kernel
theorem chunk1015_ok : (chunk1015.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
