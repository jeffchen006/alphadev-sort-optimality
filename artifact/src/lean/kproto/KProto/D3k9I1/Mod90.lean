import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk360_ok : (chunk360.toList M 3).all F = true := by decide +kernel
theorem chunk361_ok : (chunk361.toList M 3).all F = true := by decide +kernel
theorem chunk362_ok : (chunk362.toList M 3).all F = true := by decide +kernel
theorem chunk363_ok : (chunk363.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
