import LeanReflect.PlaneBits
import LeanReflect.PlaneHc
import LeanReflect.SymSound
/-
  The fast plane checker computes the list spec after decoding: `normP`, `keyLtP`, `canonP` (this part).
-/
namespace LeanReflect.FP
open SortProof LeanReflect
set_option linter.unusedSectionVars false
set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

/-! ## sorted permutations are unique -/

theorem eq_of_perm_pairwise {α : Type} (le : α → α → Bool) (P : α → Prop)
    (hanti : ∀ a b, P a → P b → le a b = true → le b a = true → a = b) :
    ∀ {l1 l2 : List α}, l1.Perm l2 → (∀ x ∈ l1, P x) → l1.Pairwise (fun a b => le a b = true) →
      l2.Pairwise (fun a b => le a b = true) → l1 = l2
  | [], l2, hp, _, _, _ => List.Perm.nil_eq hp
  | a :: t1, [], hp, _, _, _ => absurd (List.Perm.nil_eq hp.symm) (by simp)
  | a :: t1, b :: t2, hp, hP, h1, h2 => by
    by_cases e : a = b
    · subst e
      rw [eq_of_perm_pairwise le P hanti (List.Perm.cons_inv hp) (fun x hx => hP x (List.mem_cons_of_mem _ hx))
        (List.pairwise_cons.1 h1).2 (List.pairwise_cons.1 h2).2]
    · exfalso
      have hb1 : b ∈ t1 := by
        rcases List.mem_cons.1 (hp.symm.subset List.mem_cons_self) with h | h
        · exact absurd h.symm e
        · exact h
      have ha2 : a ∈ t2 := by
        rcases List.mem_cons.1 (hp.subset List.mem_cons_self) with h | h
        · exact absurd h e
        · exact h
      exact e (hanti a b (hP a List.mem_cons_self) (hP b (List.mem_cons_of_mem _ hb1))
        ((List.pairwise_cons.1 h1).1 b hb1) ((List.pairwise_cons.1 h2).1 a ha2))

/-! ## insertion sort -/

theorem perm_insertP (x : PCol) : ∀ l : List PCol, (insertP x l).Perm (x :: l)
  | [] => List.Perm.refl _
  | y :: ys => by
    simp only [insertP]; split
    · exact ((perm_insertP x ys).cons y).trans (List.Perm.swap x y ys)
    · exact List.Perm.refl _

theorem perm_sortP : ∀ l : List PCol, (sortP l).Perm l
  | [] => List.Perm.refl _
  | x :: xs => (perm_insertP x (sortP xs)).trans ((perm_sortP xs).cons x)

def leP (a b : PCol) : Bool := decide (numP a ≤ numP b)

theorem sorted_insertP (x : PCol) : ∀ l : List PCol, l.Pairwise (fun a b => leP a b = true) →
    (insertP x l).Pairwise (fun a b => leP a b = true)
  | [], _ => by simp [insertP]
  | y :: ys, h => by
    simp only [insertP]
    split
    · rename_i hyx
      rw [pLt_iff] at hyx
      have hyx' : numP y < numP x := of_decide_eq_true hyx
      refine List.pairwise_cons.2 ⟨fun z hz => ?_, sorted_insertP x ys (List.pairwise_cons.1 h).2⟩
      rcases List.mem_cons.1 ((perm_insertP x ys).subset hz) with e | e
      · subst e; simp [leP]; omega
      · exact (List.pairwise_cons.1 h).1 z e
    · rename_i hyx
      rw [pLt_iff] at hyx
      have hxy : numP x ≤ numP y := by simp at hyx; omega
      refine List.pairwise_cons.2 ⟨fun z hz => ?_, h⟩
      rcases List.mem_cons.1 hz with e | e
      · subst e; simp [leP, hxy]
      · have := (List.pairwise_cons.1 h).1 z e; simp [leP] at this ⊢; omega

theorem sorted_sortP : ∀ l : List PCol, (sortP l).Pairwise (fun a b => leP a b = true)
  | [] => by simp [sortP]
  | x :: xs => sorted_insertP x _ (sorted_sortP xs)

theorem numP_inj {p q : PCol} (h : numP p = numP q) : p = q := by
  cases p with | mk plo phi => cases q with | mk qlo qhi =>
  simp only [numP] at h
  have h1 := plo.toNat_lt; have h2 := qlo.toNat_lt
  have ehi : phi.toNat = qhi.toNat := by
    have : phi.toNat * 2 ^ 64 + plo.toNat = qhi.toNat * 2 ^ 64 + qlo.toNat := h
    omega
  have elo : plo.toNat = qlo.toNat := by omega
  rw [UInt64.toNat_inj.1 ehi, UInt64.toNat_inj.1 elo]

section
variable {f : FC} (hf : FCOK f) (hcx : CtxOK f.c)
include hf

theorem decode_sortP (cols : List PCol) (hw : ∀ p ∈ cols, WFcol f.c p) :
    (sortP cols).map (decodeCol f.c) = (cols.map (decodeCol f.c)).mergeSort (colLeP f.c) := by
  apply eq_of_perm_pairwise (colLeP f.c) (fun x => ∃ p ∈ cols, WFcol f.c p ∧ x = decodeCol f.c p)
  · rintro a b ⟨p, hp, hpw, rfl⟩ ⟨q, hq, hqw, rfl⟩ h1 h2
    simp only [colLeP, decide_eq_true_eq, colNum_decode hf p hpw, colNum_decode hf q hqw] at h1 h2
    rw [numP_inj (by omega : numP p = numP q)]
  · exact ((perm_sortP cols).map _).trans (List.mergeSort_perm _ _).symm
  · intro x hx
    obtain ⟨p, hp, rfl⟩ := List.mem_map.1 hx
    exact ⟨p, (perm_sortP cols).subset hp, hw p ((perm_sortP cols).subset hp), rfl⟩
  · rw [List.pairwise_map]
    apply (sorted_sortP cols).imp_of_mem
    intro a b ha hb hab
    have hwa := hw a ((perm_sortP cols).subset ha)
    have hwb := hw b ((perm_sortP cols).subset hb)
    simp only [colLeP, leP, decide_eq_true_eq] at hab ⊢
    rw [colNum_decode hf a hwa, colNum_decode hf b hwb]; exact hab
  · apply List.pairwise_mergeSort
    · intro a b c' h1 h2; simp only [colLeP, decide_eq_true_eq] at *; omega
    · intro a b; simp only [colLeP, Bool.or_eq_true, decide_eq_true_eq]; omega

theorem mem_map_decode {cols : List PCol} (hw : ∀ p ∈ cols, WFcol f.c p) {t : PCol} (ht : WFcol f.c t) :
    (cols.map (decodeCol f.c)).contains (decodeCol f.c t) = cols.contains t := by
  cases h1 : cols.contains t <;> cases h2 : (cols.map (decodeCol f.c)).contains (decodeCol f.c t) <;> try rfl
  · exfalso
    obtain ⟨p, hp, e⟩ := List.mem_map.1 (List.contains_iff_mem.1 h2)
    have := decodeCol_inj hf (hw p hp) ht e
    subst this
    rw [List.contains_iff_mem.2 hp] at h1; exact absurd h1 (by decide)
  · exfalso
    have := List.mem_map_of_mem (f := decodeCol f.c) (List.contains_iff_mem.1 h1)
    rw [List.contains_iff_mem.2 this] at h2; exact absurd h2 (by decide)

include hcx in
theorem tc_decode (j : Nat) (hj : j < f.c.n) : f.c.tc.getD j [] = decodeCol f.c (f.tc.getD j default) := by
  have hl : f.tc.length = f.c.n := by
    have := congrArg List.length hf.tc; rw [List.length_map, hcx.htc] at this; simpa using this
  rw [← hf.tc, getD_map_lt _ _ j (by omega) [] default]

include hcx in
theorem decode_normP (k : PKey) (hk : WFkey f.c k) :
    decodeK f.c (normP f k) = norm f.c (decodeK f.c k) ∧ WFkey f.c (normP f k) := by
  have htcw : ∀ j < f.c.n, WFcol f.c (f.tc.getD j default) := by
    intro j hj
    have hl : f.tc.length = f.c.n := by
      have := congrArg List.length hf.tc; rw [List.length_map, hcx.htc] at this; simpa using this
    exact hf.tcWF _ (getD_mem _ j (by omega) default)
  refine ⟨?_, fun p hp => hk.1 p ((perm_sortP k.cols).subset hp), WF_canonF hf _ hk.2⟩
  simp only [decodeK, normP, norm]
  congr 1
  · exact decode_sortP hf k.cols hk.1
  · exact decode_canonF hf _ hk.2
  · apply List.map_congr_left
    intro j hj
    have hjn := List.mem_range.1 hj
    rw [tc_decode hf hcx j hjn, mem_map_decode hf hk.1 (htcw j hjn)]

theorem lexLt_decode : ∀ (xs ys : List PCol), (∀ p ∈ xs, WFcol f.c p) → (∀ p ∈ ys, WFcol f.c p) →
    lexLt (fun a b => decide (colNum f.c a < colNum f.c b)) (xs.map (decodeCol f.c)) (ys.map (decodeCol f.c)) =
      lexLtP xs ys
  | [], [], _, _ => rfl
  | [], _ :: _, _, _ => rfl
  | _ :: _, [], _, _ => rfl
  | a :: as, b :: bs, ha, hb => by
    have hwa := ha a List.mem_cons_self
    have hwb := hb b List.mem_cons_self
    simp only [List.map_cons, lexLt, lexLtP]
    rw [colNum_decode hf a hwa, colNum_decode hf b hwb, pLt_iff,
      lexLt_decode as bs (fun p hp => ha p (List.mem_cons_of_mem _ hp)) (fun p hp => hb p (List.mem_cons_of_mem _ hp))]
    congr 2
    cases e : (a == b) <;> cases e2 : (decodeCol f.c a == decodeCol f.c b) <;> try rfl
    · exfalso; simp only [beq_iff_eq] at e2; rw [decodeCol_inj hf hwa hwb e2] at e; simp at e
    · exfalso; simp only [beq_iff_eq] at e; rw [e] at e2; simp at e2

theorem map_decode_inj : ∀ {xs ys : List PCol}, (∀ p ∈ xs, WFcol f.c p) → (∀ p ∈ ys, WFcol f.c p) →
    xs.map (decodeCol f.c) = ys.map (decodeCol f.c) → xs = ys
  | [], [], _, _, _ => rfl
  | [], _ :: _, _, _, h => by simp at h
  | _ :: _, [], _, _, h => by simp at h
  | a :: as, b :: bs, hx, hy, h => by
    simp only [List.map_cons, List.cons.injEq] at h
    rw [decodeCol_inj hf (hx a List.mem_cons_self) (hy b List.mem_cons_self) h.1,
      map_decode_inj (fun p hp => hx p (List.mem_cons_of_mem _ hp)) (fun p hp => hy p (List.mem_cons_of_mem _ hp)) h.2]

theorem map_decode_eq {xs ys : List PCol} (hx : ∀ p ∈ xs, WFcol f.c p) (hy : ∀ p ∈ ys, WFcol f.c p) :
    (xs.map (decodeCol f.c) == ys.map (decodeCol f.c)) = (xs == ys) := by
  cases e : (xs == ys) <;> cases e2 : (xs.map (decodeCol f.c) == ys.map (decodeCol f.c)) <;> try rfl
  · exfalso
    simp only [beq_iff_eq] at e2
    rw [map_decode_inj hf hx hy e2] at e; simp at e
  · exfalso; simp only [beq_iff_eq] at e; subst e; simp at e2

theorem keyLt_decode (x y : PKey) (hx : WFkey f.c x) (hy : WFkey f.c y) :
    keyLt f.c (decodeK f.c x) (decodeK f.c y) = keyLtP x y := by
  simp only [keyLt, keyLtP, decodeK]
  have e1 := flagNum_decode hf _ hx.2
  have e2 := flagNum_decode hf _ hy.2
  simp only [e1, e2]
  rw [lexLt_decode hf x.cols y.cols hx.1 hy.1, map_decode_eq hf hx.1 hy.1]
  have hfl : (decodeFl f.c x.fl == decodeFl f.c y.fl) = (x.fl == y.fl) := by
    cases e : (x.fl == y.fl) <;> cases e2 : (decodeFl f.c x.fl == decodeFl f.c y.fl) <;> try rfl
    · exfalso; simp only [beq_iff_eq] at e2; rw [decodeFl_inj hf hx.2 hy.2 e2] at e; simp at e
    · exfalso; simp only [beq_iff_eq] at e; rw [e] at e2; simp at e2
  rw [hfl]
  congr 1

theorem decode_actP {π : List Nat} (hπ : π.Perm (List.range f.c.m)) (k : PKey) (hk : WFkey f.c k) :
    decodeK f.c (actP (mkTab π) k) = act π (decodeK f.c k) ∧ WFkey f.c (actP (mkTab π) k) := by
  refine ⟨?_, fun p hp => ?_, WF_permFl hf hπ _ hk.2⟩
  · simp only [decodeK, actP, act, List.map_map]
    congr 1
    · apply List.map_congr_left; intro p hp
      simp only [Function.comp]; exact decode_permCol hf hπ p (hk.1 p hp)
    · exact decode_permFl hf hπ _ hk.2
  · obtain ⟨q, hq, rfl⟩ := List.mem_map.1 hp
    exact WF_permCol hf hπ q (hk.1 q hq)

theorem decode_pickMinP : ∀ (b : PKey) (l : List PKey), WFkey f.c b → (∀ x ∈ l, WFkey f.c x) →
    decodeK f.c (pickMinP b l) = pickMin f.c (decodeK f.c b) (l.map (decodeK f.c)) ∧ WFkey f.c (pickMinP b l)
  | b, [], hb, _ => ⟨rfl, hb⟩
  | b, x :: xs, hb, hl => by
    have hx := hl x List.mem_cons_self
    simp only [pickMinP, List.map_cons, pickMin]
    rw [keyLt_decode hf x b hx hb]
    have hb' : WFkey f.c (if keyLtP x b then x else b) := by split <;> assumption
    have e : decodeK f.c (if keyLtP x b then x else b) = if keyLtP x b then decodeK f.c x else decodeK f.c b := by
      split <;> rfl
    rw [← e]
    exact decode_pickMinP _ xs hb' (fun y hy => hl y (List.mem_cons_of_mem _ hy))

theorem decode_pickMinFP : ∀ (b : UInt64) (l : List UInt64), WFfl f.c b → (∀ x ∈ l, WFfl f.c x) →
    decodeFl f.c (pickMinFP b l) = pickMinF (decodeFl f.c b) (l.map (decodeFl f.c)) ∧ WFfl f.c (pickMinFP b l)
  | b, [], hb, _ => ⟨rfl, hb⟩
  | b, x :: xs, hb, hl => by
    have hx := hl x List.mem_cons_self
    simp only [pickMinFP, List.map_cons, pickMinF]
    rw [flagNum_decode hf x hx, flagNum_decode hf b hb]
    have hb' : WFfl f.c (if x < b then x else b) := by split <;> assumption
    have e : decodeFl f.c (if x < b then x else b) =
        if x.toNat < b.toNat then decodeFl f.c x else decodeFl f.c b := by
      by_cases h : x < b
      · rw [if_pos h, if_pos (UInt64.lt_iff_toNat_lt.1 h)]
      · rw [if_neg h, if_neg (fun h' => h (UInt64.lt_iff_toNat_lt.2 h'))]
    rw [← e]
    exact decode_pickMinFP _ xs hb' (fun y hy => hl y (List.mem_cons_of_mem _ hy))

theorem decodeFl_beq {a b : UInt64} (ha : WFfl f.c a) (hb : WFfl f.c b) :
    (decodeFl f.c a == decodeFl f.c b) = (a == b) := by
  cases e : (a == b) <;> cases e2 : (decodeFl f.c a == decodeFl f.c b) <;> try rfl
  · exfalso; simp only [beq_iff_eq] at e2; rw [decodeFl_inj hf ha hb e2] at e; simp at e
  · exfalso; simp only [beq_iff_eq] at e; rw [e] at e2; simp at e2

include hcx in
theorem decode_canonP (hgo : ∀ π ∈ group f.c, π.Perm (List.range f.c.m)) (k : PKey) (hk : WFkey f.c k) :
    decodeK f.c (canonP f k) = canon f.c (group f.c) (decodeK f.c k) ∧ WFkey f.c (canonP f k) := by
  let G := group f.c
  let flF := fun (tab : Array Nat) => FP.canonF (permFl tab k.fl)
  have hflπ : ∀ π ∈ G, decodeFl f.c (flF (mkTab π)) = LeanReflect.canonF (permF π (decodeFl f.c k.fl)) ∧
      WFfl f.c (flF (mkTab π)) := by
    intro π hπ
    have hp := hgo π hπ
    refine ⟨?_, WF_canonF hf _ (WF_permFl hf hp _ hk.2)⟩
    simp only [flF]; rw [decode_canonF hf _ (WF_permFl hf hp _ hk.2), decode_permFl hf hp _ hk.2]
  have hfmin := decode_pickMinFP hf (FP.canonF k.fl) (f.ptab.map flF) (WF_canonF hf _ hk.2) (by
    intro x hx; rw [hf.ptab, List.map_map] at hx
    obtain ⟨π, hπ, rfl⟩ := List.mem_map.1 hx; exact (hflπ π hπ).2)
  have hfminS : decodeFl f.c (pickMinFP (FP.canonF k.fl) (f.ptab.map flF)) =
      pickMinF (LeanReflect.canonF (decodeFl f.c k.fl)) (G.map fun π => LeanReflect.canonF (permF π (decodeFl f.c k.fl))) := by
    rw [hfmin.1, decode_canonF hf _ hk.2, hf.ptab, List.map_map, List.map_map]
    congr 1
    apply List.map_congr_left; intro π hπ; exact (hflπ π hπ).1
  have hcand : (f.ptab.filter fun tab => flF tab == pickMinFP (FP.canonF k.fl) (f.ptab.map flF)) =
      (G.filter fun π => LeanReflect.canonF (permF π (decodeFl f.c k.fl)) ==
        pickMinF (LeanReflect.canonF (decodeFl f.c k.fl)) (G.map fun π => LeanReflect.canonF (permF π (decodeFl f.c k.fl)))).map mkTab := by
    rw [hf.ptab, List.filter_map]
    congr 1
    apply List.filter_congr; intro π hπ
    simp only [Function.comp]
    rw [← (hflπ π hπ).1, ← hfminS, decodeFl_beq hf (hflπ π hπ).2 hfmin.2, hf.ptab]
  have hN := decode_normP hf hcx k hk
  have hcands : ∀ x ∈ (G.filter fun π => LeanReflect.canonF (permF π (decodeFl f.c k.fl)) ==
        pickMinF (LeanReflect.canonF (decodeFl f.c k.fl)) (G.map fun π => LeanReflect.canonF (permF π (decodeFl f.c k.fl)))),
      decodeK f.c (normP f (actP (mkTab x) k)) = norm f.c (act x (decodeK f.c k)) ∧ WFkey f.c (normP f (actP (mkTab x) k)) := by
    intro π hπ
    have hp := hgo π (List.mem_filter.1 hπ).1
    have hA := decode_actP hf hp k hk
    have hN2 := decode_normP hf hcx _ hA.2
    exact ⟨by rw [hN2.1, hA.1], hN2.2⟩
  let q := fun π => LeanReflect.canonF (permF π (decodeFl f.c k.fl)) ==
    pickMinF (LeanReflect.canonF (decodeFl f.c k.fl)) (G.map fun π => LeanReflect.canonF (permF π (decodeFl f.c k.fl)))
  have e1 : canonP f k = pickMinP (normP f k) ((G.filter q).map fun π => normP f (actP (mkTab π) k)) := by
    have : canonP f k = pickMinP (normP f k) ((f.ptab.filter fun tab => flF tab ==
        pickMinFP (FP.canonF k.fl) (f.ptab.map flF)).map fun tab => normP f (actP tab k)) := rfl
    rw [this, hcand, List.map_map]
    rfl
  have e2 : canon f.c (group f.c) (decodeK f.c k) =
      pickMin f.c (norm f.c (decodeK f.c k)) ((G.filter q).map fun π => norm f.c (act π (decodeK f.c k))) := rfl
  rw [e1, e2]
  have hP := decode_pickMinP hf (normP f k) ((G.filter q).map fun π => normP f (actP (mkTab π) k)) hN.2 (by
    intro x hx; obtain ⟨π, hπ, rfl⟩ := List.mem_map.1 hx; exact (hcands π hπ).2)
  refine ⟨?_, hP.2⟩
  rw [hP.1, hN.1, List.map_map]
  congr 1
  apply List.map_congr_left; intro π hπ
  exact (hcands π hπ).1

end

end LeanReflect.FP
