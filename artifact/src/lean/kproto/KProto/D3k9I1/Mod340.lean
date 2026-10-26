import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1360_ok : (chunk1360.toList M 3).all F = true := by decide +kernel
theorem chunk1361_ok : (chunk1361.toList M 3).all F = true := by decide +kernel
theorem chunk1362_ok : (chunk1362.toList M 3).all F = true := by decide +kernel
theorem chunk1363_ok : (chunk1363.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
