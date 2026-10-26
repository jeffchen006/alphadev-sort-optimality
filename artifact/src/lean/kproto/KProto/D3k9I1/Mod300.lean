import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1200_ok : (chunk1200.toList M 3).all F = true := by decide +kernel
theorem chunk1201_ok : (chunk1201.toList M 3).all F = true := by decide +kernel
theorem chunk1202_ok : (chunk1202.toList M 3).all F = true := by decide +kernel
theorem chunk1203_ok : (chunk1203.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
