import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node48_ok : F (decodeKey M 3 1683696988255128765238412438774843413552060195471360, 5) = true := by decide +kernel
theorem node49_ok : F (decodeKey M 3 1683696988255128765238412438774844494415970830417920, 5) = true := by decide +kernel
theorem node50_ok : F (decodeKey M 3 1683696988255128765238412438774844497864041376579584, 2) = true := by decide +kernel
theorem node51_ok : F (decodeKey M 3 1683696988255128765238412438774844567599464709160960, 5) = true := by decide +kernel
end KProto.D3k10I1G
