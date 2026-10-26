import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node0_ok : F (decodeKey M 3 1683649886205244028973054101086757554971359215387648, 6) = true := by decide +kernel
theorem node1_ok : F (decodeKey M 3 1683649886205244028973054101086758707963233640186880, 6) = true := by decide +kernel
theorem node2_ok : F (decodeKey M 3 1683651313496492877898815282696038954218895835168768, 4) = true := by decide +kernel
theorem node3_ok : F (decodeKey M 3 1683651313496492877898934128642145673293955168534528, 4) = true := by decide +kernel
theorem root_ok : lookT2 M 3 cert (canonK (mkCtx 3) (group (mkCtx 3)) (rootK (mkCtx 3))) = some 0 := by decide +kernel
end KProto.D3k10I1G
