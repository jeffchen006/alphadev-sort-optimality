import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1988_ok : (chunk1988.toList M 3).all F = true := by decide +kernel
theorem chunk1989_ok : (chunk1989.toList M 3).all F = true := by decide +kernel
theorem chunk1990_ok : (chunk1990.toList M 3).all F = true := by decide +kernel
theorem chunk1991_ok : (chunk1991.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
