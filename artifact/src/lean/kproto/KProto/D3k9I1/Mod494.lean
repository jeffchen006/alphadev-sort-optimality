import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1976_ok : (chunk1976.toList M 3).all F = true := by decide +kernel
theorem chunk1977_ok : (chunk1977.toList M 3).all F = true := by decide +kernel
theorem chunk1978_ok : (chunk1978.toList M 3).all F = true := by decide +kernel
theorem chunk1979_ok : (chunk1979.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
