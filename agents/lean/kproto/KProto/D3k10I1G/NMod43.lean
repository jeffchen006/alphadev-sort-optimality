import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node172_ok : F (decodeKey M 3 1858072689114047628863927807504696186662573972638787396763648, 5) = true := by decide +kernel
theorem node173_ok : F (decodeKey M 3 1858072689114047628863927807504696186662607337556628916469760, 4) = true := by decide +kernel
theorem node174_ok : F (decodeKey M 3 1858072689114047628863927807504696186662607409614222956494848, 5) = true := by decide +kernel
theorem node175_ok : F (decodeKey M 3 1858072689114047628863927807504696186662608454520838080724992, 4) = true := by decide +kernel
end KProto.D3k10I1G
