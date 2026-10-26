import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node12_ok : F (decodeKey M 3 1683695694723474960689314708144054358786938763280384, 5) = true := by decide +kernel
theorem node13_ok : F (decodeKey M 3 1683696988253808762695291378496044979027062854582272, 4) = true := by decide +kernel
theorem node14_ok : F (decodeKey M 3 1683696988253810087988499700303493820588355310616576, 4) = true := by decide +kernel
theorem node15_ok : F (decodeKey M 3 1683696988253810091882722344204614541986228632354816, 4) = true := by decide +kernel
end KProto.D3k10I1G
