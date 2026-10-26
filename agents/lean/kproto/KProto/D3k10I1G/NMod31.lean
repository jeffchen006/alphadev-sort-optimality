import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node124_ok : F (decodeKey M 3 1858072689114047495015900473355077214124915495866559688146944, 5) = true := by decide +kernel
theorem node125_ok : F (decodeKey M 3 1858072689114047495059456616319614248780119008018039180427264, 5) = true := by decide +kernel
theorem node126_ok : F (decodeKey M 3 1858072689114047495059456616320957337448297771472254104829952, 4) = true := by decide +kernel
theorem node127_ok : F (decodeKey M 3 1858072689114047496451935970499607002755471874692507868626944, 5) = true := by decide +kernel
end KProto.D3k10I1G
