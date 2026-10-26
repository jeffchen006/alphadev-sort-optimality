import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk192_ok : (chunk192.toList M 3).all F = true := by decide +kernel
theorem chunk193_ok : (chunk193.toList M 3).all F = true := by decide +kernel
theorem chunk194_ok : (chunk194.toList M 3).all F = true := by decide +kernel
theorem chunk195_ok : (chunk195.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
