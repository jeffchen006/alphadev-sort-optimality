import LeanReflect.NGMain
/-
  `checkNG2`: as `checkNG`, but a successor may also be pruned by the H bound on its raw (not yet canonical) key,
  before canonicalization (sound for the same reason as rule D on the raw key). The fast checker uses this order.
-/
namespace LeanReflect
open SortProof
set_option linter.unusedSectionVars false
set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false
open Classical

section
variable (c : Ctx)

def fastOK2 (G : List (List Nat)) (KB Gc : Nat) (look : Key → Option Nat) (k0 : Key) : Bool :=
  decide (KB < Gc + (undone c k0).length) || dead c k0 || decide (KB < Gc + hB c k0 (KB + 3 - Gc)) ||
    succOKG c KB Gc look (canon c G k0)

def checkNG2 (G : List (List Nat)) (cs : List Cond) (KB : Nat) (S : List (Key × Nat))
    (look : Key → Option Nat) : Bool :=
  look (canon c G (root c)) == some 0 &&
  S.all fun (k, g) => !isGoal c k &&
    (ngSuccs c cs k).all fun (k', w) => fastOK2 c G KB (g + w) look k'

theorem checkNG2_sound (hc : CtxOK c) (hs : SetCtxOK c) (G : List (List Nat)) (hgo : GroupOK c G)
    (cs : List Cond) (hsw : ∀ x ∈ cs, x.swap ∈ cs) (KB : Nat)
    (S : List (Key × Nat)) (look : Key → Option Nat) (hlook : ∀ k g, look k = some g → (k, g) ∈ S)
    (hchk : checkNG2 c G cs KB S look = true) (p : Program) (hp : p.length ≤ KB) (hcs : ∀ i ∈ p, condIn cs i)
    (hng : NGNormal c.n p) (o : Snap)
    (hsnap : ∀ w ∈ c.ts, ∀ j < c.n, (run compare (p.take (o j).2) (initOf c.n w)).regs (o j).1 = ((j : Nat) : Int)) :
    False := by
  simp only [checkNG2, Bool.and_eq_true, beq_iff_eq, List.all_eq_true] at hchk
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
  have hprisT : ∀ d, PrisT c (p.take d) (stAt d) := by
    intro d
    induction d with
    | zero =>
      intro r hr hna w hw
      simp only [stAt, List.take_zero, run_nil, initOf, relaxInit]
      rw [if_neg (by omega)]
    | succ d ih =>
      rcases Nat.lt_or_ge d p.length with hdl | hdl
      · have e1 : p.take (d + 1) = p.take d ++ [p[d]] := List.take_succ_eq_append_getElem hdl
        rw [e1, hstep d hdl]; exact prisT_step c ih p[d]
      · have e1 : p.take (d + 1) = p.take d := by
          rw [List.take_of_length_le (by omega), List.take_of_length_le (by omega)]
        have e2 : stAt (d + 1) = stAt d := by
          funext w; simp only [stAt]; rw [e1]
        rw [e1, e2]; exact ih
  have hprisV : ∀ d (f : List Int → List Int), (∀ w ∈ c.ts, f w ∈ c.ts) → PrisT c (p.take d) (view (stAt d) f) :=
    fun d f hf r hr hna w hw => hprisT d r hr hna (f w) (hf w hw)
  have Inv : ∀ d, d ≤ p.length → ∃ k g x f, (k, g) ∈ S ∧ (∀ w ∈ c.ts, f w ∈ c.ts) ∧
      g + Phi c B (view (stAt d) f) ≤ d ∧ k = norm c x ∧
      RelW c B (view (stAt d) f) k ∧ GamOK c B (p.take d) (view (stAt d) f) k ∧
      ∀ j < c.n, tm j ≤ d → k.done.getD j false = true := by
    intro d
    induction d with
    | zero =>
      intro _
      let k0 : Key := { cols := (List.range c.n).map (fun i => c.ts.map (fun w => w.getD i 0))
                        flag := List.replicate c.m .eq, done := List.replicate c.n false }
      have hR0 : RelW c B (stAt 0) (norm c k0) := rel_normW c hc ((rel_init c hc E).toW c hc)
      have hphi : Phi c B (stAt 0) = 0 := phi_init c hc hs E
      have hG0 : GamOK c B (p.take 0) (stAt 0) (norm c k0) := by
        right
        have : nGarb c B (p.take 0) (stAt 0) = 0 := by
          simp only [nGarb, List.length_eq_zero_iff, List.filter_eq_nil_iff, Bool.and_eq_true, decide_eq_true_eq]
          intro r _ ⟨ha, hT⟩
          simp only [List.take_zero, accd, List.not_mem_nil, false_and, exists_false, or_false] at ha
          apply hs.inT r ha
          rw [← hT]; simp [colOf, stAt, initOf, relaxInit, ha, xOf]
        omega
      obtain ⟨f, hf, hRf, hPf, hGf, x, hx, hxd⟩ := canon_relNG c hc hgo hR0 hG0
      refine ⟨canon c G (root c), 0, x, f, hlook _ _ hroot, hf, by omega, hx, hRf, hGf, ?_⟩
      intro j hj htm
      exact done_of_mem_norm c hx hj (pres_mem c hc hRf hj (pres_view c hf (hpres 0 j hj (by omega))))
    | succ d ih =>
      intro hd1
      obtain ⟨k, g, x, f, hkS, hf, hgd, hkx, hR, hGk, hdone⟩ := ih (by omega)
      have hdl : d < p.length := by omega
      have hk := hall (k, g) hkS
      simp only [Bool.and_eq_true, Bool.not_eq_true', List.all_eq_true] at hk
      obtain ⟨_, hsucc⟩ := hk
      let i := p[d]
      have hiP : i ∈ p := List.getElem_mem hdl
      have hngd : ngOK c.n (p.take d) i := hng d hdl
      obtain ⟨w, hw, hcase⟩ := ngStep c hc cs hsw hR hGk (hprisV d f hf) i (hB i hiP) (hcs i hiP) hngd
      have hv : stepMS (view (stAt d) f) i = view (stAt (d + 1)) f := by rw [hstep d hdl]; rfl
      have htk : p.take d ++ [i] = p.take (d + 1) := (List.take_succ_eq_append_getElem hdl).symm
      rw [hv, htk] at hcase
      rw [hv] at hw
      rcases hcase with ⟨hw0, hR', hG'⟩ | ⟨y, hy, hmem, hR', hG'⟩
      · refine ⟨k, g, x, f, hkS, hf, by omega, hkx, hR', hG', ?_⟩
        intro j hj htm
        rcases Nat.lt_or_ge (tm j) (d + 1) with hlt | hge
        · exact hdone j hj (by omega)
        · exact done_of_mem_norm c hkx hj
            (pres_mem c hc hR' hj (pres_view c hf (hpres (d + 1) j hj (by omega))))
      · obtain ⟨f2, hf2, hR2, hP2, hG2, x2, hx2, hx2d⟩ := canon_relNG c hc hgo hR' hG'
        have hff : ∀ u ∈ c.ts, f (f2 u) ∈ c.ts := fun u hu => hf _ (hf2 u hu)
        replace hR2 : RelW c B (view (stAt (d + 1)) (fun u => f (f2 u))) (canon c G (norm c y)) := hR2
        replace hP2 : Phi c B (view (stAt (d + 1)) (fun u => f (f2 u))) = Phi c B (view (stAt (d + 1)) f) := hP2
        replace hG2 : GamOK c B (p.take (d + 1)) (view (stAt (d + 1)) (fun u => f (f2 u))) (canon c G (norm c y)) := hG2
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
        have hhB := hB_le_h c (canon c G (norm c y)) (KB + 3 - (g + w))
        have hql : q.length = p.length - (d + 1) := by simp [q]
        have hok := hsucc (norm c y, w) hmem
        have hraw : ¬ (KB < g + w + (undone c (norm c y)).length) ∧ dead c (norm c y) = false ∧
            ¬ (KB < g + w + LeanReflect.hB c (norm c y) (KB + 3 - (g + w))) := by
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
          have hhr := h_le c hc hR' hA0 hF0
          have hhBr := hB_le_h c (norm c y) (KB + 3 - (g + w))
          refine ⟨by omega, not_dead c hc hR' hF0, by omega⟩
        simp only [fastOK2, hraw.1, hraw.2.1, hraw.2.2, decide_false, Bool.false_or] at hok
        simp only [succOKG, hnd, Bool.or_false, Bool.or_eq_true, decide_eq_true_eq] at hok
        rcases hok with hlook' | hlt
        · cases hg' : look (canon c G (norm c y)) with
          | none => rw [hg'] at hlook'; simp at hlook'
          | some g' =>
            rw [hg'] at hlook'
            simp only [decide_eq_true_eq] at hlook'
            exact ⟨canon c G (norm c y), g', x2, fun u => f (f2 u), hlook _ _ hg', hff, by omega, hx2, hR2, hG2, hdone'⟩
        · exfalso; omega
  obtain ⟨k, g, x, f, hkS, _, _, _, _, _, hdone⟩ := Inv p.length (Nat.le_refl _)
  have hk := hall (k, g) hkS
  simp only [Bool.and_eq_true, Bool.not_eq_true'] at hk
  have hgoal : isGoal c k = true := by
    simp only [isGoal, undone, List.isEmpty_iff, List.filter_eq_nil_iff]
    intro j hj
    have hjn := List.mem_range.1 hj
    rw [hdone j hjn (Nat.min_le_right _ _)]; simp
  rw [hgoal] at hk; exact absurd hk.1 (by decide)


end

theorem lower_bound_NG2 (n KB : Nat) (cs : List Cond) (G : List (List Nat)) (hc : CtxOK (mkCtx n))
    (hs : SetCtxOK (mkCtx n)) (hgo : GroupOK (mkCtx n) G) (hsw : ∀ x ∈ cs, x.swap ∈ cs)
    (S : List (Key × Nat)) (look : Key → Option Nat) (hlook : ∀ k g, look k = some g → (k, g) ∈ S)
    (hcert : checkNG2 (mkCtx n) G cs KB S look = true) (p : Program) (o : Snap) (hp : p.length ≤ KB)
    (hcs : ∀ i ∈ p, condIn cs i) (hng : NGNormal n p)
    (hrel : ∀ x : Nat → Int, (∀ i < n, 0 ≤ x i ∧ x i < n) → SortsOK n x (snapOut p o (relaxInit n x n))) : False := by
  apply checkNG2_sound (mkCtx n) hc hs G hgo cs hsw KB S look hlook hcert p hp hcs hng o
  intro w hw j hj
  have hx : ∀ i < n, 0 ≤ xOf w i ∧ xOf w i < (n : Int) := by
    intro i hi
    refine ⟨?_, hc.lt w hw i hi⟩
    have hmem : xOf w i ∈ (List.range n).map (fun (j : Nat) => ((j : Nat) : Int)) :=
      (hc.perm w hw).subset (List.mem_map.2 ⟨i, List.mem_range.2 hi, rfl⟩)
    obtain ⟨a, _, e⟩ := List.mem_map.1 hmem
    rw [← e]; omega
  have hsort := hrel (xOf w) hx
  simp only [SortsOK] at hsort
  have hs' : ((List.range n).map (xOf w)).mergeSort (fun a b => decide (a ≤ b))
      = (List.range n).map (fun (j : Nat) => ((j : Nat) : Int)) := sorted_of_perm n _ (hc.perm w hw)
  rw [hs'] at hsort
  have := (List.map_inj_left.1 hsort) j (List.mem_range.2 hj)
  simp only [snapOut] at this
  exact this


theorem lower_bound_strict2 (n KB : Nat) (hn2 : 2 ≤ n) (hn : n < 2 ^ 31 - 1) (G : List (List Nat))
    (hc : CtxOK (mkCtx n)) (hs : SetCtxOK (mkCtx n)) (hgo : GroupOK (mkCtx n) G)
    (S : List (Key × Nat)) (look : Key → Option Nat) (hlook : ∀ k g, look k = some g → (k, g) ∈ S)
    (hcert : checkNG2 (mkCtx n) G I1 KB S look = true) :
    ∀ (p : Program) (o : Snap), p.length ≤ KB → ¬ XSnap n p o := by
  intro p o hp hx
  obtain ⟨q, hql, hqn, hqr⟩ := NGR.ng_rewrite hn2 hn hx
  exact lower_bound_NG2 n KB I1 G hc hs hgo swap_I1 S look hlook hcert q o (by omega)
    (fun i _ => condIn_I1 i) hqn hqr

end LeanReflect
