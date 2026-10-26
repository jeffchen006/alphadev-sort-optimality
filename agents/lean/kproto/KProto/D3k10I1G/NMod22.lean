import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node88_ok : F (decodeKey M 3 1858071204415453321901505740021596716395969152580412818653184, 5) = true := by decide +kernel
theorem node89_ok : F (decodeKey M 3 1858071204415453321901505740021596716397112851803698345607168, 6) = true := by decide +kernel
theorem node90_ok : F (decodeKey M 3 1858071204415453321901505740021596716397183179945110619095040, 5) = true := by decide +kernel
theorem node91_ok : F (decodeKey M 3 1858071204415453321901505740021596716397185483571504391192576, 5) = true := by decide +kernel
end KProto.D3k10I1G
