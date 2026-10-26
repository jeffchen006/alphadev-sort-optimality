import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node104_ok : F (decodeKey M 3 1858072689114046064937058474612988139823669311378027507154944, 5) = true := by decide +kernel
theorem node105_ok : F (decodeKey M 3 1858072689114046064937058474612988139823740685550821981618176, 5) = true := by decide +kernel
theorem node106_ok : F (decodeKey M 3 1858072689114046069117130978607965697822878525694839898570752, 5) = true := by decide +kernel
theorem node107_ok : F (decodeKey M 3 1858072689114046069118448199337479978861687861672389763989504, 5) = true := by decide +kernel
end KProto.D3k10I1G
