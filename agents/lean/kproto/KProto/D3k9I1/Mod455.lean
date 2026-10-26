import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1820_ok : (chunk1820.toList M 3).all F = true := by decide +kernel
theorem chunk1821_ok : (chunk1821.toList M 3).all F = true := by decide +kernel
theorem chunk1822_ok : (chunk1822.toList M 3).all F = true := by decide +kernel
theorem chunk1823_ok : (chunk1823.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
