import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node252_ok : F (decodeKey M 3 1858072689115461983851204951703861178841619898892349977198592, 5) = true := by decide +kernel
theorem node253_ok : F (decodeKey M 3 1858072689115461983851204951744425998049996678270559027527680, 6) = true := by decide +kernel
theorem node254_ok : F (decodeKey M 3 1858072689115461983851204951783647731007080117684140924534784, 5) = true := by decide +kernel
theorem node255_ok : F (decodeKey M 3 1858072689115461983851204951783687345050558317989980534800384, 6) = true := by decide +kernel
end KProto.D3k10I1G
