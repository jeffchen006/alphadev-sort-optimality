import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node40_ok : F (decodeKey M 3 1683696988255128765237188157292802458136562817368064, 4) = true := by decide +kernel
theorem node41_ok : F (decodeKey M 3 1683696988255128765238372825978067587913955710894080, 4) = true := by decide +kernel
theorem node42_ok : F (decodeKey M 3 1683696988255128765238376617169437899391013230804992, 5) = true := by decide +kernel
theorem node43_ok : F (decodeKey M 3 1683696988255128765238412438774842153740435330236416, 5) = true := by decide +kernel
end KProto.D3k10I1G
