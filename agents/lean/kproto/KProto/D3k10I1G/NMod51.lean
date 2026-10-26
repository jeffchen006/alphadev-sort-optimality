import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node204_ok : F (decodeKey M 3 1858072689114135985810200960741746897524277656499083852972032, 5) = true := by decide +kernel
theorem node205_ok : F (decodeKey M 3 1858072689114135985810200960741746897524313399352710851002368, 5) = true := by decide +kernel
theorem node206_ok : F (decodeKey M 3 1858072689114135985810200960741746897524315705195720064696320, 4) = true := by decide +kernel
theorem node207_ok : F (decodeKey M 3 1858072689114135985810200960741746897524350183663751678459904, 6) = true := by decide +kernel
end KProto.D3k10I1G
