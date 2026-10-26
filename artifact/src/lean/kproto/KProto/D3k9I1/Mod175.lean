import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk700_ok : (chunk700.toList M 3).all F = true := by decide +kernel
theorem chunk701_ok : (chunk701.toList M 3).all F = true := by decide +kernel
theorem chunk702_ok : (chunk702.toList M 3).all F = true := by decide +kernel
theorem chunk703_ok : (chunk703.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
