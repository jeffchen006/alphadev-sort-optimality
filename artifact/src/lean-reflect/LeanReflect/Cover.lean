import LeanReflect.Heur
/-
  Rule H3' (enum PRUNING.md v2): #cmov ≥ #undone + cover_j − 2 for every undone output j, where cover_j = the least
  number of columns that hold value j on every test. Proof by a potential: the cover number of j by registers
  does not drop on mov / cmp, drops by ≤ 1 on a cmov, and does not drop on the cmov that creates another output
  (its new column is constant k ≠ j). An output is created only by a cmov (a mov copies a present column).
-/
namespace LeanReflect
open SortProof
set_option linter.unusedSectionVars false
set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false
open Classical

/-! ## list helpers -/

theorem mem_dd {α : Type} [DecidableEq α] {a : α} : ∀ {l : List α}, a ∈ dd l ↔ a ∈ l
  | [] => by simp [dd]
  | b :: l => by
    simp only [dd]
    split
    · rename_i h; rw [mem_dd]; constructor
      · exact List.mem_cons_of_mem _
      · intro hm; rcases List.mem_cons.1 hm with e | e
        · exact e ▸ h
        · exact e
    · rw [List.mem_cons, List.mem_cons, mem_dd]

theorem nodup_dd {α : Type} [DecidableEq α] : ∀ l : List α, (dd l).Nodup
  | [] => by simp [dd]
  | b :: l => by
    simp only [dd]
    split
    · exact nodup_dd l
    · rename_i h; exact List.nodup_cons.2 ⟨fun hm => h (mem_dd.1 hm), nodup_dd l⟩

theorem mem_combs {α : Type} : ∀ (l : List α) (s : Nat) (l' : List α), l'.Sublist l → l'.length = s →
    l' ∈ combs s l
  | [], s, l', h, hl => by
    have := List.sublist_nil.1 h; subst this; simp at hl; subst hl; simp [combs]
  | a :: t, 0, l', h, hl => by
    have : l' = [] := List.eq_nil_of_length_eq_zero hl
    subst this; simp [combs]
  | a :: t, s + 1, l', h, hl => by
    simp only [combs, List.mem_append, List.mem_map]
    cases h with
    | cons _ h => exact Or.inr (mem_combs t (s + 1) l' h hl)
    | cons₂ _ h =>
      rename_i l''
      exact Or.inl ⟨l'', mem_combs t s l'' h (by simpa using hl), rfl⟩

section
variable (c : Ctx)

theorem coverFrom_le (A : List Col) (j : Nat) : ∀ (f s s0 : Nat), s ≤ s0 → s0 < s + f →
    (combs s0 A).any (fun F => covers c F j) = true → coverFrom c A j f s ≤ s0
  | 0, s, s0, h1, h2, _ => by omega
  | f + 1, s, s0, h1, h2, h3 => by
    simp only [coverFrom]
    split
    · exact h1
    · rename_i hs
      have hne : s ≠ s0 := by intro e; subst e; exact hs h3
      exact coverFrom_le A j f (s + 1) s0 (by omega) (by omega) h3

/-- Register cover of value `j`. -/
def CovBy (st : MS) (j : Nat) (R : List Nat) : Prop := ∀ w ∈ c.ts, ∃ r ∈ R, (st w).regs r = ((j : Nat) : Int)

/-- The checker's cover number is at most the size of any register cover. -/
theorem coverLB_le (hc : CtxOK c) {B : Nat} {st : MS} {k : Key} (hR : RelW c B st k) {j : Nat} (hj : j < c.n)
    {R : List Nat} (hcov : CovBy c st j R) : coverLB c k j ≤ R.length := by
  let A := dd k.cols
  let F := A.filter fun col => decide (col ∈ R.map (colOf c st))
  have hsub : F.Sublist A := List.filter_sublist
  have hFnd : F.Nodup := (nodup_dd k.cols).sublist hsub
  have hFR : F ⊆ R.map (colOf c st) := fun x hx => by simpa using (List.mem_filter.1 hx).2
  have hlen : F.length ≤ R.length := by
    have := List.Nodup.length_le_of_subset hFnd hFR; simpa using this
  have hcovF : covers c F j = true := by
    simp only [covers, List.all_eq_true, List.mem_range]
    intro i hi
    have hw : c.ts.getD i [] ∈ c.ts := getD_mem _ i (hc.hm ▸ hi) []
    obtain ⟨r, hrR, hr⟩ := hcov _ hw
    have hv : (colOf c st r).getD i 0 = (j : Int) := by rw [getD_colOf c hc st r i hi, hr]
    have hT : colOf c st r ≠ c.T := by
      intro e; rw [e, getD_T c hc i hi] at hv; omega
    have hrB : r < B := by
      rcases Nat.lt_or_ge r B with h | h
      · exact h
      · have := hR.hi r h (c.ts.getD i []); rw [hr] at this; omega
    have hmem : colOf c st r ∈ F :=
      List.mem_filter.2 ⟨mem_dd.2 (hR.sub r hrB hT), by simpa using ⟨r, hrR, rfl⟩⟩
    exact List.any_eq_true.2 ⟨_, hmem, by simp [hv]⟩
  have hFA : F.length ≤ A.length := hsub.length_le
  have := coverFrom_le c A j (A.length + 1) 0 F.length (Nat.zero_le _) (by omega)
    (List.any_eq_true.2 ⟨F, mem_combs A F.length F hsub rfl, hcovF⟩)
  simp only [coverLB]
  omega

/-! ## creation of an output -/

def isCmov : Instr → Bool
  | .cmov _ _ _ => true
  | _ => false

def ncmov (q : Program) : Nat := (q.filter isCmov).length

theorem ncmov_cons (i : Instr) (q : Program) : ncmov (i :: q) = ncmov q + (if isCmov i then 1 else 0) := by
  cases h : isCmov i <;> simp [ncmov, List.filter_cons, h]

theorem ncmov_le_nwr : ∀ q : Program, ncmov q ≤ nwr q
  | [] => by simp [ncmov, nwr]
  | i :: q => by
    rw [ncmov_cons, nwr_cons]
    have := ncmov_le_nwr q
    cases i <;> simp [isCmov, Instr.isCmp] <;> omega

/-- A newly present output was created by a cmov into its destination. -/
theorem create_cmov {st : MS} {i : Instr} {j : Nat} (hn : ¬ Pres c st j) (hp : Pres c (stepMS st i) j) :
    isCmov i = true ∧ ∀ w ∈ c.ts, (stepMS st i w).regs i.dst = ((j : Nat) : Int) := by
  obtain ⟨r, hr⟩ := hp
  cases i with
  | cmp a b => exact absurd ⟨r, fun w hw => by simpa [stepMS, step_cmp_regs] using hr w hw⟩ hn
  | mov d s =>
    exfalso; apply hn
    by_cases hrd : r = d
    · subst hrd; exact ⟨s, fun w hw => by have := hr w hw; simpa [stepMS, step_mov_regs] using this⟩
    · exact ⟨r, fun w hw => by have := hr w hw; simpa [stepMS, step_mov_regs, hrd] using this⟩
  | cmov cd d s =>
    refine ⟨rfl, ?_⟩
    by_cases hrd : r = d
    · subst hrd; exact hr
    · exfalso; apply hn
      exact ⟨r, fun w hw => by have := hr w hw; simpa [stepMS, step_cmov_regs, hrd] using this⟩

theorem removed_le (hc : CtxOK c) {st : MS} {i : Instr} {U : List Nat} (hnd : U.Nodup)
    (hA : ∀ j ∈ U, ¬ Pres c st j) :
    (U.filter fun j => decide (Pres c (stepMS st i) j)).length ≤ (if isCmov i then 1 else 0) := by
  cases hi : isCmov i
  · simp only [Bool.false_eq_true, if_false, Nat.le_zero, List.length_eq_zero_iff]
    apply List.filter_eq_nil_iff.2
    intro j hj hp
    have := (create_cmov c (hA j hj) (of_decide_eq_true hp)).1
    rw [hi] at this; exact absurd this (by decide)
  · simp only [if_true]
    apply nodup_all_eq_len _ (hnd.filter _)
    intro a ha b hb
    have ha' := List.mem_filter.1 ha
    have hb' := List.mem_filter.1 hb
    have h1 := (create_cmov c (hA a ha'.1) (of_decide_eq_true ha'.2)).2
    have h2 := (create_cmov c (hA b hb'.1) (of_decide_eq_true hb'.2)).2
    obtain ⟨w0, hw0⟩ := List.exists_mem_of_ne_nil _ hc.ne
    have := (h1 w0 hw0).symm.trans (h2 w0 hw0)
    exact_mod_cast this

/-- Every undone (absent) output needs its own creating cmov. -/
theorem und_le_cmov (hc : CtxOK c) : ∀ (q : Program) (st : MS) (U : List Nat), U.Nodup →
    (∀ j ∈ U, ¬ Pres c st j) → Fut c st q U → U.length ≤ ncmov q
  | [], st, U, _, hA, hF => by simp [Fut_nil c hF hA]
  | i :: q, st, U, hnd, hA, hF => by
    let st' := stepMS st i
    let f : Nat → Bool := fun j => decide (Pres c st' j)
    have hsplit := length_filter_split f U
    have hmemK : ∀ j, j ∈ U.filter (fun x => !f x) ↔ j ∈ U ∧ ¬ Pres c st' j := by
      intro j; simp [f, List.mem_filter]
    have ih := und_le_cmov hc q st' (U.filter fun x => !f x) (hnd.filter _)
      (fun j hj => ((hmemK j).1 hj).2)
      (Fut_mono c (fun j hj => ((hmemK j).1 hj).1) (Fut_step c hF hA))
    have hrem := removed_le c hc (i := i) hnd hA
    rw [ncmov_cons]
    simp only [f] at hsplit
    split at hrem <;> simp_all <;> omega

/-! ## the cover potential -/

theorem cover_le (hc : CtxOK c) : ∀ (q : Program) (st : MS) (U : List Nat) (cv j : Nat), U.Nodup →
    (∀ k ∈ U, ¬ Pres c st k) → Fut c st q U → j ∈ U → (∀ R, CovBy c st j R → cv ≤ R.length) →
    U.length + cv ≤ ncmov q + 2
  | [], st, U, cv, j, _, hA, hF, hj, _ => by rw [Fut_nil c hF hA] at hj; simp at hj
  | i :: q, st, U, cv, j, hnd, hA, hF, hj, hcv => by
    let st' := stepMS st i
    let f : Nat → Bool := fun k => decide (Pres c st' k)
    have hsplit := length_filter_split f U
    have hmemK : ∀ k, k ∈ U.filter (fun x => !f x) ↔ k ∈ U ∧ ¬ Pres c st' k := by
      intro k; simp [f, List.mem_filter]
    have hF' : Fut c st' q (U.filter fun x => !f x) :=
      Fut_mono c (fun k hk => ((hmemK k).1 hk).1) (Fut_step c hF hA)
    have hA' : ∀ k ∈ U.filter (fun x => !f x), ¬ Pres c st' k := fun k hk => ((hmemK k).1 hk).2
    have hrem := removed_le c hc (i := i) hnd hA
    have hnc := ncmov_cons i q
    by_cases hpj : Pres c st' j
    · -- j is created by this instruction: a cmov, so cv ≤ 2
      obtain ⟨hcm, hd⟩ := create_cmov c (hA j hj) hpj
      have hu := und_le_cmov c hc q st' _ (hnd.filter _) hA' hF'
      have hcv2 : cv ≤ 2 := by
        cases i with
        | cmp _ _ => simp [isCmov] at hcm
        | mov _ _ => simp [isCmov] at hcm
        | cmov cd d s =>
          apply hcv [d, s]
          intro w hw
          have e := hd w hw
          simp only [stepMS, step_cmov_regs, Instr.dst, if_true] at e
          split at e
          · exact ⟨s, by simp, e⟩
          · exact ⟨d, by simp, e⟩
      simp only [f] at hsplit
      rw [hcm] at hrem hnc
      simp only [if_true] at hrem hnc
      omega
    · -- j stays undone: the cover number drops by at most `dec`
      have hjU' : j ∈ U.filter (fun x => !f x) := (hmemK j).2 ⟨hj, hpj⟩
      let dec : Nat := if isCmov i ∧ ∃ w ∈ c.ts, (st' w).regs i.dst = ((j : Nat) : Int) then 1 else 0
      have hcv' : ∀ R, CovBy c st' j R → cv - dec ≤ R.length := by
        intro R hR
        cases i with
        | cmp a b =>
          have := hcv R (fun w hw => by simpa [st', stepMS, step_cmp_regs] using hR w hw); omega
        | mov d s =>
          have := hcv (R.map fun r => if r = d then s else r) (by
            intro w hw
            obtain ⟨r, hr, e⟩ := hR w hw
            refine ⟨if r = d then s else r, List.mem_map.2 ⟨r, hr, rfl⟩, ?_⟩
            simp only [st', stepMS, step_mov_regs] at e
            split at e <;> simp_all)
          simp at this; omega
        | cmov cd d s =>
          by_cases hdec : ∃ w ∈ c.ts, (st' w).regs d = ((j : Nat) : Int)
          · have := hcv (s :: R) (by
              intro w hw
              obtain ⟨r, hr, e⟩ := hR w hw
              by_cases hrd : r = d
              · subst hrd
                simp only [st', stepMS, step_cmov_regs, if_true] at e
                split at e
                · exact ⟨s, List.mem_cons_self, e⟩
                · exact ⟨r, List.mem_cons_of_mem _ hr, e⟩
              · refine ⟨r, List.mem_cons_of_mem _ hr, ?_⟩
                simpa [st', stepMS, step_cmov_regs, hrd] using e)
            have hd1 : dec = 1 := by simp [dec, isCmov, Instr.dst, hdec]
            simp at this; omega
          · have := hcv R (by
              intro w hw
              obtain ⟨r, hr, e⟩ := hR w hw
              have hrd : r ≠ d := by
                intro h; subst h; exact hdec ⟨w, hw, e⟩
              exact ⟨r, hr, by simpa [st', stepMS, step_cmov_regs, hrd] using e⟩)
            omega
      have ih := cover_le hc q st' _ (cv - dec) j (hnd.filter _) hA' hF' hjU' hcv'
      -- a cmov that creates another output k holds k everywhere, so it does not lower the cover of j
      have hex : (U.filter f).length + dec ≤ (if isCmov i then 1 else 0) := by
        by_cases hcm : isCmov i = true
        · rw [if_pos hcm]
          by_cases hd : dec = 1
          · have hz : (U.filter f).length = 0 := by
              rw [List.length_eq_zero_iff]
              apply List.filter_eq_nil_iff.2
              intro k hk hpk
              have hpk' := of_decide_eq_true hpk
              obtain ⟨_, hkd⟩ := create_cmov c (hA k hk) hpk'
              have hdc : isCmov i ∧ ∃ w ∈ c.ts, (st' w).regs i.dst = ((j : Nat) : Int) := by
                by_contra hno; simp only [dec, if_neg hno] at hd; omega
              obtain ⟨w, hw, e⟩ := hdc.2
              have := (hkd w hw).symm.trans e
              have hkj : k = j := by exact_mod_cast this
              subst hkj; exact hpj hpk'
            omega
          · have : dec = 0 := by simp only [dec]; split <;> simp_all
            rw [hcm] at hrem; simp at hrem; omega
        · have h0 : dec = 0 := by simp [dec, hcm]
          rw [if_neg hcm] at hrem ⊢; omega
      simp only [f] at hsplit hex
      omega
end

end LeanReflect
