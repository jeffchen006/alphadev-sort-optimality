import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk2000_ok : (chunk2000.toList M 3).all F = true := by decide +kernel
theorem chunk2001_ok : (chunk2001.toList M 3).all F = true := by decide +kernel
theorem chunk2002_ok : (chunk2002.toList M 3).all F = true := by decide +kernel
theorem chunk2003_ok : (chunk2003.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
