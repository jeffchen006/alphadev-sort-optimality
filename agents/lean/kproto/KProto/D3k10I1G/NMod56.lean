import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node224_ok : F (decodeKey M 3 1858072689115460467444086223820997024542668815069501907337216, 6) = true := by decide +kernel
theorem node225_ok : F (decodeKey M 3 1858072689115460467444086223820997024542777191942734764638208, 5) = true := by decide +kernel
theorem node226_ok : F (decodeKey M 3 1858072689115460467487642366786877147865980764785583866314752, 6) = true := by decide +kernel
theorem node227_ok : F (decodeKey M 3 1858072689115460559434660167758591963954318491347107142762496, 5) = true := by decide +kernel
end KProto.D3k10I1G
