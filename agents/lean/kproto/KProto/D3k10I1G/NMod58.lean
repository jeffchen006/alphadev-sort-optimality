import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node232_ok : F (decodeKey M 3 1858072689115460604036150564821063766449052729897372111405056, 5) = true := by decide +kernel
theorem node233_ok : F (decodeKey M 3 1858072689115461983851203581018620164062879875134430839373824, 4) = true := by decide +kernel
theorem node234_ok : F (decodeKey M 3 1858072689115461983851203584831713169548213323321351935688704, 5) = true := by decide +kernel
theorem node235_ok : F (decodeKey M 3 1858072689115461983851203584911617288540738610103593258254336, 5) = true := by decide +kernel
end KProto.D3k10I1G
