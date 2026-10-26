import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1020_ok : (chunk1020.toList M 3).all F = true := by decide +kernel
theorem chunk1021_ok : (chunk1021.toList M 3).all F = true := by decide +kernel
theorem chunk1022_ok : (chunk1022.toList M 3).all F = true := by decide +kernel
theorem chunk1023_ok : (chunk1023.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
