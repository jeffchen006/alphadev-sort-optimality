import KProto.D3k10I1G.Data
set_option maxRecDepth 1000000
namespace KProto.D3k10I1G
open LeanReflect KProto
theorem chunk507_ok : (chunk507.toList M 3).all F = true := by decide +kernel
end KProto.D3k10I1G
