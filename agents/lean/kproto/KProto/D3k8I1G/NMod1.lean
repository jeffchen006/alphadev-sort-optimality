import KProto.D3k8I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k8I1G
open LeanReflect KProto
theorem node4_ok : F (decodeKey M 3 1683696988255126108038585899001317673472571524317184, 3) = true := by decide +kernel
theorem node5_ok : F (decodeKey M 3 1683696988255128765237069315049031061630171426619392, 3) = true := by decide +kernel
theorem node6_ok : F (decodeKey M 3 1683696988255128765237186919352763172756287918243840, 3) = true := by decide +kernel
theorem node7_ok : F (decodeKey M 3 1683696988255128765238412438774843378649163083350016, 4) = true := by decide +kernel
end KProto.D3k8I1G
