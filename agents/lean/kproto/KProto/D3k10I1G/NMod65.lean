import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node260_ok : F (decodeKey M 3 1858072689115461983851204951784990817256193144738605476937728, 5) = true := by decide +kernel
theorem node261_ok : F (decodeKey M 3 1858072689115461983851204951784990817256193215670299608023040, 4) = true := by decide +kernel
theorem node262_ok : F (decodeKey M 3 1858072689115461983851204951784990817256226580588138982342656, 5) = true := by decide +kernel
theorem node263_ok : F (decodeKey M 3 1858072689115461983851204951784990817257300019118453530099712, 5) = true := by decide +kernel
end KProto.D3k10I1G
