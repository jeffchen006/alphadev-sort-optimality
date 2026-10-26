import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node268_ok : F (decodeKey M 3 1858072689115461983851204951784990817257409546661390105739264, 5) = true := by decide +kernel
theorem node269_ok : F (decodeKey M 3 1858072689115461983851204951784990817257410627595670493659136, 5) = true := by decide +kernel
theorem node270_ok : F (decodeKey M 3 1858072689115461983851204951784990817257410699653264531587072, 4) = true := by decide +kernel
theorem node271_ok : F (decodeKey M 3 1858072689115461983851204955679213461157313863884677910167552, 5) = true := by decide +kernel
end KProto.D3k10I1G
