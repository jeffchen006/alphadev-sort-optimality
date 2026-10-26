import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node168_ok : F (decodeKey M 3 1858072689114047628863927807504696186662496653749671312818176, 6) = true := by decide +kernel
theorem node169_ok : F (decodeKey M 3 1858072689114047628863927807504696186662533549524802917695488, 6) = true := by decide +kernel
theorem node170_ok : F (decodeKey M 3 1858072689114047628863927807504696186662535891396609150353408, 6) = true := by decide +kernel
theorem node171_ok : F (decodeKey M 3 1858072689114047628863927807504696186662537080346944094666752, 5) = true := by decide +kernel
end KProto.D3k10I1G
