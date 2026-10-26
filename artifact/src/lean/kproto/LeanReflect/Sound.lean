import LeanReflect.Class
import SortProof.Snap
/-
  Main soundness theorem: if `check` accepts, no program of length ≤ KB is RS-correct on the tests;
  hence (tests ⊆ inputs) no program of length ≤ KB satisfies `RelaxedSnap n p o` (lean's frozen v1 API).
-/
namespace LeanReflect
open SortProof
set_option linter.unusedSectionVars false
set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false
open Classical

theorem getD_range {n j : Nat} (h : j < n) (d : Nat) : (List.range n).getD j d = j := by
  simp [List.getD_eq_getElem?_getD, h]

theorem getD_map_swap (l : List Ordering) (i : Nat) :
    (l.map Ordering.swap).getD i .eq = (l.getD i .eq).swap := by
  simp only [List.getD_eq_getElem?_getD, List.getElem?_map]
  cases l[i]? <;> rfl

section
variable (c : Ctx)

theorem colOf_pres (hc : CtxOK c) {st : MS} {j r : Nat} (hj : j < c.n)
    (hr : ∀ w ∈ c.ts, (st w).regs r = ((j : Nat) : Int)) : colOf c st r = c.tc.getD j [] := by
  rw [hc.htc, getD_map_lt _ _ j (by simpa using hj) [] 0, getD_range hj, hc.hm]
  simp only [colOf]
  rw [List.map_congr_left hr, List.map_const']

theorem tc_ne_T (hc : CtxOK c) {j : Nat} (hj : j < c.n) : c.tc.getD j [] ≠ c.T := by
  intro h
  have hm0 : 0 < c.m := by rw [hc.hm]; exact List.length_pos_iff.2 hc.ne
  have e1 : c.tc.getD j [] = List.replicate c.m ((j : Nat) : Int) := by
    rw [hc.htc, getD_map_lt _ _ j (by rw [List.length_range]; exact hj) [] 0, getD_range hj]
  rw [e1, hc.hT] at h
  have h1 := congrArg (fun l => l.getD 0 (0 : Int)) h
  simp [List.getD_eq_getElem?_getD, hm0] at h1
  omega

theorem pres_mem (hc : CtxOK c) {B : Nat} {st : MS} {k : Key} (hR : RelW c B st k) {j : Nat}
    (hj : j < c.n) (hp : Pres c st j) : c.tc.getD j [] ∈ k.cols := by
  obtain ⟨r, hr⟩ := hp
  have hcol := colOf_pres c hc hj hr
  have hrB : r < B := by
    rcases Nat.lt_or_ge r B with h | h
    · exact h
    · obtain ⟨w0, hw0⟩ := List.exists_mem_of_ne_nil _ hc.ne
      have := hR.hi r h w0; rw [hr w0 hw0] at this; omega
  rw [← hcol]
  exact hR.sub _ hrB (by rw [hcol]; exact tc_ne_T c hc hj)

/-- Undone outputs of a normalized key are absent. -/
theorem undone_absent (hc : CtxOK c) {B : Nat} {st : MS} (x : Key) (hR : RelW c B st (norm c x))
    (j : Nat) (hj : j ∈ undone c (norm c x)) : ¬ Pres c st j := by
  intro hp
  have hjn : j < c.n := by simp [undone] at hj; exact hj.1
  have hd : (norm c x).done.getD j false = false := by simp [undone] at hj; simpa using hj.2
  rw [norm_done c x j hjn] at hd
  simp only [Bool.or_eq_false_iff] at hd
  have hmem := pres_mem c hc hR hjn hp
  simp only [norm] at hmem
  have : x.cols.contains (c.tc.getD j []) = true :=
    List.contains_iff_mem.2 ((List.mergeSort_perm x.cols colLe).mem_iff.1 hmem)
  rw [hd.2] at this; exact absurd this (by decide)

theorem sig_eqv (hc : CtxOK c) {B : Nat} {st : MS} {k : Key} (hR : RelW c B st k) {a b : Nat}
    (ha : a < c.m) (hb : b < c.m) (h : stateSig c k a = stateSig c k b) : Eqv c st a b := by
  simp only [stateSig, Prod.mk.injEq] at h
  obtain ⟨hf, hcols⟩ := h
  have hfa : (st (tsAt c a)).flag = (flagOf c st).getD a .eq := by
    simp only [flagOf]; rw [getD_map_lt _ _ a (hc.hm ▸ ha) _ []]; rfl
  have hfb : (st (tsAt c b)).flag = (flagOf c st).getD b .eq := by
    simp only [flagOf]; rw [getD_map_lt _ _ b (hc.hm ▸ hb) _ []]; rfl
  refine ⟨?_, fun r => ?_⟩
  · rw [hfa, hfb]
    rcases hR.fl with hfl | hfl
    · rw [hfl]; exact hf
    · rw [hfl, getD_map_swap, getD_map_swap, hf]
  · have hwa := tsAt_mem c hc ha
    have hwb := tsAt_mem c hc hb
    have hidxT : ∀ w ∈ c.ts, w.idxOf (c.n : Int) = c.n := fun w hw => by
      rw [List.idxOf_eq_length (hc.noT w hw), hc.len w hw]
    rcases Nat.lt_or_ge r B with hrB | hrB
    · by_cases hT : colOf c st r = c.T
      · have ea := getD_colOf c hc st r a ha
        have eb := getD_colOf c hc st r b hb
        rw [hT, getD_T c hc a ha] at ea
        rw [hT, getD_T c hc b hb] at eb
        simp only [tsAt]
        rw [← ea, ← eb, hidxT (c.ts.getD a []) hwa, hidxT (c.ts.getD b []) hwb]
      · have := (List.map_inj_left.1 hcols) _ (hR.sub _ hrB hT)
        rw [getD_colOf c hc st r a ha, getD_colOf c hc st r b hb] at this
        exact this
    · simp only [tsAt]
      rw [hR.hi r hrB, hR.hi r hrB, hidxT (c.ts.getD a []) hwa, hidxT (c.ts.getD b []) hwb]

theorem hc_le (hc : CtxOK c) {B : Nat} {st : MS} {k : Key} {q : Program} (hR : RelW c B st k)
    (hA : ∀ j ∈ undone c k, ¬ Pres c st j) (hF : Fut c st q (undone c k)) : LeanReflect.hc c k ≤ ncmp q := by
  simp only [LeanReflect.hc]
  apply clog2_le
  apply maxList_le
  intro x hx
  obtain ⟨i, hi, rfl⟩ := List.mem_map.1 hx
  have him : i < c.m := List.mem_range.1 hi
  have hsg : ∀ a, a < c.m → ((List.range c.m).map (stateSig c k)).getD a (.eq, []) = stateSig c k a :=
    fun a ha => by rw [getD_map_lt _ _ a (by simpa using ha) _ 0, getD_range ha]
  have hus : ∀ a, a < c.m → ((List.range c.m).map (usig c k)).getD a [] = usigU c (undone c k) a :=
    fun a ha => by rw [getD_map_lt _ _ a (by simpa using ha) _ 0, getD_range ha]; rfl
  let Cl := (List.range c.m).filter fun i' =>
    ((List.range c.m).map (stateSig c k)).getD i' (.eq, []) == ((List.range c.m).map (stateSig c k)).getD i (.eq, [])
  have hCl : ∀ a ∈ Cl, a < c.m ∧ stateSig c k a = stateSig c k i := by
    intro a ha
    have h1 := List.mem_filter.1 ha
    have ham : a < c.m := List.mem_range.1 h1.1
    refine ⟨ham, ?_⟩
    have := beq_iff_eq.1 h1.2
    rwa [hsg a ham, hsg i him] at this
  have h1 : dc (fun i' => ((List.range c.m).map (usig c k)).getD i' []) Cl ≤ dc (usigU c (undone c k)) Cl := by
    apply dc_mono
    intro a ha b hb hab
    rw [hus a (hCl a ha).1, hus b (hCl b hb).1]; exact hab
  have h2 := class_le c hc q st (undone c k) Cl (fun a ha => (hCl a ha).1) hR.vals
    (fun a ha b hb => sig_eqv c hc hR (hCl a ha).1 (hCl b hb).1 ((hCl a ha).2.trans (hCl b hb).2.symm)) hA hF
  exact Nat.le_trans h1 h2

theorem h_le (hc : CtxOK c) {B : Nat} {st : MS} {k : Key} {q : Program} (hR : RelW c B st k)
    (hA : ∀ j ∈ undone c k, ¬ Pres c st j) (hF : Fut c st q (undone c k)) : h c k ≤ q.length := by
  have h1 := hc_le c hc hR hA hF
  have h2 := und_le c hc q st (undone c k) (List.nodup_range.filter _) hA hF
  have h3 := ncmp_add_nwr q
  simp only [h]; omega

/-! ## the main induction -/

theorem le_sum_of_mem : ∀ {l : List Nat} {r : Nat}, r ∈ l → r ≤ l.sum
  | a :: l, r, h => by
    rcases List.mem_cons.1 h with h | h
    · subst h; simp
    · have := le_sum_of_mem h; simp; omega

theorem take_min_len (p : Program) (t : Nat) : p.take (min t p.length) = p.take t := by
  rcases Nat.le_total t p.length with h | h
  · rw [Nat.min_eq_left h]
  · rw [Nat.min_eq_right h, List.take_length, List.take_of_length_le h]

theorem rel_init (hc : CtxOK c) (E : Nat) :
    Rel c (c.n + E) (fun w => initOf c.n w)
      { cols := (List.range c.n).map (fun i => c.ts.map (fun w => w.getD i 0))
        flag := List.replicate c.m .eq, done := List.replicate c.n false } := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro r hr w
    simp only [initOf, relaxInit]
    rw [if_neg (by omega)]
  · intro col hcol
    simp only [regCols, List.range_add, List.map_append, List.count_append, List.map_map]
    have e1 : (List.range c.n).map (colOf c (fun w => initOf c.n w)) =
        (List.range c.n).map (fun i => c.ts.map (fun w => w.getD i 0)) := by
      apply List.map_congr_left; intro i hi
      have hi' := List.mem_range.1 hi
      simp [colOf, initOf, relaxInit, hi', xOf]
    have e2 : ((List.range E).map (colOf c (fun w => initOf c.n w) ∘ (c.n + ·))).count col = 0 := by
      apply List.count_eq_zero.2
      intro hm
      obtain ⟨r, _, hr⟩ := List.mem_map.1 hm
      apply hcol; rw [← hr]
      simp only [Function.comp, colOf, initOf, relaxInit]
      rw [hc.hT, hc.hm]
      simp only [show ¬ (c.n + r < c.n) from by omega, if_false]
      exact List.map_const'
    rw [e1, e2]; simp
  · left; simp [flagOf, initOf, relaxInit, hc.hm, List.map_const']
  · intro w hw r
    simp only [initOf, relaxInit]
    split
    · left; simp only [xOf]
      rename_i hr
      have : r < w.length := by rw [hc.len w hw]; exact hr
      simp [List.getD_eq_getElem?_getD, this]
    · right; rfl

theorem check_sound (hc : CtxOK c) (cs : List Cond) (hsw : ∀ x ∈ cs, x.swap ∈ cs) (KB : Nat)
    (S : List (Key × Nat)) (look : Key → Option Nat) (hlook : ∀ k g, look k = some g → (k, g) ∈ S)
    (hchk : check c cs KB S look = true) (p : Program) (hp : p.length ≤ KB) (hcs : ∀ i ∈ p, condIn cs i)
    (o : Snap)
    (hsnap : ∀ w ∈ c.ts, ∀ j < c.n, (run compare (p.take (o j).2) (initOf c.n w)).regs (o j).1 = ((j : Nat) : Int)) :
    False := by
  simp only [check, Bool.and_eq_true, beq_iff_eq, List.all_eq_true] at hchk
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
  have Inv : ∀ d, d ≤ p.length → ∃ k g x, (k, g) ∈ S ∧ g ≤ d ∧ k = norm c x ∧ Rel c B (stAt d) k ∧
      ∀ j < c.n, tm j ≤ d → k.done.getD j false = true := by
    intro d
    induction d with
    | zero =>
      intro _
      let k0 : Key := { cols := (List.range c.n).map (fun i => c.ts.map (fun w => w.getD i 0))
                        flag := List.replicate c.m .eq, done := List.replicate c.n false }
      have hR0 : Rel c B (stAt 0) k0 := rel_init c hc E
      refine ⟨root c, 0, k0, hlook _ _ hroot, Nat.le_refl 0, rfl, rel_norm c hc hR0, ?_⟩
      intro j hj htm
      have hp : Pres c (stAt 0) j := ⟨(o j).1, fun w hw => by
        have := hsn w hw j hj; rwa [show tm j = 0 by omega] at this⟩
      have := pres_mem c hc (hR0.toW c hc) hj hp
      show (norm c k0).done.getD j false = true
      rw [norm_done c k0 j hj, List.contains_iff_mem.2 this]; simp
    | succ d ih =>
      intro hd1
      obtain ⟨k, g, x, hkS, hgd, hkx, hR, hdone⟩ := ih (by omega)
      have hdl : d < p.length := by omega
      have hk := hall (k, g) hkS
      simp only [Bool.and_eq_true, Bool.not_eq_true', List.all_eq_true] at hk
      obtain ⟨_, hsucc⟩ := hk
      let i := p[d]
      have hiP : i ∈ p := List.getElem_mem hdl
      obtain ⟨a, ha, hRa⟩ := sim c hc cs hsw hR i (hB i hiP) (hcs i hiP)
      rw [← hstep d hdl] at hRa
      let k' := norm c (a.apply c k)
      have hR' : Rel c B (stAt (d + 1)) k' := rel_norm c hc hRa
      have hk'mem : k' ∈ succs c cs k := List.mem_map.2 ⟨a, ha, rfl⟩
      have hdone' : ∀ j < c.n, tm j ≤ d + 1 → k'.done.getD j false = true := by
        intro j hj htm
        show (norm c (a.apply c k)).done.getD j false = true
        rw [norm_done c _ j hj, apply_done]
        rcases Nat.lt_or_ge (tm j) (d + 1) with hlt | hge
        · rw [hdone j hj (by omega)]; simp
        · have hp : Pres c (stAt (d + 1)) j := ⟨(o j).1, fun w hw => by
            have := hsn w hw j hj; rwa [show tm j = d + 1 by omega] at this⟩
          rw [List.contains_iff_mem.2 (pres_mem c hc (hRa.toW c hc) hj hp)]; simp
      -- the remaining program
      let q := p.drop (d + 1)
      have hF : Fut c (stAt (d + 1)) q (undone c k') := by
        intro j hj
        have hjn : j < c.n := by simp [undone] at hj; exact hj.1
        have hnd : k'.done.getD j false = false := by simp [undone] at hj; simpa using hj.2
        have hlt : d + 1 < tm j := by
          rcases Nat.lt_or_ge (d + 1) (tm j) with h | h
          · exact h
          · rw [hdone' j hjn h] at hnd; exact absurd hnd (by decide)
        have htmle : tm j ≤ p.length := Nat.min_le_right _ _
        refine ⟨tm j - (d + 1), by simp [q]; omega, (o j).1, fun w hw => ?_⟩
        have := hsn w hw j hjn
        rw [show tm j = (d + 1) + (tm j - (d + 1)) by omega, List.take_add, run_append] at this
        exact this
      have hA := undone_absent c hc (a.apply c k) (hR'.toW c hc)
      have hnd := not_dead c hc (hR'.toW c hc) hF
      have hh := h_le c hc (hR'.toW c hc) hA hF
      have hql : q.length = p.length - (d + 1) := by simp [q]
      have hok := hsucc k' hk'mem
      simp only [succOK, hnd, Bool.or_false, Bool.or_eq_true, decide_eq_true_eq] at hok
      rcases hok with hlook' | hlt
      · cases hg' : look k' with
        | none => rw [hg'] at hlook'; simp at hlook'
        | some g' =>
          rw [hg'] at hlook'
          simp only [decide_eq_true_eq] at hlook'
          exact ⟨k', g', a.apply c k, hlook _ _ hg', by omega, rfl, hR', hdone'⟩
      · exfalso; omega
  obtain ⟨k, g, x, hkS, _, _, _, hdone⟩ := Inv p.length (Nat.le_refl _)
  have hk := hall (k, g) hkS
  simp only [Bool.and_eq_true, Bool.not_eq_true'] at hk
  have hgoal : isGoal c k = true := by
    simp only [isGoal, undone, List.isEmpty_iff, List.filter_eq_nil_iff]
    intro j hj
    have hjn := List.mem_range.1 hj
    rw [hdone j hjn (Nat.min_le_right _ _)]; simp
  rw [hgoal] at hk; exact absurd hk.1 (by decide)
end

/-! ## the user-facing lower bound -/

theorem condIn_I1 (i : Instr) : condIn I1 i := by
  cases i with
  | cmov cd _ _ => cases cd <;> simp [condIn, I1]
  | _ => trivial

theorem swap_I1 : ∀ x ∈ I1, x.swap ∈ I1 := by decide
theorem swap_I0 : ∀ x ∈ I0, x.swap ∈ I0 := by decide

theorem eq_of_perm_of_pairwise : ∀ {l1 l2 : List Int}, l1.Perm l2 →
    l1.Pairwise (fun a b => decide (a ≤ b) = true) → l2.Pairwise (fun a b => decide (a ≤ b) = true) → l1 = l2
  | [], l2, hp, _, _ => List.Perm.nil_eq hp
  | a :: t1, [], hp, _, _ => absurd (List.Perm.nil_eq hp.symm) (by simp)
  | a :: t1, b :: t2, hp, h1, h2 => by
    have ha : a ∈ b :: t2 := hp.subset (List.mem_cons_self)
    have hb : b ∈ a :: t1 := hp.symm.subset (List.mem_cons_self)
    have hab : a ≤ b := by
      rcases List.mem_cons.1 hb with e | e
      · omega
      · have := (List.pairwise_cons.1 h1).1 b e; simpa using this
    have hba : b ≤ a := by
      rcases List.mem_cons.1 ha with e | e
      · omega
      · have := (List.pairwise_cons.1 h2).1 a e; simpa using this
    have e : a = b := by omega
    subst e
    rw [eq_of_perm_of_pairwise (List.Perm.cons_inv hp) (List.pairwise_cons.1 h1).2 (List.pairwise_cons.1 h2).2]

theorem sorted_of_perm (n : Nat) (l : List Int)
    (hp : l.Perm ((List.range n).map fun (j : Nat) => ((j : Nat) : Int))) :
    l.mergeSort (fun a b => decide (a ≤ b)) = (List.range n).map fun (j : Nat) => ((j : Nat) : Int) := by
  apply eq_of_perm_of_pairwise ((List.mergeSort_perm _ _).trans hp)
  · apply List.pairwise_mergeSort
    · intro a b c h1 h2; simp at *; omega
    · intro a b; simp; omega
  · rw [List.pairwise_map]
    apply List.Pairwise.imp _ (List.pairwise_lt_range (n := n))
    intro a b h; simp; omega

/-- If the certificate check accepts, no program of length ≤ KB is correct in the relaxed RS model. -/
theorem lower_bound (n KB : Nat) (cs : List Cond) (hc : CtxOK (mkCtx n)) (hsw : ∀ x ∈ cs, x.swap ∈ cs)
    (hcert : certOK n cs KB = true) :
    ∀ (p : Program) (o : Snap), p.length ≤ KB → (∀ i ∈ p, condIn cs i) → ¬ RelaxedSnap n p o := by
  intro p o hp hcs hrs
  let c := mkCtx n
  let S := search c cs KB
  have hlook : ∀ k g, S[k]? = some g → (k, g) ∈ S.toList :=
    fun k g h => Std.HashMap.mem_toList_iff_getElem?_eq_some.2 h
  apply check_sound c hc cs hsw KB S.toList (fun k => S[k]?) hlook hcert p hp hcs o
  intro w hw j hj
  have hx : ∀ i < n, xOf w i < (n : Int) := hc.lt w hw
  have hsort := hrs (xOf w) n hx
  simp only [SortsOK] at hsort
  have hs : ((List.range n).map (xOf w)).mergeSort (fun a b => decide (a ≤ b))
      = (List.range n).map (fun (j : Nat) => ((j : Nat) : Int)) := sorted_of_perm n _ (hc.perm w hw)
  rw [hs] at hsort
  have := (List.map_inj_left.1 hsort) j (List.mem_range.2 hj)
  simp only [snapOut] at this
  exact this

end LeanReflect

namespace LeanReflect
open SortProof

theorem task_spawn_get {α : Type} (f : Unit → α) (prio : Task.Priority) : (Task.spawn f prio).get = f () := rfl

theorem checkPar_check (c : Ctx) (cs : List Cond) (KB T : Nat) (hT : 0 < T) (S : List (Key × Nat))
    (look : Key → Option Nat) (h : checkPar c cs KB T S look = true) : check c cs KB S look = true := by
  simp only [checkPar, Bool.and_eq_true, List.all_eq_true, List.mem_map, List.mem_range] at h
  obtain ⟨hroot, hall⟩ := h
  simp only [check, Bool.and_eq_true, List.all_eq_true]
  refine ⟨hroot, fun e he => ?_⟩
  have hr : shareOf T e.1 < T := Nat.mod_lt _ hT
  have := hall _ ⟨shareOf T e.1, hr, rfl⟩
  rw [task_spawn_get] at this
  simp only [List.all_eq_true, List.mem_filter] at this
  have h2 := this e ⟨he, by simp⟩
  simpa only [Bool.and_eq_true, List.all_eq_true] using h2

theorem lower_bound_par (n KB T : Nat) (cs : List Cond) (hc : CtxOK (mkCtx n)) (hsw : ∀ x ∈ cs, x.swap ∈ cs)
    (hT : 0 < T) (hcert : certOKPar n cs KB T = true) :
    ∀ (p : Program) (o : Snap), p.length ≤ KB → (∀ i ∈ p, condIn cs i) → ¬ RelaxedSnap n p o := by
  intro p o hp hcs hrs
  let c := mkCtx n
  let S := searchPar c cs KB T
  have hlook : ∀ k g, S[k]? = some g → (k, g) ∈ S.toList :=
    fun k g h => Std.HashMap.mem_toList_iff_getElem?_eq_some.2 h
  apply check_sound c hc cs hsw KB S.toList (fun k => S[k]?) hlook
    (checkPar_check c cs KB T hT _ _ hcert) p hp hcs o
  intro w hw j hj
  have hx : ∀ i < n, xOf w i < (n : Int) := hc.lt w hw
  have hsort := hrs (xOf w) n hx
  simp only [SortsOK] at hsort
  have hs : ((List.range n).map (xOf w)).mergeSort (fun a b => decide (a ≤ b))
      = (List.range n).map (fun (j : Nat) => ((j : Nat) : Int)) := sorted_of_perm n _ (hc.perm w hw)
  rw [hs] at hsort
  have := (List.map_inj_left.1 hsort) j (List.mem_range.2 hj)
  simp only [snapOut] at this
  exact this

end LeanReflect
