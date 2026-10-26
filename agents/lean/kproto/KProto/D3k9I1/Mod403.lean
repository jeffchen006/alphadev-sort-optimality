import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1612_ok : (chunk1612.toList M 3).all F = true := by decide +kernel
theorem chunk1613_ok : (chunk1613.toList M 3).all F = true := by decide +kernel
theorem chunk1614_ok : (chunk1614.toList M 3).all F = true := by decide +kernel
theorem chunk1615_ok : (chunk1615.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
