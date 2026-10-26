import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk1280_ok : (chunk1280.toList M 3).all F = true := by decide +kernel
theorem chunk1281_ok : (chunk1281.toList M 3).all F = true := by decide +kernel
theorem chunk1282_ok : (chunk1282.toList M 3).all F = true := by decide +kernel
theorem chunk1283_ok : (chunk1283.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
