import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk960_ok : (chunk960.toList M 3).all F = true := by decide +kernel
theorem chunk961_ok : (chunk961.toList M 3).all F = true := by decide +kernel
theorem chunk962_ok : (chunk962.toList M 3).all F = true := by decide +kernel
theorem chunk963_ok : (chunk963.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
