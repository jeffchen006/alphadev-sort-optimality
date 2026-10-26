import KProto.D3k8I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k8I1G
open LeanReflect KProto
theorem node16_ok : F (decodeKey M 3 1858072689114135985810200960741746897524388304312428811845632, 5) = true := by decide +kernel
theorem node17_ok : F (decodeKey M 3 1858072689115461983851204914140838592879907982220281222594560, 4) = true := by decide +kernel
theorem node18_ok : F (decodeKey M 3 1858072689115461983851204951783765297834111820756751925444608, 5) = true := by decide +kernel
theorem node19_ok : F (decodeKey M 3 1858072689115461983851204951784990817257336914893585134977024, 5) = true := by decide +kernel
theorem node20_ok : F (decodeKey M 3 1858072689115461983851331190800438159887762469718213380866048, 4) = true := by decide +kernel
theorem node21_ok : F (decodeKey M 3 1858072689115461983852647082260051187785370145747228772335616, 3) = true := by decide +kernel
end KProto.D3k8I1G
