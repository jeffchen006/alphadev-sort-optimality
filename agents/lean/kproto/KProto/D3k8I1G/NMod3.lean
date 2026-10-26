import KProto.D3k8I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k8I1G
open LeanReflect KProto
theorem node12_ok : F (decodeKey M 3 1858072689114047496453253191227895764370984742360431124873216, 4) = true := by decide +kernel
theorem node13_ok : F (decodeKey M 3 1858072689114047496453253191229121283794209836497264334405632, 4) = true := by decide +kernel
theorem node14_ok : F (decodeKey M 3 1858072689114047496453253191229121283794281317630549958918144, 3) = true := by decide +kernel
theorem node15_ok : F (decodeKey M 3 1858072689114047628862692875593870180205762976980604947595264, 5) = true := by decide +kernel
end KProto.D3k8I1G
