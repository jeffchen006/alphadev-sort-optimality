import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk2016_ok : (chunk2016.toList M 3).all F = true := by decide +kernel
theorem chunk2017_ok : (chunk2017.toList M 3).all F = true := by decide +kernel
theorem chunk2018_ok : (chunk2018.toList M 3).all F = true := by decide +kernel
theorem chunk2019_ok : (chunk2019.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
