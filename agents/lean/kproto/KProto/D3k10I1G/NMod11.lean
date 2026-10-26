import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node44_ok : F (decodeKey M 3 1683696988255128765238412438774842192021032162885632, 4) = true := by decide +kernel
theorem node45_ok : F (decodeKey M 3 1683696988255128765238412438774843344942536769732608, 4) = true := by decide +kernel
theorem node46_ok : F (decodeKey M 3 1683696988255128765238412438774843378719533975011328, 5) = true := by decide +kernel
theorem node47_ok : F (decodeKey M 3 1683696988255128765238412438774843379810249509765121, 6) = true := by decide +kernel
end KProto.D3k10I1G
