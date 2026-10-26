import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node120_ok : F (decodeKey M 3 1858072689114047492271863466503286359714931682780881516298240, 5) = true := by decide +kernel
theorem node121_ok : F (decodeKey M 3 1858072689114047492271863466504629444756335259492405299183616, 5) = true := by decide +kernel
theorem node122_ok : F (decodeKey M 3 1858072689114047493665660041412793391101101355444733432889344, 5) = true := by decide +kernel
theorem node123_ok : F (decodeKey M 3 1858072689114047495014665541444251207668141391339169580646400, 5) = true := by decide +kernel
end KProto.D3k10I1G
