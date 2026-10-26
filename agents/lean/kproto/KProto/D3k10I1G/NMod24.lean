import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node96_ok : F (decodeKey M 3 1858072689114044641914311636342135955230850551317022677991424, 5) = true := by decide +kernel
theorem node97_ok : F (decodeKey M 3 1858072689114044641914311636343479043899031586872433984995328, 5) = true := by decide +kernel
theorem node98_ok : F (decodeKey M 3 1858072689114044641957867779309359167221126049263033524486144, 5) = true := by decide +kernel
theorem node99_ok : F (decodeKey M 3 1858072689114044641957867779309359167222270937506991568912384, 5) = true := by decide +kernel
end KProto.D3k10I1G
