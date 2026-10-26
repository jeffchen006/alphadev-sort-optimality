import LeanReflect.SymBasic
import LeanReflect.SetSound
/-
  Soundness of rule G. Fact used: every pruning lemma holds for any multi-state whose tests are re-indexed by a map
  f with f(ts) ⊆ ts (all tests have the same value set {0..n-1}). A position permutation π (π ~ range m) acts on
  columns; the view `st ∘ lane π` has the columns `permCol π (colOf st r)` and the same potential Φ.
-/
namespace LeanReflect
open SortProof
set_option linter.unusedSectionVars false
set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false
open Classical

section
variable (c : Ctx)

/-- Facts for rule G, checked by `decide`: tests distinct, every π ∈ G a permutation of the positions. -/
structure GroupOK (G : List (List Nat)) : Prop where
  nodup : c.ts.Nodup
  perm : ∀ π ∈ G, π.Perm (List.range c.m)

/-- The test map induced by π: test `ts[t]` ↦ `ts[π t]`. -/
def lane (π : List Nat) (w : List Int) : List Int := c.ts.getD (π.getD (c.ts.idxOf w) 0) []

def view (st : MS) (f : List Int → List Int) : MS := fun w => st (f w)

theorem lane_mem (hc : CtxOK c) {π : List Nat} (hπ : π.Perm (List.range c.m)) {w : List Int} (hw : w ∈ c.ts) :
    lane c π w ∈ c.ts := by
  apply getD_mem
  have hi : c.ts.idxOf w < c.ts.length := List.idxOf_lt_length_iff.2 hw
  have hl : π.length = c.m := by rw [hπ.length_eq, List.length_range]
  have : π.getD (c.ts.idxOf w) 0 ∈ π := getD_mem _ _ (by rw [hl, hc.hm]; exact hi) 0
  have := List.mem_range.1 (hπ.subset this)
  rw [← hc.hm]; exact this

theorem lane_at (hc : CtxOK c) (hG : c.ts.Nodup) (π : List Nat) {t : Nat} (ht : t < c.ts.length) :
    lane c π (c.ts[t]) = c.ts.getD (π.getD t 0) [] := by
  simp only [lane, List.Nodup.idxOf_getElem hG t ht]

theorem permCol_map {γ : Type} (hc : CtxOK c) (hG : c.ts.Nodup) {π : List Nat} (hπ : π.Perm (List.range c.m))
    (g : List Int → γ) (d : γ) :
    c.ts.map (fun w => g (lane c π w)) = π.map fun t => (c.ts.map g).getD t d := by
  have hl : π.length = c.ts.length := by rw [hπ.length_eq, List.length_range, hc.hm]
  apply List.ext_getElem (by simp [hl])
  intro t h1 h2
  simp only [List.getElem_map]
  have ht : t < c.ts.length := by simpa using h1
  rw [lane_at c hc hG π ht]
  have hπt : π[t] < c.ts.length := by
    have := List.mem_range.1 (hπ.subset (List.getElem_mem (by rw [hl]; exact ht)))
    rw [← hc.hm]; exact this
  rw [show π.getD t 0 = π[t] from by simp [List.getD_eq_getElem?_getD, hl ▸ ht]]
  rw [getD_map_lt _ _ _ hπt d []]

theorem colOf_view (hc : CtxOK c) (hG : c.ts.Nodup) {π : List Nat} (hπ : π.Perm (List.range c.m)) (st : MS) (r : Nat) :
    colOf c (view st (lane c π)) r = permCol π (colOf c st r) := by
  simp only [colOf, view, permCol]
  exact permCol_map c hc hG hπ (fun w => (st w).regs r) 0

theorem flagOf_view (hc : CtxOK c) (hG : c.ts.Nodup) {π : List Nat} (hπ : π.Perm (List.range c.m)) (st : MS) :
    flagOf c (view st (lane c π)) = permF π (flagOf c st) := by
  simp only [flagOf, view, permF]
  exact permCol_map c hc hG hπ (fun w => (st w).flag) .eq

theorem permF_swap (π : List Nat) (f : List Ordering) : permF π (f.map Ordering.swap) = (permF π f).map Ordering.swap := by
  simp only [permF, List.map_map]
  apply List.map_congr_left; intro t _
  simp only [Function.comp, getD_map_swap]

theorem len_colOf (hc : CtxOK c) (st : MS) (r : Nat) : (colOf c st r).length = c.m := by
  simp [colOf, hc.hm]

theorem permCol_inj (hc : CtxOK c) {π : List Nat} (hπ : π.Perm (List.range c.m)) {a b : Col}
    (ha : a.length = c.m) (hb : b.length = c.m) (h : permCol π a = permCol π b) : a = b := by
  apply List.ext_getElem (by rw [ha, hb])
  intro t h1 h2
  have htm : t < c.m := ha ▸ h1
  obtain ⟨s, hs, hst⟩ := List.getElem_of_mem (hπ.symm.subset (List.mem_range.2 htm))
  have e := congrArg (fun l => l.getD s 0) h
  simp only [permCol] at e
  rw [getD_map_lt π _ s hs 0 0, getD_map_lt π _ s hs 0 0] at e
  rw [show π.getD s 0 = t from by simp [List.getD_eq_getElem?_getD, hs, hst]] at e
  simpa [List.getD_eq_getElem?_getD, h1, h2] using e

theorem permCol_T (hc : CtxOK c) {π : List Nat} (hπ : π.Perm (List.range c.m)) : permCol π c.T = c.T := by
  have hl : π.length = c.m := by rw [hπ.length_eq, List.length_range]
  simp only [permCol, hc.hT]
  rw [List.map_congr_left (g := fun _ => (c.n : Int)), List.map_const', hl]
  intro t ht
  have := List.mem_range.1 (hπ.subset ht)
  simp [List.getD_eq_getElem?_getD, this]

/-- All tests have the same value set. -/
theorem mem_test_iff (hc : CtxOK c) {w w' : List Int} (hw : w ∈ c.ts) (hw' : w' ∈ c.ts) (v : Int) :
    v ∈ w ↔ v ∈ w' := by
  have e : ∀ u ∈ c.ts, u = (List.range c.n).map (xOf u) := by
    intro u hu
    apply List.ext_getElem (by simp [hc.len u hu])
    intro i h1 h2
    simp [xOf, List.getD_eq_getElem?_getD, h1]
  rw [e w hw, e w' hw', (hc.perm w hw).mem_iff, (hc.perm w' hw').mem_iff]

theorem relW_view (hc : CtxOK c) (hG : c.ts.Nodup) {π : List Nat} (hπ : π.Perm (List.range c.m))
    {B : Nat} {st : MS} {k : Key} (hR : RelW c B st k) : RelW c B (view st (lane c π)) (act π k) := by
  refine ⟨fun r hr w => hR.hi r hr _, fun r hr hT => ?_, ?_, ?_⟩
  · rw [colOf_view c hc hG hπ] at hT ⊢
    have hT' : colOf c st r ≠ c.T := fun h => hT (by rw [h, permCol_T c hc hπ])
    exact List.mem_map.2 ⟨_, hR.sub r hr hT', rfl⟩
  · rw [flagOf_view c hc hG hπ]
    rcases hR.fl with h | h
    · left; rw [h]; rfl
    · right; rw [h, permF_swap]; rfl
  · intro w hw r
    have hlw := lane_mem c hc hπ hw
    rcases hR.vals _ hlw r with h | h
    · left; exact (mem_test_iff c hc hlw hw _).1 h
    · right; exact h

theorem nonT_map (hc : CtxOK c) {π : List Nat} (hπ : π.Perm (List.range c.m)) (L : List Col)
    (hL : ∀ x ∈ L, x.length = c.m) : nonT c (L.map (permCol π)) = (nonT c L).map (permCol π) := by
  have hTl : c.T.length = c.m := by simp [hc.hT]
  simp only [nonT, List.filter_map]
  congr 1
  apply List.filter_congr
  intro x hx
  have hiff : permCol π x = c.T ↔ x = c.T :=
    ⟨fun e => permCol_inj c hc hπ (hL x hx) hTl (by rw [e, permCol_T c hc hπ]), fun e => by rw [e, permCol_T c hc hπ]⟩
  show (permCol π x != c.T) = (x != c.T)
  by_cases e : x = c.T
  · rw [e, permCol_T c hc hπ]
  · have e' : permCol π x ≠ c.T := fun h => e (hiff.1 h)
    rw [bne_iff_ne.2 e, bne_iff_ne.2 e']

theorem phi_view (hc : CtxOK c) (hG : c.ts.Nodup) {π : List Nat} (hπ : π.Perm (List.range c.m)) (B : Nat) (st : MS) :
    Phi c B (view st (lane c π)) = Phi c B st := by
  have hreg : regCols c B (view st (lane c π)) = (regCols c B st).map (permCol π) := by
    simp only [regCols, List.map_map]
    apply List.map_congr_left; intro r _; exact colOf_view c hc hG hπ st r
  have hL : ∀ x ∈ regCols c B st, x.length = c.m := by
    intro x hx; obtain ⟨r, _, e⟩ := List.mem_map.1 hx; rw [← e]; exact len_colOf c hc st r
  have hL' : ∀ x ∈ nonT c (regCols c B st), x.length = c.m :=
    fun x hx => hL x (List.mem_filter.1 hx).1
  simp only [Phi, Pl, hreg, nonT_map c hc hπ _ hL, List.length_map]
  have h1 : dc id ((nonT c (regCols c B st)).map (permCol π)) = dc id (nonT c (regCols c B st)) := by
    have e1 : dc id ((nonT c (regCols c B st)).map (permCol π)) = dc (permCol π) (nonT c (regCols c B st)) := by
      generalize nonT c (regCols c B st) = l
      induction l with
      | nil => rfl
      | cons a l ih =>
        simp only [List.map_cons, dc]; rw [List.any_map, ih]; rfl
    rw [e1]
    apply Nat.le_antisymm
    · apply dc_mono; intro a ha b hb e; simp at e; rw [e]
    · apply dc_mono; intro a ha b hb e; exact permCol_inj c hc hπ (hL' a ha) (hL' b hb) e
  rw [h1]

/-! ## canonical form -/

theorem pickMin_mem (best : Key) : ∀ l : List Key, pickMin best l = best ∨ pickMin best l ∈ l
  | [] => Or.inl rfl
  | x :: xs => by
    simp only [pickMin]
    rcases pickMin_mem (if keyLt x best then x else best) xs with h | h
    · rw [h]; split
      · exact Or.inr List.mem_cons_self
      · exact Or.inl rfl
    · exact Or.inr (List.mem_cons_of_mem _ h)

theorem canon_spec (G : List (List Nat)) (k : Key) :
    canon c G k = norm c k ∨ ∃ π ∈ G, canon c G k = norm c (act π k) := by
  rcases pickMin_mem (norm c k) (G.map fun π => norm c (act π k)) with h | h
  · exact Or.inl h
  · obtain ⟨π, hπ, e⟩ := List.mem_map.1 h
    exact Or.inr ⟨π, hπ, e.symm⟩

/-- The canonical image is related to a re-indexed view, with the same potential and outputs taken. -/
theorem canon_rel (hc : CtxOK c) (hgo : GroupOK c G) {B : Nat} {st : MS} {k : Key} (hR : RelW c B st k) :
    ∃ f : List Int → List Int, (∀ w ∈ c.ts, f w ∈ c.ts) ∧ RelW c B (view st f) (canon c G k) ∧
      Phi c B (view st f) = Phi c B st ∧ ∃ x, canon c G k = norm c x ∧ x.done = k.done := by
  rcases canon_spec c G k with h | ⟨π, hπG, h⟩
  · refine ⟨id, fun w hw => hw, ?_, rfl, k, h, rfl⟩
    rw [h]; exact rel_normW c hc hR
  · have hπ := hgo.perm π hπG
    refine ⟨lane c π, fun w hw => lane_mem c hc hπ hw, ?_, phi_view c hc hgo.nodup hπ B st, act π k, h, rfl⟩
    rw [h]; exact rel_normW c hc (relW_view c hc hgo.nodup hπ hR)

theorem pres_view {st : MS} {f : List Int → List Int} (hf : ∀ w ∈ c.ts, f w ∈ c.ts) {j : Nat}
    (hp : Pres c st j) : Pres c (view st f) j := by
  obtain ⟨r, hr⟩ := hp
  exact ⟨r, fun w hw => hr _ (hf w hw)⟩


theorem fut_view {st : MS} {f : List Int → List Int} (hf : ∀ w ∈ c.ts, f w ∈ c.ts) {q : Program} {U : List Nat}
    (hF : Fut c st q U) : Fut c (view st f) q U := by
  intro j hj
  obtain ⟨t, ht, r, hr⟩ := hF j hj
  exact ⟨t, ht, r, fun w hw => hr _ (hf w hw)⟩

theorem checkG_sound (hc : CtxOK c) (hs : SetCtxOK c) (G : List (List Nat)) (hgo : GroupOK c G)
    (cs : List Cond) (hsw : ∀ x ∈ cs, x.swap ∈ cs) (KB : Nat)
    (S : List (Key × Nat)) (look : Key → Option Nat) (hlook : ∀ k g, look k = some g → (k, g) ∈ S)
    (hchk : checkG c G cs KB S look = true) (p : Program) (hp : p.length ≤ KB) (hcs : ∀ i ∈ p, condIn cs i)
    (o : Snap)
    (hsnap : ∀ w ∈ c.ts, ∀ j < c.n, (run compare (p.take (o j).2) (initOf c.n w)).regs (o j).1 = ((j : Nat) : Int)) :
    False := by
  simp only [checkG, Bool.and_eq_true, beq_iff_eq, List.all_eq_true] at hchk
  obtain ⟨hroot, hall⟩ := hchk
  let E := (p.flatMap Instr.regs).sum + 1
  let B := c.n + E
  have hB : ∀ i ∈ p, ∀ r ∈ i.regs, r < B := by
    intro i hi r hr
    have := le_sum_of_mem (List.mem_flatMap.2 ⟨i, hi, hr⟩)
    simp only [B, E]; omega
  let tm : Nat → Nat := fun j => min (o j).2 p.length
  have hsn : ∀ w ∈ c.ts, ∀ j < c.n, (run compare (p.take (tm j)) (initOf c.n w)).regs (o j).1 = ((j : Nat) : Int) := by
    intro w hw j hj; simp only [tm]; rw [take_min_len]; exact hsnap w hw j hj
  let stAt : Nat → MS := fun d w => run compare (p.take d) (initOf c.n w)
  have hstep : ∀ d (hd : d < p.length), stAt (d + 1) = stepMS (stAt d) p[d] := by
    intro d hd; funext w
    simp only [stAt, stepMS]
    rw [List.take_succ_eq_append_getElem hd, run_append]; rfl
  have hpres : ∀ d j, j < c.n → tm j = d → Pres c (stAt d) j := fun d j hj htm =>
    ⟨(o j).1, fun w hw => by have := hsn w hw j hj; rwa [htm] at this⟩
  have Inv : ∀ d, d ≤ p.length → ∃ k g x f, (k, g) ∈ S ∧ (∀ w ∈ c.ts, f w ∈ c.ts) ∧
      g + Phi c B (view (stAt d) f) ≤ d ∧ k = norm c x ∧
      RelW c B (view (stAt d) f) k ∧ ∀ j < c.n, tm j ≤ d → k.done.getD j false = true := by
    intro d
    induction d with
    | zero =>
      intro _
      let k0 : Key := { cols := (List.range c.n).map (fun i => c.ts.map (fun w => w.getD i 0))
                        flag := List.replicate c.m .eq, done := List.replicate c.n false }
      have hR0 : RelW c B (stAt 0) (norm c k0) := rel_normW c hc ((rel_init c hc E).toW c hc)
      have hphi : Phi c B (stAt 0) = 0 := phi_init c hc hs E
      obtain ⟨f, hf, hRf, hPf, x, hx, hxd⟩ := canon_rel c hc hgo hR0
      refine ⟨canon c G (root c), 0, x, f, hlook _ _ hroot, hf, by omega, hx, hRf, ?_⟩
      intro j hj htm
      exact done_of_mem_norm c hx hj (pres_mem c hc hRf hj (pres_view c hf (hpres 0 j hj (by omega))))
    | succ d ih =>
      intro hd1
      obtain ⟨k, g, x, f, hkS, hf, hgd, hkx, hR, hdone⟩ := ih (by omega)
      have hdl : d < p.length := by omega
      have hk := hall (k, g) hkS
      simp only [Bool.and_eq_true, Bool.not_eq_true', List.all_eq_true] at hk
      obtain ⟨_, hsucc⟩ := hk
      let i := p[d]
      have hiP : i ∈ p := List.getElem_mem hdl
      obtain ⟨w, hw, hcase⟩ := setStep c hc cs hsw hR i (hB i hiP) (hcs i hiP)
      have hv : stepMS (view (stAt d) f) i = view (stAt (d + 1)) f := by rw [hstep d hdl]; rfl
      rw [hv] at hw hcase
      rcases hcase with ⟨hw0, hR'⟩ | ⟨y, hy, hmem, hR'⟩
      · refine ⟨k, g, x, f, hkS, hf, by omega, hkx, hR', ?_⟩
        intro j hj htm
        rcases Nat.lt_or_ge (tm j) (d + 1) with hlt | hge
        · exact hdone j hj (by omega)
        · exact done_of_mem_norm c hkx hj
            (pres_mem c hc hR' hj (pres_view c hf (hpres (d + 1) j hj (by omega))))
      · obtain ⟨f2, hf2, hR2, hP2, x2, hx2, hx2d⟩ := canon_rel c hc hgo hR'
        have hff : ∀ u ∈ c.ts, f (f2 u) ∈ c.ts := fun u hu => hf _ (hf2 u hu)
        replace hR2 : RelW c B (view (stAt (d + 1)) (fun u => f (f2 u))) (canon c G (norm c y)) := hR2
        replace hP2 : Phi c B (view (stAt (d + 1)) (fun u => f (f2 u))) = Phi c B (view (stAt (d + 1)) f) := hP2
        have hdone' : ∀ j < c.n, tm j ≤ d + 1 → (canon c G (norm c y)).done.getD j false = true := by
          intro j hj htm
          rcases Nat.lt_or_ge (tm j) (d + 1) with hlt | hge
          · rw [hx2, norm_done c x2 j hj, hx2d, norm_done c y j hj, hy, hdone j hj (by omega)]; simp
          · exact done_of_mem_norm c hx2 hj
              (pres_mem c hc hR2 hj (pres_view c hff (hpres (d + 1) j hj (by omega))))
        let q := p.drop (d + 1)
        have hF : Fut c (view (stAt (d + 1)) (fun u => f (f2 u))) q (undone c (canon c G (norm c y))) := by
          apply fut_view c hff
          intro j hj
          have hjn : j < c.n := by simp [undone] at hj; exact hj.1
          have hnd : (canon c G (norm c y)).done.getD j false = false := by simp [undone] at hj; simpa using hj.2
          have hlt : d + 1 < tm j := by
            rcases Nat.lt_or_ge (d + 1) (tm j) with h | h
            · exact h
            · rw [hdone' j hjn h] at hnd; exact absurd hnd (by decide)
          have htmle : tm j ≤ p.length := Nat.min_le_right _ _
          refine ⟨tm j - (d + 1), by simp [q]; omega, (o j).1, fun w hw => ?_⟩
          have := hsn w hw j hjn
          rw [show tm j = (d + 1) + (tm j - (d + 1)) by omega, List.take_add, run_append] at this
          exact this
        have hR2' : RelW c B (view (stAt (d + 1)) (fun u => f (f2 u))) (norm c x2) := hx2 ▸ hR2
        have hA := undone_absent c hc x2 hR2'
        rw [← hx2] at hA
        have hnd := not_dead c hc hR2 hF
        have hh := h_le c hc hR2 hA hF
        have hql : q.length = p.length - (d + 1) := by simp [q]
        have hok := hsucc (norm c y, w) hmem
        have hraw : ¬ (KB < g + w + (undone c (norm c y)).length) ∧ dead c (norm c y) = false := by
          have hA0 := undone_absent c hc y hR'
          let q0 := p.drop (d + 1)
          have hF0 : Fut c (view (stAt (d + 1)) f) q (undone c (norm c y)) := by
            intro j hj
            have hjn : j < c.n := by simp [undone] at hj; exact hj.1
            have hnd0 : (norm c y).done.getD j false = false := by simp [undone] at hj; simpa using hj.2
            have hlt : d + 1 < tm j := by
              rcases Nat.lt_or_ge (d + 1) (tm j) with h | h
              · exact h
              · have e : (norm c y).done.getD j false = true := by
                  rcases Nat.lt_or_ge (tm j) (d + 1) with hlt | hge
                  · rw [norm_done c y j hjn, hy, hdone j hjn (by omega)]; simp
                  · exact done_of_mem_norm c rfl hjn
                      (pres_mem c hc hR' hjn (pres_view c hf (hpres (d + 1) j hjn (by omega))))
                rw [e] at hnd0; exact absurd hnd0 (by decide)
            have htmle : tm j ≤ p.length := Nat.min_le_right _ _
            refine ⟨tm j - (d + 1), by simp [q]; omega, (o j).1, fun w' hw' => ?_⟩
            have := hsn _ (hf w' hw') j hjn
            rw [show tm j = (d + 1) + (tm j - (d + 1)) by omega, List.take_add, run_append] at this
            exact this
          have hu := und_le c hc q _ (undone c (norm c y)) (List.nodup_range.filter _) hA0 hF0
          have h3 := ncmp_add_nwr q
          refine ⟨by omega, not_dead c hc hR' hF0⟩
        simp only [fastOK, hraw.1, hraw.2, decide_false, Bool.false_or] at hok
        simp only [succOKG, hnd, Bool.or_false, Bool.or_eq_true, decide_eq_true_eq] at hok
        rcases hok with hlook' | hlt
        · cases hg' : look (canon c G (norm c y)) with
          | none => rw [hg'] at hlook'; simp at hlook'
          | some g' =>
            rw [hg'] at hlook'
            simp only [decide_eq_true_eq] at hlook'
            exact ⟨canon c G (norm c y), g', x2, fun u => f (f2 u), hlook _ _ hg', hff, by omega, hx2, hR2, hdone'⟩
        · exfalso; omega
  obtain ⟨k, g, x, f, hkS, _, _, _, _, hdone⟩ := Inv p.length (Nat.le_refl _)
  have hk := hall (k, g) hkS
  simp only [Bool.and_eq_true, Bool.not_eq_true'] at hk
  have hgoal : isGoal c k = true := by
    simp only [isGoal, undone, List.isEmpty_iff, List.filter_eq_nil_iff]
    intro j hj
    have hjn := List.mem_range.1 hj
    rw [hdone j hjn (Nat.min_le_right _ _)]; simp
  rw [hgoal] at hk; exact absurd hk.1 (by decide)

end

theorem lower_bound_G (n KB : Nat) (cs : List Cond) (G : List (List Nat)) (hc : CtxOK (mkCtx n))
    (hs : SetCtxOK (mkCtx n)) (hgo : GroupOK (mkCtx n) G) (hsw : ∀ x ∈ cs, x.swap ∈ cs)
    (S : List (Key × Nat)) (look : Key → Option Nat) (hlook : ∀ k g, look k = some g → (k, g) ∈ S)
    (hcert : checkG (mkCtx n) G cs KB S look = true) :
    ∀ (p : Program) (o : Snap), p.length ≤ KB → (∀ i ∈ p, condIn cs i) → ¬ RelaxedSnap n p o := by
  intro p o hp hcs hrs
  apply checkG_sound (mkCtx n) hc hs G hgo cs hsw KB S look hlook hcert p hp hcs o
  intro w hw j hj
  have hx : ∀ i < n, xOf w i < (n : Int) := hc.lt w hw
  have hsort := hrs (xOf w) n hx
  simp only [SortsOK] at hsort
  have hs' : ((List.range n).map (xOf w)).mergeSort (fun a b => decide (a ≤ b))
      = (List.range n).map (fun (j : Nat) => ((j : Nat) : Int)) := sorted_of_perm n _ (hc.perm w hw)
  rw [hs'] at hsort
  have := (List.map_inj_left.1 hsort) j (List.mem_range.2 hj)
  simp only [snapOut] at this
  exact this

theorem certOKG_sound (n KB : Nat) (cs : List Cond) (hc : CtxOK (mkCtx n)) (hs : SetCtxOK (mkCtx n))
    (hgo : GroupOK (mkCtx n) (group (mkCtx n))) (hsw : ∀ x ∈ cs, x.swap ∈ cs) (hcert : certOKG n cs KB = true) :
    ∀ (p : Program) (o : Snap), p.length ≤ KB → (∀ i ∈ p, condIn cs i) → ¬ RelaxedSnap n p o :=
  lower_bound_G n KB cs _ hc hs hgo hsw _ _ (fun k g h => Std.HashMap.mem_toList_iff_getElem?_eq_some.2 h) hcert

end LeanReflect
