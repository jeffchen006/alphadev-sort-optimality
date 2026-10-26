import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node36_ok : F (decodeKey M 3 1683696988255128765237108966606988601852473689309184, 5) = true := by decide +kernel
theorem node37_ok : F (decodeKey M 3 1683696988255128765237148540680356891149634063368192, 5) = true := by decide +kernel
theorem node38_ok : F (decodeKey M 3 1683696988255128765237185604003692500176788676214784, 5) = true := by decide +kernel
theorem node39_ok : F (decodeKey M 3 1683696988255128765237186919277205309030373594824704, 5) = true := by decide +kernel
end KProto.D3k10I1G
