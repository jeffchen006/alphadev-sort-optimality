import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node128_ok : F (decodeKey M 3 1858072689114047496452018259318295277337435733130958505836544, 4) = true := by decide +kernel
theorem node129_ok : F (decodeKey M 3 1858072689114047496453253191227778160067252631234313558425600, 4) = true := by decide +kernel
theorem node130_ok : F (decodeKey M 3 1858072689114047496453253191227778195126101400058560699727872, 5) = true := by decide +kernel
theorem node131_ok : F (decodeKey M 3 1858072689114047496453253191227895764370984742360428975226880, 5) = true := by decide +kernel
end KProto.D3k10I1G
