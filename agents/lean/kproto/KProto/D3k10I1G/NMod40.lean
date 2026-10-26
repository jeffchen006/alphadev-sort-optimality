import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node160_ok : F (decodeKey M 3 1858072689114047628863927807504616957403286561832613040947200, 6) = true := by decide +kernel
theorem node161_ok : F (decodeKey M 3 1858072689114047628863927807504660365055986712844802879193088, 6) = true := by decide +kernel
theorem node162_ok : F (decodeKey M 3 1858072689114047628863927807504696186661391076371331570270208, 5) = true := by decide +kernel
theorem node163_ok : F (decodeKey M 3 1858072689114047628863927807504696186661392192102954879221760, 5) = true := by decide +kernel
end KProto.D3k10I1G
