import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1016_ok : (chunk1016.toList M 3).all F = true := by decide +kernel
theorem chunk1017_ok : (chunk1017.toList M 3).all F = true := by decide +kernel
theorem chunk1018_ok : (chunk1018.toList M 3).all F = true := by decide +kernel
theorem chunk1019_ok : (chunk1019.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
