import LeanReflect.Sort3
import SortProof.L5
import KProto.D3k8I1.Final
/-
  Headline sort3 results in the AlphaDev memory model MM (theory request), one build.
  * `sort3_mm_optimal`  : no MM program of length ≤ 16 sorts 3 int32 (MM-1, I1, every instruction counts).
                          Trust: kernel + native_decide (lean-reflect's checker at k = 10).
  * `sort3_mm_le14_kernel` : no MM program of length ≤ 14 — KERNEL ONLY (k = 8 certificate).
-/
namespace KProto
open SortProof

theorem sort3_mm_optimal : ∀ q : Program, MMProg 3 q → q.length ≤ 16 → ¬ XCorrect 3 q := by
  intro q hq hl hx
  obtain ⟨p, o, hlen, -, hp⟩ := l5 (by decide) hq (xcorrect_to_relaxed (by decide) hx)
  exact LeanReflect.sort3_rs_lb p o (by omega) hp

theorem sort3_mm_le14_kernel : ∀ q : Program, MMProg 3 q → q.length ≤ 14 → ¬ XCorrect 3 q := by
  intro q hq hl hx
  obtain ⟨p, o, hlen, -, hp⟩ := l5 (by decide) hq (xcorrect_to_relaxed (by decide) hx)
  exact KProto.D3k8I1.lower_bound_kernel p o (by omega) hp

end KProto
