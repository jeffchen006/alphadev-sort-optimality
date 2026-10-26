import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1300_ok : (chunk1300.toList M 3).all F = true := by decide +kernel
theorem chunk1301_ok : (chunk1301.toList M 3).all F = true := by decide +kernel
theorem chunk1302_ok : (chunk1302.toList M 3).all F = true := by decide +kernel
theorem chunk1303_ok : (chunk1303.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
