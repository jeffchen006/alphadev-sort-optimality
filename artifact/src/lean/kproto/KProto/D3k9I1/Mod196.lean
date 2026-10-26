import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk784_ok : (chunk784.toList M 3).all F = true := by decide +kernel
theorem chunk785_ok : (chunk785.toList M 3).all F = true := by decide +kernel
theorem chunk786_ok : (chunk786.toList M 3).all F = true := by decide +kernel
theorem chunk787_ok : (chunk787.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
