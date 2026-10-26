import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1232_ok : (chunk1232.toList M 3).all F = true := by decide +kernel
theorem chunk1233_ok : (chunk1233.toList M 3).all F = true := by decide +kernel
theorem chunk1234_ok : (chunk1234.toList M 3).all F = true := by decide +kernel
theorem chunk1235_ok : (chunk1235.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
