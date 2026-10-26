import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node320_ok : F (decodeKey M 3 1858072689115461983852647082260051262737592677202429313351680, 6) = true := by decide +kernel
theorem node321_ok : F (decodeKey M 3 1858072689115461983852647082260051262738733959188983593369600, 6) = true := by decide +kernel
theorem node322_ok : F (decodeKey M 3 1858072689115461983852647082260051262738769807736463271428096, 5) = true := by decide +kernel
theorem node323_ok : F (decodeKey M 3 1858072689115461983852647082260051262738772079837658577174528, 4) = true := by decide +kernel
end KProto.D3k10I1G
