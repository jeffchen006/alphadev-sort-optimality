import KProto.D3k8I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k8I1G
open LeanReflect KProto
theorem node20_ok : F (decodeKey M 3 1858072689114135985810200960741746897524315705195720064696320, 4) = true := by decide +kernel
theorem node21_ok : F (decodeKey M 3 1858072689114135985810200960741746897524388304312428811845632, 5) = true := by decide +kernel
theorem node22_ok : F (decodeKey M 3 1858072689115461983851204914140838592878692908824201221177344, 4) = true := by decide +kernel
theorem node23_ok : F (decodeKey M 3 1858072689115461983851204914140838592879907982220281222594560, 4) = true := by decide +kernel
end KProto.D3k8I1G
