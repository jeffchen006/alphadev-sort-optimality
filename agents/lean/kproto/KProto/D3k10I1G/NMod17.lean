import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem node68_ok : F (decodeKey M 3 1858022113674458933386686385397639614573181586005549866091520, 6) = true := by decide +kernel
theorem node69_ok : F (decodeKey M 3 1858022113674504608145322272736011251229902345674007842456576, 6) = true := by decide +kernel
theorem node70_ok : F (decodeKey M 3 1858022113674504608145322272737236770653198922034842211255296, 6) = true := by decide +kernel
theorem node71_ok : F (decodeKey M 3 1858023646216770840057102526162445891962155236886569419866112, 6) = true := by decide +kernel
end KProto.D3k10I1G
