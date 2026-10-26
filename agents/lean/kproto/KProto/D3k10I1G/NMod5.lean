import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node20_ok : F (decodeKey M 3 1683696988253811544427768519322643623392576731676672, 5) = true := by decide +kernel
theorem node21_ok : F (decodeKey M 3 1683696988253811544508898157737250305089498566918144, 3) = true := by decide +kernel
theorem node22_ok : F (decodeKey M 3 1683696988253851295435572885743867427435672522260480, 5) = true := by decide +kernel
theorem node23_ok : F (decodeKey M 3 1683696988253893831988947398478203915546296714330112, 4) = true := by decide +kernel
end KProto.D3k10I1G
