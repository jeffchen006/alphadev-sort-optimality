import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1960_ok : (chunk1960.toList M 3).all F = true := by decide +kernel
theorem chunk1961_ok : (chunk1961.toList M 3).all F = true := by decide +kernel
theorem chunk1962_ok : (chunk1962.toList M 3).all F = true := by decide +kernel
theorem chunk1963_ok : (chunk1963.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
