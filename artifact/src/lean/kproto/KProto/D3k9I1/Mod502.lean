import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk2008_ok : (chunk2008.toList M 3).all F = true := by decide +kernel
theorem chunk2009_ok : (chunk2009.toList M 3).all F = true := by decide +kernel
theorem chunk2010_ok : (chunk2010.toList M 3).all F = true := by decide +kernel
theorem chunk2011_ok : (chunk2011.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
