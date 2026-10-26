import SortProof.OrderType
import SortProof.X86
/-
  Representatives of weak order types.
  `rank v m i = #{j < m : v j < v i}` has the same order type as `v` on `[0, m)`.
  `reps m` = all canonical rank vectors of length m = one vector per weak order type
  (|reps 3| = 13, |reps 4| = 75, |reps 5| = 541: Fubini numbers, checked in Checks.lean).
  Corollary `x86_iff_reps`: a program is correct on all Int32 register files and flag states
  iff it is correct on every representative.
-/
namespace SortProof

/-- `cnt v t m = #{j < m : v j < t}`. -/
def cnt (v : Nat → Int) (t : Int) : Nat → Nat
  | 0 => 0
  | m + 1 => cnt v t m + if v m < t then 1 else 0

theorem cnt_le (v : Nat → Int) (t : Int) (m : Nat) : cnt v t m ≤ m := by
  induction m with
  | zero => simp [cnt]
  | succ m ih => simp only [cnt]; split <;> omega

theorem cnt_mono (v : Nat → Int) {t t' : Int} (h : t ≤ t') (m : Nat) : cnt v t m ≤ cnt v t' m := by
  induction m with
  | zero => simp [cnt]
  | succ m ih =>
    simp only [cnt]
    by_cases h1 : v m < t
    · have : v m < t' := by omega
      simp [h1, this]; omega
    · simp only [h1, if_false]; split <;> omega

theorem cnt_strict (v : Nat → Int) {t t' : Int} {i m : Nat} (hi : i < m) (h1 : t ≤ v i)
    (h2 : v i < t') (h : t ≤ t') : cnt v t m < cnt v t' m := by
  induction m with
  | zero => omega
  | succ m ih =>
    simp only [cnt]
    by_cases him : i = m
    · subst him
      have := cnt_mono v h i
      have e1 : ¬ v i < t := by omega
      simp [e1, h2]; omega
    · have := ih (by omega)
      by_cases h3 : v m < t
      · have : v m < t' := by omega
        simp [h3, this]; omega
      · simp only [h3, if_false]; split <;> omega

theorem cnt_congr (v w : Nat → Int) (t t' : Int) (m : Nat)
    (h : ∀ j < m, (v j < t ↔ w j < t')) : cnt v t m = cnt w t' m := by
  induction m with
  | zero => rfl
  | succ m ih =>
    simp only [cnt]
    rw [ih (fun j hj => h j (by omega))]
    by_cases h1 : v m < t
    · have := (h m (by omega)).mp h1; simp [h1, this]
    · have : ¬ w m < t' := fun h' => h1 ((h m (by omega)).mpr h'); simp [h1, this]

/-- `i` is not counted in `cnt v (v i) m`, so the count is `< m`. -/
theorem cnt_self_lt (v : Nat → Int) {i m : Nat} (hi : i < m) : cnt v (v i) m < m := by
  induction m with
  | zero => omega
  | succ k ih =>
    simp only [cnt]
    by_cases hik : i = k
    · subst hik
      have := cnt_le v (v i) i
      have e : ¬ v i < v i := Int.lt_irrefl _
      simp only [e, if_false]; omega
    · have := ih (by omega); split <;> omega

def rank (v : Nat → Int) (m : Nat) (i : Nat) : Int := (cnt v (v i) m : Int)

theorem rank_compare (v : Nat → Int) {m i j : Nat} (hi : i < m) (hj : j < m) :
    compare (rank v m i) (rank v m j) = compare (v i) (v j) := by
  unfold rank
  rcases Int.lt_trichotomy (v i) (v j) with h | h | h
  · have := cnt_strict v (t := v i) (t' := v j) hi (Int.le_refl _) h (Int.le_of_lt h)
    rw [Int.compare_eq_lt.mpr h, Int.compare_eq_lt.mpr (by omega)]
  · rw [h, Int.compare_eq_eq.mpr rfl, Int.compare_eq_eq.mpr rfl]
  · have := cnt_strict v (t := v j) (t' := v i) hj (Int.le_refl _) h (Int.le_of_lt h)
    rw [Int.compare_eq_gt.mpr h, Int.compare_eq_gt.mpr (by omega)]

theorem rank_nonneg_lt (v : Nat → Int) (m i : Nat) : 0 ≤ rank v m i ∧ rank v m i ≤ m := by
  unfold rank; have := cnt_le v (v i) m; omega

/-! ### Finite list of representatives -/

/-- All lists of length `m` with entries `< b`. -/
def allVecs : Nat → Nat → List (List Nat)
  | 0, _ => [[]]
  | m + 1, b => (allVecs m b).flatMap (fun l => (List.range b).map (fun x => x :: l))

theorem mem_allVecs : ∀ (m b : Nat) (l : List Nat),
    l ∈ allVecs m b ↔ l.length = m ∧ ∀ x ∈ l, x < b
  | 0, b, l => by cases l <;> simp [allVecs]
  | m + 1, b, l => by
    cases l with
    | nil => simp [allVecs]
    | cons x l =>
      simp only [allVecs, List.mem_flatMap, List.mem_map, List.mem_range, List.cons.injEq,
        List.length_cons, List.mem_cons, forall_eq_or_imp]
      constructor
      · rintro ⟨l', hl', y, hy, rfl, rfl⟩
        have := (mem_allVecs m b l').mp hl'
        exact ⟨by omega, hy, this.2⟩
      · rintro ⟨hlen, hx, hl⟩
        exact ⟨l, (mem_allVecs m b l).mpr ⟨by omega, hl⟩, x, hx, rfl, rfl⟩

def vecRegs (c : List Nat) : Nat → Int := fun r => ((c.getD r 0 : Nat) : Int)

def rankList (v : Nat → Int) (m : Nat) : List Nat := (List.range m).map (fun i => cnt v (v i) m)

theorem vecRegs_rankList (v : Nat → Int) {m r : Nat} (hr : r < m) :
    vecRegs (rankList v m) r = rank v m r := by
  simp [vecRegs, rankList, rank, List.getD_eq_getElem?_getD, hr]

/-- Canonical rank vector: each entry equals the number of strictly smaller entries. -/
def isCanon (m : Nat) (c : List Nat) : Bool :=
  (List.range m).all fun i => cnt (vecRegs c) (vecRegs c i) m == c.getD i 0

def reps (m : Nat) : List (List Nat) := (allVecs m m).filter (isCanon m)

theorem rankList_mem_reps (v : Nat → Int) (m : Nat) : rankList v m ∈ reps m := by
  unfold reps
  rw [List.mem_filter, mem_allVecs]
  refine ⟨⟨by simp [rankList], ?_⟩, ?_⟩
  · intro x hx
    simp only [rankList, List.mem_map, List.mem_range] at hx
    obtain ⟨i, hi, rfl⟩ := hx
    exact cnt_self_lt v hi
  · simp only [isCanon, List.all_eq_true, List.mem_range, beq_iff_eq]
    intro i hi
    rw [vecRegs_rankList v hi]
    have hlen : (rankList v m).getD i 0 = cnt v (v i) m := by
      simp [rankList, List.getD_eq_getElem?_getD, hi]
    rw [hlen]
    apply cnt_congr
    intro j hj
    rw [vecRegs_rankList v hj]
    have := rank_compare v hj hi
    constructor
    · intro h; exact Int.compare_eq_lt.mp (this ▸ Int.compare_eq_lt.mpr h)
    · intro h; exact Int.compare_eq_lt.mp (this.symm ▸ Int.compare_eq_lt.mpr h)

/-- Correct for all `Int` states iff correct on every representative (and every flag state). -/
theorem strict_iff_reps {n R : Nat} {p : Program} (hp : Program.WF R p) (hn : n ≤ R) :
    StrictCorrect n p ↔
      ∀ c ∈ reps R, ∀ fl : Ordering,
        SortsOK n (vecRegs c) (run compare p ⟨vecRegs c, fl⟩).regs := by
  constructor
  · intro h c _ fl; exact h ⟨vecRegs c, fl⟩
  · intro h s
    have := h (rankList s.regs R) (rankList_mem_reps s.regs R) s.flag
    refine (correct_transfer hp hn s ⟨vecRegs (rankList s.regs R), s.flag⟩ rfl ?_).mpr this
    intro i j hi hj
    show _ = compare (vecRegs (rankList s.regs R) i) (vecRegs (rankList s.regs R) j)
    rw [vecRegs_rankList _ hi, vecRegs_rankList _ hj, rank_compare _ hi hj]

/-! ### Int32 realization -/

def flagsOf : Ordering → XState → XState
  | .lt, s => { s with cf := false, zf := false, sf := true, of := false }
  | .eq, s => { s with cf := false, zf := true, sf := false, of := false }
  | .gt, s => { s with cf := false, zf := false, sf := false, of := false }

theorem toInt_ofInt_small (k : Int) (h0 : 0 ≤ k) (h1 : k < 2 ^ 31) :
    (BitVec.ofInt 32 k).toInt = k := by
  rw [BitVec.toInt_ofInt]
  simp only [Int.bmod]
  omega

/-- An x86 state whose abstraction is `⟨vecRegs c, fl⟩`, when all entries of `c` are `< 2^31`. -/
def realize (c : List Nat) (fl : Ordering) : XState :=
  flagsOf fl { regs := fun r => BitVec.ofInt 32 (vecRegs c r), cf := false, zf := false,
               sf := false, of := false }

theorem realize_abs (c : List Nat) (fl : Ordering) (hc : ∀ x ∈ c, x < 2 ^ 31) :
    (realize c fl).abs = ⟨vecRegs c, fl⟩ := by
  have hregs : ∀ r, (BitVec.ofInt 32 (vecRegs c r)).toInt = vecRegs c r := by
    intro r
    apply toInt_ofInt_small
    · simp [vecRegs]
    · simp only [vecRegs, List.getD_eq_getElem?_getD]
      cases h : c[r]? with
      | none => simp
      | some x =>
        have := hc x (List.mem_of_getElem? h)
        simp; omega
  cases fl <;> simp [realize, flagsOf, XState.abs, XState.flagOrd, hregs]

/-- Order-type corollary over Int32: correct for every 32-bit register file and every flag
  state iff correct on each representative of each weak order type of the `R` registers. -/
theorem x86_iff_reps {n R : Nat} {p : Program} (hp : Program.WF R p) (hn : n ≤ R)
    (hR : R ≤ 2 ^ 31) :
    XCorrect n p ↔
      ∀ c ∈ reps R, ∀ fl : Ordering,
        SortsOK n (vecRegs c) (run compare p ⟨vecRegs c, fl⟩).regs := by
  rw [← strict_iff_reps hp hn]
  constructor
  · intro hx
    rw [strict_iff_reps hp hn]
    intro c hc fl
    have hc' : ∀ x ∈ c, x < 2 ^ 31 := by
      intro x hx'
      have := ((mem_allVecs R R c).mp (List.mem_filter.mp hc).1).2 x hx'
      omega
    have := hx (realize c fl)
    have e := xrun_abs p (realize c fl)
    rw [realize_abs c fl hc'] at e
    have e2 : (fun r => ((realize c fl).regs r).toInt) = vecRegs c := by
      have := congrArg State.regs (realize_abs c fl hc'); exact this
    have e3 : (fun r => ((xrun p (realize c fl)).regs r).toInt) =
        (run compare p ⟨vecRegs c, fl⟩).regs := congrArg State.regs e
    rw [e2, e3] at this
    exact this
  · exact strict_to_x86

end SortProof
