import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node220_ok : F (decodeKey M 3 1858072689115459084841440057888242372650377952878963806240768, 6) = true := by decide +kernel
theorem node221_ok : F (decodeKey M 3 1858072689115459133624320179673980494759758143475146742104064, 5) = true := by decide +kernel
theorem node222_ok : F (decodeKey M 3 1858072689115460467444086223819653823444496050210233332596736, 5) = true := by decide +kernel
theorem node223_ok : F (decodeKey M 3 1858072689115460467444086223819771505119480616672615930593280, 6) = true := by decide +kernel
end KProto.D3k10I1G
