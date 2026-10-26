import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1320_ok : (chunk1320.toList M 3).all F = true := by decide +kernel
theorem chunk1321_ok : (chunk1321.toList M 3).all F = true := by decide +kernel
theorem chunk1322_ok : (chunk1322.toList M 3).all F = true := by decide +kernel
theorem chunk1323_ok : (chunk1323.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
