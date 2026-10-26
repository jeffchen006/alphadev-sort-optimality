import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node308_ok : F (decodeKey M 3 1858072689115461983852647082260049986036331218024839679901696, 5) = true := by decide +kernel
theorem node309_ok : F (decodeKey M 3 1858072689115461983852647082260049986037549890922921857187840, 5) = true := by decide +kernel
theorem node310_ok : F (decodeKey M 3 1858072689115461983852647082260049987283037156200927828443137, 6) = true := by decide +kernel
theorem node311_ok : F (decodeKey M 3 1858072689115461983852647082260051184157377506546770096750592, 5) = true := by decide +kernel
end KProto.D3k10I1G
