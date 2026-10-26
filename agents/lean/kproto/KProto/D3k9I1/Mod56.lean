import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk224_ok : (chunk224.toList M 3).all F = true := by decide +kernel
theorem chunk225_ok : (chunk225.toList M 3).all F = true := by decide +kernel
theorem chunk226_ok : (chunk226.toList M 3).all F = true := by decide +kernel
theorem chunk227_ok : (chunk227.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
