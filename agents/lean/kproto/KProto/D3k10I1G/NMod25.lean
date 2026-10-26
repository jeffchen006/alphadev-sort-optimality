import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node100_ok : F (decodeKey M 3 1858072689114044774324986252619053946766142532382086152650752, 5) = true := by decide +kernel
theorem node101_ok : F (decodeKey M 3 1858072689114044774324986252619053946767360018616850889900032, 5) = true := by decide +kernel
theorem node102_ok : F (decodeKey M 3 1858072689114046064935741253883473858784931349573272116199424, 5) = true := by decide +kernel
theorem node103_ok : F (decodeKey M 3 1858072689114046064937058474611762620400444217241194297622528, 5) = true := by decide +kernel
end KProto.D3k10I1G
