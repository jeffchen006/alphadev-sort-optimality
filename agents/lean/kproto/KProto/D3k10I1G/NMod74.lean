import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node296_ok : F (decodeKey M 3 1858072689115461983851331190800438159887835104934087891156992, 4) = true := by decide +kernel
theorem node297_ok : F (decodeKey M 3 1858072689115461983851332520028433944802525039219827508576256, 5) = true := by decide +kernel
theorem node298_ok : F (decodeKey M 3 1858072689115461983851332561526243993875024435094144266862592, 6) = true := by decide +kernel
theorem node299_ok : F (decodeKey M 3 1858072689115461983852562010491937479806401019586984573730816, 6) = true := by decide +kernel
end KProto.D3k10I1G
