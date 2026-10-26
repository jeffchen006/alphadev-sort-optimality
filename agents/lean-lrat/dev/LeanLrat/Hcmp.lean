import LeanLrat.Normal
/-
  Information bound behind sat's cut `hcmp` part 2 (theory L7 per step), work in progress.
  Types = distinct permutations (rank vectors). `Ag t w w'`: the content runs of types w and w' are
  equal at every time ≤ t. Claim (`class_bound`): for a relaxed-correct program,
  #{w' | Ag t w w'} ≤ 2 ^ (number of cmp in steps ≥ t).
-/
namespace LeanLrat
open Std.Sat SortProof

/-- A rank vector that is a permutation of `0..n-1`. -/
def IsPermRow (n : Nat) (row : List Nat) : Prop :=
  row.length = n ∧ row.Nodup ∧ (∀ v ∈ row, v < n) ∧ (∀ v < n, v ∈ row)

def PermTypes (n : Nat) (types : List (List Nat)) : Prop :=
  types.Nodup ∧ ∀ row ∈ types, IsPermRow n row

/-- Number of cmp steps at positions `≥ t`. -/
def nCmpFrom (q : Program) (t : Nat) : Nat := ((q.drop t).filter Instr.isCmp).length

theorem nCmpFrom_succ (q : Program) (t : Nat) (ht : t < q.length) :
    nCmpFrom q t = (if q[t].isCmp then 1 else 0) + nCmpFrom q (t+1) := by
  simp only [nCmpFrom, List.drop_eq_getElem_cons ht, List.filter_cons]
  split <;> simp <;> omega

section
variable (n : Nat) (types : List (List Nat)) (q : Program)

/-- Types `w`, `w'` have equal content runs up to time `t`. -/
def Ag (t w w' : Nat) : Prop := ∀ t' ≤ t, cs n types q w t' = cs n types q w' t'

theorem cs_le (w : Nat) : ∀ t, t ≤ q.length → ∀ r, (cs n types q w t).regs r ≤ n := by
  intro t
  induction t with
  | zero => intro _ r; simp only [cs_zero, cinit, initC]; split <;> omega
  | succ t ih =>
    intro ht r
    rw [cs_succ n types q w t (by omega), step_regs]
    split
    · exact ih (by omega) _
    · exact ih (by omega) _

end

/-! Lists -/

theorem length_le_one_of_eq {l : List Nat} (hl : l.Nodup) (w : Nat) (h : ∀ x ∈ l, x = w) : l.length ≤ 1 := by
  match l, hl, h with
  | [], _, _ => simp
  | [_], _, _ => simp
  | x :: y :: l, hl, h =>
    exfalso
    have hx := h x (by simp); have hy := h y (by simp)
    have := (List.nodup_cons.mp hl).1
    exact this (by rw [hx, ← hy]; simp)

theorem countP_le_add {α : Type} (l : List α) (P P1 P2 : α → Bool)
    (h : ∀ x ∈ l, P x = true → P1 x = true ∨ P2 x = true) :
    l.countP P ≤ l.countP P1 + l.countP P2 := by
  induction l with
  | nil => simp
  | cons x l ih =>
    simp only [List.countP_cons]
    have ih' := ih (fun y hy => h y (by simp [hy]))
    have hx := h x (by simp)
    cases hp : P x <;> cases hp1 : P1 x <;> cases hp2 : P2 x <;> simp [hp, hp1, hp2] at hx ⊢ <;> omega

/-! Permutation rows -/

section PermRow
variable {n : Nat} {row : List Nat} (hp : IsPermRow n row)
include hp

theorem xOf_perm (c : Nat) (hc : c < n) : xOf n row c = row[c]'(by rw [hp.1]; exact hc) := by
  have hl : c < row.length := by rw [hp.1]; exact hc
  have hv := hp.2.2.1 _ (List.getElem_mem hl)
  simp only [xOf, List.getD_eq_getElem?_getD, List.getElem?_eq_getElem hl, Option.getD_some]
  exact Nat.mod_eq_of_lt hv

theorem rkC_inj (c c' : Nat) (hc : c ≤ n) (hc' : c' ≤ n) (h : rkC n row c = rkC n row c') : c = c' := by
  simp only [rkC] at h
  by_cases h1 : c < n <;> by_cases h2 : c' < n <;> simp only [h1, h2, if_true, if_false] at h
  · rw [xOf_perm hp c h1, xOf_perm hp c' h2] at h
    have hl : c < row.length := by rw [hp.1]; exact h1
    have hl' : c' < row.length := by rw [hp.1]; exact h2
    exact (List.getElem?_inj hl hp.2.1).mp (by rw [List.getElem?_eq_getElem hl, List.getElem?_eq_getElem hl', h])
  · have := xOf_lt n row c h1; omega
  · have := xOf_lt n row c' h2; omega
  · omega

theorem sorted_perm (j : Nat) (hj : j < n) : (sortedInt n row).getD j 0 = (j : Int) := by
  have hmap : (List.range n).map (fun i => (xOf n row i : Int)) = row.map (fun v : Nat => (v : Int)) := by
    apply List.ext_getElem
    · simp [hp.1]
    · intro i h1 h2
      simp only [List.getElem_map, List.getElem_range]
      rw [xOf_perm hp i (by simpa using h1)]
  have hperm : (row.map (fun v : Nat => (v : Int))).Perm ((List.range n).map (fun v : Nat => (v : Int))) := by
    apply List.Perm.map
    refine (List.perm_ext_iff_of_nodup hp.2.1 List.nodup_range).mpr fun a => ?_
    simp only [List.mem_range]
    exact ⟨hp.2.2.1 a, hp.2.2.2 a⟩
  have hs : sortedInt n row = (List.range n).map (fun v : Nat => (v : Int)) := by
    simp only [sortedInt, hmap]
    have t1 := List.pairwise_mergeSort (le := fun a b : Int => decide (a ≤ b))
      (fun a b c h1 h2 => by simp at *; omega) (fun a b => by simp; omega) (row.map (fun v : Nat => (v : Int)))
    have t2 : ((List.range n).map (fun v : Nat => (v : Int))).Pairwise (fun a b => decide (a ≤ b) = true) := by
      rw [List.pairwise_map]
      exact (List.pairwise_lt_range).imp (fun h => by simp; omega)
    exact List.Perm.eq_of_pairwise (fun a b _ _ h1 h2 => by simp at h1 h2; omega) t1 t2
      ((List.mergeSort_perm _ _).trans hperm)
  rw [hs]; simp [List.getD_eq_getElem?_getD, hj]

end PermRow

/-! The class bound -/

section Bound
variable (n k : Nat) (types : List (List Nat)) (q : Program) (o : Snap)
  (hperm : PermTypes n types) (hlen : q.length = k) (hot : ∀ j, (o j).2 ≤ k) (hcorr : RelaxedSnap n q o)

include hperm in
theorem row_perm (w : Nat) (hw : w < types.length) : IsPermRow n (types.getD w []) := by
  rw [List.getD_eq_getElem?_getD, List.getElem?_eq_getElem hw, Option.getD_some]
  exact hperm.2 _ (List.getElem_mem hw)

include hperm hlen hot hcorr in
/-- Types that agree on the whole run are equal. -/
theorem ag_final (w w' : Nat) (hw : w < types.length) (hw' : w' < types.length)
    (hA : Ag n types q k w w') : w = w' := by
  have pA := row_perm n types hperm w hw
  have pB := row_perm n types hperm w' hw'
  -- output contents
  have key : ∀ j < n, ∃ c, c < n ∧ xOf n (types.getD w []) c = j ∧ xOf n (types.getD w' []) c = j := by
    intro j hj
    have g1 := out_good n types q o hcorr w j hj
    have g2 := out_good n types q o hcorr w' j hj
    rw [← hA _ (hot j)] at g2
    simp only [good, List.mem_filter, List.mem_range, decide_eq_true_eq] at g1 g2
    rw [sorted_perm pA j hj] at g1
    rw [sorted_perm pB j hj] at g2
    exact ⟨_, g1.1, by exact_mod_cast g1.2, by exact_mod_cast g2.2⟩
  have hrow : types.getD w [] = types.getD w' [] := by
    apply List.ext_getElem
    · rw [pA.1, pB.1]
    · intro i h1 h2
      have hi : i < n := by rw [← pA.1]; exact h1
      have hv := pA.2.2.1 _ (List.getElem_mem h1)
      obtain ⟨c, hc, e1, e2⟩ := key _ hv
      have : c = i := by
        apply rkC_inj pA c i (by omega) (by omega)
        simp only [rkC, hc, hi, if_true, e1, xOf_perm pA i hi]
      subst this
      rw [← xOf_perm pB c hi, e2]
  rw [List.getD_eq_getElem?_getD, List.getElem?_eq_getElem hw, List.getD_eq_getElem?_getD,
    List.getElem?_eq_getElem hw'] at hrow
  simp only [Option.getD_some] at hrow
  exact (List.getElem?_inj hw hperm.1).mp (by rw [List.getElem?_eq_getElem hw, List.getElem?_eq_getElem hw', hrow])

theorem ag_symm {t w w' : Nat} (h : Ag n types q t w w') : Ag n types q t w' w := fun t' ht => (h t' ht).symm
theorem ag_trans {t a b c : Nat} (h1 : Ag n types q t a b) (h2 : Ag n types q t b c) : Ag n types q t a c :=
  fun t' ht => (h1 t' ht).trans (h2 t' ht)

include hlen in
theorem ag_succ_nocmp (t x y : Nat) (ht : t < k) (hc : (ins q t).isCmp = false)
    (h : Ag n types q t x y) : Ag n types q (t+1) x y := by
  intro t' ht'
  by_cases e : t' ≤ t
  · exact h t' e
  · have : t' = t + 1 := by omega
    subst this
    rw [cs_succ n types q x t (by omega), cs_succ n types q y t (by omega), h t (Nat.le_refl _)]
    exact step_nocmp _ _ _ _ hc

include hlen in
theorem ag_succ_cmp (t x y : Nat) (ht : t < k) (hc : (ins q t).isCmp = true)
    (h : Ag n types q t x y) (hf : (cs n types q x (t+1)).flag = (cs n types q y (t+1)).flag) :
    Ag n types q (t+1) x y := by
  intro t' ht'
  by_cases e : t' ≤ t
  · exact h t' e
  · have : t' = t + 1 := by omega
    subst this
    have hr : (cs n types q x (t+1)).regs = (cs n types q y (t+1)).regs := by
      rw [cs_succ n types q x t (by omega), cs_succ n types q y t (by omega)]
      funext r
      rw [step_regs, step_regs, h t (Nat.le_refl _)]
    cases hx : cs n types q x (t+1); cases hy : cs n types q y (t+1)
    rw [hx, hy] at hr hf
    simp_all

open Classical in
/-- Number of types that agree with `w` up to time `t`. -/
noncomputable def classSize (t w : Nat) : Nat :=
  (List.range types.length).countP (fun w' => decide (Ag n types q t w w'))

theorem cmp_flag (t x : Nat) (ht : t < q.length) (hc : (ins q t).isCmp = true) :
    (cs n types q x (t+1)).flag = ordC n types x ((cs n types q x t).regs (dstOf (ins q t)))
      ((cs n types q x t).regs (srcOf (ins q t))) := by
  rw [cs_succ n types q x t ht, step_flag, if_pos (op1_of_isCmp _ hc)]

include hperm hlen in
/-- After a cmp, the flag of a class member is `eq` iff the two compared contents are equal. -/
theorem flag_class (t w y : Nat) (ht : t < k) (hc : (ins q t).isCmp = true) (hy : y < types.length)
    (h : Ag n types q t w y) :
    (cs n types q y (t+1)).flag = .eq ↔
      (cs n types q w t).regs (dstOf (ins q t)) = (cs n types q w t).regs (srcOf (ins q t)) := by
  rw [cmp_flag n types q t y (by omega) hc, ← h t (Nat.le_refl _)]
  have pY := row_perm n types hperm y hy
  have l1 := cs_le n types q w t (by omega) (dstOf (ins q t))
  have l2 := cs_le n types q w t (by omega) (srcOf (ins q t))
  simp only [ordC, fC]
  rw [Int.compare_eq_eq]
  constructor
  · intro e; exact rkC_inj pY _ _ l1 l2 (by exact_mod_cast e)
  · intro e; rw [e]

open Classical in
include hperm hlen hot hcorr in
theorem class_bound : ∀ d t, t + d = k → ∀ w < types.length,
    classSize n types q t w ≤ 2 ^ nCmpFrom q t := by
  intro d
  induction d with
  | zero =>
    intro t ht w hw
    have htk : t = k := by omega
    subst htk
    have hz : nCmpFrom q t = 0 := by simp [nCmpFrom, ← hlen]
    rw [hz, classSize, List.countP_eq_length_filter]
    apply length_le_one_of_eq (List.Nodup.sublist List.filter_sublist List.nodup_range) w
    intro x hx
    simp only [List.mem_filter, List.mem_range, decide_eq_true_eq] at hx
    exact (ag_final n t types q o hperm hlen hot hcorr w x hw hx.1 hx.2).symm
  | succ d ih =>
    intro t ht w hw
    have htk : t < k := by omega
    have htq : t < q.length := by omega
    have hs := nCmpFrom_succ q t htq
    rw [← ins_eq q t htq] at hs
    have ih1 := ih (t+1) (by omega)
    by_cases hc : (ins q t).isCmp = true
    · rw [hs, if_pos hc]
      -- the two outcome classes
      by_cases hw2 : ∃ w2 < types.length, Ag n types q t w w2 ∧
          (cs n types q w2 (t+1)).flag ≠ (cs n types q w (t+1)).flag
      · obtain ⟨w2, hw2l, hA2, hf2⟩ := hw2
        have hsplit := countP_le_add (List.range types.length) (fun w' => decide (Ag n types q t w w'))
          (fun w' => decide (Ag n types q (t+1) w w')) (fun w' => decide (Ag n types q (t+1) w2 w'))
          (by
            intro x hxm hx
            have hxl : x < types.length := List.mem_range.mp hxm
            simp only [decide_eq_true_eq] at hx ⊢
            have fw := flag_class n k types q hperm hlen t w w htk hc hw (fun _ _ => rfl)
            have fw2 := flag_class n k types q hperm hlen t w w2 htk hc hw2l hA2
            have fx := flag_class n k types q hperm hlen t w x htk hc hxl hx
            by_cases ec : (cs n types q w t).regs (dstOf (ins q t)) = (cs n types q w t).regs (srcOf (ins q t))
            · exact absurd ((fw2.mpr ec).trans (fw.mpr ec).symm) hf2
            · have n1 : (cs n types q w (t+1)).flag ≠ .eq := fun e => ec (fw.mp e)
              have n2 : (cs n types q w2 (t+1)).flag ≠ .eq := fun e => ec (fw2.mp e)
              have n3 : (cs n types q x (t+1)).flag ≠ .eq := fun e => ec (fx.mp e)
              by_cases e1 : (cs n types q w (t+1)).flag = (cs n types q x (t+1)).flag
              · exact Or.inl (ag_succ_cmp n k types q hlen t w x htk hc hx e1)
              · right
                apply ag_succ_cmp n k types q hlen t w2 x htk hc
                  (ag_trans n types q (ag_symm n types q hA2) hx)
                revert n1 n2 n3 e1 hf2
                cases (cs n types q w (t+1)).flag <;> cases (cs n types q w2 (t+1)).flag <;>
                  cases (cs n types q x (t+1)).flag <;> simp)
        have b1 := ih1 w hw
        have b2 := ih1 w2 hw2l
        have := Nat.le_trans hsplit (Nat.add_le_add b1 b2)
        refine Nat.le_trans this ?_
        rw [Nat.add_comm 1, Nat.pow_succ]; omega
      · have hsub := countP_le_add (List.range types.length) (fun w' => decide (Ag n types q t w w'))
          (fun w' => decide (Ag n types q (t+1) w w')) (fun _ => false)
          (by
            intro x hxm hx
            simp only [decide_eq_true_eq] at hx ⊢
            left
            apply ag_succ_cmp n k types q hlen t w x htk hc hx
            exact Classical.byContradiction fun hne =>
              hw2 ⟨x, List.mem_range.mp hxm, hx, fun e => hne e.symm⟩)
        have b1 : (List.range types.length).countP (fun w' => decide (Ag n types q (t+1) w w')) ≤
            2 ^ nCmpFrom q (t+1) := ih1 w hw
        have hz : (List.range types.length).countP (fun _ : Nat => false) = 0 :=
          List.countP_eq_zero.mpr (by simp)
        show (List.range types.length).countP (fun w' => decide (Ag n types q t w w')) ≤ _
        rw [Nat.add_comm 1, Nat.pow_succ]; omega
    · have hc' : (ins q t).isCmp = false := by simpa using hc
      rw [hs, if_neg hc]
      have hsub := countP_le_add (List.range types.length) (fun w' => decide (Ag n types q t w w'))
        (fun w' => decide (Ag n types q (t+1) w w')) (fun _ => false)
        (by
          intro x _ hx
          simp only [decide_eq_true_eq] at hx ⊢
          exact Or.inl (ag_succ_nocmp n k types q hlen t w x htk hc' hx))
      have b1 : (List.range types.length).countP (fun w' => decide (Ag n types q (t+1) w w')) ≤
          2 ^ nCmpFrom q (t+1) := ih1 w hw
      have hz : (List.range types.length).countP (fun _ : Nat => false) = 0 :=
        List.countP_eq_zero.mpr (by simp)
      show (List.range types.length).countP (fun w' => decide (Ag n types q t w w')) ≤ _
      simp only [Nat.zero_add]; omega

end Bound

/-! ### The hcmp clauses hold -/

theorem ag_iff (n : Nat) (types : List (List Nat)) (q : Program) (t w w' : Nat) :
    (∀ t' ≤ t, cs n types q w t' = cs n types q w' t') ↔ Ag n types q t w w' := Iff.rfl

theorem regs_succ_eq (n : Nat) (types : List (List Nat)) (q : Program) (t w w' : Nat) (ht : t < q.length)
    (h : cs n types q w t = cs n types q w' t) :
    (cs n types q w (t+1)).regs = (cs n types q w' (t+1)).regs := by
  rw [cs_succ n types q w t ht, cs_succ n types q w' t ht]
  funext r; rw [step_regs, step_regs, h]

theorem ordering_eq_of (a b : Ordering) (h1 : (a == .lt) = (b == .lt)) (h2 : (a == .gt) = (b == .gt)) : a = b := by
  cases a <;> cases b <;> simp_all

open Classical in
theorem classSize_eq (n : Nat) (types : List (List Nat)) (q : Program) (t w i : Nat) :
    (List.range i).countP (fun w' => decide (∀ t' ≤ t, cs n types q w t' = cs n types q w' t')) =
    (List.range i).countP (fun w' => decide (Ag n types q t w w')) := by
  apply List.countP_congr; intro x _; simp only [decide_eq_true_eq]; rfl

open Classical in
theorem hcmpCls_sat (n k : Nat) (types : List (List Nat)) (q : Program) (o : Snap)
    (hperm : PermTypes n types) (hlen : q.length = k) (hot : ∀ j, (o j).2 ≤ k) (hcorr : RelaxedSnap n q o) :
    ∀ c ∈ hcmpCls k types.length, CNF.Clause.eval (asg n types q o) c = true := by
  intro c hc
  simp only [hcmpCls, List.mem_append, List.mem_flatMap, List.mem_map, List.mem_range, List.mem_cons,
    List.mem_filter, List.not_mem_nil, or_false] at hc
  rcases hc with (((((⟨w, _, w', _, rfl⟩ | ⟨t, ht, w, _, w', _, a, _, b, _, rfl⟩) | ⟨t, ht, w, _, hc⟩) |
    ⟨t, _, rfl⟩) | ⟨cc, _, rfl⟩) | ⟨t, ht, cc, _, hc⟩) | ⟨t, ht, w, hw, m, ⟨_, hm⟩, rfl⟩
  · -- agreement at time 0
    simp only [CNF.Clause.eval, List.any_cons, List.any_nil, pos, asg, Bool.or_false]
    simp only [beq_true, decide_eq_true_eq]
    intro t' ht'
    have : t' = 0 := by omega
    subst this; simp [cs_zero]
  · -- agreement step
    apply eval_of_not; intro hall
    simp only [List.forall_mem_cons, List.not_mem_nil, false_implies, implies_true, forall_const,
      pos, neg, asg, Bool.not_true, Bool.not_false, and_true, Bool.not_not, decide_eq_true_eq,
      decide_eq_false_iff_not] at hall
    obtain ⟨hA, h1, h2, h3, h4, hB⟩ := hall
    apply hB
    intro t' ht'
    by_cases e : t' ≤ t
    · exact hA t' e
    · have : t' = t + 1 := by omega
      subst this
      have hr := regs_succ_eq n types q t w w' (by omega) (hA t (Nat.le_refl _))
      have hf : (cs n types q w (t+1)).flag = (cs n types q w' (t+1)).flag := by
        revert h1 h2 h3 h4
        cases (cs n types q w (t+1)).flag <;> cases (cs n types q w' (t+1)).flag <;> cases a <;> cases b <;>
          simp
      cases hx : cs n types q w (t+1); cases hy : cs n types q w' (t+1)
      rw [hx, hy] at hr hf; simp_all
  · -- class counters
    have hcs : ∀ i, (List.range (i+1)).countP (fun w' => decide (∀ t' ≤ t, cs n types q w t' = cs n types q w' t'))
        = (List.range i).countP (fun w' => decide (∀ t' ≤ t, cs n types q w t' = cs n types q w' t')) +
          (if (∀ t' ≤ t, cs n types q w t' = cs n types q i t') then 1 else 0) := by
      intro i; rw [List.range_succ, List.countP_append]; simp
    rcases hc with rfl | ⟨i, _, c', _, hc⟩
    · simp [CNF.Clause.eval, pos, asg]
    · rcases hc with rfl | hc
      · apply eval_of_not; intro hall
        simp only [List.forall_mem_cons, List.not_mem_nil, false_implies, implies_true, forall_const,
          pos, neg, asg, Bool.not_true, Bool.not_false, and_true, decide_eq_true_eq,
          decide_eq_false_iff_not] at hall
        rw [hcs] at hall; omega
      · split at hc
        · simp only [List.mem_singleton] at hc; subst hc
          apply eval_of_not; intro hall
          simp only [List.forall_mem_cons, List.not_mem_nil, false_implies, implies_true, forall_const,
            pos, neg, asg, Bool.not_true, Bool.not_false, and_true, decide_eq_true_eq,
            decide_eq_false_iff_not] at hall
          obtain ⟨h1, h2, h3⟩ := hall
          rw [hcs, if_pos h2] at h3; omega
        · simp at hc
  · simp [CNF.Clause.eval, pos, asg]
  · -- gc k (c+1) false
    simp [CNF.Clause.eval, neg, asg, nCmpFrom, ← hlen]
  · -- cmp suffix counters
    have htq : t < q.length := by omega
    have hn := nCmpFrom_succ q t htq
    rw [← ins_eq q t htq] at hn
    have hg : ∀ t' c', asg n types q o (.gc t' c') = decide (c' ≤ nCmpFrom q t') := fun _ _ => rfl
    rcases hc with rfl | rfl
    · apply eval_of_not; intro hall
      simp only [List.forall_mem_cons, List.not_mem_nil, false_implies, implies_true, forall_const,
        pos, neg, hg, Bool.not_true, Bool.not_false, and_true, decide_eq_true_eq,
        decide_eq_false_iff_not] at hall
      obtain ⟨h1, h2, h3⟩ := hall
      simp only [asg, beq_eq_false_iff_ne] at h2
      rw [hn, if_neg (fun h' => h2 (op1_of_isCmp _ h'))] at h1; omega
    · apply eval_of_not; intro hall
      simp only [List.forall_mem_cons, List.not_mem_nil, false_implies, implies_true, forall_const,
        pos, neg, hg, Bool.not_true, Bool.not_false, and_true, decide_eq_true_eq,
        decide_eq_false_iff_not] at hall
      obtain ⟨h1, h2, h3⟩ := hall
      rw [hn] at h1; split at h1 <;> omega
  · -- the cut
    apply eval_of_not; intro hall
    simp only [List.forall_mem_cons, List.not_mem_nil, false_implies, implies_true, forall_const,
      pos, neg, asg, Bool.not_true, Bool.not_false, and_true, decide_eq_true_eq,
      decide_eq_false_iff_not] at hall
    obtain ⟨h1, h2⟩ := hall
    rw [classSize_eq] at h1
    have hb := class_bound n k types q o hperm hlen hot hcorr (k - t) t (by omega) w hw
    have hle : 2 ^ nCmpFrom q t ≤ 2 ^ m := Nat.pow_le_pow_right (by omega) (by simp [nCmpFrom] at h2 ⊢; omega)
    simp only [classSize] at hb
    omega

end LeanLrat
