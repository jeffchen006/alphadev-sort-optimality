import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node180_ok : F (decodeKey M 3 1858072689114047628863927807504696186662610795300795948531712, 5) = true := by decide +kernel
theorem node181_ok : F (decodeKey M 3 1858072689114047628863927807504696186662610865106590172774400, 5) = true := by decide +kernel
theorem node182_ok : F (decodeKey M 3 1858072689114047630257724382411517044340411035948730810433536, 5) = true := by decide +kernel
theorem node183_ok : F (decodeKey M 3 1858072689114047630257724382412860133008590846560227844751360, 5) = true := by decide +kernel
end KProto.D3k10I1G
