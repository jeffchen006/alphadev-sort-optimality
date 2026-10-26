import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node8_ok : F (decodeKey M 3 1683695605520494166566822142001181268193490589712384, 4) = true := by decide +kernel
theorem node9_ok : F (decodeKey M 3 1683695605520494166566822142001182385156566990979072, 5) = true := by decide +kernel
theorem node10_ok : F (decodeKey M 3 1683695605521814170408018616244873758803023120826368, 5) = true := by decide +kernel
theorem node11_ok : F (decodeKey M 3 1683695605651162595464462511971117117447291732557824, 5) = true := by decide +kernel
end KProto.D3k10I1G
