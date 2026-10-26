import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk2020_ok : (chunk2020.toList M 3).all F = true := by decide +kernel
theorem chunk2021_ok : (chunk2021.toList M 3).all F = true := by decide +kernel
theorem chunk2022_ok : (chunk2022.toList M 3).all F = true := by decide +kernel
theorem chunk2023_ok : (chunk2023.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
