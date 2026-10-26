import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node256_ok : F (decodeKey M 3 1858072689115461983851204951783765297834111820756751925444608, 5) = true := by decide +kernel
theorem node257_ok : F (decodeKey M 3 1858072689115461983851204951784911587998086396379287399759872, 6) = true := by decide +kernel
theorem node258_ok : F (decodeKey M 3 1858072689115461983851204951784990817256190838860411891154944, 5) = true := by decide +kernel
theorem node259_ok : F (decodeKey M 3 1858072689115461983851204951784990817256192026649627090550784, 5) = true := by decide +kernel
end KProto.D3k10I1G
