import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1124_ok : (chunk1124.toList M 3).all F = true := by decide +kernel
theorem chunk1125_ok : (chunk1125.toList M 3).all F = true := by decide +kernel
theorem chunk1126_ok : (chunk1126.toList M 3).all F = true := by decide +kernel
theorem chunk1127_ok : (chunk1127.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
