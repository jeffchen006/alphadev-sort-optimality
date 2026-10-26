import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk432_ok : (chunk432.toList M 3).all F = true := by decide +kernel
theorem chunk433_ok : (chunk433.toList M 3).all F = true := by decide +kernel
theorem chunk434_ok : (chunk434.toList M 3).all F = true := by decide +kernel
theorem chunk435_ok : (chunk435.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
