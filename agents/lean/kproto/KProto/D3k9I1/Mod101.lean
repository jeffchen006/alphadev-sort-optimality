import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk404_ok : (chunk404.toList M 3).all F = true := by decide +kernel
theorem chunk405_ok : (chunk405.toList M 3).all F = true := by decide +kernel
theorem chunk406_ok : (chunk406.toList M 3).all F = true := by decide +kernel
theorem chunk407_ok : (chunk407.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
