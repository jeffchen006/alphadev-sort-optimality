import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1304_ok : (chunk1304.toList M 3).all F = true := by decide +kernel
theorem chunk1305_ok : (chunk1305.toList M 3).all F = true := by decide +kernel
theorem chunk1306_ok : (chunk1306.toList M 3).all F = true := by decide +kernel
theorem chunk1307_ok : (chunk1307.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
