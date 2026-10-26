import SortProof.Relax
/-
  Verified checker for the STRICT model (upper bound: a found program really sorts).
  1. `taintOK`: a static check that the outputs never depend on scratch garbage or on the
     initial flags (def-before-use, with cmov tracked exactly).
  2. Run the program on one representative per weak order type of the n inputs
     (`reps n`), scratch = n (any value works after step 1), flags = eq.
  `checkStrict_sound` : checkStrict n p = true → StrictCorrect n p (hence XCorrect n p).
-/
namespace SortProof

/-- Taint state: `clean r` = register r is a function of the inputs only;
  second component = the flags are a function of the inputs only. -/
def taintStep (t : (Nat → Bool) × Bool) : Instr → (Nat → Bool) × Bool
  | .mov d s => (upd t.1 d (t.1 s), t.2)
  | .cmp a b => (t.1, t.1 a && t.1 b)
  | .cmov _ d s => (upd t.1 d (t.1 d && t.1 s && t.2), t.2)

def taintInit (n : Nat) : (Nat → Bool) × Bool := (fun r => decide (r < n), false)

def taintOK (n : Nat) (o : Nat → Nat) (p : Program) : Bool :=
  let t := p.foldl taintStep (taintInit n)
  (List.range n).all fun j => t.1 (o j)

def TInv (t : (Nat → Bool) × Bool) (s1 s2 : State Int) : Prop :=
  (∀ r, t.1 r = true → s1.regs r = s2.regs r) ∧ (t.2 = true → s1.flag = s2.flag)

theorem taintStep_inv {t : (Nat → Bool) × Bool} {s1 s2 : State Int} (i : Instr)
    (h : TInv t s1 s2) : TInv (taintStep t i) (step compare s1 i) (step compare s2 i) := by
  obtain ⟨hr, hf⟩ := h
  cases i with
  | mov d src =>
    refine ⟨fun r hc => ?_, hf⟩
    simp only [taintStep, upd] at hc
    simp only [step, upd]
    split
    · rename_i e; rw [if_pos e] at hc; exact hr _ hc
    · rename_i e; rw [if_neg e] at hc; exact hr _ hc
  | cmp a b =>
    refine ⟨hr, fun hc => ?_⟩
    simp only [taintStep, Bool.and_eq_true] at hc
    simp only [step]; rw [hr a hc.1, hr b hc.2]
  | cmov c d src =>
    refine ⟨fun r hc => ?_, fun hc => ?_⟩
    rotate_left
    · simp only [step]; split <;> split <;> exact hf hc
    simp only [taintStep, upd] at hc
    by_cases e : r = d
    · rw [if_pos e] at hc
      simp only [Bool.and_eq_true] at hc
      obtain ⟨⟨hd, hs⟩, hfl⟩ := hc
      have hfe := hf hfl
      simp only [step, hfe]
      split
      · simp only [upd, if_pos e]; exact hr _ hs
      · subst e; exact hr _ hd
    · rw [if_neg e] at hc
      have := hr r hc
      simp only [step]
      split <;> split <;> simp [upd, e, this]

theorem taint_sound {n : Nat} {o : Nat → Nat} {p : Program} (h : taintOK n o p = true)
    (s1 s2 : State Int) (hin : ∀ r < n, s1.regs r = s2.regs r) :
    ∀ j < n, (run compare p s1).regs (o j) = (run compare p s2).regs (o j) := by
  have key : ∀ (q : Program) (t : (Nat → Bool) × Bool) (u1 u2 : State Int), TInv t u1 u2 →
      TInv (q.foldl taintStep t) (run compare q u1) (run compare q u2) := by
    intro q
    induction q with
    | nil => intro t u1 u2 h; exact h
    | cons i q ih => intro t u1 u2 h; exact ih _ _ _ (taintStep_inv i h)
  have := key p (taintInit n) s1 s2
    ⟨fun r hr => hin r (by simpa [taintInit] using hr), fun h => by simp [taintInit] at h⟩
  intro j hj
  apply this.1
  simp only [taintOK, List.all_eq_true, List.mem_range] at h
  exact h j hj

/-- Structurally recursive form of `SortsOK` (kernel-reducible; `List.mergeSort` uses
  well-founded recursion and does not reduce well in the kernel). -/
def sortsCheck (n : Nat) (x y : Nat → Int) : Bool :=
  let xs := (List.range n).map x
  let ys := (List.range n).map y
  ys.isPerm xs && decide (ys.Pairwise (· ≤ ·))

theorem sortsCheck_iff (n : Nat) (x y : Nat → Int) : sortsCheck n x y = true ↔ SortsOK n x y := by
  simp only [sortsCheck, Bool.and_eq_true, decide_eq_true_eq, List.isPerm_iff, SortsOK]
  have hm := List.mergeSort_perm ((List.range n).map x) (fun a b : Int => decide (a ≤ b))
  have hs : (((List.range n).map x).mergeSort (fun a b : Int => decide (a ≤ b))).Pairwise
      (fun a b : Int => a ≤ b) :=
    (List.pairwise_mergeSort (le := fun a b : Int => decide (a ≤ b))
      (fun a b c h1 h2 => by simp at *; omega) (fun a b => by simp; omega) _).imp
      (fun h => by simpa using h)
  constructor
  · rintro ⟨hp, hpw⟩
    exact List.Perm.eq_of_pairwise (le := fun a b : Int => a ≤ b)
      (fun a b _ _ h1 h2 => by omega) hpw hs (hp.trans hm.symm)
  · intro h
    rw [h]
    exact ⟨hm, hs⟩

/-- The checker. `o j` = register that holds output `j` (`id` for the §1 / `mem` models). -/
def checkStrictO (n : Nat) (o : Nat → Nat) (p : Program) : Bool :=
  taintOK n o p &&
    (reps n).all fun c =>
      sortsCheck n (vecRegs c) (fun j => (run compare p (relaxInit n (vecRegs c) n)).regs (o j))

theorem checkStrictO_sound {n : Nat} {o : Nat → Nat} {p : Program} (h : checkStrictO n o p = true) :
    StrictCorrectO n o p := by
  simp only [checkStrictO, Bool.and_eq_true, List.all_eq_true, sortsCheck_iff] at h
  obtain ⟨ht, hr⟩ := h
  intro s
  let x := s.regs
  let c := rankList x n
  let T := bigT x n
  have hxT := (bigT_spec x n).2
  -- garbage does not matter
  have h1 : ∀ j < n, (run compare p s).regs (o j) = (run compare p (relaxInit n x T)).regs (o j) :=
    taint_sound ht _ _ (fun r hr => by simp [relaxInit, hr, x])
  -- order transfer from the representative
  have hcn : ∀ i < n, vecRegs c i < n := by
    intro i hi
    rw [vecRegs_rankList x hi]
    have := cnt_self_lt x hi; simp [rank]; omega
  have hord : ∀ i j, i < n → j < n → compare (x i) (x j) = compare (vecRegs c i) (vecRegs c j) := by
    intro i j hi hj
    rw [vecRegs_rankList x hi, vecRegs_rankList x hj, rank_compare x hi hj]
  have key := correct_transfer_allO (n := n) o p (relaxInit n x T) (relaxInit n (vecRegs c) n)
    rfl (relaxInit_order x (vecRegs c) T n hxT hcn hord)
  have h2 := hr c (rankList_mem_reps x n)
  have h3 := key.mpr ((sortsOK_congr (fun i hi => by simp [relaxInit, hi]) (fun _ _ => rfl)).mp h2)
  exact (sortsOK_congr (fun i hi => by simp [relaxInit, hi, x]) (fun j hj => (h1 j hj).symm)).mp h3

def checkStrict (n : Nat) (p : Program) : Bool := checkStrictO n id p

theorem checkStrict_sound {n : Nat} {p : Program} (h : checkStrict n p = true) :
    StrictCorrect n p :=
  checkStrictO_sound (o := id) h

theorem checkStrict_x86 {n : Nat} {p : Program} (h : checkStrict n p = true) : XCorrect n p :=
  strict_to_x86 (checkStrict_sound h)

theorem checkStrictO_x86 {n : Nat} {o : Nat → Nat} {p : Program} (h : checkStrictO n o p = true) :
    XCorrectO n o p :=
  strictO_to_x86 (checkStrictO_sound h)

end SortProof
