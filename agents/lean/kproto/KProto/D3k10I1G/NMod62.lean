import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node248_ok : F (decodeKey M 3 1858072689115461983851204914140838592879873500339363366633472, 5) = true := by decide +kernel
theorem node249_ok : F (decodeKey M 3 1858072689115461983851204914140838592879906865257203815710720, 5) = true := by decide +kernel
theorem node250_ok : F (decodeKey M 3 1858072689115461983851204914140838592879908089180771297820672, 4) = true := by decide +kernel
theorem node251_ok : F (decodeKey M 3 1858072689115461983851204914140838592879909207164194420457472, 5) = true := by decide +kernel
end KProto.D3k10I1G
