import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node176_ok : F (decodeKey M 3 1858072689114047628863927807504696186662608561480196400676864, 4) = true := by decide +kernel
theorem node177_ok : F (decodeKey M 3 1858072689114047628863927807504696186662609604028325764857856, 5) = true := by decide +kernel
theorem node178_ok : F (decodeKey M 3 1858072689114047628863927807504696186662609679463617373732864, 4) = true := by decide +kernel
theorem node179_ok : F (decodeKey M 3 1858072689114047628863927807504696186662609712114715746926592, 5) = true := by decide +kernel
end KProto.D3k10I1G
