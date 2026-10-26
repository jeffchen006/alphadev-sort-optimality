import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1224_ok : (chunk1224.toList M 3).all F = true := by decide +kernel
theorem chunk1225_ok : (chunk1225.toList M 3).all F = true := by decide +kernel
theorem chunk1226_ok : (chunk1226.toList M 3).all F = true := by decide +kernel
theorem chunk1227_ok : (chunk1227.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
