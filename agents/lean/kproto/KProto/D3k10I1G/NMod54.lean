import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node216_ok : F (decodeKey M 3 1858072689114138840305586372660283494673029510049159620657152, 5) = true := by decide +kernel
theorem node217_ok : F (decodeKey M 3 1858072689114138840305586372661509014096254604185992830189568, 5) = true := by decide +kernel
theorem node218_ok : F (decodeKey M 3 1858072689114138974066501420879367739987252290324895535005696, 6) = true := by decide +kernel
theorem node219_ok : F (decodeKey M 3 1858072689114138974110057563844022343887339145939328656539648, 5) = true := by decide +kernel
end KProto.D3k10I1G
