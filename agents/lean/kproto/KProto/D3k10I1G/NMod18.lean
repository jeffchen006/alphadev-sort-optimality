import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node72_ok : F (decodeKey M 3 1858023646216813526427534592555955829152458011812647250493440, 5) = true := by decide +kernel
theorem node73_ok : F (decodeKey M 3 1858023646216813526428769524465556316186007021042119869530112, 5) = true := by decide +kernel
theorem node74_ok : F (decodeKey M 3 1858023646216813526428769524466781835608121780873506926428160, 5) = true := by decide +kernel
theorem node75_ok : F (decodeKey M 3 1858023646216813526428769524466781835609302372388671221465088, 6) = true := by decide +kernel
end KProto.D3k10I1G
