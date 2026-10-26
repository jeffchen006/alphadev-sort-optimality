import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1536_ok : (chunk1536.toList M 3).all F = true := by decide +kernel
theorem chunk1537_ok : (chunk1537.toList M 3).all F = true := by decide +kernel
theorem chunk1538_ok : (chunk1538.toList M 3).all F = true := by decide +kernel
theorem chunk1539_ok : (chunk1539.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
