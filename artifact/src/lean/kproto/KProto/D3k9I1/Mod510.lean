import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk2040_ok : (chunk2040.toList M 3).all F = true := by decide +kernel
theorem chunk2041_ok : (chunk2041.toList M 3).all F = true := by decide +kernel
theorem chunk2042_ok : (chunk2042.toList M 3).all F = true := by decide +kernel
theorem chunk2043_ok : (chunk2043.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
