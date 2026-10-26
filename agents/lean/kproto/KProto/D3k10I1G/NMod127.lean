import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node508_ok : F (decodeKey M 3 2049010251669722376733933855508224746532636492283523148741149710155776, 6) = true := by decide +kernel
theorem node509_ok : F (decodeKey M 3 2049010251669722376733933855508224746533905342100383200365436788080640, 5) = true := by decide +kernel
theorem node510_ok : F (decodeKey M 3 2049010251669722376733933855508263213663916661374124561351244605620224, 6) = true := by decide +kernel
end KProto.D3k10I1G
