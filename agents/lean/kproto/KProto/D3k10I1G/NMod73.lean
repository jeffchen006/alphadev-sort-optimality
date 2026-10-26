import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node292_ok : F (decodeKey M 3 1858072689115461983851331190800438159887799364367445078900736, 5) = true := by decide +kernel
theorem node293_ok : F (decodeKey M 3 1858072689115461983851331190800438159887832799091078677463040, 5) = true := by decide +kernel
theorem node294_ok : F (decodeKey M 3 1858072689115461983851331190800438159887833952012583284310016, 5) = true := by decide +kernel
theorem node295_ok : F (decodeKey M 3 1858072689115461983851331190800438159887835068834955446517760, 5) = true := by decide +kernel
end KProto.D3k10I1G
