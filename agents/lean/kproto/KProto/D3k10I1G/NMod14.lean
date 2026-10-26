import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node56_ok : F (decodeKey M 3 1683696988255128765238412438776024005172777606774784, 5) = true := by decide +kernel
theorem node57_ok : F (decodeKey M 3 1683696988255128765238412438776025159184997748375552, 3) = true := by decide +kernel
theorem node58_ok : F (decodeKey M 3 1683696988255128765238412438776025160381266399395840, 4) = true := by decide +kernel
theorem node59_ok : F (decodeKey M 3 1683696988255128765238412438776058524102839268081664, 3) = true := by decide +kernel
end KProto.D3k10I1G
