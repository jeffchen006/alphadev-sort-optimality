import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node84_ok : F (decodeKey M 3 1858071158021545346469323504563825386651498391925560780587008, 5) = true := by decide +kernel
theorem node85_ok : F (decodeKey M 3 1858071158161849503653090184711379130591080970191812893409280, 5) = true := by decide +kernel
theorem node86_ok : F (decodeKey M 3 1858071204415453321900188395975032045156218712399655135674368, 5) = true := by decide +kernel
theorem node87_ok : F (decodeKey M 3 1858071204415453321900270808110770709940338748437392517038080, 6) = true := by decide +kernel
end KProto.D3k10I1G
