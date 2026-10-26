import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node140_ok : F (decodeKey M 3 1858072689114047496453253191229121283794280093706982474711040, 5) = true := by decide +kernel
theorem node141_ok : F (decodeKey M 3 1858072689114047496453253191229121283794280163512775626227712, 4) = true := by decide +kernel
theorem node142_ok : F (decodeKey M 3 1858072689114047496453253191229121283794281210670056659222528, 5) = true := by decide +kernel
theorem node143_ok : F (decodeKey M 3 1858072689114047496453253191229121283794281210671191638966272, 5) = true := by decide +kernel
end KProto.D3k10I1G
