import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node288_ok : F (decodeKey M 3 1858072689115461983851331190800438159887723270387056748068864, 5) = true := by decide +kernel
theorem node289_ok : F (decodeKey M 3 1858072689115461983851331190800438159887760055788813110280192, 5) = true := by decide +kernel
theorem node290_ok : F (decodeKey M 3 1858072689115461983851331190800438159887762469718213380866048, 4) = true := by decide +kernel
theorem node291_ok : F (decodeKey M 3 1858072689115461983851331190800438159887797057363351586275328, 5) = true := by decide +kernel
end KProto.D3k10I1G
