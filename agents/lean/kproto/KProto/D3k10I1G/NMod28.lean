import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node112_ok : F (decodeKey M 3 1858072689114046156927632418551808598658507186017334347235328, 6) = true := by decide +kernel
theorem node113_ok : F (decodeKey M 3 1858072689114046156927632418551808598658577513068031085969408, 5) = true := by decide +kernel
theorem node114_ok : F (decodeKey M 3 1858072689114046156927632418551808598658579820072124578594816, 5) = true := by decide +kernel
theorem node115_ok : F (decodeKey M 3 1858072689114046157014744704483568845304020751249605228822528, 6) = true := by decide +kernel
end KProto.D3k10I1G
