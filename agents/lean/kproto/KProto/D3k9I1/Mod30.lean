import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk120_ok : (chunk120.toList M 3).all F = true := by decide +kernel
theorem chunk121_ok : (chunk121.toList M 3).all F = true := by decide +kernel
theorem chunk122_ok : (chunk122.toList M 3).all F = true := by decide +kernel
theorem chunk123_ok : (chunk123.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
