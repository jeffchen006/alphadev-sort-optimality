import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1700_ok : (chunk1700.toList M 3).all F = true := by decide +kernel
theorem chunk1701_ok : (chunk1701.toList M 3).all F = true := by decide +kernel
theorem chunk1702_ok : (chunk1702.toList M 3).all F = true := by decide +kernel
theorem chunk1703_ok : (chunk1703.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
