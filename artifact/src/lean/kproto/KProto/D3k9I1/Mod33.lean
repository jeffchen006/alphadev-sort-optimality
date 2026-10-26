import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk132_ok : (chunk132.toList M 3).all F = true := by decide +kernel
theorem chunk133_ok : (chunk133.toList M 3).all F = true := by decide +kernel
theorem chunk134_ok : (chunk134.toList M 3).all F = true := by decide +kernel
theorem chunk135_ok : (chunk135.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
