import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1492_ok : (chunk1492.toList M 3).all F = true := by decide +kernel
theorem chunk1493_ok : (chunk1493.toList M 3).all F = true := by decide +kernel
theorem chunk1494_ok : (chunk1494.toList M 3).all F = true := by decide +kernel
theorem chunk1495_ok : (chunk1495.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
