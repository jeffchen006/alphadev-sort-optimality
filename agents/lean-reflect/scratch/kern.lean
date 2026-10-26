import LeanReflect.Ctx3
open LeanReflect
set_option maxRecDepth 100000
theorem k5 : certOK 3 I1 5 = true := by decide +kernel
