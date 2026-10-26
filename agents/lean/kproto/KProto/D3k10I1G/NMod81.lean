import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node324_ok : F (decodeKey M 3 1858072689115461983852647082260051262738773194548937245130752, 5) = true := by decide +kernel
theorem node325_ok : F (decodeKey M 3 1858072689115461983852647082260051262738773265480631376216064, 5) = true := by decide +kernel
theorem node326_ok : F (decodeKey M 3 1858072689115461983852647082260051265156624905835789632471040, 5) = true := by decide +kernel
theorem node327_ok : F (decodeKey M 3 1858072689115461983852647082260087088045329912179478283485184, 5) = true := by decide +kernel
end KProto.D3k10I1G
