import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node348_ok : F (decodeKey M 3 1858072689115461983852647082261357253136886892813189214437376, 4) = true := by decide +kernel
theorem node349_ok : F (decodeKey M 3 1858072689115461983852651069945306267973279952970270405361664, 5) = true := by decide +kernel
theorem node350_ok : F (decodeKey M 3 1858072689115461983852651072663184977752490540665112746852352, 5) = true := by decide +kernel
theorem node351_ok : F (decodeKey M 3 1858072689115461988032594676509482656295356690131861664497664, 5) = true := by decide +kernel
end KProto.D3k10I1G
