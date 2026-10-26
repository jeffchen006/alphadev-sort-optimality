import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node4_ok : F (decodeKey M 3 1683651313540049020864695406019350903969029336137728, 5) = true := by decide +kernel
theorem node5_ok : F (decodeKey M 3 1683654167991878289818577399267977853208035770564608, 5) = true := by decide +kernel
theorem node6_ok : F (decodeKey M 3 1683695559525207194597411912583762330856246058450944, 4) = true := by decide +kernel
theorem node7_ok : F (decodeKey M 3 1683695559525209854392042516256519540568659536707584, 4) = true := by decide +kernel
end KProto.D3k10I1G
