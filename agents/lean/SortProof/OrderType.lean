import SortProof.Machine
/-
  Order-type lemma (MODEL.md section 3).
  * `run_map`        : execution commutes with any value map that preserves `ord`.
  * `run_strictMono` : special case, any strictly monotone `f : Int → Int`.
  * `index_pattern`  : two states with the same weak order type on registers `< R` give
                       final states `u ∘ σ`, `v ∘ σ` with the SAME index map `σ`.
  * `sortsOK_transfer` / `correct_transfer` : correctness depends only on the order type.
-/
namespace SortProof

theorem step_map {α β : Type} (ordA : α → α → Ordering) (ordB : β → β → Ordering) (f : α → β)
    (hf : ∀ a b, ordB (f a) (f b) = ordA a b) (s : State α) (i : Instr) :
    step ordB (s.map f) i = (step ordA s i).map f := by
  cases i with
  | mov d src =>
    simp only [step, State.map]; congr 1; funext r; simp only [upd]; split <;> rfl
  | cmp a b => simp only [step, State.map, hf]
  | cmov c d src =>
    simp only [step]
    have : (s.map f).flag = s.flag := rfl
    rw [this]
    split
    · simp only [State.map]; congr 1; funext r; simp only [upd]; split <;> rfl
    · rfl

theorem run_map {α β : Type} (ordA : α → α → Ordering) (ordB : β → β → Ordering) (f : α → β)
    (hf : ∀ a b, ordB (f a) (f b) = ordA a b) (p : Program) (s : State α) :
    run ordB p (s.map f) = (run ordA p s).map f := by
  induction p generalizing s with
  | nil => rfl
  | cons i p ih => simp only [run_cons, step_map ordA ordB f hf, ih]

theorem compare_strictMono (f : Int → Int) (hf : ∀ a b, a < b → f a < f b) (a b : Int) :
    compare (f a) (f b) = compare a b := by
  rcases Int.lt_trichotomy a b with h | h | h
  · rw [Int.compare_eq_lt.mpr h, Int.compare_eq_lt.mpr (hf a b h)]
  · subst h; rw [Int.compare_eq_eq.mpr rfl, Int.compare_eq_eq.mpr rfl]
  · rw [Int.compare_eq_gt.mpr h, Int.compare_eq_gt.mpr (hf b a h)]

/-- Order-type lemma, monotone form: execution commutes with every strictly monotone map. -/
theorem run_strictMono (f : Int → Int) (hf : ∀ a b, a < b → f a < f b) (p : Program)
    (s : State Int) : run compare p (s.map f) = (run compare p s).map f :=
  run_map compare compare f (compare_strictMono f hf) p s

/-! ### Symbolic execution: registers hold indices of initial registers. -/

def oracleOf (v : Nat → Int) : Nat → Nat → Ordering := fun i j => compare (v i) (v j)

def symInit (fl : Ordering) : State Nat := { regs := id, flag := fl }

theorem run_eq_sym (p : Program) (s : State Int) :
    run compare p s = (run (oracleOf s.regs) p (symInit s.flag)).map s.regs := by
  have : s = (symInit s.flag).map s.regs := rfl
  conv => lhs; rw [this]
  exact run_map (oracleOf s.regs) compare s.regs (fun _ _ => rfl) p _

def Bounded (R : Nat) (s : State Nat) : Prop := ∀ r < R, s.regs r < R

theorem step_bounded {R : Nat} {o : Nat → Nat → Ordering} {s : State Nat} {i : Instr}
    (hi : ∀ r ∈ i.regs, r < R) (hs : Bounded R s) : Bounded R (step o s i) := by
  intro r hr
  cases i with
  | mov d src =>
    simp only [step, upd]; split
    · exact hs _ (hi src (by simp [Instr.regs]))
    · exact hs r hr
  | cmp a b => exact hs r hr
  | cmov c d src =>
    simp only [step]; split
    · simp only [upd]; split
      · exact hs _ (hi src (by simp [Instr.regs]))
      · exact hs r hr
    · exact hs r hr

theorem step_congr {R : Nat} {o o' : Nat → Nat → Ordering}
    (ho : ∀ i j, i < R → j < R → o i j = o' i j) {s : State Nat} {i : Instr}
    (hi : ∀ r ∈ i.regs, r < R) (hs : Bounded R s) : step o s i = step o' s i := by
  cases i with
  | cmp a b =>
    simp only [step]
    rw [ho _ _ (hs a (hi a (by simp [Instr.regs]))) (hs b (hi b (by simp [Instr.regs])))]
  | _ => rfl

theorem run_congr {R : Nat} {o o' : Nat → Nat → Ordering}
    (ho : ∀ i j, i < R → j < R → o i j = o' i j) (p : Program) (hp : Program.WF R p)
    (s : State Nat) (hs : Bounded R s) :
    run o p s = run o' p s ∧ Bounded R (run o p s) := by
  induction p generalizing s with
  | nil => exact ⟨rfl, hs⟩
  | cons i p ih =>
    have hi : ∀ r ∈ i.regs, r < R := hp i (by simp)
    have hp' : Program.WF R p := fun j hj => hp j (by simp [hj])
    simp only [run_cons]
    rw [step_congr ho hi hs]
    have := ih hp' (step o' s i) (by rw [← step_congr ho hi hs]; exact step_bounded hi hs)
    exact this

/-- Order-type lemma, index-pattern form. -/
theorem index_pattern {R : Nat} {p : Program} (hp : Program.WF R p) (u v : State Int)
    (hflag : u.flag = v.flag)
    (hord : ∀ i j, i < R → j < R → compare (u.regs i) (u.regs j) = compare (v.regs i) (v.regs j)) :
    ∃ σ : Nat → Nat, (∀ r < R, σ r < R) ∧
      (run compare p u).regs = (fun r => u.regs (σ r)) ∧
      (run compare p v).regs = (fun r => v.regs (σ r)) ∧
      (run compare p u).flag = (run compare p v).flag := by
  have hb : Bounded R (symInit u.flag) := fun r hr => hr
  obtain ⟨heq, hbd⟩ := run_congr (o := oracleOf u.regs) (o' := oracleOf v.regs) hord p hp _ hb
  refine ⟨(run (oracleOf u.regs) p (symInit u.flag)).regs, hbd, ?_, ?_, ?_⟩
  · rw [run_eq_sym]; rfl
  · rw [run_eq_sym, heq, hflag]; rfl
  · rw [run_eq_sym, run_eq_sym, heq, hflag]; rfl

/-! ### Correctness depends only on the order type. -/

theorem decide_le_eq_compare (a b : Int) : decide (a ≤ b) = (compare a b != .gt) := by
  by_cases h : a ≤ b
  · have : compare a b ≠ .gt := fun h' => by have := Int.compare_eq_gt.mp h'; omega
    simp [h, this]
  · have : compare a b = .gt := Int.compare_eq_gt.mpr (by omega)
    simp [h, this]

theorem map_eq_transfer {Q : Nat → Prop} (u v : Nat → Int)
    (huv : ∀ a b, Q a → Q b → (u a = u b ↔ v a = v b)) :
    ∀ (A B : List Nat), (∀ a ∈ A, Q a) → (∀ b ∈ B, Q b) →
      (A.map u = B.map u ↔ A.map v = B.map v)
  | [], [], _, _ => by simp
  | [], _ :: _, _, _ => by simp
  | _ :: _, [], _, _ => by simp
  | a :: A, b :: B, hA, hB => by
    simp only [List.map_cons, List.cons.injEq]
    rw [huv a b (hA a (by simp)) (hB b (by simp)),
      map_eq_transfer u v huv A B (fun x hx => hA x (by simp [hx])) (fun x hx => hB x (by simp [hx]))]

/-- General form: `Q` is a set of registers that contains the inputs and the image of `σ`,
  and `u`, `v` have the same order type on `Q`. -/
theorem sortsOK_transferQ {n : Nat} (Q : Nat → Prop) (hQ : ∀ r < n, Q r) (u v : Nat → Int)
    (σ : Nat → Nat) (hσ : ∀ r < n, Q (σ r))
    (hord : ∀ i j, Q i → Q j → compare (u i) (u j) = compare (v i) (v j)) :
    SortsOK n u (fun r => u (σ r)) ↔ SortsOK n v (fun r => v (σ r)) := by
  let le : Int → Int → Bool := fun a b => decide (a ≤ b)
  let leu : Nat → Nat → Bool := fun i j => le (u i) (u j)
  let lev : Nat → Nat → Bool := fun i j => le (v i) (v j)
  have hmem : ∀ a ∈ List.range n, Q a := fun a ha => hQ a (by simpa using ha)
  have hu : ((List.range n).map u).mergeSort le = ((List.range n).mergeSort leu).map u :=
    (List.map_mergeSort (r := leu) (s := le) (f := u) (l := List.range n)
      (fun _ _ _ _ => rfl)).symm
  have hv : ((List.range n).map v).mergeSort le = ((List.range n).mergeSort lev).map v :=
    (List.map_mergeSort (r := lev) (s := le) (f := v) (l := List.range n)
      (fun _ _ _ _ => rfl)).symm
  have hB : (List.range n).mergeSort leu = (List.range n).mergeSort lev := by
    have := List.map_mergeSort (l := List.range n) (r := leu) (s := lev) (f := id)
      (fun a ha b hb => by
        simp only [leu, lev, le, id, decide_le_eq_compare, hord a b (hmem a ha) (hmem b hb)])
    simpa using this
  unfold SortsOK
  have eu : (List.range n).map (fun r => u (σ r)) = ((List.range n).map σ).map u := by
    simp [List.map_map, Function.comp_def]
  have ev : (List.range n).map (fun r => v (σ r)) = ((List.range n).map σ).map v := by
    simp [List.map_map, Function.comp_def]
  rw [hu, hv, ← hB, eu, ev]
  apply map_eq_transfer (Q := Q) u v
  · intro a b ha hb
    rw [← Int.compare_eq_eq, ← Int.compare_eq_eq, hord a b ha hb]
  · intro a ha
    simp only [List.mem_map] at ha
    obtain ⟨r, hr, rfl⟩ := ha
    exact hσ r (by simpa using hr)
  · intro b hb
    exact hmem b ((List.mergeSort_perm _ _).mem_iff.mp hb)

theorem sortsOK_transfer {n R : Nat} (hn : n ≤ R) (u v : Nat → Int) (σ : Nat → Nat)
    (hσ : ∀ r < R, σ r < R)
    (hord : ∀ i j, i < R → j < R → compare (u i) (u j) = compare (v i) (v j)) :
    SortsOK n u (fun r => u (σ r)) ↔ SortsOK n v (fun r => v (σ r)) :=
  sortsOK_transferQ (fun r => r < R) (fun r hr => by omega) u v σ
    (fun r hr => hσ r (by omega)) hord

/-- Correctness on `u` iff correctness on `v`, if `u`, `v` have the same weak order type on
  the registers `< R` and the same flag state. -/
theorem correct_transfer {n R : Nat} {p : Program} (hp : Program.WF R p) (hn : n ≤ R) (u v : State Int)
    (hflag : u.flag = v.flag)
    (hord : ∀ i j, i < R → j < R → compare (u.regs i) (u.regs j) = compare (v.regs i) (v.regs j)) :
    SortsOK n u.regs (run compare p u).regs ↔ SortsOK n v.regs (run compare p v).regs := by
  obtain ⟨σ, hσ, hu, hv, -⟩ := index_pattern hp u v hflag hord
  rw [hu, hv]
  exact sortsOK_transfer hn u.regs v.regs σ hσ hord

/-- Same, without a register bound: `u`, `v` have the same order type on ALL registers.
  The outputs are read from registers `o 0, ..., o (n-1)` (`o = id` for the §1 model). -/
theorem correct_transfer_allO {n : Nat} (o : Nat → Nat) (p : Program) (u v : State Int)
    (hflag : u.flag = v.flag)
    (hord : ∀ i j, compare (u.regs i) (u.regs j) = compare (v.regs i) (v.regs j)) :
    SortsOK n u.regs (fun j => (run compare p u).regs (o j)) ↔
      SortsOK n v.regs (fun j => (run compare p v).regs (o j)) := by
  have ho : oracleOf u.regs = oracleOf v.regs := by funext i j; exact hord i j
  rw [run_eq_sym p u, run_eq_sym p v, ho, hflag]
  exact sortsOK_transferQ (fun _ => True) (fun _ _ => trivial) u.regs v.regs _
    (fun _ _ => trivial) (fun i j _ _ => hord i j)

theorem correct_transfer_all {n : Nat} (p : Program) (u v : State Int) (hflag : u.flag = v.flag)
    (hord : ∀ i j, compare (u.regs i) (u.regs j) = compare (v.regs i) (v.regs j)) :
    SortsOK n u.regs (run compare p u).regs ↔ SortsOK n v.regs (run compare p v).regs :=
  correct_transfer_allO id p u v hflag hord

theorem sortsOK_congr {n : Nat} {x x' y y' : Nat → Int} (hx : ∀ i < n, x i = x' i)
    (hy : ∀ i < n, y i = y' i) : SortsOK n x y ↔ SortsOK n x' y' := by
  unfold SortsOK
  have e1 : (List.range n).map x = (List.range n).map x' :=
    List.map_congr_left (fun a ha => hx a (by simpa using ha))
  have e2 : (List.range n).map y = (List.range n).map y' :=
    List.map_congr_left (fun a ha => hy a (by simpa using ha))
  rw [e1, e2]

end SortProof
