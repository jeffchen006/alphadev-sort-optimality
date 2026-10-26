import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk144_ok : (chunk144.toList M 3).all F = true := by decide +kernel
theorem chunk145_ok : (chunk145.toList M 3).all F = true := by decide +kernel
theorem chunk146_ok : (chunk146.toList M 3).all F = true := by decide +kernel
theorem chunk147_ok : (chunk147.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
