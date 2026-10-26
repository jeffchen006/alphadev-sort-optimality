import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk2004_ok : (chunk2004.toList M 3).all F = true := by decide +kernel
theorem chunk2005_ok : (chunk2005.toList M 3).all F = true := by decide +kernel
theorem chunk2006_ok : (chunk2006.toList M 3).all F = true := by decide +kernel
theorem chunk2007_ok : (chunk2007.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
