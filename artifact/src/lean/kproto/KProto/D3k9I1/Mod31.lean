import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk124_ok : (chunk124.toList M 3).all F = true := by decide +kernel
theorem chunk125_ok : (chunk125.toList M 3).all F = true := by decide +kernel
theorem chunk126_ok : (chunk126.toList M 3).all F = true := by decide +kernel
theorem chunk127_ok : (chunk127.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
