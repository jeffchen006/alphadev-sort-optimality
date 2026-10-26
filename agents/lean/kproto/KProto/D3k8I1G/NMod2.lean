import KProto.D3k8I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k8I1G
open LeanReflect KProto
theorem node8_ok : F (decodeKey M 3 1683696988255128765238412438774877932587674975141888, 3) = true := by decide +kernel
theorem node9_ok : F (decodeKey M 3 1683696988255128765238412438776059748026405677465600, 3) = true := by decide +kernel
theorem node10_ok : F (decodeKey M 3 1683696988255128765238414953379542254394477673250816, 4) = true := by decide +kernel
theorem node11_ok : F (decodeKey M 3 1683696988255130136085912730385161479756649794174976, 4) = true := by decide +kernel
end KProto.D3k8I1G
