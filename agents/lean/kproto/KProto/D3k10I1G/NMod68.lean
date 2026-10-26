import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node272_ok : F (decodeKey M 3 1858072689115461983851246118868765381785186304991684999577600, 5) = true := by decide +kernel
theorem node273_ok : F (decodeKey M 3 1858072689115461983851246118870068891429742678862551326982144, 6) = true := by decide +kernel
theorem node274_ok : F (decodeKey M 3 1858072689115461983851246118870068891430958977202545601085440, 6) = true := by decide +kernel
theorem node275_ok : F (decodeKey M 3 1858072689115461983851246118910633710638261093106525830971392, 6) = true := by decide +kernel
end KProto.D3k10I1G
