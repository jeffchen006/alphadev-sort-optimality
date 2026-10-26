import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node16_ok : F (decodeKey M 3 1683696988253810173661397866128149691342678647668736, 4) = true := by decide +kernel
theorem node17_ok : F (decodeKey M 3 1683696988253810212603624305139356905320268286722048, 4) = true := by decide +kernel
theorem node18_ok : F (decodeKey M 3 1683696988253811419853208733694083879508559332966400, 4) = true := by decide +kernel
theorem node19_ok : F (decodeKey M 3 1683696988253811421191847767535094127489077917843456, 2) = true := by decide +kernel
end KProto.D3k10I1G
