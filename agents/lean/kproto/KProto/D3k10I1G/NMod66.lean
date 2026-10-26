import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node264_ok : F (decodeKey M 3 1858072689115461983851204951784990817257336914893584092692480, 5) = true := by decide +kernel
theorem node265_ok : F (decodeKey M 3 1858072689115461983851204951784990817257373807185461755576320, 5) = true := by decide +kernel
theorem node266_ok : F (decodeKey M 3 1858072689115461983851204951784990817257408289066379609440256, 4) = true := by decide +kernel
theorem node267_ok : F (decodeKey M 3 1858072689115461983851204951784990817257408396026870759489536, 4) = true := by decide +kernel
end KProto.D3k10I1G
