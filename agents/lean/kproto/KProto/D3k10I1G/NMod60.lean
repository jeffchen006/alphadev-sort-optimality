import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node240_ok : F (decodeKey M 3 1858072689115461983851204911544690163611279094558953056567296, 5) = true := by decide +kernel
theorem node241_ok : F (decodeKey M 3 1858072689115461983851204912800974039615601265930134953721856, 5) = true := by decide +kernel
theorem node242_ok : F (decodeKey M 3 1858072689115461983851204912841421289578021264476160105971712, 5) = true := by decide +kernel
theorem node243_ok : F (decodeKey M 3 1858072689115461983851204914139495504211728171608783113453568, 5) = true := by decide +kernel
end KProto.D3k10I1G
