import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1972_ok : (chunk1972.toList M 3).all F = true := by decide +kernel
theorem chunk1973_ok : (chunk1973.toList M 3).all F = true := by decide +kernel
theorem chunk1974_ok : (chunk1974.toList M 3).all F = true := by decide +kernel
theorem chunk1975_ok : (chunk1975.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
