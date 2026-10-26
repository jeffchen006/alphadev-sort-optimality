import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node156_ok : F (decodeKey M 3 1858072689114047628863927807503353062935579875083961075007488, 5) = true := by decide +kernel
theorem node157_ok : F (decodeKey M 3 1858072689114047628863927807503353100412280283137466565722112, 5) = true := by decide +kernel
theorem node158_ok : F (decodeKey M 3 1858072689114047628863927807503392714455758483443306175987712, 6) = true := by decide +kernel
theorem node159_ok : F (decodeKey M 3 1858072689114047628863927807503470667239311986210075416985600, 5) = true := by decide +kernel
end KProto.D3k10I1G
