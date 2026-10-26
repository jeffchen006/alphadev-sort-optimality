import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk800_ok : (chunk800.toList M 3).all F = true := by decide +kernel
theorem chunk801_ok : (chunk801.toList M 3).all F = true := by decide +kernel
theorem chunk802_ok : (chunk802.toList M 3).all F = true := by decide +kernel
theorem chunk803_ok : (chunk803.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
