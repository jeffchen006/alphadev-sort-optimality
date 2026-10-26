import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node332_ok : F (decodeKey M 3 1858072689115461983852647082260087088046509421775199772114944, 5) = true := by decide +kernel
theorem node333_ok : F (decodeKey M 3 1858072689115461983852647082260087088046510572409720193187840, 5) = true := by decide +kernel
theorem node334_ok : F (decodeKey M 3 1858072689115461983852647082260090801866626126155605216395264, 5) = true := by decide +kernel
theorem node335_ok : F (decodeKey M 3 1858072689115461983852647082261239683892001243577596190425088, 5) = true := by decide +kernel
end KProto.D3k10I1G
