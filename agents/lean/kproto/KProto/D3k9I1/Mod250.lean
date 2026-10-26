import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1000_ok : (chunk1000.toList M 3).all F = true := by decide +kernel
theorem chunk1001_ok : (chunk1001.toList M 3).all F = true := by decide +kernel
theorem chunk1002_ok : (chunk1002.toList M 3).all F = true := by decide +kernel
theorem chunk1003_ok : (chunk1003.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
