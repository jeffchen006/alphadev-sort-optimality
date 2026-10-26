import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk580_ok : (chunk580.toList M 3).all F = true := by decide +kernel
theorem chunk581_ok : (chunk581.toList M 3).all F = true := by decide +kernel
theorem chunk582_ok : (chunk582.toList M 3).all F = true := by decide +kernel
theorem chunk583_ok : (chunk583.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
