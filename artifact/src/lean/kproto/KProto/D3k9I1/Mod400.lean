import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1600_ok : (chunk1600.toList M 3).all F = true := by decide +kernel
theorem chunk1601_ok : (chunk1601.toList M 3).all F = true := by decide +kernel
theorem chunk1602_ok : (chunk1602.toList M 3).all F = true := by decide +kernel
theorem chunk1603_ok : (chunk1603.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
