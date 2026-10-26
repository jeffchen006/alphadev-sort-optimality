import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node200_ok : F (decodeKey M 3 1858072689114135985810200960741746897523171935005556034568192, 5) = true := by decide +kernel
theorem node201_ok : F (decodeKey M 3 1858072689114135985810200960741746897523172005937250165653504, 6) = true := by decide +kernel
theorem node202_ok : F (decodeKey M 3 1858072689114135985810200960741746897523206522650694239977472, 5) = true := by decide +kernel
theorem node203_ok : F (decodeKey M 3 1858072689114135985810200960741746897523208829654787732602880, 5) = true := by decide +kernel
end KProto.D3k10I1G
