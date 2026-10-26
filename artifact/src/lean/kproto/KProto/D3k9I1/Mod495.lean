import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1980_ok : (chunk1980.toList M 3).all F = true := by decide +kernel
theorem chunk1981_ok : (chunk1981.toList M 3).all F = true := by decide +kernel
theorem chunk1982_ok : (chunk1982.toList M 3).all F = true := by decide +kernel
theorem chunk1983_ok : (chunk1983.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
