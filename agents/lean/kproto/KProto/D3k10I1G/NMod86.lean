import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node344_ok : F (decodeKey M 3 1858072689115461983852647082261354738533402009600046204518400, 4) = true := by decide +kernel
theorem node345_ok : F (decodeKey M 3 1858072689115461983852647082261354813486802789678255869853696, 5) = true := by decide +kernel
theorem node346_ok : F (decodeKey M 3 1858072689115461983852647082261355937863372895009302670016512, 4) = true := by decide +kernel
theorem node347_ok : F (decodeKey M 3 1858072689115461983852647082261356052711325791050172640296960, 4) = true := by decide +kernel
end KProto.D3k10I1G
