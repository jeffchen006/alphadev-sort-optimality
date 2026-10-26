import KProto.D3k9I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k9I1
open LeanReflect KProto
theorem chunk280_ok : (chunk280.toList M 3).all F = true := by decide +kernel
theorem chunk281_ok : (chunk281.toList M 3).all F = true := by decide +kernel
theorem chunk282_ok : (chunk282.toList M 3).all F = true := by decide +kernel
theorem chunk283_ok : (chunk283.toList M 3).all F = true := by decide +kernel
end KProto.D3k9I1
