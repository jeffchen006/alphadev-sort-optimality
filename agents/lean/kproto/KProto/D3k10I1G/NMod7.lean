import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node28_ok : F (decodeKey M 3 1683696988255127352974231736510249246562722829631488, 4) = true := by decide +kernel
theorem node29_ok : F (decodeKey M 3 1683696988255127438645785536965500704986177066795008, 4) = true := by decide +kernel
theorem node30_ok : F (decodeKey M 3 1683696988255127439984424570806510952966696726495232, 4) = true := by decide +kernel
theorem node31_ok : F (decodeKey M 3 1683696988255128765237068077033433912523983278899200, 4) = true := by decide +kernel
end KProto.D3k10I1G
