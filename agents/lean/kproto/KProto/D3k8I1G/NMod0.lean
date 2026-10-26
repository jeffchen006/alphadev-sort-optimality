import KProto.D3k8I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k8I1G
open LeanReflect KProto
theorem node0_ok : F (decodeKey M 3 1683651313496492877898815282696038954217763002974208, 4) = true := by decide +kernel
theorem node1_ok : F (decodeKey M 3 1683695559525207194597411912583765791978113883766784, 3) = true := by decide +kernel
theorem node2_ok : F (decodeKey M 3 1683696988253810173661399142829373068115868630712320, 4) = true := by decide +kernel
theorem node3_ok : F (decodeKey M 3 1683696988253811421191847767535094127490210747940864, 3) = true := by decide +kernel
theorem root_ok : lookT2 M 3 cert (canonK (mkCtx 3) (group (mkCtx 3)) (rootK (mkCtx 3))) = some 0 := by decide +kernel
end KProto.D3k8I1G
