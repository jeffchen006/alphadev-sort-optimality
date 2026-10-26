import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk408_ok : (chunk408.toList M 3).all F = true := by decide +kernel
theorem chunk409_ok : (chunk409.toList M 3).all F = true := by decide +kernel
theorem chunk410_ok : (chunk410.toList M 3).all F = true := by decide +kernel
theorem chunk411_ok : (chunk411.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
