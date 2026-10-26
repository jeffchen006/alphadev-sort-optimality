import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk200_ok : (chunk200.toList M 3).all F = true := by decide +kernel
theorem chunk201_ok : (chunk201.toList M 3).all F = true := by decide +kernel
theorem chunk202_ok : (chunk202.toList M 3).all F = true := by decide +kernel
theorem chunk203_ok : (chunk203.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
