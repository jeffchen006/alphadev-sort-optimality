import KProto.Packed
namespace KPacked
set_option maxRecDepth 1000000
#eval (succs root 0b010101010101).length
theorem p1 : (score (succs root 0b010101010101) == 7) = false := by decide +kernel
theorem p2 : (score (succs [5, 77, 300, 1200, 2000] 0b010101010101) == 7) = false := by decide +kernel
end KPacked
