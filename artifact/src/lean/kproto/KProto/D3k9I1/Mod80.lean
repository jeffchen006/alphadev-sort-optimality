import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk320_ok : (chunk320.toList M 3).all F = true := by decide +kernel
theorem chunk321_ok : (chunk321.toList M 3).all F = true := by decide +kernel
theorem chunk322_ok : (chunk322.toList M 3).all F = true := by decide +kernel
theorem chunk323_ok : (chunk323.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
