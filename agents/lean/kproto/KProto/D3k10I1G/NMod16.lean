import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node64_ok : F (decodeKey M 3 1683696988255128765238413676791655673209027418947584, 5) = true := by decide +kernel
theorem node65_ok : F (decodeKey M 3 1683696988255128765238414913484990276917511279673344, 3) = true := by decide +kernel
theorem node66_ok : F (decodeKey M 3 1683696988255130098441760506007661205561648705765376, 3) = true := by decide +kernel
theorem node67_ok : F (decodeKey M 3 1683696988255130136084687210886305922777193514074112, 5) = true := by decide +kernel
end KProto.D3k10I1G
