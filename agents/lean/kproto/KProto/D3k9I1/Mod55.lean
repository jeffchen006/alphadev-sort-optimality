import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk220_ok : (chunk220.toList M 3).all F = true := by decide +kernel
theorem chunk221_ok : (chunk221.toList M 3).all F = true := by decide +kernel
theorem chunk222_ok : (chunk222.toList M 3).all F = true := by decide +kernel
theorem chunk223_ok : (chunk223.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
