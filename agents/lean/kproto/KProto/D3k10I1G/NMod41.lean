import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node164_ok : F (decodeKey M 3 1858072689114047628863927807504696186661393310191931118125056, 5) = true := by decide +kernel
theorem node165_ok : F (decodeKey M 3 1858072689114047628863927807504696186661393311318963855065088, 5) = true := by decide +kernel
theorem node166_ok : F (decodeKey M 3 1858072689114047628863927807504696186661393381124758079307776, 4) = true := by decide +kernel
theorem node167_ok : F (decodeKey M 3 1858072689114047628863927807504696186661426746006280251441152, 6) = true := by decide +kernel
end KProto.D3k10I1G
