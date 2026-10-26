import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1508_ok : (chunk1508.toList M 3).all F = true := by decide +kernel
theorem chunk1509_ok : (chunk1509.toList M 3).all F = true := by decide +kernel
theorem chunk1510_ok : (chunk1510.toList M 3).all F = true := by decide +kernel
theorem chunk1511_ok : (chunk1511.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
