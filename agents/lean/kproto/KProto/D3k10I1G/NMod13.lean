import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node52_ok : F (decodeKey M 3 1683696988255128765238412438774877932517306228867072, 5) = true := by decide +kernel
theorem node53_ok : F (decodeKey M 3 1683696988255128765238412438774879085509179581988864, 5) = true := by decide +kernel
theorem node54_ok : F (decodeKey M 3 1683696988255128765238412438774881391352188795682816, 4) = true := by decide +kernel
theorem node55_ok : F (decodeKey M 3 1683696988255128765238412438775988266928305499865088, 5) = true := by decide +kernel
end KProto.D3k10I1G
