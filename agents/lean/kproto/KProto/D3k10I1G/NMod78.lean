import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node312_ok : F (decodeKey M 3 1858072689115461983852647082260051185366303328413199085142016, 5) = true := by decide +kernel
theorem node313_ok : F (decodeKey M 3 1858072689115461983852647082260051186576444219172108447580160, 5) = true := by decide +kernel
theorem node314_ok : F (decodeKey M 3 1858072689115461983852647082260051187784188330308496995188736, 4) = true := by decide +kernel
theorem node315_ok : F (decodeKey M 3 1858072689115461983852647082260051187785298664613943147823104, 4) = true := by decide +kernel
end KProto.D3k10I1G
