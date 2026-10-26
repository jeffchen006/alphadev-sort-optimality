import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node236_ok : F (decodeKey M 3 1858072689115461983851203584912842807963926808465294862909440, 5) = true := by decide +kernel
theorem node237_ok : F (decodeKey M 3 1858072689115461983851203622474522305258748892952033289633792, 5) = true := by decide +kernel
theorem node238_ok : F (decodeKey M 3 1858072689115461983851203622475865393926931114150415246098432, 5) = true := by decide +kernel
theorem node239_ok : F (decodeKey M 3 1858072689115461983851204910245272863937384909054799465480192, 5) = true := by decide +kernel
end KProto.D3k10I1G
