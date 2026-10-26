import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1920_ok : (chunk1920.toList M 3).all F = true := by decide +kernel
theorem chunk1921_ok : (chunk1921.toList M 3).all F = true := by decide +kernel
theorem chunk1922_ok : (chunk1922.toList M 3).all F = true := by decide +kernel
theorem chunk1923_ok : (chunk1923.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
