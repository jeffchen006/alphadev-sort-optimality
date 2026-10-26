import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1040_ok : (chunk1040.toList M 3).all F = true := by decide +kernel
theorem chunk1041_ok : (chunk1041.toList M 3).all F = true := by decide +kernel
theorem chunk1042_ok : (chunk1042.toList M 3).all F = true := by decide +kernel
theorem chunk1043_ok : (chunk1043.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
