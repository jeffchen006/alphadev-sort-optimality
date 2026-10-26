import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk480_ok : (chunk480.toList M 3).all F = true := by decide +kernel
theorem chunk481_ok : (chunk481.toList M 3).all F = true := by decide +kernel
theorem chunk482_ok : (chunk482.toList M 3).all F = true := by decide +kernel
theorem chunk483_ok : (chunk483.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
