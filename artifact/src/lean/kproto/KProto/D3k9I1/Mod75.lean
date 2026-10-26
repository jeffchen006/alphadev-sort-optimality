import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk300_ok : (chunk300.toList M 3).all F = true := by decide +kernel
theorem chunk301_ok : (chunk301.toList M 3).all F = true := by decide +kernel
theorem chunk302_ok : (chunk302.toList M 3).all F = true := by decide +kernel
theorem chunk303_ok : (chunk303.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
