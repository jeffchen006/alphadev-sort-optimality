import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node60_ok : F (decodeKey M 3 1683696988255128765238412438776059637688213801271296, 5) = true := by decide +kernel
theorem node61_ok : F (decodeKey M 3 1683696988255128765238412438776059749187491031220224, 4) = true := by decide +kernel
theorem node62_ok : F (decodeKey M 3 1683696988255128765238412438776060865974643353255936, 4) = true := by decide +kernel
theorem node63_ok : F (decodeKey M 3 1683696988255128765238412438776060866080198619103232, 5) = true := by decide +kernel
end KProto.D3k10I1G
