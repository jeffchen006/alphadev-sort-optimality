import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1208_ok : (chunk1208.toList M 3).all F = true := by decide +kernel
theorem chunk1209_ok : (chunk1209.toList M 3).all F = true := by decide +kernel
theorem chunk1210_ok : (chunk1210.toList M 3).all F = true := by decide +kernel
theorem chunk1211_ok : (chunk1211.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
