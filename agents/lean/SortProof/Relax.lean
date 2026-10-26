import SortProof.Reps
/-
  Relaxation lemma (MODEL.md section 2).
  * `strict_to_relaxed`  : StrictCorrect → RelaxedCorrect (over Int).
  * `x86_to_relaxed`     : XCorrect → RelaxedCorrect. Realization in 32 bits: inputs are
                           rank values `0..n-1 < INT_MAX`, every scratch register = INT_MAX
                           (0x7fffffff), flags = (ZF=1, SF=OF=CF=0), which is "eq".
  * `relaxed_iff_abs`    : RelaxedCorrect ↔ the T-machine used by `sat`/`enum`
                           (register = `some i` "holds x_i" or `none` = T; T > every input;
                           T in an output register = wrong).
-/
namespace SortProof

theorem strict_to_relaxed {n : Nat} {p : Program} (h : StrictCorrect n p) : RelaxedCorrect n p := by
  intro x T _
  have := h (relaxInit n x T)
  exact (sortsOK_congr (fun i hi => by simp [relaxInit, hi]) (fun _ _ => rfl)).mp this

/-- The 32-bit relaxed initial state: `P i = xin i`, scratch = INT_MAX, flags = eq. -/
def xRelaxInit (n : Nat) (xin : Nat → BitVec 32) : XState :=
  { regs := fun r => if r < n then xin r else BitVec.ofInt 32 (2 ^ 31 - 1),
    cf := false, zf := true, sf := false, of := false }

theorem relaxInit_order {n : Nat} (x x' : Nat → Int) (T T' : Int) (hx : ∀ i < n, x i < T)
    (hx' : ∀ i < n, x' i < T')
    (hord : ∀ i j, i < n → j < n → compare (x i) (x j) = compare (x' i) (x' j)) :
    ∀ i j, compare ((relaxInit n x T).regs i) ((relaxInit n x T).regs j) =
      compare ((relaxInit n x' T').regs i) ((relaxInit n x' T').regs j) := by
  intro i j
  simp only [relaxInit]
  by_cases hi : i < n <;> by_cases hj : j < n <;> simp only [hi, hj, if_true, if_false]
  · exact hord i j hi hj
  · rw [Int.compare_eq_lt.mpr (hx i hi), Int.compare_eq_lt.mpr (hx' i hi)]
  · rw [Int.compare_eq_gt.mpr (hx j hj), Int.compare_eq_gt.mpr (hx' j hj)]
  · rw [Int.compare_eq_eq.mpr rfl, Int.compare_eq_eq.mpr rfl]

/-- Relaxation lemma, x86 form. A program that is correct for all 32-bit garbage values and
  flag states is correct in the relaxed model (for every `Int` input and every `T` above the
  inputs). The proof only uses the x86 runs from `xRelaxInit` with inputs `< INT_MAX`. -/
theorem x86_to_relaxed {n : Nat} {p : Program} (hn : n < 2 ^ 31 - 1)
    (h : ∀ xin : Nat → BitVec 32, (∀ i < n, (xin i).toInt < 2 ^ 31 - 1) →
      SortsOK n (fun r => (xin r).toInt) (fun r => ((xrun p (xRelaxInit n xin)).regs r).toInt)) :
    RelaxedCorrect n p := by
  intro x T hx
  -- representative: ranks of the inputs, realized as 32-bit values
  let c := rankList x n
  let xin : Nat → BitVec 32 := fun r => BitVec.ofInt 32 (vecRegs c r)
  have hc : ∀ r, 0 ≤ vecRegs c r ∧ vecRegs c r < 2 ^ 31 - 1 := by
    intro r
    simp only [vecRegs, List.getD_eq_getElem?_getD]
    cases hr : c[r]? with
    | none => simp
    | some y =>
      have hy := List.mem_of_getElem? hr
      have := ((mem_allVecs n n c).mp (List.mem_filter.mp (rankList_mem_reps x n)).1).2 y hy
      simp
      omega
  have hxin : ∀ r, (xin r).toInt = vecRegs c r := fun r =>
    toInt_ofInt_small _ (hc r).1 (by have := (hc r).2; omega)
  have habs : (xRelaxInit n xin).abs = relaxInit n (vecRegs c) (2 ^ 31 - 1) := by
    simp only [XState.abs, XState.flagOrd, xRelaxInit, relaxInit]
    congr 1
    · funext r
      by_cases hr : r < n
      · simp [hr, hxin]
      · simp only [hr, if_false]; exact toInt_ofInt_small _ (by decide) (by decide)
  have h1 := h xin (fun i _ => by rw [hxin]; exact (hc i).2)
  have e := xrun_abs p (xRelaxInit n xin)
  rw [habs] at e
  have e3 : (fun r => ((xrun p (xRelaxInit n xin)).regs r).toInt) =
      (run compare p (relaxInit n (vecRegs c) (2 ^ 31 - 1))).regs := congrArg State.regs e
  have e2 : (fun r => (xin r).toInt) = vecRegs c := funext hxin
  rw [e2, e3] at h1
  -- transfer from the representative back to `x`
  have hord : ∀ i j, i < n → j < n → compare (x i) (x j) = compare (vecRegs c i) (vecRegs c j) := by
    intro i j hi hj
    rw [vecRegs_rankList x hi, vecRegs_rankList x hj, rank_compare x hi hj]
  have key := correct_transfer_all (n := n) p (relaxInit n x T) (relaxInit n (vecRegs c) (2 ^ 31 - 1))
    rfl (relaxInit_order x (vecRegs c) T _ hx (fun i _ => (hc i).2) hord)
  have h2 := key.mpr ((sortsOK_congr (fun i hi => by simp [relaxInit, hi]) (fun _ _ => rfl)).mp h1)
  exact (sortsOK_congr (fun i hi => by simp [relaxInit, hi]) (fun _ _ => rfl)).mp h2

/-- Instance of the hypothesis of `x86_to_relaxed` from full x86 correctness. -/
theorem xcorrect_to_relaxed {n : Nat} {p : Program} (hn : n < 2 ^ 31 - 1) (h : XCorrect n p) :
    RelaxedCorrect n p :=
  x86_to_relaxed hn (fun xin _ => by
    have := h (xRelaxInit n xin)
    refine (sortsOK_congr (fun i hi => ?_) (fun _ _ => rfl)).mp this
    simp [xRelaxInit, hi])

/-! ### The T-machine (abstract relaxed state used by `sat` and `enum`) -/

/-- Compare in the T-machine: `some i` = "holds x_i", `none` = T (above every input). -/
def absOrd {n : Nat} (x : Nat → Int) : Option (Fin n) → Option (Fin n) → Ordering
  | some i, some j => compare (x i) (x j)
  | some _, none => .lt
  | none, some _ => .gt
  | none, none => .eq

def absInit (n : Nat) : State (Option (Fin n)) :=
  { regs := fun r => if h : r < n then some ⟨r, h⟩ else none, flag := .eq }

def absVal {n : Nat} (x : Nat → Int) : Option (Fin n) → Int
  | some i => x i
  | none => 0

/-- Correct in the T-machine for the inputs `x`: no output is T, and outputs are sorted. -/
def AbsOK (n : Nat) (p : Program) (x : Nat → Int) : Prop :=
  let out := (run (absOrd x) p (absInit n)).regs
  (∀ j < n, (out j).isSome) ∧ SortsOK n x (fun j => absVal x (out j))

def interp {n : Nat} (x : Nat → Int) (T : Int) : Option (Fin n) → Int
  | some i => x i
  | none => T

theorem run_relax_eq_abs {n : Nat} (p : Program) (x : Nat → Int) (T : Int) (hx : ∀ i < n, x i < T) :
    run compare p (relaxInit n x T) = (run (absOrd x) p (absInit n)).map (interp x T) := by
  have h0 : relaxInit n x T = (absInit n).map (interp x T) := by
    simp only [relaxInit, absInit, State.map]
    congr 1; funext r
    by_cases hr : r < n <;> simp [hr, interp]
  rw [h0]
  apply run_map
  intro a b
  cases a <;> cases b <;> simp only [interp, absOrd]
  · exact Int.compare_eq_eq.mpr rfl
  · exact Int.compare_eq_gt.mpr (hx _ (Fin.isLt _))
  · exact Int.compare_eq_lt.mpr (hx _ (Fin.isLt _))

/-- A bound above all inputs. -/
def bigT (x : Nat → Int) : Nat → Int
  | 0 => 1
  | m + 1 => bigT x m + (if x m < 0 then -x m else x m)

theorem bigT_spec (x : Nat → Int) (m : Nat) : 1 ≤ bigT x m ∧ ∀ i < m, x i < bigT x m := by
  induction m with
  | zero => simp [bigT]
  | succ m ih =>
    refine ⟨?_, ?_⟩
    · simp only [bigT]; split <;> omega
    · intro i hi
      simp only [bigT]
      by_cases him : i = m
      · subst him; split <;> omega
      · have := ih.2 i (by omega); split <;> omega

theorem sortsOK_no_T {n : Nat} {x y : Nat → Int} {T : Int} (hx : ∀ i < n, x i < T)
    (h : SortsOK n x y) : ∀ j < n, y j < T := by
  intro j hj
  have hmem : y j ∈ (List.range n).map y := List.mem_map.mpr ⟨j, by simpa using hj, rfl⟩
  unfold SortsOK at h
  rw [h] at hmem
  have := (List.mergeSort_perm _ _).mem_iff.mp hmem
  obtain ⟨i, hi, e⟩ := List.mem_map.mp this
  rw [← e]; exact hx i (by simpa using hi)

/-- The relaxed model equals the T-machine. -/
theorem relaxed_iff_abs {n : Nat} {p : Program} : RelaxedCorrect n p ↔ ∀ x, AbsOK n p x := by
  constructor
  · intro h x
    let T := bigT x n
    have hx := (bigT_spec x n).2
    have hc := h x T hx
    rw [run_relax_eq_abs p x T hx] at hc
    have hlt := sortsOK_no_T hx hc
    have hsome : ∀ j < n, ((run (absOrd x) p (absInit n)).regs j).isSome := by
      intro j hj
      have := hlt j hj
      simp only [State.map] at this
      cases e : (run (absOrd x) p (absInit n)).regs j with
      | none => rw [e] at this; simp only [interp, T] at this; exact absurd this (Int.lt_irrefl _)
      | some _ => rfl
    refine ⟨hsome, (sortsOK_congr (fun _ _ => rfl) (fun j hj => ?_)).mp hc⟩
    have := hsome j hj
    simp only [State.map]
    cases e : (run (absOrd x) p (absInit n)).regs j with
    | none => rw [e] at this; simp at this
    | some _ => rfl
  · intro h x T hx
    obtain ⟨hsome, hs⟩ := h x
    rw [run_relax_eq_abs p x T hx]
    refine (sortsOK_congr (fun _ _ => rfl) (fun j hj => ?_)).mp hs
    have := hsome j hj
    simp only [State.map]
    cases e : (run (absOrd x) p (absInit n)).regs j with
    | none => rw [e] at this; simp at this
    | some _ => rfl

end SortProof
