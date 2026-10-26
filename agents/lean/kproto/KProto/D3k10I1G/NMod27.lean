import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node108_ok : F (decodeKey M 3 1858072689114046069205560485268015944025054578245569641250816, 5) = true := by decide +kernel
theorem node109_ok : F (decodeKey M 3 1858072689114046069205560485269240225508277279294006719741952, 5) = true := by decide +kernel
theorem node110_ok : F (decodeKey M 3 1858072689114046156926397486640982592201733082686212890755072, 6) = true := by decide +kernel
theorem node111_ok : F (decodeKey M 3 1858072689114046156927632418550583079235282091915685509791744, 6) = true := by decide +kernel
end KProto.D3k10I1G
