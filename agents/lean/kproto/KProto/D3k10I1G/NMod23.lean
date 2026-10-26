import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node92_ok : F (decodeKey M 3 1858071204555757479085272420169150460337839125915536264855552, 6) = true := by decide +kernel
theorem node93_ok : F (decodeKey M 3 1858071298699846949392714799176369555921854579408515998220288, 5) = true := by decide +kernel
theorem node94_ok : F (decodeKey M 3 1858071298699846949392714799177712644590035614963927305224192, 5) = true := by decide +kernel
theorem node95_ok : F (decodeKey M 3 1858072689114044640564071204401195220876325437758345593290752, 4) = true := by decide +kernel
end KProto.D3k10I1G
