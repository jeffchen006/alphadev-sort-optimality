import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node284_ok : F (decodeKey M 3 1858072689115461983851331190800438159886618699528049350737920, 5) = true := by decide +kernel
theorem node285_ok : F (decodeKey M 3 1858072689115461983851331190800438159886618700689200267689984, 5) = true := by decide +kernel
theorem node286_ok : F (decodeKey M 3 1858072689115461983851331190800438159886618770494927853912064, 5) = true := by decide +kernel
theorem node287_ok : F (decodeKey M 3 1858072689115461983851331190800438159886653287173187556147200, 5) = true := by decide +kernel
end KProto.D3k10I1G
