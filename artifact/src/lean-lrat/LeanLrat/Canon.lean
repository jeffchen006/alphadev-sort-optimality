import LeanLrat.Sound
/-
  Symmetry breaking "first touch" (= sat's rules canon + pcanon), with proof.
  Rule: inside each register class (inputs P = [0, n), scratch S = [n, ∞)), registers are touched
  for the first time in increasing order; in one instruction the first operand comes first.
  Formally (`Canonical`): at step t, if the first operand x is not the first register of its class
  (x ≠ 0, x ≠ n), then x - 1 was touched before step t; if the second operand y is not the first
  register of its class, then y - 1 was touched before step t or y - 1 is the first operand.

  `canonicalize`: every relaxed-correct snapshot program can be renamed (a permutation of each
  class, so all snapshots, lengths, bounds and opcodes stay) into a `Canonical` one.
-/
namespace LeanLrat
open Std.Sat SortProof

/-! ### First-touch order of a list -/

def ftAux : List Nat → List Nat → List Nat
  | acc, [] => acc
  | acc, x :: l => ftAux (if x ∈ acc then acc else acc ++ [x]) l

/-- The elements of `l` in order of first occurrence. -/
def ft (l : List Nat) : List Nat := ftAux [] l

theorem ftAux_append (acc l r : List Nat) : ftAux acc (l ++ r) = ftAux (ftAux acc l) r := by
  induction l generalizing acc with
  | nil => rfl
  | cons x l ih => exact ih _

theorem ftAux_prefix (acc l : List Nat) : acc <+: ftAux acc l := by
  induction l generalizing acc with
  | nil => exact List.prefix_refl _
  | cons x l ih =>
    simp only [ftAux]
    refine List.IsPrefix.trans ?_ (ih _)
    split
    · exact List.prefix_refl _
    · exact List.prefix_append _ _

theorem mem_ftAux (acc l : List Nat) (x : Nat) : x ∈ ftAux acc l ↔ x ∈ acc ∨ x ∈ l := by
  induction l generalizing acc with
  | nil => simp [ftAux]
  | cons y l ih =>
    simp only [ftAux, ih, List.mem_cons]
    split
    · constructor
      · rintro (h | h)
        · exact Or.inl h
        · exact Or.inr (Or.inr h)
      · rintro (h | rfl | h)
        · exact Or.inl h
        · exact Or.inl (by assumption)
        · exact Or.inr h
    · simp only [List.mem_append, List.mem_singleton]
      constructor
      · rintro ((h | rfl) | h)
        · exact Or.inl h
        · exact Or.inr (Or.inl rfl)
        · exact Or.inr (Or.inr h)
      · rintro (h | rfl | h)
        · exact Or.inl (Or.inl h)
        · exact Or.inl (Or.inr rfl)
        · exact Or.inr h

theorem nodup_ftAux (acc l : List Nat) (h : acc.Nodup) : (ftAux acc l).Nodup := by
  induction l generalizing acc with
  | nil => exact h
  | cons x l ih =>
    simp only [ftAux]
    apply ih
    split
    · exact h
    · rw [List.nodup_append]
      refine ⟨h, List.nodup_cons.mpr ⟨by simp, List.nodup_nil⟩, ?_⟩
      intro a ha b hb
      simp only [List.mem_singleton] at hb
      subst hb
      intro e; subst e; contradiction

theorem ftAux_map (ρ : Nat → Nat) (hρ : ∀ a b, ρ a = ρ b → a = b) (acc l : List Nat) :
    ftAux (acc.map ρ) (l.map ρ) = (ftAux acc l).map ρ := by
  induction l generalizing acc with
  | nil => rfl
  | cons x l ih =>
    simp only [List.map_cons, ftAux]
    have hm : (ρ x ∈ acc.map ρ) ↔ x ∈ acc := by
      constructor
      · intro h
        obtain ⟨y, hy, e⟩ := List.mem_map.mp h
        rw [← hρ _ _ e]; exact hy
      · intro h; exact List.mem_map_of_mem h
    by_cases h : x ∈ acc
    · rw [if_pos (hm.mpr h), if_pos h, ih]
    · rw [if_neg (fun h' => h (hm.mp h')), if_neg h, ← ih]
      simp

theorem ft_snoc (l : List Nat) (x : Nat) :
    ft (l ++ [x]) = if x ∈ l then ft l else ft l ++ [x] := by
  simp only [ft, ftAux_append, ftAux]
  have : x ∈ ftAux [] l ↔ x ∈ l := by simp [mem_ftAux]
  by_cases h : x ∈ l
  · rw [if_pos (this.mpr h), if_pos h]
  · rw [if_neg (fun h' => h (this.mp h')), if_neg h]

theorem mem_ft (l : List Nat) (x : Nat) : x ∈ ft l ↔ x ∈ l := by simp [ft, mem_ftAux]

theorem ft_prefix (l r : List Nat) : ft l <+: ft (l ++ r) := by
  simp only [ft, ftAux_append]; exact ftAux_prefix _ _

theorem ft_nodup (l : List Nat) : (ft l).Nodup := nodup_ftAux _ _ List.nodup_nil

theorem ft_map (ρ : Nat → Nat) (hρ : ∀ a b, ρ a = ρ b → a = b) (l : List Nat) :
    ft (l.map ρ) = (ft l).map ρ := by
  simpa [ft] using ftAux_map ρ hρ [] l

/-! ### Initial segments -/

/-- `[a, a+1, ..., a+m-1]`. -/
def seg (a m : Nat) : List Nat := (List.range m).map (a + ·)

theorem prefix_seg {l : List Nat} {a m : Nat} (h : l <+: seg a m) : l = seg a l.length := by
  have hl := h.length_le
  simp only [seg, List.length_map, List.length_range] at hl
  rw [List.prefix_iff_eq_take.mp h]
  simp [seg, ← List.map_take, List.take_range, Nat.min_eq_left hl]

theorem seg_snoc (a m : Nat) : seg a (m+1) = seg a m ++ [a + m] := by
  simp [seg, List.range_succ]

theorem mem_seg (a m x : Nat) : x ∈ seg a m ↔ a ≤ x ∧ x < a + m := by
  simp only [seg, List.mem_map, List.mem_range]
  constructor
  · rintro ⟨i, hi, rfl⟩; omega
  · intro h; exact ⟨x - a, by omega, by omega⟩

/-- Key step: if the first-touch order of `L`, restricted to class `C`, is an initial segment
  starting at `a`, and `L = L' ++ x :: _` with `x` in the class and `a < x`, then `x - 1 ∈ L'`. -/
theorem canon_step (C : Nat → Bool) (a m : Nat) (L L' R : List Nat) (x : Nat)
    (hL : (ft L).filter C = seg a m) (hsplit : L = L' ++ x :: R) (hx : C x = true) (hax : a < x) :
    x - 1 ∈ L' := by
  -- the filtered first-touch order of any prefix is an initial segment
  have hpre : ∀ l, l <+: L → ∃ m', (ft l).filter C = seg a m' := by
    intro l hl
    obtain ⟨r, rfl⟩ := hl
    have h1 : (ft l).filter C <+: seg a m := by
      rw [← hL]; exact (ft_prefix l r).filter C
    exact ⟨_, prefix_seg h1⟩
  obtain ⟨m1, h1⟩ := hpre L' ⟨x :: R, hsplit.symm⟩
  by_cases hin : x ∈ L'
  · have : x ∈ (ft L').filter C := List.mem_filter.mpr ⟨(mem_ft _ _).mpr hin, hx⟩
    rw [h1, mem_seg] at this
    have : x - 1 ∈ seg a m1 := (mem_seg _ _ _).mpr (by omega)
    rw [← h1] at this
    exact (mem_ft _ _).mp (List.mem_filter.mp this).1
  · obtain ⟨m2, h2⟩ := hpre (L' ++ [x]) ⟨R, by simp [hsplit]⟩
    rw [ft_snoc, if_neg hin, List.filter_append, h1] at h2
    simp only [List.filter_cons, hx, if_true, List.filter_nil] at h2
    -- seg a m1 ++ [x] = seg a m2
    have hlen : m2 = m1 + 1 := by
      have := congrArg List.length h2; simp [seg] at this; omega
    subst hlen
    rw [seg_snoc] at h2
    have hxe : x = a + m1 := by
      have := List.append_inj_right' h2 rfl; simpa using this
    have : x - 1 ∈ seg a m1 := (mem_seg _ _ _).mpr (by omega)
    rw [← h1] at this
    exact (mem_ft _ _).mp (List.mem_filter.mp this).1

/-! ### Registers touched by a program -/

theorem touch_rename (ρ : Nat → Nat) (p : Program) : touch (p.rename ρ) = (touch p).map ρ := by
  induction p with
  | nil => rfl
  | cons i p ih =>
    simp only [Program.rename, List.map_cons, touch, List.flatMap_cons] at *
    rw [ih]
    cases i <;> simp [Instr.rename, dstOf, srcOf]

theorem touch_split (q : Program) (t : Nat) (ht : t < q.length) :
    touch q = touch (q.take t) ++ dstOf q[t] :: srcOf q[t] :: touch (q.drop (t+1)) := by
  have h := List.take_append_drop t q
  have hd : q.drop t = q[t] :: q.drop (t+1) := List.drop_eq_getElem_cons ht
  calc touch q = touch (q.take t ++ q.drop t) := by rw [h]
    _ = _ := by rw [hd]; simp only [touch, List.flatMap_append, List.flatMap_cons]; rfl

/-- If the first-touch order is an initial segment in both classes, the program is canonical. -/
theorem canonical_of_seg (n : Nat) (q : Program) (mP mS : Nat)
    (hP : (ft (touch q)).filter (fun r => decide (r < n)) = seg 0 mP)
    (hS : (ft (touch q)).filter (fun r => decide (n ≤ r)) = seg n mS) : Canonical n q := by
  intro t ht
  have hsp := touch_split q t ht
  constructor
  · intro h0 hn
    by_cases hc : dstOf q[t] < n
    · exact canon_step _ 0 mP _ _ _ _ hP hsp (by simpa using hc) h0
    · exact canon_step _ n mS _ _ _ _ hS hsp (by simp; omega) (by omega)
  · intro h0 hn
    have hsp' : touch q = (touch (q.take t) ++ [dstOf q[t]]) ++ srcOf q[t] :: touch (q.drop (t+1)) := by
      rw [hsp]; simp
    have key : srcOf q[t] - 1 ∈ touch (q.take t) ++ [dstOf q[t]] := by
      by_cases hc : srcOf q[t] < n
      · exact canon_step _ 0 mP _ _ _ _ hP hsp' (by simpa using hc) h0
      · exact canon_step _ n mS _ _ _ _ hS hsp' (by simp; omega) (by omega)
    simp only [List.mem_append, List.mem_singleton] at key
    exact key

/-! ### Renaming by a class-preserving permutation keeps `RelaxedSnap` -/

theorem mergeSort_eq_of_perm {l1 l2 : List Int} (h : l1.Perm l2) :
    l1.mergeSort (fun a b => decide (a ≤ b)) = l2.mergeSort (fun a b => decide (a ≤ b)) := by
  have t1 := List.pairwise_mergeSort (le := fun a b : Int => decide (a ≤ b))
    (fun a b c h1 h2 => by simp at *; omega) (fun a b => by simp; omega) l1
  have t2 := List.pairwise_mergeSort (le := fun a b : Int => decide (a ≤ b))
    (fun a b c h1 h2 => by simp at *; omega) (fun a b => by simp; omega) l2
  exact List.Perm.eq_of_pairwise (fun a b _ _ h1 h2 => by simp at h1 h2; omega) t1 t2
    ((List.mergeSort_perm l1 _).trans (h.trans (List.mergeSort_perm l2 _).symm))

theorem take_rename' (ρ : Nat → Nat) (p : Program) (t : Nat) :
    (p.rename ρ).take t = Program.rename ρ (p.take t) := by
  simp [Program.rename, List.map_take]

section Perm
variable {n : Nat} (ρ σ : Nat → Nat) (h1 : ∀ r, σ (ρ r) = r) (h2 : ∀ r, ρ (σ r) = r)
  (hc : ∀ r, r < n ↔ ρ r < n)

include h1 in
theorem inj_of_inv : ∀ a b, ρ a = ρ b → a = b := fun a b e => by rw [← h1 a, ← h1 b, e]

include h1 h2 hc in
theorem perm_range : ((List.range n).map ρ).Perm (List.range n) := by
  have hnd : ((List.range n).map ρ).Nodup :=
    List.Pairwise.map ρ (fun a b hab e => hab (inj_of_inv ρ σ h1 a b e)) List.nodup_range
  refine (List.perm_ext_iff_of_nodup hnd List.nodup_range).mpr fun a => ?_
  simp only [List.mem_map, List.mem_range]
  constructor
  · rintro ⟨i, hi, rfl⟩; exact (hc i).mp hi
  · intro ha; exact ⟨σ a, (hc (σ a)).mpr (by rw [h2]; exact ha), h2 a⟩

include h1 h2 hc in
theorem relaxed_snap_perm {p : Program} {o : Snap} (h : RelaxedSnap n p o) :
    RelaxedSnap n (p.rename ρ) (fun j => (ρ (o j).1, (o j).2)) := by
  intro x T hx
  let x' : Nat → Int := fun r => x (ρ r)
  have H := h x' T (fun i hi => hx _ ((hc i).mp hi))
  have hout : snapOut (p.rename ρ) (fun j => (ρ (o j).1, (o j).2)) (relaxInit n x T)
      = snapOut p o (relaxInit n x' T) := by
    funext j
    simp only [snapOut]
    rw [take_rename']
    have hsim := run_sim (U := fun _ => True) (ρ := ρ) (p.take (o j).2) (fun _ _ _ _ => trivial)
      (fun _ _ w _ r _ e => inj_of_inv ρ σ h1 w r e) (relaxInit n x T) (relaxInit n x' T)
      ⟨fun r _ => by
        simp only [relaxInit, x']
        by_cases hr : r < n
        · simp [hr, (hc r).mp hr]
        · have : ¬ ρ r < n := fun h' => hr ((hc r).mpr h')
          simp [hr, this], rfl⟩
    exact hsim.1 _ trivial
  rw [hout]
  unfold SortsOK at H ⊢
  rw [H]
  apply mergeSort_eq_of_perm
  have : (List.range n).map x' = ((List.range n).map ρ).map x := by simp [x', List.map_map]
  rw [this]
  exact (perm_range ρ σ h1 h2 hc).map x

end Perm

/-! ### The first-touch permutation of a program -/

section Build
variable (n k : Nat) (p : Program)

/-- All registers `< n + k`, first-touched ones first (in touch order), then the others. -/
def Mall : List Nat := ft (touch p ++ List.range (n + k))
def MP : List Nat := (Mall n k p).filter (fun r => decide (r < n))
def MS : List Nat := (Mall n k p).filter (fun r => decide (n ≤ r))

def ρc (r : Nat) : Nat :=
  if r < n then (MP n k p).idxOf r else if r < n + k then n + (MS n k p).idxOf r else r

def σc (m : Nat) : Nat :=
  if m < n then (MP n k p).getD m 0 else if m < n + k then (MS n k p).getD (m - n) 0 else m

theorem dstOf_mem (i : Instr) : dstOf i ∈ i.regs := by cases i <;> simp [dstOf, Instr.regs]
theorem srcOf_mem (i : Instr) : srcOf i ∈ i.regs := by cases i <;> simp [srcOf, Instr.regs]

variable {n k p} (hWF : p.WF (n + k))
include hWF

theorem touch_lt : ∀ r ∈ touch p, r < n + k := by
  intro r hr
  simp only [touch, List.mem_flatMap, List.mem_cons, List.not_mem_nil, or_false] at hr
  obtain ⟨i, hi, rfl | rfl⟩ := hr
  · exact hWF i hi _ (dstOf_mem i)
  · exact hWF i hi _ (srcOf_mem i)

theorem mem_Mall (r : Nat) : r ∈ Mall n k p ↔ r < n + k := by
  simp only [Mall, mem_ft, List.mem_append, List.mem_range]
  constructor
  · rintro (h | h)
    · exact touch_lt hWF r h
    · exact h
  · exact Or.inr

theorem mem_MP (r : Nat) : r ∈ MP n k p ↔ r < n := by
  simp only [MP, List.mem_filter, mem_Mall hWF, decide_eq_true_eq]
  constructor <;> intro h <;> omega

theorem mem_MS (r : Nat) : r ∈ MS n k p ↔ n ≤ r ∧ r < n + k := by
  simp only [MS, List.mem_filter, mem_Mall hWF, decide_eq_true_eq]
  constructor <;> intro h <;> omega

omit hWF in
theorem nodup_MP : (MP n k p).Nodup := List.Nodup.sublist (List.filter_sublist) (ft_nodup _)
omit hWF in
theorem nodup_MS : (MS n k p).Nodup := List.Nodup.sublist (List.filter_sublist) (ft_nodup _)

theorem len_MP : (MP n k p).length = n := by
  have : (MP n k p).Perm (List.range n) :=
    (List.perm_ext_iff_of_nodup nodup_MP List.nodup_range).mpr (fun a => by simp [mem_MP hWF])
  simpa using this.length_eq

theorem len_MS : (MS n k p).length = k := by
  have : (MS n k p).Perm (List.range' n k) :=
    (List.perm_ext_iff_of_nodup nodup_MS List.nodup_range').mpr
      (fun a => by simp only [mem_MS hWF, List.mem_range'_1])
  simpa using this.length_eq

omit hWF in
theorem getD_of_lt (l : List Nat) (i : Nat) (h : i < l.length) : l.getD i 0 = l[i] := by
  simp [List.getD_eq_getElem?_getD, h]

theorem idxP (r : Nat) (h1 : r < n) :
    (MP n k p).idxOf r < (MP n k p).length ∧ (MP n k p).idxOf r < n := by
  have hl := List.idxOf_lt_length_of_mem ((mem_MP hWF r).mpr h1)
  have := len_MP hWF
  exact ⟨hl, by omega⟩

theorem idxS (r : Nat) (h1 : ¬ r < n) (h2 : r < n + k) :
    (MS n k p).idxOf r < (MS n k p).length ∧ (MS n k p).idxOf r < k := by
  have hl := List.idxOf_lt_length_of_mem ((mem_MS hWF r).mpr ⟨by omega, h2⟩)
  have := len_MS hWF
  exact ⟨hl, by omega⟩

theorem inv1 : ∀ r, σc n k p (ρc n k p r) = r := by
  intro r
  by_cases h1 : r < n
  · obtain ⟨hl, hl'⟩ := idxP hWF r h1
    simp only [ρc, σc, h1, if_true, hl', getD_of_lt _ _ hl]
    exact List.getElem_idxOf hl
  · by_cases h2 : r < n + k
    · obtain ⟨hl, hl'⟩ := idxS hWF r h1 h2
      have e1 : ¬ n + (MS n k p).idxOf r < n := by omega
      have e2 : n + (MS n k p).idxOf r < n + k := by omega
      simp only [ρc, σc, h1, h2, if_false, if_true, e1, e2, Nat.add_sub_cancel_left,
        getD_of_lt _ _ hl]
      exact List.getElem_idxOf hl
    · simp [ρc, σc, h1, h2]

theorem inv2 : ∀ m, ρc n k p (σc n k p m) = m := by
  intro m
  by_cases h1 : m < n
  · have hl : m < (MP n k p).length := by rw [len_MP hWF]; exact h1
    have hmem : (MP n k p)[m] < n := (mem_MP hWF _).mp (List.getElem_mem hl)
    simp only [σc, h1, if_true, getD_of_lt _ _ hl, ρc, hmem]
    exact nodup_MP.idxOf_getElem m hl
  · by_cases h2 : m < n + k
    · have hl : m - n < (MS n k p).length := by rw [len_MS hWF]; omega
      have hmem := (mem_MS hWF _).mp (List.getElem_mem hl)
      have e1 : ¬ (MS n k p)[m - n] < n := by omega
      simp only [σc, h1, h2, if_false, if_true, getD_of_lt _ _ hl, ρc, e1, hmem.2]
      rw [nodup_MS.idxOf_getElem (m - n) hl]; omega
    · simp [ρc, σc, h1, h2]

theorem cls (r : Nat) : r < n ↔ ρc n k p r < n := by
  by_cases h1 : r < n
  · simp only [ρc, h1, if_true, true_iff]; exact (idxP hWF r h1).2
  · by_cases h2 : r < n + k <;> simp [ρc, h1, h2]

theorem cls2 (r : Nat) : r < n + k ↔ ρc n k p r < n + k := by
  by_cases h1 : r < n
  · have := (idxP hWF r h1).2
    simp only [ρc, h1, if_true]; constructor <;> intro <;> omega
  · by_cases h2 : r < n + k
    · have := (idxS hWF r h1 h2).2
      simp only [ρc, h1, h2, if_true, if_false, true_iff]; omega
    · simp [ρc, h1, h2]

theorem map_MP : (MP n k p).map (ρc n k p) = seg 0 n := by
  apply List.ext_getElem
  · simp [seg, len_MP hWF]
  · intro i h h'
    have hl : i < (MP n k p).length := by simpa using h
    have hmem : (MP n k p)[i] < n := (mem_MP hWF _).mp (List.getElem_mem hl)
    simp only [List.getElem_map, ρc, hmem, if_true, seg, List.getElem_range, Nat.zero_add]
    exact nodup_MP.idxOf_getElem i hl

theorem map_MS : (MS n k p).map (ρc n k p) = seg n k := by
  apply List.ext_getElem
  · simp [seg, len_MS hWF]
  · intro i h h'
    have hl : i < (MS n k p).length := by simpa using h
    have hmem := (mem_MS hWF _).mp (List.getElem_mem hl)
    have e1 : ¬ (MS n k p)[i] < n := by omega
    simp only [List.getElem_map, ρc, e1, hmem.2, if_true, if_false, seg, List.getElem_range]
    rw [nodup_MS.idxOf_getElem i hl]

theorem rename_canonical : Canonical n (p.rename (ρc n k p)) := by
  have hinj := inj_of_inv _ _ (inv1 hWF)
  have hft : ft (touch (p.rename (ρc n k p))) = (ft (touch p)).map (ρc n k p) := by
    rw [touch_rename, ft_map _ hinj]
  have hpre : ft (touch p) <+: Mall n k p := ft_prefix _ _
  apply canonical_of_seg n _ ((ft (touch p)).filter (fun r => decide (r < n))).length
    ((ft (touch p)).filter (fun r => decide (n ≤ r))).length
  · rw [hft, List.filter_map]
    have e : ((ft (touch p)).filter ((fun r => decide (r < n)) ∘ ρc n k p))
        = (ft (touch p)).filter (fun r => decide (r < n)) :=
      List.filter_congr (fun r _ => by simp [(cls hWF r).symm])
    rw [e]
    have h1 : ((ft (touch p)).filter (fun r => decide (r < n))).map (ρc n k p) <+: seg 0 n := by
      rw [← map_MP hWF]; exact (hpre.filter _).map _
    rw [prefix_seg h1, List.length_map]
  · rw [hft, List.filter_map]
    have e : ((ft (touch p)).filter ((fun r => decide (n ≤ r)) ∘ ρc n k p))
        = (ft (touch p)).filter (fun r => decide (n ≤ r)) :=
      List.filter_congr (fun r _ => by have := cls hWF r; simp; omega)
    rw [e]
    have h1 : ((ft (touch p)).filter (fun r => decide (n ≤ r))).map (ρc n k p) <+: seg n k := by
      rw [← map_MS hWF]; exact (hpre.filter _).map _
    rw [prefix_seg h1, List.length_map]

end Build

theorem inSet_rename (ρ : Nat → Nat) (iset : Cond → Bool) (i : Instr) :
    (i.rename ρ).inSet iset = i.inSet iset := by
  cases i <;> rfl

/-- Canonical form: every program allowed by the search hypothesis has a canonical renaming
  that is also allowed. -/
theorem canonicalize (n k : Nat) (iset : Cond → Bool) (p : Program) (o : Snap)
    (hlen : p.length = k) (hWF : p.WF (n + k)) (hor : ∀ j, (o j).1 < n + k) (hot : ∀ j, (o j).2 ≤ k)
    (hI : ∀ i ∈ p, i.inSet iset) (h : RelaxedSnap n p o) :
    ∃ (p' : Program) (o' : Snap), p'.length = k ∧ p'.WF (n + k) ∧ (∀ j, (o' j).1 < n + k) ∧
      (∀ j, (o' j).2 ≤ k) ∧ (∀ i ∈ p', i.inSet iset) ∧ RelaxedSnap n p' o' ∧ Canonical n p' := by
  refine ⟨p.rename (ρc n k p), fun j => (ρc n k p (o j).1, (o j).2), by simp [Program.rename, hlen],
    ?_, fun j => (cls2 hWF _).mp (hor j), hot, ?_,
    relaxed_snap_perm _ _ (inv1 hWF) (inv2 hWF) (cls hWF) h, rename_canonical hWF⟩
  · intro i hi r hr
    simp only [Program.rename, List.mem_map] at hi
    obtain ⟨j, hj, rfl⟩ := hi
    cases j <;> simp only [Instr.rename, Instr.regs, List.mem_cons, List.not_mem_nil, or_false] at hr <;>
      rcases hr with rfl | rfl <;> exact (cls2 hWF _).mp (hWF _ hj _ (by simp [Instr.regs]))
  · intro i hi
    simp only [Program.rename, List.mem_map] at hi
    obtain ⟨j, hj, rfl⟩ := hi
    rw [inSet_rename]; exact hI j hj

/-- Soundness, in the form of the hypothesis `H` of `SortProof.lower_bound_chain_snap`:
  if the CNF is unsatisfiable, no program of length exactly `k` on registers `< n + k`, with
  snapshots on registers `< n + k` at positions `≤ k`, opcodes in `isetOf i1`, is relaxed-correct.
  Holds for every list `types` of inputs, with or without the first-touch rule (`canon`). -/
theorem sound (n k : Nat) (i1 canon : Bool) (types : List (List Nat))
    (hU : (encV n k i1 canon types).Unsat) :
    ∀ (p : Program) (o : Snap), p.length = k → Program.WF (n + k) p →
      (∀ j, (o j).1 < n + k) → (∀ j, (o j).2 ≤ k) → (∀ i ∈ p, i.inSet (isetOf i1)) →
      ¬ RelaxedSnap n p o := by
  intro p o hlen hWF hor hot hI h
  obtain ⟨q, o', hlen', hWF', _, hot', hI', hq, hcan⟩ :=
    canonicalize n k (isetOf i1) p o hlen hWF hor hot hI h
  have := hU (asg n types q o')
  rw [sat_of_prog n k i1 canon types false false q o' hlen' hWF' hot' hI' hq (fun _ => hcan) (by simp) (by simp)] at this
  exact Bool.noConfusion this

end LeanLrat
