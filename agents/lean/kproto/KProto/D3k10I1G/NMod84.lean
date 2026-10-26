import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node336_ok : F (decodeKey M 3 1858072689115461983852647082261279300428854357997200544432128, 4) = true := by decide +kernel
theorem node337_ok : F (decodeKey M 3 1858072689115461983852647082261279300428890097473127821934592, 5) = true := by decide +kernel
theorem node338_ok : F (decodeKey M 3 1858072689115461983852647082261318913225661241549087414747136, 5) = true := by decide +kernel
theorem node339_ok : F (decodeKey M 3 1858072689115461983852647082261318913225662395666861747372032, 5) = true := by decide +kernel
end KProto.D3k10I1G
