import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node144_ok : F (decodeKey M 3 1858072689114047496453253191229121283794282435613970931908608, 5) = true := by decide +kernel
theorem node145_ok : F (decodeKey M 3 1858072689114047496453253191229121283794282435613973081554944, 4) = true := by decide +kernel
theorem node146_ok : F (decodeKey M 3 1858072689114047496453253191229121283794282468265070379991040, 3) = true := by decide +kernel
theorem node147_ok : F (decodeKey M 3 1858072689114047627468814011867017959277816726501632791085056, 5) = true := by decide +kernel
end KProto.D3k10I1G
