import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node280_ok : F (decodeKey M 3 1858072689115461983851331190759873340679315429647033351340032, 6) = true := by decide +kernel
theorem node281_ok : F (decodeKey M 3 1858072689115461983851331190799213877157871909484068734042112, 5) = true := by decide +kernel
theorem node282_ok : F (decodeKey M 3 1858072689115461983851331190799213917090202888629788661055488, 5) = true := by decide +kernel
theorem node283_ok : F (decodeKey M 3 1858072689115461983851331190800438159886616356565527583326208, 6) = true := by decide +kernel
end KProto.D3k10I1G
