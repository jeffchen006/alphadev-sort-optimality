import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk2012_ok : (chunk2012.toList M 3).all F = true := by decide +kernel
theorem chunk2013_ok : (chunk2013.toList M 3).all F = true := by decide +kernel
theorem chunk2014_ok : (chunk2014.toList M 3).all F = true := by decide +kernel
theorem chunk2015_ok : (chunk2015.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
