import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk840_ok : (chunk840.toList M 3).all F = true := by decide +kernel
theorem chunk841_ok : (chunk841.toList M 3).all F = true := by decide +kernel
theorem chunk842_ok : (chunk842.toList M 3).all F = true := by decide +kernel
theorem chunk843_ok : (chunk843.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
