import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node152_ok : F (decodeKey M 3 1858072689114047628862692875512740541791156295284815942451200, 6) = true := by decide +kernel
theorem node153_ok : F (decodeKey M 3 1858072689114047628862695658624421535666068528478742906994688, 6) = true := by decide +kernel
theorem node154_ok : F (decodeKey M 3 1858072689114047628863926480912069284852049518439967790006272, 5) = true := by decide +kernel
theorem node155_ok : F (decodeKey M 3 1858072689114047628863927807503351859978831494802018993766400, 5) = true := by decide +kernel
end KProto.D3k10I1G
