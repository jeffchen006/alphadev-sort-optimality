import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk24_ok : (chunk24.toList M 3).all F = true := by decide +kernel
theorem chunk25_ok : (chunk25.toList M 3).all F = true := by decide +kernel
theorem chunk26_ok : (chunk26.toList M 3).all F = true := by decide +kernel
theorem chunk27_ok : (chunk27.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
