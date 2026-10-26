import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1784_ok : (chunk1784.toList M 3).all F = true := by decide +kernel
theorem chunk1785_ok : (chunk1785.toList M 3).all F = true := by decide +kernel
theorem chunk1786_ok : (chunk1786.toList M 3).all F = true := by decide +kernel
theorem chunk1787_ok : (chunk1787.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
