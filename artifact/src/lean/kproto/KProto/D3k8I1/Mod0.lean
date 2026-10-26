import KProto.D3k8I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k8I1
open LeanReflect KProto
theorem chunk0_ok : (chunk0.toList M 3).all F = true := by decide +kernel
theorem chunk1_ok : (chunk1.toList M 3).all F = true := by decide +kernel
theorem chunk2_ok : (chunk2.toList M 3).all F = true := by decide +kernel
theorem chunk3_ok : (chunk3.toList M 3).all F = true := by decide +kernel
end KProto.D3k8I1
