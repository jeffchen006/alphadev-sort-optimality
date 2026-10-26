import KProto.D3k8I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k8I1G
open LeanReflect KProto
theorem node28_ok : F (decodeKey M 3 1858072689115461983852647082260051187784154965390657620869120, 4) = true := by decide +kernel
theorem node29_ok : F (decodeKey M 3 1858072689115461983852647082260051187785370145747228772335616, 3) = true := by decide +kernel
theorem node30_ok : F (decodeKey M 3 1858072689115461983852647082260051262738773266606531283058688, 4) = true := by decide +kernel
end KProto.D3k8I1G
