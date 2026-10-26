import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node76_ok : F (decodeKey M 3 1858023646216813526428769524466781835609303594025254517800960, 5) = true := by decide +kernel
theorem node77_ok : F (decodeKey M 3 1858023646216813526428769524466781835609304714295661826211840, 6) = true := by decide +kernel
theorem node78_ok : F (decodeKey M 3 1858023646310349631217947311230593422105514647348508042002432, 6) = true := by decide +kernel
theorem node79_ok : F (decodeKey M 3 1858023646310349631217947311231817664903146827553641508962304, 6) = true := by decide +kernel
end KProto.D3k10I1G
