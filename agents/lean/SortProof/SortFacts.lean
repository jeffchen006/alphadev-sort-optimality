import SortProof.Reps
/-
  Facts about `SortsOK` used by L5.
  * `cnt_eq_countP`   : `cnt x t n` = number of list entries `< t`.
  * `sortsOK_cnt`     : the count of entries `< t` is the same in input and output.
  * `sortsOK_rank_lt` : `#{i : x i < y j} ≤ j`;  `sortsOK_rank_le` : `j < #{i : x i ≤ y j}`.
  * `cnt_ind`         : the count for a vector with one special entry.
-/
namespace SortProof

theorem cnt_eq_countP (x : Nat → Int) (t : Int) (m : Nat) :
    cnt x t m = ((List.range m).map x).countP (fun a => decide (a < t)) := by
  induction m with
  | zero => rfl
  | succ m ih =>
    rw [List.range_succ, List.map_append, List.countP_append, ← ih]
    simp only [cnt, List.map_cons, List.map_nil]
    by_cases h : x m < t <;> simp [h]

theorem sortsOK_sorted {n : Nat} {x y : Nat → Int} (h : SortsOK n x y) :
    ((List.range n).map y).Pairwise (fun a b => a ≤ b) := by
  unfold SortsOK at h
  rw [h]
  exact (List.pairwise_mergeSort (le := fun a b : Int => decide (a ≤ b))
    (fun a b c h1 h2 => by simp at *; omega) (fun a b => by simp; omega) _).imp
    (fun h => by simpa using h)

theorem sortsOK_perm {n : Nat} {x y : Nat → Int} (h : SortsOK n x y) :
    List.Perm ((List.range n).map y) ((List.range n).map x) := by
  unfold SortsOK at h
  rw [h]; exact List.mergeSort_perm _ _

theorem sortsOK_cnt {n : Nat} {x y : Nat → Int} (h : SortsOK n x y) (t : Int) :
    cnt x t n = cnt y t n := by
  rw [cnt_eq_countP, cnt_eq_countP]
  exact ((sortsOK_perm h).countP_eq _).symm

theorem sortsOK_rank_lt {n : Nat} {x y : Nat → Int} (h : SortsOK n x y) {j : Nat} (hj : j < n) :
    cnt x (y j) n ≤ j := by
  rw [sortsOK_cnt h, cnt_eq_countP]
  have hs := sortsOK_sorted h
  generalize hl : (List.range n).map y = l at hs
  have hlen : l.length = n := by rw [← hl]; simp
  have hyj : ∀ (hj' : j < l.length), l[j] = y j := by intro hj'; subst hl; simp
  rw [← List.take_append_drop j l, List.countP_append]
  have h1 : (l.take j).countP (fun a => decide (a < y j)) ≤ j :=
    Nat.le_trans List.countP_le_length (by simp; omega)
  have h2 : (l.drop j).countP (fun a => decide (a < y j)) = 0 := by
    rw [List.countP_eq_zero]
    intro a ha
    obtain ⟨k, hk, rfl⟩ := List.mem_iff_getElem.mp ha
    rw [List.getElem_drop]
    simp only [List.length_drop] at hk
    have hjl : j < l.length := by omega
    rw [← hyj hjl]
    by_cases hk0 : k = 0
    · subst hk0; simp
    · have := List.pairwise_iff_getElem.mp hs j (j + k) hjl (by omega) (by omega)
      simp; omega
  omega

theorem sortsOK_rank_le {n : Nat} {x y : Nat → Int} (h : SortsOK n x y) {j : Nat} (hj : j < n) :
    j < cnt x (y j + 1) n := by
  rw [sortsOK_cnt h, cnt_eq_countP]
  have hs := sortsOK_sorted h
  generalize hl : (List.range n).map y = l at hs
  have hlen : l.length = n := by rw [← hl]; simp
  have hyj : ∀ (hj' : j < l.length), l[j] = y j := by intro hj'; subst hl; simp
  rw [← List.take_append_drop (j + 1) l, List.countP_append]
  have h1 : (l.take (j + 1)).countP (fun a => decide (a < y j + 1)) = j + 1 := by
    have e : (l.take (j + 1)).length = j + 1 := by simp; omega
    suffices H : (l.take (j + 1)).countP (fun a => decide (a < y j + 1)) = (l.take (j + 1)).length by
      rw [H, e]
    apply List.countP_eq_length.mpr
    intro a ha
    obtain ⟨k, hk, rfl⟩ := List.mem_iff_getElem.mp ha
    rw [List.getElem_take]
    simp only [List.length_take] at hk
    have hjl : j < l.length := by omega
    rw [← hyj hjl]
    by_cases hkj : k = j
    · subst hkj; simp; omega
    · have := List.pairwise_iff_getElem.mp hs k j (by omega) hjl (by omega)
      simp; omega
  omega

/-- Count for the vector `x k = if k = i then a else b`. -/
theorem cnt_ind (i : Nat) (a b t : Int) (m : Nat) :
    cnt (fun k => if k = i then a else b) t m =
      (if i < m ∧ a < t then 1 else 0) + (if b < t then (if i < m then m - 1 else m) else 0) := by
  induction m with
  | zero => simp [cnt]
  | succ m ih =>
    simp only [cnt, ih]
    by_cases hm : m = i
    · subst hm
      have : ¬ m < m := Nat.lt_irrefl _
      by_cases ha : a < t <;> by_cases hb : b < t <;> simp [ha, hb, this] <;> omega
    · have hm' : ¬ m = i := hm
      by_cases hi : i < m
      · have : i < m + 1 := by omega
        by_cases ha : a < t <;> by_cases hb : b < t <;> simp [ha, hb, hi, this, hm'] <;> omega
      · have : ¬ i < m + 1 := by omega
        by_cases ha : a < t <;> by_cases hb : b < t <;> simp [ha, hb, hi, this, hm']

end SortProof
