import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node316_ok : F (decodeKey M 3 1858072689115461983852647082260051187785368921823661322731520, 5) = true := by decide +kernel
theorem node317_ok : F (decodeKey M 3 1858072689115461983852647082260051187785370038786737622286336, 4) = true := by decide +kernel
theorem node318_ok : F (decodeKey M 3 1858072689115461983852647082260051187785371263730650820149248, 5) = true := by decide +kernel
theorem node319_ok : F (decodeKey M 3 1858072689115461983852647082260051262624252350826632192262144, 5) = true := by decide +kernel
end KProto.D3k10I1G
