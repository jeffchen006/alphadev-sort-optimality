import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node132_ok : F (decodeKey M 3 1858072689114047496453253191229081670996289157518064558866432, 5) = true := by decide +kernel
theorem node133_ok : F (decodeKey M 3 1858072689114047496453253191229121283793064948253308437463040, 5) = true := by decide +kernel
theorem node134_ok : F (decodeKey M 3 1858072689114047496453253191229121283793066067469317413306368, 4) = true := by decide +kernel
theorem node135_ok : F (decodeKey M 3 1858072689114047496453253191229121283793066137273978807451648, 4) = true := by decide +kernel
end KProto.D3k10I1G
