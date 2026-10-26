import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk80_ok : (chunk80.toList M 3).all F = true := by decide +kernel
theorem chunk81_ok : (chunk81.toList M 3).all F = true := by decide +kernel
theorem chunk82_ok : (chunk82.toList M 3).all F = true := by decide +kernel
theorem chunk83_ok : (chunk83.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
