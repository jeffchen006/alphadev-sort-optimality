import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node228_ok : F (decodeKey M 3 1858072689115460559434660167759817483377543585483940352294912, 5) = true := by decide +kernel
theorem node229_ok : F (decodeKey M 3 1858072689115460559434660167759817483377616217251746397880320, 4) = true := by decide +kernel
theorem node230_ok : F (decodeKey M 3 1858072689115460560828456742667981429723598576641171693568000, 5) = true := by decide +kernel
theorem node231_ok : F (decodeKey M 3 1858072689115460560872012885633861553046801031500597672607744, 5) = true := by decide +kernel
end KProto.D3k10I1G
