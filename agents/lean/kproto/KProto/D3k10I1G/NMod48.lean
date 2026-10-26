import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node192_ok : F (decodeKey M 3 1858072689114135985808968811820907427320543812479657692954624, 6) = true := by decide +kernel
theorem node193_ok : F (decodeKey M 3 1858072689114135985810198306259763244638965487462235383070720, 5) = true := by decide +kernel
theorem node194_ok : F (decodeKey M 3 1858072689114135985810200960740402535857319214552496539238400, 5) = true := by decide +kernel
theorem node195_ok : F (decodeKey M 3 1858072689114135985810200960740403773797358499932771438362624, 4) = true := by decide +kernel
end KProto.D3k10I1G
