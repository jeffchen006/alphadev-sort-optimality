import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node80_ok : F (decodeKey M 3 1858026854879352214383566712255869931569155574123708293382144, 6) = true := by decide +kernel
theorem node81_ok : F (decodeKey M 3 1858071155028389993214317107353164568209739089785670462406656, 5) = true := by decide +kernel
theorem node82_ok : F (decodeKey M 3 1858071155028389993215634328082678849247333282561346102165504, 4) = true := by decide +kernel
theorem node83_ok : F (decodeKey M 3 1858071158021545346469323504562482297983316239407073141522432, 5) = true := by decide +kernel
end KProto.D3k10I1G
