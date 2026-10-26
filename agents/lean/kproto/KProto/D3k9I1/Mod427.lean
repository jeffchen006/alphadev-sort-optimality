import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1708_ok : (chunk1708.toList M 3).all F = true := by decide +kernel
theorem chunk1709_ok : (chunk1709.toList M 3).all F = true := by decide +kernel
theorem chunk1710_ok : (chunk1710.toList M 3).all F = true := by decide +kernel
theorem chunk1711_ok : (chunk1711.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
