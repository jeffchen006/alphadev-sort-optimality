import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1404_ok : (chunk1404.toList M 3).all F = true := by decide +kernel
theorem chunk1405_ok : (chunk1405.toList M 3).all F = true := by decide +kernel
theorem chunk1406_ok : (chunk1406.toList M 3).all F = true := by decide +kernel
theorem chunk1407_ok : (chunk1407.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
