import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node300_ok : F (decodeKey M 3 1858072689115461983852604548343386207173262706352026579697664, 5) = true := by decide +kernel
theorem node301_ok : F (decodeKey M 3 1858072689115461983852604548343386207174444414830267206795264, 6) = true := by decide +kernel
theorem node302_ok : F (decodeKey M 3 1858072689115461983852608619104123298478090109343309313933312, 6) = true := by decide +kernel
theorem node303_ok : F (decodeKey M 3 1858072689115461983852647082260047471547401768360566698606592, 4) = true := by decide +kernel
end KProto.D3k10I1G
