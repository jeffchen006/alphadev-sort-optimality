import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node244_ok : F (decodeKey M 3 1858072689115461983851204914139613073456611513910653538598912, 4) = true := by decide +kernel
theorem node245_ok : F (decodeKey M 3 1858072689115461983851204914140838592878691719803530851188736, 5) = true := by decide +kernel
theorem node246_ok : F (decodeKey M 3 1858072689115461983851204914140838592878692908824200147402752, 5) = true := by decide +kernel
theorem node247_ok : F (decodeKey M 3 1858072689115461983851204914140838592879799712272354068430848, 5) = true := by decide +kernel
end KProto.D3k10I1G
