import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk2024_ok : (chunk2024.toList M 3).all F = true := by decide +kernel
theorem chunk2025_ok : (chunk2025.toList M 3).all F = true := by decide +kernel
theorem chunk2026_ok : (chunk2026.toList M 3).all F = true := by decide +kernel
theorem chunk2027_ok : (chunk2027.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
