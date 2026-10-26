import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node304_ok : F (decodeKey M 3 1858072689115461983852647082260048670800631892650555256930304, 6) = true := by decide +kernel
theorem node305_ok : F (decodeKey M 3 1858072689115461983852647082260048710657405008070360860524544, 5) = true := by decide +kernel
theorem node306_ok : F (decodeKey M 3 1858072689115461983852647082260048711905220093853393349574656, 5) = true := by decide +kernel
theorem node307_ok : F (decodeKey M 3 1858072689115461983852647082260048789237549918103417842106368, 5) = true := by decide +kernel
end KProto.D3k10I1G
