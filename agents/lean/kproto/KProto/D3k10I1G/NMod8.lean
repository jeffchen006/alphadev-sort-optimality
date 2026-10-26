import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node32_ok : F (decodeKey M 3 1683696988255128765237069311422253602786284977324032, 4) = true := by decide +kernel
theorem node33_ok : F (decodeKey M 3 1683696988255128765237069315049031061630171426619392, 3) = true := by decide +kernel
theorem node34_ok : F (decodeKey M 3 1683696988255128765237069352525731469683676917334016, 5) = true := by decide +kernel
theorem node35_ok : F (decodeKey M 3 1683696988255128765237107689943544156942240867975168, 4) = true := by decide +kernel
end KProto.D3k10I1G
