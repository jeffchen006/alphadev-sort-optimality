import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node116_ok : F (decodeKey M 3 1858072689114046198741529665795383900369870510829493983182848, 5) = true := by decide +kernel
theorem node117_ok : F (decodeKey M 3 1858072689114046198741529665796726989038051546384905290186752, 5) = true := by decide +kernel
theorem node118_ok : F (decodeKey M 3 1858072689114047492183516248662043191652864657506858061332480, 5) = true := by decide +kernel
theorem node119_ok : F (decodeKey M 3 1858072689114047492184751180572869198109601868546100749729792, 5) = true := by decide +kernel
end KProto.D3k10I1G
