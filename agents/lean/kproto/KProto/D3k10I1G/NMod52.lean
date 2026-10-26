import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node208_ok : F (decodeKey M 3 1858072689114135985810200960741746897524352597487596683198464, 4) = true := by decide +kernel
theorem node209_ok : F (decodeKey M 3 1858072689114135985810200960741746897524385962405472565788672, 5) = true := by decide +kernel
theorem node210_ok : F (decodeKey M 3 1858072689114135985810200960741746897524387079368547857661952, 5) = true := by decide +kernel
theorem node211_ok : F (decodeKey M 3 1858072689114135985810200960741746897524387187490089968140288, 4) = true := by decide +kernel
end KProto.D3k10I1G
