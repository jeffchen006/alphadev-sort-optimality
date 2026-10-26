import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1312_ok : (chunk1312.toList M 3).all F = true := by decide +kernel
theorem chunk1313_ok : (chunk1313.toList M 3).all F = true := by decide +kernel
theorem chunk1314_ok : (chunk1314.toList M 3).all F = true := by decide +kernel
theorem chunk1315_ok : (chunk1315.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
