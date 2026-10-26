import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk52_ok : (chunk52.toList M 3).all F = true := by decide +kernel
theorem chunk53_ok : (chunk53.toList M 3).all F = true := by decide +kernel
theorem chunk54_ok : (chunk54.toList M 3).all F = true := by decide +kernel
theorem chunk55_ok : (chunk55.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
