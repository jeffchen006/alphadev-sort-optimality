import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node328_ok : F (decodeKey M 3 1858072689115461983852647082260087088046397514115044503257088, 6) = true := by decide +kernel
theorem node329_ok : F (decodeKey M 3 1858072689115461983852647082260087088046434483038485680816128, 5) = true := by decide +kernel
theorem node330_ok : F (decodeKey M 3 1858072689115461983852647082260087088046474835291146920460288, 5) = true := by decide +kernel
theorem node331_ok : F (decodeKey M 3 1858072689115461983852647082260087088046508267657427586973696, 5) = true := by decide +kernel
end KProto.D3k10I1G
