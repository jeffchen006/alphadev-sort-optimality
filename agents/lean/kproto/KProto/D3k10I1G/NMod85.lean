import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node340_ok : F (decodeKey M 3 1858072689115461983852647082261318913225664699222885702631424, 4) = true := by decide +kernel
theorem node341_ok : F (decodeKey M 3 1858072689115461983852647082261318913225664702600585421062144, 4) = true := by decide +kernel
theorem node342_ok : F (decodeKey M 3 1858072689115461983852647082261354738533399703721852618735616, 4) = true := by decide +kernel
theorem node343_ok : F (decodeKey M 3 1858072689115461983852647082261354738533400856713725969760256, 4) = true := by decide +kernel
end KProto.D3k10I1G
