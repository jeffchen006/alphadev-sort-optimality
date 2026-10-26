import KProto.D3k8I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k8I1G
open LeanReflect KProto
theorem node24_ok : F (decodeKey M 3 1858072689115461983851204951783765297834111820756751925444608, 5) = true := by decide +kernel
theorem node25_ok : F (decodeKey M 3 1858072689115461983851204951784990817257336914893585134977024, 5) = true := by decide +kernel
theorem node26_ok : F (decodeKey M 3 1858072689115461983851331190799213878404576660961655070457856, 4) = true := by decide +kernel
theorem node27_ok : F (decodeKey M 3 1858072689115461983851331190800438159887762469718213380866048, 4) = true := by decide +kernel
end KProto.D3k8I1G
