import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node24_ok : F (decodeKey M 3 1683696988253895245551202315377722442126027841929216, 5) = true := by decide +kernel
theorem node25_ok : F (decodeKey M 3 1683696988255126065202138092790211995655421328162816, 5) = true := by decide +kernel
theorem node26_ok : F (decodeKey M 3 1683696988255126108038585899001314212350703699001344, 4) = true := by decide +kernel
theorem node27_ok : F (decodeKey M 3 1683696988255126108039932739078433939543528180875264, 4) = true := by decide +kernel
end KProto.D3k10I1G
