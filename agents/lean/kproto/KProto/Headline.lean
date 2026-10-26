import SortProof.L5
import KProto.D3k10I1G.Final
/-
  HEADLINE (kernel only): no program in the AlphaDev memory model MM (MM-1) of length <= 16 sorts 3 int32 values,
  I1 (all four cmov conditions), every instruction counts (loads and stores included).
  Trust: Lean kernel only (propext, Classical.choice, Quot.sound); the certificate was produced by untrusted code.
-/
namespace KProto
open SortProof

theorem sort3_mm_optimal_kernel : ∀ q : Program, MMProg 3 q → q.length ≤ 16 → ¬ XCorrect 3 q := by
  intro q hq hl hx
  obtain ⟨p, o, hlen, -, hp⟩ := l5 (by decide) hq (xcorrect_to_relaxed (by decide) hx)
  exact KProto.D3k10I1G.lower_bound_kernel p o (by omega) hp

end KProto
