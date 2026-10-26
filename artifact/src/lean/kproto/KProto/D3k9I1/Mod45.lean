import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk180_ok : (chunk180.toList M 3).all F = true := by decide +kernel
theorem chunk181_ok : (chunk181.toList M 3).all F = true := by decide +kernel
theorem chunk182_ok : (chunk182.toList M 3).all F = true := by decide +kernel
theorem chunk183_ok : (chunk183.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
