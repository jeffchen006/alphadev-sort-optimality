import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk104_ok : (chunk104.toList M 3).all F = true := by decide +kernel
theorem chunk105_ok : (chunk105.toList M 3).all F = true := by decide +kernel
theorem chunk106_ok : (chunk106.toList M 3).all F = true := by decide +kernel
theorem chunk107_ok : (chunk107.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
