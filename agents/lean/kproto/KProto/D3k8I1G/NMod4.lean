import KProto.D3k8I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k8I1G
open LeanReflect KProto
theorem node16_ok : F (decodeKey M 3 1858072689114047628863927807504696186661393381123625249210368, 4) = true := by decide +kernel
theorem node17_ok : F (decodeKey M 3 1858072689114047628863927807504696186662607337556628918566912, 4) = true := by decide +kernel
theorem node18_ok : F (decodeKey M 3 1858072689114047628863927807504696186662610867358389986459648, 4) = true := by decide +kernel
theorem node19_ok : F (decodeKey M 3 1858072689114135985810200960740521378101090611058886855163904, 4) = true := by decide +kernel
end KProto.D3k8I1G
