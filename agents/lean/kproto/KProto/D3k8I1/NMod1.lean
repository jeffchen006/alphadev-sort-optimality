import KProto.D3k8I1.Data
set_option maxRecDepth 1000000
namespace KProto.D3k8I1
open LeanReflect KProto
theorem node64_ok : F (decodeKey M 3 1858072689115461983852647082261318913225661241549156136321024, 4) = true := by decide +kernel
theorem node65_ok : F (decodeKey M 3 1858072689115461983852647082261354738533399631664325154897920, 4) = true := by decide +kernel
theorem node66_ok : F (decodeKey M 3 1858072689115461983852647082261354738533402006222413058080768, 5) = true := by decide +kernel
theorem node67_ok : F (decodeKey M 3 1858072689115461983852647082261354813486802822329355317870592, 3) = true := by decide +kernel
theorem node68_ok : F (decodeKey M 3 1858072689115461983852647082261355937863372927660402183045120, 4) = true := by decide +kernel
theorem node69_ok : F (decodeKey M 3 1858072689115461983852647082261357253136885703862889738207232, 4) = true := by decide +kernel
end KProto.D3k8I1
