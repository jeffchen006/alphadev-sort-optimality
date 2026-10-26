import LeanReflect.Heur
/-
  Rule H1: a class of tests with equal index content needs >= log2(#distinct undone-output signatures) cmps.
-/
namespace LeanReflect
open SortProof
set_option linter.unusedSectionVars false
set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false
open Classical

section
variable (c : Ctx)

def tsAt (i : Nat) : List Int := c.ts.getD i []

/-- Tests `a`, `b` (indices) have equal flags and equal index content in every register. -/
def Eqv (st : MS) (a b : Nat) : Prop :=
  (st (tsAt c a)).flag = (st (tsAt c b)).flag ∧
  ∀ r, (tsAt c a).idxOf ((st (tsAt c a)).regs r) = (tsAt c b).idxOf ((st (tsAt c b)).regs r)

/-- Input index of each output in `U`, for test `a`. -/
def usigU (U : List Nat) (a : Nat) : List Nat := U.map fun (j : Nat) => (tsAt c a).idxOf ((j : Nat) : Int)

theorem tsAt_mem (hc : CtxOK c) {a : Nat} (ha : a < c.m) : tsAt c a ∈ c.ts :=
  getD_mem _ a (hc.hm ▸ ha) []

theorem idx_inj (hc : CtxOK c) {w : List Int} (hw : w ∈ c.ts) {u v : Int}
    (hu : u ∈ w ∨ u = c.n) (hv : v ∈ w ∨ v = c.n) (h : w.idxOf u = w.idxOf v) : u = v := by
  have hnT := hc.noT w hw
  rcases hu with hu | hu <;> rcases hv with hv | hv
  · have h1 := List.getElem_idxOf (List.idxOf_lt_length_iff.2 hu)
    have h2 := List.getElem_idxOf (List.idxOf_lt_length_iff.2 hv)
    simp only [h] at h1
    exact h1.symm.trans h2
  · subst hv
    have h1 := List.idxOf_lt_length_iff.2 hu
    rw [h, List.idxOf_eq_length hnT] at h1; omega
  · subst hu
    have h1 := List.idxOf_lt_length_iff.2 hv
    rw [← h, List.idxOf_eq_length hnT] at h1; omega
  · rw [hu, hv]

/-- Reduction: outputs present now are constant on a class. -/
theorem dc_reduce (hc : CtxOK c) (st : MS) (U : List Nat) (C : List Nat) (hC : ∀ a ∈ C, a < c.m)
    (hE : ∀ a ∈ C, ∀ b ∈ C, ∀ r,
      (tsAt c a).idxOf ((st (tsAt c a)).regs r) = (tsAt c b).idxOf ((st (tsAt c b)).regs r)) :
    dc (usigU c U) C ≤ dc (usigU c (U.filter fun j => !decide (Pres c st j))) C := by
  classical
  apply dc_mono
  intro a ha b hb hab
  simp only [usigU] at hab ⊢
  apply List.map_congr_left
  intro j hj
  by_cases hp : Pres c st j
  · obtain ⟨r, hr⟩ := hp
    have := hE a ha b hb r
    rwa [hr _ (tsAt_mem c hc (hC a ha)), hr _ (tsAt_mem c hc (hC b hb))] at this
  · have hj' : j ∈ U.filter fun j => !decide (Pres c st j) := by simp [List.mem_filter, hj, hp]
    exact (List.map_inj_left.1 hab) j hj'

theorem eqv_write (st : MS) (i : Instr) (hi : i.isCmp = false) {a b : Nat} (h : Eqv c st a b) :
    Eqv c (stepMS st i) a b := by
  obtain ⟨hf, hr⟩ := h
  cases i with
  | cmp x y => simp [Instr.isCmp] at hi
  | mov d src =>
    refine ⟨by simp [stepMS, step_mov_flag, hf], fun r => ?_⟩
    simp only [stepMS, step_mov_regs]
    split
    · exact hr src
    · exact hr r
  | cmov cd d src =>
    refine ⟨by simp [stepMS, step_cmov_flag, hf], fun r => ?_⟩
    simp only [stepMS, step_cmov_regs, hf]
    split
    · split
      · exact hr src
      · exact hr d
    · exact hr r

theorem cmp_eq_iff (hc : CtxOK c) {w : List Int} (hw : w ∈ c.ts) {u v : Int}
    (hu : u ∈ w ∨ u = c.n) (hv : v ∈ w ∨ v = c.n) :
    compare u v = .eq ↔ w.idxOf u = w.idxOf v := by
  rw [Int.compare_eq_eq]
  constructor
  · intro h; rw [h]
  · exact idx_inj c hc hw hu hv

theorem eqv_cmp (hc : CtxOK c) (st : MS) (hV : Vals c st) (x y : Nat) {a b : Nat} (ha : a < c.m) (hb : b < c.m)
    (h : Eqv c st a b) (hab : ((stepMS st (.cmp x y) (tsAt c a)).flag = .lt) =
      ((stepMS st (.cmp x y) (tsAt c b)).flag = .lt)) :
    Eqv c (stepMS st (.cmp x y)) a b := by
  obtain ⟨hf, hr⟩ := h
  refine ⟨?_, fun r => by simpa [stepMS, step_cmp_regs] using hr r⟩
  simp only [stepMS, step_cmp_flag] at hab ⊢
  have hwa := tsAt_mem c hc ha
  have hwb := tsAt_mem c hc hb
  have hea := cmp_eq_iff c hc hwa (hV _ hwa x) (hV _ hwa y)
  have heb := cmp_eq_iff c hc hwb (hV _ hwb x) (hV _ hwb y)
  have hxy := hr x
  have hyy := hr y
  have heq : (compare ((st (tsAt c a)).regs x) ((st (tsAt c a)).regs y) = .eq) ↔
      (compare ((st (tsAt c b)).regs x) ((st (tsAt c b)).regs y) = .eq) := by
    rw [hea, heb, hxy, hyy]
  revert hab heq
  cases compare ((st (tsAt c a)).regs x) ((st (tsAt c a)).regs y) <;>
    cases compare ((st (tsAt c b)).regs x) ((st (tsAt c b)).regs y) <;> simp

theorem vals_step (st : MS) (hV : Vals c st) (i : Instr) : Vals c (stepMS st i) := by
  intro w hw r
  obtain ⟨r', h⟩ := step_val (st w) i r
  simp only [stepMS]; rw [h]; exact hV w hw r'

theorem class_le (hc : CtxOK c) : ∀ (q : Program) (st : MS) (U C : List Nat),
    (∀ a ∈ C, a < c.m) → Vals c st → (∀ a ∈ C, ∀ b ∈ C, Eqv c st a b) →
    (∀ j ∈ U, ¬ Pres c st j) → Fut c st q U → dc (usigU c U) C ≤ 2 ^ ncmp q
  | [], st, U, C, hC, hV, hE, hA, hF => by
    rw [Fut_nil c hF hA]
    have := dc_const (usigU c []) C (fun a _ b _ => by simp [usigU])
    simp [ncmp]; omega
  | i :: q, st, U, C, hC, hV, hE, hA, hF => by
    classical
    let st' := stepMS st i
    let U1 := U.filter fun j => !decide (Pres c st' j)
    have hF1 : Fut c st' q U1 := Fut_mono c (fun j hj => (List.mem_filter.1 hj).1) (Fut_step c hF hA)
    have hA1 : ∀ j ∈ U1, ¬ Pres c st' j := fun j hj => by
      have := (List.mem_filter.1 hj).2; simpa using this
    have hV' : Vals c st' := vals_step c st hV i
    cases hi : i.isCmp
    · have hE' : ∀ a ∈ C, ∀ b ∈ C, Eqv c st' a b := fun a ha b hb => eqv_write c st i hi (hE a ha b hb)
      have h1 := dc_reduce c hc st' U C hC (fun a ha b hb => (hE' a ha b hb).2)
      have h2 := class_le hc q st' U1 C hC hV' hE' hA1 hF1
      rw [ncmp_cons, hi]; simp only [Bool.false_eq_true, if_false, Nat.add_zero]
      exact Nat.le_trans h1 h2
    · cases i with
      | mov _ _ => simp [Instr.isCmp] at hi
      | cmov _ _ _ => simp [Instr.isCmp] at hi
      | cmp x y =>
        let p : Nat → Bool := fun a => decide ((st' (tsAt c a)).flag = .lt)
        have hsub : ∀ (D : List Nat), (∀ a ∈ D, a ∈ C) →
            (∀ a ∈ D, ∀ b ∈ D, p a = p b) → dc (usigU c U1) D ≤ 2 ^ ncmp q := by
          intro D hD hp
          have hE' : ∀ a ∈ D, ∀ b ∈ D, Eqv c st' a b := by
            intro a ha b hb
            apply eqv_cmp c hc st hV x y (hC a (hD a ha)) (hC b (hD b hb)) (hE a (hD a ha) b (hD b hb))
            have := hp a ha b hb
            simp only [p] at this
            exact propext ⟨fun h => of_decide_eq_true (this ▸ decide_eq_true h),
              fun h => of_decide_eq_true (this.symm ▸ decide_eq_true h)⟩
          exact class_le hc q st' U1 D (fun a ha => hC a (hD a ha)) hV' hE' hA1 hF1
        have h1 := dc_reduce c hc st' U C hC (fun a ha b hb r => by
          simpa [st', stepMS, step_cmp_regs] using (hE a ha b hb).2 r)
        have h2 := dc_filter (usigU c U1) p C
        have h3 := hsub (C.filter p) (fun a ha => (List.mem_filter.1 ha).1)
          (fun a ha b hb => by rw [(List.mem_filter.1 ha).2, (List.mem_filter.1 hb).2])
        have h4 := hsub (C.filter fun a => !p a) (fun a ha => (List.mem_filter.1 ha).1)
          (fun a ha b hb => by
            have e1 := (List.mem_filter.1 ha).2; have e2 := (List.mem_filter.1 hb).2
            simp only [Bool.not_eq_true'] at e1 e2; rw [e1, e2])
        have h1' : dc (usigU c U) C ≤ dc (usigU c U1) C := h1
        rw [ncmp_cons]; simp only [Instr.isCmp, if_true, Nat.pow_succ]
        omega
end

end LeanReflect
#print axioms LeanReflect.class_le
#print axioms LeanReflect.und_le
#print axioms LeanReflect.not_dead
#print axioms LeanReflect.sim
