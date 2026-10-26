import LeanReflect.Basic
/-
  Generic lemmas for the soundness proof (lists, counting, `dc`, `clog2`, column operations).
-/
namespace LeanReflect
open SortProof
set_option linter.unusedSectionVars false
set_option linter.unusedSimpArgs false

/-! ## count after a point update -/

theorem count_map_update {α : Type} [BEq α] [LawfulBEq α] (f : Nat → α) (d : Nat) (v x : α) :
    ∀ (l : List Nat), l.Nodup → d ∈ l →
    (l.map (fun r => if r = d then v else f r)).count x + (if f d == x then 1 else 0)
      = (l.map f).count x + (if v == x then 1 else 0)
  | [], _, h => by simp at h
  | a :: l, hnd, hd => by
    simp only [List.nodup_cons] at hnd
    simp only [List.map_cons, List.count_cons]
    by_cases had : a = d
    · subst had
      have hmap : l.map (fun r => if r = a then v else f r) = l.map f := by
        apply List.map_congr_left
        intro r hr
        have : r ≠ a := fun h => hnd.1 (h ▸ hr)
        simp [this]
      simp only [hmap, if_pos rfl, if_true]
      omega
    · have hd' : d ∈ l := by
        rcases List.mem_cons.1 hd with h | h
        · exact absurd h.symm had
        · exact h
      have ih := count_map_update f d v x l hnd.2 hd'
      simp only [had, if_false]
      omega

theorem count_pos_of_mem {α : Type} [BEq α] [LawfulBEq α] {a : α} {l : List α} (h : a ∈ l) :
    0 < l.count a := List.count_pos_iff.2 h

theorem mem_of_count_pos {α : Type} [BEq α] [LawfulBEq α] {a : α} {l : List α} (h : 0 < l.count a) :
    a ∈ l := List.count_pos_iff.1 h

/-! ## distinct counts -/

section dc
variable {α β : Type} [BEq β] [LawfulBEq β]

theorem dc_cons_le (f : α → β) (a : α) (l : List α) : dc f (a :: l) ≤ dc f l + 1 := by
  simp only [dc]; split <;> omega

theorem dc_le_cons (f : α → β) (a : α) (l : List α) : dc f l ≤ dc f (a :: l) := by
  simp only [dc]; split <;> omega

theorem any_filter_imp (p : α → Bool) (q : α → Bool) (l : List α) :
    (l.filter p).any q = true → l.any q = true := by
  simp only [List.any_eq_true, List.mem_filter]
  rintro ⟨x, ⟨hx, _⟩, hq⟩
  exact ⟨x, hx, hq⟩

theorem dc_filter (f : α → β) (p : α → Bool) :
    ∀ l : List α, dc f l ≤ dc f (l.filter p) + dc f (l.filter fun a => !p a)
  | [] => by simp [dc]
  | a :: l => by
    have ih := dc_filter f p l
    by_cases hpa : p a = true
    · have e1 : (a :: l).filter p = a :: l.filter p := by simp [List.filter_cons, hpa]
      have e2 : ((a :: l).filter fun a => !p a) = l.filter fun a => !p a := by
        simp [List.filter_cons, hpa]
      rw [e1, e2]
      by_cases hA : l.any (fun b => f b == f a) = true
      · have : dc f (a :: l) = dc f l := by simp [dc, hA]
        have := dc_le_cons f a (l.filter p)
        omega
      · have hB : (l.filter p).any (fun b => f b == f a) = false := by
          cases h : (l.filter p).any (fun b => f b == f a)
          · rfl
          · exact absurd (any_filter_imp _ _ _ h) hA
        have : dc f (a :: l) = dc f l + 1 := by simp [dc, hA]
        have : dc f (a :: l.filter p) = dc f (l.filter p) + 1 := by simp [dc, hB]
        omega
    · have e1 : (a :: l).filter p = l.filter p := by simp [List.filter_cons, hpa]
      have e2 : ((a :: l).filter fun a => !p a) = a :: l.filter fun a => !p a := by
        simp [List.filter_cons, hpa]
      rw [e1, e2]
      by_cases hA : l.any (fun b => f b == f a) = true
      · have : dc f (a :: l) = dc f l := by simp [dc, hA]
        have := dc_le_cons f a (l.filter fun a => !p a)
        omega
      · have hB : (l.filter fun a => !p a).any (fun b => f b == f a) = false := by
          cases h : (l.filter fun a => !p a).any (fun b => f b == f a)
          · rfl
          · exact absurd (any_filter_imp _ _ _ h) hA
        have : dc f (a :: l) = dc f l + 1 := by simp [dc, hA]
        have : dc f (a :: l.filter fun a => !p a) = dc f (l.filter fun a => !p a) + 1 := by
          simp [dc, hB]
        omega

theorem dc_mono {γ : Type} [BEq γ] [LawfulBEq γ] (f : α → β) (g : α → γ) :
    ∀ l : List α, (∀ a ∈ l, ∀ b ∈ l, g a = g b → f a = f b) → dc f l ≤ dc g l
  | [], _ => by simp [dc]
  | a :: l, h => by
    have ih := dc_mono f g l (fun x hx y hy => h x (List.mem_cons_of_mem _ hx) y (List.mem_cons_of_mem _ hy))
    by_cases hA : l.any (fun b => g b == g a) = true
    · obtain ⟨b, hb, hgb⟩ := List.any_eq_true.1 hA
      have hfb : f b = f a := h b (List.mem_cons_of_mem _ hb) a (List.mem_cons_self) (by simpa using hgb)
      have hF : l.any (fun b => f b == f a) = true := List.any_eq_true.2 ⟨b, hb, by simp [hfb]⟩
      have : dc f (a :: l) = dc f l := by simp [dc, hF]
      have : dc g (a :: l) = dc g l := by simp [dc, hA]
      omega
    · have : dc g (a :: l) = dc g l + 1 := by simp [dc, hA]
      have := dc_cons_le f a l
      omega

theorem dc_const (f : α → β) : ∀ l : List α, (∀ a ∈ l, ∀ b ∈ l, f a = f b) → dc f l ≤ 1
  | [], _ => by simp [dc]
  | [a], _ => by simp [dc]
  | a :: b :: l, h => by
    have hA : (b :: l).any (fun x => f x == f a) = true :=
      List.any_eq_true.2 ⟨b, List.mem_cons_self, by
        simp [h b (by simp) a (by simp)]⟩
    have : dc f (a :: b :: l) = dc f (b :: l) := by simp only [dc] at *; simp [hA]
    have ih := dc_const f (b :: l) (fun x hx y hy => h x (List.mem_cons_of_mem _ hx) y (List.mem_cons_of_mem _ hy))
    omega
end dc

/-! ## clog2, maxList -/

theorem clog2_le : ∀ (e x : Nat), x ≤ 2 ^ e → clog2 x ≤ e
  | 0, x, h => by
    have : x ≤ 1 := by simpa using h
    unfold clog2; simp [this]
  | e + 1, x, h => by
    unfold clog2
    split
    · omega
    · have hy : (x + 1) / 2 ≤ 2 ^ e := by
        have : 2 ^ (e + 1) = 2 * 2 ^ e := by rw [Nat.pow_succ]; omega
        omega
      have := clog2_le e ((x + 1) / 2) hy
      omega

theorem maxList_le (B : Nat) : ∀ l : List Nat, (∀ x ∈ l, x ≤ B) → maxList l ≤ B
  | [], _ => by simp [maxList]
  | a :: l, h => by
    simp only [maxList]
    have := maxList_le B l (fun x hx => h x (List.mem_cons_of_mem _ hx))
    have := h a List.mem_cons_self
    omega

/-! ## column operations as maps over the tests -/

theorem cmpCol_map {γ : Type} (A B : γ → Int) : ∀ ts : List γ,
    cmpCol (ts.map A) (ts.map B) = ts.map fun w => compare (A w) (B w)
  | [] => rfl
  | w :: ts => by simp [cmpCol, cmpCol_map A B ts]

theorem merge_map {γ : Type} (cd : Cond) (F : γ → Ordering) (A B : γ → Int) : ∀ ts : List γ,
    merge cd (ts.map F) (ts.map A) (ts.map B) = ts.map fun w => if cd.eval (F w) then B w else A w
  | [] => rfl
  | w :: ts => by simp [merge, merge_map cd F A B ts]

/-- The polarity mirror of a condition. -/
def _root_.SortProof.Cond.swap : Cond → Cond
  | .l => .g
  | .g => .l
  | .le => .ge
  | .ge => .le

theorem _root_.SortProof.Cond.eval_swap (cd : Cond) (o : Ordering) : cd.eval o.swap = cd.swap.eval o := by
  cases cd <;> cases o <;> rfl

theorem merge_swap (cd : Cond) : ∀ (f : List Ordering) (a b : Col),
    merge cd (f.map Ordering.swap) a b = merge cd.swap f a b
  | o :: os, x :: xs, y :: ys => by simp [merge, Cond.eval_swap, merge_swap cd os xs ys]
  | [], _, _ => by simp [merge]
  | _ :: _, [], _ => by simp [merge]
  | _ :: _, _ :: _, [] => by simp [merge]

theorem canonF_cases (f : List Ordering) : canonF f = f ∨ canonF f = f.map Ordering.swap := by
  unfold canonF
  split
  · exact Or.inr rfl
  · exact Or.inl rfl

theorem swap_swap_map (f : List Ordering) : (f.map Ordering.swap).map Ordering.swap = f := by
  simp [List.map_map, Function.comp_def, Ordering.swap_swap]

/-! ## fast (array) versions equal the list versions -/

theorem cget_toArray (l : List Int) (i : Nat) : cget l.toArray i = l.getD i 0 := by
  simp [cget, Array.getD, List.getD_eq_getElem?_getD]
  split <;> simp_all

theorem dead_eq (c : Ctx) (k : Key) : dead c k =
    (undone c k).any fun j => (List.range c.m).any fun i => !(k.cols.any fun col => col.getD i 0 == (j : Int)) := by
  simp only [dead, List.any_map, Function.comp_def, cget_toArray]

theorem stateSigA_eq (c : Ctx) (k : Key) (i : Nat) : stateSigA c k (k.cols.map List.toArray) i = stateSig c k i := by
  simp only [stateSigA, stateSig, List.map_map, Function.comp_def, cget_toArray]

theorem coversA_eq (c : Ctx) (F : List Col) (j : Nat) : coversA c (F.map List.toArray) j = covers c F j := by
  simp only [coversA, covers, List.any_map, Function.comp_def, cget_toArray]

theorem combs_map {α β : Type} (f : α → β) : ∀ (s : Nat) (l : List α), combs s (l.map f) = (combs s l).map (List.map f)
  | 0, l => by cases l <;> simp [combs]
  | _ + 1, [] => by simp [combs]
  | s + 1, a :: l => by
    simp only [List.map_cons, combs, List.map_append, List.map_map, combs_map f s l, combs_map f (s + 1) l]
    rfl

end LeanReflect
