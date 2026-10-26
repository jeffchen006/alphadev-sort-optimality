import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1580_ok : (chunk1580.toList M 3).all F = true := by decide +kernel
theorem chunk1581_ok : (chunk1581.toList M 3).all F = true := by decide +kernel
theorem chunk1582_ok : (chunk1582.toList M 3).all F = true := by decide +kernel
theorem chunk1583_ok : (chunk1583.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
