import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node196_ok : F (decodeKey M 3 1858072689114135985810200960740520138914346574201025619623936, 5) = true := by decide +kernel
theorem node197_ok : F (decodeKey M 3 1858072689114135985810200960740522616041129896439161754288128, 5) = true := by decide +kernel
theorem node198_ok : F (decodeKey M 3 1858072689114135985810200960741746897523169592007849895067648, 6) = true := by decide +kernel
theorem node199_ok : F (decodeKey M 3 1858072689114135985810200960741746897523170779797067241947136, 5) = true := by decide +kernel
end KProto.D3k10I1G
