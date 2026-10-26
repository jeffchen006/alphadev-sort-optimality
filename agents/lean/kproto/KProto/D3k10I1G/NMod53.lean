import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node212_ok : F (decodeKey M 3 1858072689114135985810200960741746897524388340411594574987264, 5) = true := by decide +kernel
theorem node213_ok : F (decodeKey M 3 1858072689114137408789391656045375870124603744761309850304512, 5) = true := by decide +kernel
theorem node214_ok : F (decodeKey M 3 1858072689114137413057893666700402436387060060554023237910528, 5) = true := by decide +kernel
theorem node215_ok : F (decodeKey M 3 1858072689114137502173762174892360275306534345781769809231872, 6) = true := by decide +kernel
end KProto.D3k10I1G
