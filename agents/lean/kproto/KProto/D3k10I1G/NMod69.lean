import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node276_ok : F (decodeKey M 3 1858072689115461983851247489636439544625452909253576515190784, 6) = true := by decide +kernel
theorem node277_ok : F (decodeKey M 3 1858072689115461983851288652908424613312488332743744992378880, 6) = true := by decide +kernel
theorem node278_ok : F (decodeKey M 3 1858072689115461983851329778455127819206233834269871177793536, 6) = true := by decide +kernel
theorem node279_ok : F (decodeKey M 3 1858072689115461983851329860233803341129768983625188363010048, 5) = true := by decide +kernel
end KProto.D3k10I1G
