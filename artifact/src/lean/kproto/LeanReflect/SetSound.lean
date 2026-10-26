import LeanReflect.SetBasic
import LeanReflect.Sound
/-
  Soundness of the set-model checker `checkS` (enum's Lemma S, PRUNING.md), with the potential
  Φ = #non-T registers − #distinct non-T register columns:  abstract cost + Φ grows by ≤ 1 per instruction.
-/
namespace LeanReflect
open SortProof
set_option linter.unusedSectionVars false
set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false
open Classical

/-! ## distinct counts are permutation invariant -/

theorem any_perm {α : Type} {l1 l2 : List α} (h : l1.Perm l2) (p : α → Bool) : l1.any p = l2.any p := by
  cases e1 : l1.any p <;> cases e2 : l2.any p <;> try rfl
  · obtain ⟨x, hx, hp⟩ := List.any_eq_true.1 e2
    have := List.any_eq_true.2 ⟨x, h.symm.subset hx, hp⟩; rw [e1] at this; exact absurd this (by decide)
  · obtain ⟨x, hx, hp⟩ := List.any_eq_true.1 e1
    have := List.any_eq_true.2 ⟨x, h.subset hx, hp⟩; rw [e2] at this; exact absurd this (by decide)

theorem dc_perm {α β : Type} [BEq β] [LawfulBEq β] (f : α → β) {l1 l2 : List α} (h : l1.Perm l2) :
    dc f l1 = dc f l2 := by
  induction h with
  | nil => rfl
  | cons x _ ih => simp only [dc]; rw [any_perm (by assumption) _, ih]
  | swap x y l =>
    simp only [dc, List.any_cons]
    by_cases hxy : f x = f y
    · have hp : (fun b => f b == f y) = (fun b => f b == f x) := by rw [hxy]
      simp only [hp, hxy, beq_self_eq_true, Bool.true_or, if_true]
    · have h1 : (f x == f y) = false := by simp [hxy]
      have h2 : (f y == f x) = false := by simp [Ne.symm hxy]
      simp only [h1, h2, Bool.false_or]
      cases l.any (fun b => f b == f x) <;> cases l.any (fun b => f b == f y) <;> simp
  | trans _ _ ih1 ih2 => exact ih1.trans ih2

theorem dc_le_length {α β : Type} [BEq β] (f : α → β) : ∀ l : List α, dc f l ≤ l.length
  | [] => by simp [dc]
  | a :: l => by have := dc_le_length f l; simp only [dc]; split <;> simp <;> omega

theorem dc_nodup {β : Type} [BEq β] [LawfulBEq β] : ∀ l : List β, l.Nodup → dc id l = l.length
  | [] => fun _ => by simp [dc]
  | a :: l => fun h => by
    have ih := dc_nodup l (List.nodup_cons.1 h).2
    have hA : l.any (fun b => id b == id a) = false := by
      cases e : l.any (fun b => id b == id a)
      · rfl
      · obtain ⟨x, hx, hb⟩ := List.any_eq_true.1 e
        simp at hb; subst hb; exact absurd hx (List.nodup_cons.1 h).1
    simp only [dc, hA, Bool.false_eq_true, if_false, ih, List.length_cons]

section
variable (c : Ctx)

/-! ## the potential -/

def nonT (l : List Col) : List Col := l.filter fun x => x != c.T

def Pl (l : List Col) : Nat := (nonT c l).length - dc id (nonT c l)

def Phi (B : Nat) (st : MS) : Nat := Pl c (regCols c B st)

theorem Pl_perm {l1 l2 : List Col} (h : l1.Perm l2) : Pl c l1 = Pl c l2 := by
  simp only [Pl, nonT]
  rw [(h.filter _).length_eq, dc_perm id (h.filter _)]

theorem Pl_cons (X : Col) (R : List Col) :
    Pl c (X :: R) = Pl c R + (if X ≠ c.T ∧ X ∈ R then 1 else 0) := by
  have hle := dc_le_length id (nonT c R)
  by_cases hX : X = c.T
  · simp [Pl, nonT, hX]
  · have hnf : nonT c (X :: R) = X :: nonT c R := by simp [nonT, List.filter_cons, hX]
    have hmem : X ∈ nonT c R ↔ X ∈ R := by simp [nonT, List.mem_filter, hX]
    simp only [Pl, hnf, dc, List.length_cons]
    by_cases hR : X ∈ R
    · have hA : (nonT c R).any (fun b => id b == id X) = true :=
        List.any_eq_true.2 ⟨X, hmem.2 hR, by simp⟩
      simp only [hA, if_true]; rw [if_pos ⟨hX, hR⟩]; omega
    · have hA : (nonT c R).any (fun b => id b == id X) = false := by
        cases e : (nonT c R).any (fun b => id b == id X)
        · rfl
        · obtain ⟨x, hx, hb⟩ := List.any_eq_true.1 e
          simp at hb; subst hb; exact absurd (hmem.1 hx) hR
      simp only [hA, Bool.false_eq_true, if_false]; rw [if_neg (fun h => hR h.2)]; omega

/-- Registers other than `d`. -/
def restCols (B : Nat) (st : MS) (d : Nat) : List Col := ((List.range B).erase d).map (colOf c st)

theorem Phi_split {B d : Nat} (hd : d < B) (st : MS) :
    Phi c B st = Pl c (restCols c B st d) +
      (if colOf c st d ≠ c.T ∧ colOf c st d ∈ restCols c B st d then 1 else 0) := by
  have hp : (List.range B).Perm (d :: (List.range B).erase d) := List.perm_cons_erase (List.mem_range.2 hd)
  have := Pl_perm c (hp.map (colOf c st))
  simp only [Phi, regCols, this, List.map_cons, Pl_cons]
  rfl

theorem restCols_eq {B d : Nat} (st st' : MS) (h : ∀ r, r ≠ d → colOf c st' r = colOf c st r) :
    restCols c B st' d = restCols c B st d := by
  simp only [restCols]
  apply List.map_congr_left
  intro r hr
  exact h r (List.Nodup.mem_erase_iff List.nodup_range |>.1 hr).1

theorem mem_restCols {B d : Nat} {st : MS} {X : Col} (h : X ∈ restCols c B st d) :
    ∃ r, r < B ∧ r ≠ d ∧ colOf c st r = X := by
  obtain ⟨r, hr, e⟩ := List.mem_map.1 h
  have := (List.Nodup.mem_erase_iff List.nodup_range).1 hr
  exact ⟨r, List.mem_range.1 this.2, this.1, e⟩

theorem rel_normW (hc : CtxOK c) {B : Nat} {st : MS} {k : Key} (hR : RelW c B st k) : RelW c B st (norm c k) := by
  refine ⟨hR.hi, fun r hr hT => ?_, ?_, hR.vals⟩
  · simp only [norm]; exact (List.mergeSort_perm k.cols colLe).mem_iff.2 (hR.sub r hr hT)
  · simp only [norm]
    rcases canonF_cases k.flag with h | h <;> rw [h]
    · exact hR.fl
    · rcases hR.fl with hf | hf
      · right; rw [hf, swap_swap_map]
      · left; exact hf

theorem done_of_mem_norm {k x : Key} (hk : k = norm c x) {j : Nat} (hj : j < c.n)
    (hm : c.tc.getD j [] ∈ k.cols) : k.done.getD j false = true := by
  subst hk
  rw [norm_done c x j hj]
  simp only [norm] at hm
  rw [List.contains_iff_mem.2 ((List.mergeSort_perm x.cols colLe).mem_iff.1 hm)]; simp

/-! ## one concrete step in the set model -/

theorem mem_srcsS (hc : CtxOK c) {B : Nat} {st : MS} {k : Key} (hR : RelW c B st k) {r : Nat}
    (hr : r < B) : colOf c st r ∈ k.cols ++ [c.T] := by
  by_cases hT : colOf c st r = c.T
  · simp [hT]
  · exact List.mem_append_left _ (hR.sub r hr hT)

theorem setStep (hc : CtxOK c) (cs : List Cond) (hsw : ∀ x ∈ cs, x.swap ∈ cs)
    {B : Nat} {st : MS} {k : Key} (hR : RelW c B st k) (i : Instr) (hi : ∀ r ∈ i.regs, r < B)
    (hci : condIn cs i) :
    ∃ w, w + Phi c B (stepMS st i) ≤ Phi c B st + 1 ∧
      ((w = 0 ∧ RelW c B (stepMS st i) k) ∨
       ∃ y : Key, y.done = k.done ∧ (norm c y, w) ∈ setSuccs c cs k ∧ RelW c B (stepMS st i) (norm c y)) := by
  have hne : ∀ r, B ≤ r → ∀ (d : Nat), d < B → r ≠ d := fun r hr d hd => by omega
  cases i with
  | cmp a b =>
    have ha : a < B := hi a (by simp [Instr.regs])
    have hb : b < B := hi b (by simp [Instr.regs])
    have hP : Phi c B (stepMS st (.cmp a b)) = Phi c B st := rfl
    refine ⟨1, by omega, Or.inr ⟨{ k with flag := cmpCol (colOf c st a) (colOf c st b) },
      rfl, ?_, ?_⟩⟩
    · simp only [setSuccs]
      exact List.mem_append_left _ (List.mem_append_left _ (List.mem_flatMap.2 ⟨_, mem_srcsS c hc hR ha,
        List.mem_map.2 ⟨_, mem_srcsS c hc hR hb, rfl⟩⟩))
    · apply rel_normW c hc
      exact ⟨fun r hr w => hR.hi r hr w, fun r hr hT => hR.sub r hr hT, Or.inl (flagOf_cmp c st a b), hR.vals⟩
  | mov d src =>
    have hd : d < B := hi d (by simp [Instr.regs])
    have hs : src < B := hi src (by simp [Instr.regs])
    have hcol := colOf_mov c st d src
    have hrest := restCols_eq c (B := B) (d := d) st (stepMS st (.mov d src)) (fun r hr => by rw [hcol]; simp [hr])
    refine ⟨0, ?_, Or.inl ⟨rfl, ?_⟩⟩
    · rw [Phi_split c hd, Phi_split c hd, hrest]; split <;> split <;> omega
    · refine ⟨fun r hr w => ?_, fun r hr hT => ?_, by rw [flagOf_mov]; exact hR.fl, ?_⟩
      · simp only [stepMS, step_mov_regs, hne r hr d hd, if_false]; exact hR.hi r hr w
      · rw [hcol] at hT ⊢
        split
        · rename_i h; rw [if_pos h] at hT; exact hR.sub src hs hT
        · rename_i h; rw [if_neg h] at hT; exact hR.sub r hr hT
      · intro w hw r
        simp only [stepMS, step_mov_regs]
        split
        · exact hR.vals w hw src
        · exact hR.vals w hw r
  | cmov cd d src =>
    have hd : d < B := hi d (by simp [Instr.regs])
    have hs : src < B := hi src (by simp [Instr.regs])
    have hcd : cd ∈ cs := hci
    let st' := stepMS st (.cmov cd d src)
    let X := colOf c st d
    let S := colOf c st src
    let M := merge cd (flagOf c st) X S
    have hcol : ∀ r, colOf c st' r = if r = d then M else colOf c st r := colOf_cmov c st cd d src
    have hrest : restCols c B st' d = restCols c B st d :=
      restCols_eq c st st' (fun r hr => by rw [hcol]; simp [hr])
    have hfl : flagOf c st' = flagOf c st := flagOf_cmov c st cd d src
    have hhi : ∀ r, B ≤ r → ∀ w, (st' w).regs r = c.n := by
      intro r hr w
      simp only [st', stepMS, step_cmov_regs, hne r hr d hd, if_false]; exact hR.hi r hr w
    have hvals : Vals c st' := by
      intro w hw r
      simp only [st', stepMS, step_cmov_regs]
      split
      · split
        · exact hR.vals w hw src
        · exact hR.vals w hw d
      · exact hR.vals w hw r
    -- abstract condition with the key's polarity
    obtain ⟨cd', hcd', hM⟩ : ∃ cd', cd' ∈ cs ∧ merge cd' k.flag X S = M := by
      rcases hR.fl with hf | hf
      · exact ⟨cd, hcd, by simp only [M]; rw [hf]⟩
      · exact ⟨cd.swap, hsw cd hcd, by simp only [M]; rw [hf, merge_swap]⟩
    have hPhi' : Phi c B st' = Pl c (restCols c B st d) + (if M ≠ c.T ∧ M ∈ restCols c B st d then 1 else 0) := by
      rw [Phi_split c hd, hrest, hcol d, if_pos rfl]
    have hPhi : Phi c B st = Pl c (restCols c B st d) + (if X ≠ c.T ∧ X ∈ restCols c B st d then 1 else 0) :=
      Phi_split c hd st
    -- covering of the other registers
    have hother : ∀ A : List Col, (∀ r, r < B → r ≠ d → colOf c st r ≠ c.T → colOf c st r ∈ A) → M ∈ A →
        RelW c B st' { k with cols := A } := by
      intro A hA hMA
      refine ⟨hhi, fun r hr hT => ?_, by rw [hfl]; exact hR.fl, hvals⟩
      rw [hcol] at hT ⊢
      split
      · exact hMA
      · rename_i h; rw [if_neg h] at hT; exact hA r hr h hT
    have hkeep : (M = c.T ∨ M ∈ k.cols) → RelW c B st' k := by
      intro hMk
      refine ⟨hhi, fun r hr hT => ?_, by rw [hfl]; exact hR.fl, hvals⟩
      rw [hcol] at hT ⊢
      split
      · rename_i h; rw [if_pos h] at hT
        rcases hMk with h1 | h1
        · exact absurd h1 hT
        · exact h1
      · rename_i h; rw [if_neg h] at hT; exact hR.sub r hr hT
    by_cases hMX : M = X
    · -- no change of any column
      refine ⟨0, ?_, Or.inl ⟨rfl, ?_⟩⟩
      · rw [hPhi', hPhi, hMX]; omega
      · refine ⟨hhi, fun r hr hT => ?_, by rw [hfl]; exact hR.fl, hvals⟩
        have e : colOf c st' r = colOf c st r := by rw [hcol]; split <;> simp_all [X]
        rw [e] at hT ⊢; exact hR.sub r hr hT
    by_cases hMT : M = c.T
    · refine ⟨0, ?_, Or.inl ⟨rfl, hkeep (Or.inl hMT)⟩⟩
      rw [hPhi', hPhi, if_neg (fun h => h.1 hMT)]; omega
    by_cases hMA : M ∈ k.cols
    · refine ⟨0, ?_, Or.inl ⟨rfl, hkeep (Or.inr hMA)⟩⟩
      rw [hPhi', hPhi]; split <;> split <;> omega
    have hMR : M ∉ restCols c B st d := by
      intro h
      obtain ⟨r, hr, _, e⟩ := mem_restCols c h
      exact hMA (e ▸ hR.sub r hr (by rw [e]; exact hMT))
    have hcov : ∀ r, r < B → r ≠ d → colOf c st r ≠ c.T → colOf c st r ∈ k.cols :=
      fun r hr _ hT => hR.sub r hr hT
    have hcontains : k.cols.contains M = false := by
      cases e : k.cols.contains M
      · rfl
      · exact absurd (List.contains_iff_mem.1 e) hMA
    by_cases hXT : X = c.T
    · -- cmov on a T register: {M} ∪ A, cost 1
      refine ⟨1, ?_, Or.inr ⟨{ k with cols := M :: k.cols }, rfl, ?_, ?_⟩⟩
      · rw [hPhi', hPhi, if_neg (fun h => hMR h.2), if_neg (fun h => h.1 hXT)]; omega
      · simp only [setSuccs]
        apply List.mem_append_right
        refine List.mem_flatMap.2 ⟨S, mem_srcsS c hc hR hs, List.mem_flatMap.2 ⟨cd', hcd', ?_⟩⟩
        have e : merge cd' k.flag c.T S = M := by rw [← hXT]; exact hM
        simp only [e, hcontains, Bool.or_false]
        simp [hMT]
      · exact rel_normW c hc (hother _ (fun r hr hrd hT => List.mem_cons_of_mem _ (hcov r hr hrd hT))
          List.mem_cons_self)
    have hXA : X ∈ k.cols := hR.sub d hd hXT
    have hcond : (M == X || M == c.T || k.cols.contains M) = false := by
      simp [hMX, hMT, hcontains, hMA]
    by_cases hXR : X ∈ restCols c B st d
    · -- X is still held by another register: copy, cost 2
      refine ⟨2, ?_, Or.inr ⟨{ k with cols := M :: k.cols }, rfl, ?_, ?_⟩⟩
      · rw [hPhi', hPhi, if_neg (fun h => hMR h.2), if_pos ⟨hXT, hXR⟩]; omega
      · simp only [setSuccs]
        apply List.mem_append_left; apply List.mem_append_right
        refine List.mem_flatMap.2 ⟨X, hXA, List.mem_flatMap.2 ⟨S, mem_srcsS c hc hR hs,
          List.mem_flatMap.2 ⟨cd', hcd', ?_⟩⟩⟩
        simp only [hM, hcond]; simp
      · exact rel_normW c hc (hother _ (fun r hr hrd hT => List.mem_cons_of_mem _ (hcov r hr hrd hT))
          List.mem_cons_self)
    · -- X held only by d: in place, cost 1
      refine ⟨1, ?_, Or.inr ⟨{ k with cols := M :: k.cols.erase X }, rfl, ?_, ?_⟩⟩
      · rw [hPhi', hPhi, if_neg (fun h => hMR h.2), if_neg (fun h => hXR h.2)]; omega
      · simp only [setSuccs]
        apply List.mem_append_left; apply List.mem_append_right
        refine List.mem_flatMap.2 ⟨X, hXA, List.mem_flatMap.2 ⟨S, mem_srcsS c hc hR hs,
          List.mem_flatMap.2 ⟨cd', hcd', ?_⟩⟩⟩
        simp only [hM, hcond]; simp
      · apply rel_normW c hc
        refine hother _ (fun r hr hrd hT => List.mem_cons_of_mem _ ?_) List.mem_cons_self
        have hne' : colOf c st r ≠ X := by
          intro e; apply hXR
          exact List.mem_map.2 ⟨r, (List.Nodup.mem_erase_iff List.nodup_range).2 ⟨hrd, List.mem_range.2 hr⟩, e⟩
        exact (List.mem_erase_of_ne hne').2 (hcov r hr hrd hT)

/-! ## the main induction for the set model -/

/-- Extra context facts for the set model: the input columns are distinct and not `T`. -/
structure SetCtxOK (c : Ctx) : Prop where
  inT : ∀ i < c.n, c.ts.map (fun w => w.getD i 0) ≠ c.T
  inNodup : ((List.range c.n).map fun i => c.ts.map (fun w => w.getD i 0)).Nodup

theorem phi_init (hc : CtxOK c) (hs : SetCtxOK c) (E : Nat) : Phi c (c.n + E) (fun w => initOf c.n w) = 0 := by
  let L0 := (List.range c.n).map fun i => c.ts.map (fun w => w.getD i 0)
  have hreg : nonT c (regCols c (c.n + E) (fun w => initOf c.n w)) = L0 := by
    simp only [nonT, regCols, List.range_add, List.map_append, List.filter_append, List.map_map]
    have e1 : (List.range c.n).map (colOf c (fun w => initOf c.n w)) = L0 := by
      apply List.map_congr_left; intro i hi
      have hi' := List.mem_range.1 hi
      simp [colOf, initOf, relaxInit, hi', xOf]
    have e2 : ((List.range E).map (colOf c (fun w => initOf c.n w) ∘ (c.n + ·))).filter (fun x => x != c.T) = [] := by
      apply List.filter_eq_nil_iff.2
      intro x hx
      obtain ⟨r, _, hr⟩ := List.mem_map.1 hx
      have : x = c.T := by
        rw [← hr]
        simp only [Function.comp, colOf, initOf, relaxInit]
        rw [hc.hT, hc.hm]
        simp only [show ¬ (c.n + r < c.n) from by omega, if_false]
        exact List.map_const'
      simp [this]
    rw [e1, e2, List.append_nil]
    apply List.filter_eq_self.2
    intro x hx
    obtain ⟨i, hi, e⟩ := List.mem_map.1 hx
    rw [← e]; simpa using hs.inT i (List.mem_range.1 hi)
  simp only [Phi, Pl, hreg, dc_nodup L0 hs.inNodup]; omega

theorem checkS_sound (hc : CtxOK c) (hs : SetCtxOK c) (cs : List Cond) (hsw : ∀ x ∈ cs, x.swap ∈ cs) (KB : Nat)
    (S : List (Key × Nat)) (look : Key → Option Nat) (hlook : ∀ k g, look k = some g → (k, g) ∈ S)
    (hchk : checkS c cs KB S look = true) (p : Program) (hp : p.length ≤ KB) (hcs : ∀ i ∈ p, condIn cs i)
    (o : Snap)
    (hsnap : ∀ w ∈ c.ts, ∀ j < c.n, (run compare (p.take (o j).2) (initOf c.n w)).regs (o j).1 = ((j : Nat) : Int)) :
    False := by
  simp only [checkS, Bool.and_eq_true, beq_iff_eq, List.all_eq_true] at hchk
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
  have Inv : ∀ d, d ≤ p.length → ∃ k g x, (k, g) ∈ S ∧ g + Phi c B (stAt d) ≤ d ∧ k = norm c x ∧
      RelW c B (stAt d) k ∧ ∀ j < c.n, tm j ≤ d → k.done.getD j false = true := by
    intro d
    induction d with
    | zero =>
      intro _
      let k0 : Key := { cols := (List.range c.n).map (fun i => c.ts.map (fun w => w.getD i 0))
                        flag := List.replicate c.m .eq, done := List.replicate c.n false }
      have hR0 : RelW c B (stAt 0) k0 := (rel_init c hc E).toW c hc
      have hphi : Phi c B (stAt 0) = 0 := phi_init c hc hs E
      refine ⟨root c, 0, k0, hlook _ _ hroot, by omega, rfl, rel_normW c hc hR0, ?_⟩
      intro j hj htm
      exact done_of_mem_norm c rfl hj (pres_mem c hc (rel_normW c hc hR0) hj (hpres 0 j hj (by omega)))
    | succ d ih =>
      intro hd1
      obtain ⟨k, g, x, hkS, hgd, hkx, hR, hdone⟩ := ih (by omega)
      have hdl : d < p.length := by omega
      have hk := hall (k, g) hkS
      simp only [Bool.and_eq_true, Bool.not_eq_true', List.all_eq_true] at hk
      obtain ⟨_, hsucc⟩ := hk
      let i := p[d]
      have hiP : i ∈ p := List.getElem_mem hdl
      obtain ⟨w, hw, hcase⟩ := setStep c hc cs hsw hR i (hB i hiP) (hcs i hiP)
      rw [← hstep d hdl] at hw hcase
      rcases hcase with ⟨hw0, hR'⟩ | ⟨y, hy, hmem, hR'⟩
      · refine ⟨k, g, x, hkS, by omega, hkx, hR', ?_⟩
        intro j hj htm
        rcases Nat.lt_or_ge (tm j) (d + 1) with hlt | hge
        · exact hdone j hj (by omega)
        · exact done_of_mem_norm c hkx hj (pres_mem c hc hR' hj (hpres (d + 1) j hj (by omega)))
      · have hdone' : ∀ j < c.n, tm j ≤ d + 1 → (norm c y).done.getD j false = true := by
          intro j hj htm
          rcases Nat.lt_or_ge (tm j) (d + 1) with hlt | hge
          · rw [norm_done c y j hj, hy, hdone j hj (by omega)]; simp
          · exact done_of_mem_norm c rfl hj (pres_mem c hc hR' hj (hpres (d + 1) j hj (by omega)))
        let q := p.drop (d + 1)
        have hF : Fut c (stAt (d + 1)) q (undone c (norm c y)) := by
          intro j hj
          have hjn : j < c.n := by simp [undone] at hj; exact hj.1
          have hnd : (norm c y).done.getD j false = false := by simp [undone] at hj; simpa using hj.2
          have hlt : d + 1 < tm j := by
            rcases Nat.lt_or_ge (d + 1) (tm j) with h | h
            · exact h
            · rw [hdone' j hjn h] at hnd; exact absurd hnd (by decide)
          have htmle : tm j ≤ p.length := Nat.min_le_right _ _
          refine ⟨tm j - (d + 1), by simp [q]; omega, (o j).1, fun w hw => ?_⟩
          have := hsn w hw j hjn
          rw [show tm j = (d + 1) + (tm j - (d + 1)) by omega, List.take_add, run_append] at this
          exact this
        have hA := undone_absent c hc y hR'
        have hnd := not_dead c hc hR' hF
        have hh := h_le c hc hR' hA hF
        have hql : q.length = p.length - (d + 1) := by simp [q]
        have hok := hsucc (norm c y, w) hmem
        simp only [succOKG, hnd, Bool.or_false, Bool.or_eq_true, decide_eq_true_eq] at hok
        rcases hok with hlook' | hlt
        · cases hg' : look (norm c y) with
          | none => rw [hg'] at hlook'; simp at hlook'
          | some g' =>
            rw [hg'] at hlook'
            simp only [decide_eq_true_eq] at hlook'
            exact ⟨norm c y, g', y, hlook _ _ hg', by omega, rfl, hR', hdone'⟩
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

/-- If the set-model certificate check accepts, no program of length ≤ KB is relaxed-RS-correct. -/
theorem lower_bound_set (n KB : Nat) (cs : List Cond) (hc : CtxOK (mkCtx n)) (hs : SetCtxOK (mkCtx n))
    (hsw : ∀ x ∈ cs, x.swap ∈ cs) (S : List (Key × Nat)) (look : Key → Option Nat)
    (hlook : ∀ k g, look k = some g → (k, g) ∈ S) (hcert : checkS (mkCtx n) cs KB S look = true) :
    ∀ (p : Program) (o : Snap), p.length ≤ KB → (∀ i ∈ p, condIn cs i) → ¬ RelaxedSnap n p o := by
  intro p o hp hcs hrs
  apply checkS_sound (mkCtx n) hc hs cs hsw KB S look hlook hcert p hp hcs o
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

theorem certOKS_sound (n KB : Nat) (cs : List Cond) (hc : CtxOK (mkCtx n)) (hs : SetCtxOK (mkCtx n))
    (hsw : ∀ x ∈ cs, x.swap ∈ cs) (hcert : certOKS n cs KB = true) :
    ∀ (p : Program) (o : Snap), p.length ≤ KB → (∀ i ∈ p, condIn cs i) → ¬ RelaxedSnap n p o :=
  lower_bound_set n KB cs hc hs hsw _ _ (fun k g h => Std.HashMap.mem_toList_iff_getElem?_eq_some.2 h) hcert

end LeanReflect
