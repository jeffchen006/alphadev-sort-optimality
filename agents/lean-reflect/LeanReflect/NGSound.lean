import LeanReflect.SymSound
import LeanReflect.NGBasic
import LeanReflect.NGDefs
/-
  Soundness of the NG set model for NG-normal programs (relaxed run): the key's γ bounds the number of accessed
  registers that hold the all-T column ("garbage registers"); registers not yet accessed hold T and are read only by
  garbage moves.
-/
namespace LeanReflect
open SortProof
set_option linter.unusedSectionVars false
set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false
open Classical

theorem accd_append (n : Nat) (pre : Program) (i : Instr) (r : Nat) :
    accd n (pre ++ [i]) r ↔ accd n pre r ∨ r ∈ i.regs := by
  simp only [accd, List.mem_append, List.mem_singleton]
  constructor
  · rintro (h | ⟨j, hj | hj, hr⟩)
    · exact Or.inl (Or.inl h)
    · exact Or.inl (Or.inr ⟨j, hj, hr⟩)
    · subst hj; exact Or.inr hr
  · rintro ((h | ⟨j, hj, hr⟩) | hr)
    · exact Or.inl h
    · exact Or.inr ⟨j, Or.inl hj, hr⟩
    · exact Or.inr ⟨i, Or.inr rfl, hr⟩

theorem step_regs_notin (s : State Int) (i : Instr) (r : Nat) (hr : r ∉ i.regs) :
    (step compare s i).regs r = s.regs r := by
  cases i with
  | cmp a b => rfl
  | mov d src =>
    have : r ≠ d := fun h => hr (by simp [Instr.regs, h])
    rw [step_mov_regs]; simp [this]
  | cmov cd d src =>
    have : r ≠ d := fun h => hr (by simp [Instr.regs, h])
    rw [step_cmov_regs]; simp [this]

theorem filter_len_le (l : List Nat) (hl : l.Nodup) (P P' : Nat → Bool) (E : List Nat)
    (h : ∀ r ∈ l, P' r = true → P r = true ∨ r ∈ E) : (l.filter P').length ≤ (l.filter P).length + E.length := by
  have hsub : l.filter P' ⊆ l.filter P ++ E := by
    intro r hr
    obtain ⟨hrl, hP'⟩ := List.mem_filter.1 hr
    rcases h r hrl hP' with h1 | h1
    · exact List.mem_append_left _ (List.mem_filter.2 ⟨hrl, h1⟩)
    · exact List.mem_append_right _ h1
  have := List.Nodup.length_le_of_subset (hl.filter _) hsub
  simpa using this

theorem filter_len_dec (l : List Nat) (hl : l.Nodup) (P P' : Nat → Bool) (d : Nat) (hd : d ∈ l)
    (hPd : P d = true) (hP'd : P' d = false) (h : ∀ r ∈ l, r ≠ d → P' r = true → P r = true) :
    (l.filter P').length + 1 ≤ (l.filter P).length := by
  have hsub : l.filter P' ⊆ (l.filter P).erase d := by
    intro r hr
    obtain ⟨hrl, hP'⟩ := List.mem_filter.1 hr
    have hrd : r ≠ d := by intro e; subst e; rw [hP'd] at hP'; exact absurd hP' (by decide)
    exact (List.Nodup.mem_erase_iff (hl.filter _)).2 ⟨hrd, List.mem_filter.2 ⟨hrl, h r hrl hrd hP'⟩⟩
  have h1 := List.Nodup.length_le_of_subset (hl.filter _) hsub
  have h2 := List.length_erase_of_mem (List.mem_filter.2 ⟨hd, hPd⟩)
  have h3 : 0 < (l.filter P).length := List.length_pos_of_mem (List.mem_filter.2 ⟨hd, hPd⟩)
  omega

theorem merge_self (cd : Cond) : ∀ (f : List Ordering) (a : Col), a.length ≤ f.length → merge cd f a a = a
  | f, [], _ => by cases f <;> simp [merge]
  | [], _ :: _, h => absurd h (by simp)
  | o :: os, x :: xs, h => by
    simp only [merge, ite_self, merge_self cd os xs (by simp at h; omega)]

section
variable (c : Ctx)

/-- Accessed registers holding the all-T column. -/
def nGarb (B : Nat) (pre : Program) (st : MS) : Nat :=
  ((List.range B).filter fun r => decide (accd c.n pre r) && decide (colOf c st r = c.T)).length

def GamOK (B : Nat) (pre : Program) (st : MS) (k : Key) : Prop := 7 ≤ k.gam ∨ nGarb c B pre st ≤ k.gam

/-- Registers not accessed hold T (on every test). -/
def PrisT (pre : Program) (st : MS) : Prop := ∀ r, c.n ≤ r → ¬ accd c.n pre r → ∀ w ∈ c.ts, (st w).regs r = c.n

theorem colT_of_vals (hc : CtxOK c) {st : MS} {r : Nat} (h : ∀ w ∈ c.ts, (st w).regs r = c.n) :
    colOf c st r = c.T := by
  simp only [colOf, hc.hT, hc.hm]
  rw [List.map_congr_left h, List.map_const']

theorem gam_pos (hc : CtxOK c) {B : Nat} {pre : Program} {st : MS} {k : Key} (hG : GamOK c B pre st k)
    {r : Nat} (hr : r < B) (ha : accd c.n pre r) (hT : colOf c st r = c.T) : 1 ≤ k.gam := by
  rcases hG with h | h
  · omega
  · have : 0 < nGarb c B pre st :=
      List.length_pos_of_mem (List.mem_filter.2 ⟨List.mem_range.2 hr, by simp [ha, hT]⟩)
    omega

theorem mem_srcsNG (hc : CtxOK c) {B : Nat} {pre : Program} {st : MS} {k : Key} (hR : RelW c B st k)
    (hG : GamOK c B pre st k) {r : Nat} (hr : r < B) (ha : accd c.n pre r) :
    colOf c st r ∈ (if 1 ≤ k.gam then k.cols ++ [c.T] else k.cols) := by
  by_cases hT : colOf c st r = c.T
  · rw [if_pos (gam_pos c hc hG hr ha hT), hT]; simp
  · split
    · exact List.mem_append_left _ (hR.sub r hr hT)
    · exact hR.sub r hr hT

theorem prisT_step {pre : Program} {st : MS} (hP : PrisT c pre st) (i : Instr) :
    PrisT c (pre ++ [i]) (stepMS st i) := by
  intro r hr hna w hw
  rw [accd_append] at hna
  have h1 : ¬ accd c.n pre r := fun h => hna (Or.inl h)
  have h2 : r ∉ i.regs := fun h => hna (Or.inr h)
  simp only [stepMS]; rw [step_regs_notin _ _ _ h2]; exact hP r hr h1 w hw

/-- If the accessed set and the T-status change only at registers in `E`, the garbage count grows by ≤ |E|. -/
theorem nGarb_le (B : Nat) (pre pre' : Program) (st st' : MS) (E : List Nat)
    (h : ∀ r, r < B → accd c.n pre' r → colOf c st' r = c.T → (accd c.n pre r ∧ colOf c st r = c.T) ∨ r ∈ E) :
    nGarb c B pre' st' ≤ nGarb c B pre st + E.length := by
  apply filter_len_le _ List.nodup_range
  intro r hr hP'
  simp only [Bool.and_eq_true, decide_eq_true_eq] at hP' ⊢
  exact h r (List.mem_range.1 hr) hP'.1 hP'.2

theorem rel_normNG {B : Nat} {pre : Program} {st : MS} {y : Key} (hG : GamOK c B pre st y) :
    GamOK c B pre st (norm c y) := hG

/-! ## one concrete step in the NG model -/

theorem ngStep (hc : CtxOK c) (cs : List Cond) (hsw : ∀ x ∈ cs, x.swap ∈ cs)
    {B : Nat} {pre : Program} {st : MS} {k : Key} (hR : RelW c B st k) (hG : GamOK c B pre st k)
    (hP : PrisT c pre st) (i : Instr) (hi : ∀ r ∈ i.regs, r < B) (hci : condIn cs i) (hng : ngOK c.n pre i) :
    ∃ w, w + Phi c B (stepMS st i) ≤ Phi c B st + 1 ∧
      ((w = 0 ∧ RelW c B (stepMS st i) k ∧ GamOK c B (pre ++ [i]) (stepMS st i) k) ∨
       ∃ y : Key, y.done = k.done ∧ (norm c y, w) ∈ ngSuccs c cs k ∧ RelW c B (stepMS st i) (norm c y) ∧
         GamOK c B (pre ++ [i]) (stepMS st i) (norm c y)) := by
  have hne : ∀ r, B ≤ r → ∀ (d : Nat), d < B → r ≠ d := fun r hr d hd => by omega
  have hgarb : ∀ (st' : MS) (E : List Nat),
      (∀ r, r < B → accd c.n (pre ++ [i]) r → colOf c st' r = c.T → (accd c.n pre r ∧ colOf c st r = c.T) ∨ r ∈ E) →
      nGarb c B (pre ++ [i]) st' ≤ nGarb c B pre st + E.length := fun st' E h => nGarb_le c B pre _ st st' E h
  -- the garbage op (kind 4) or, if γ ≥ 7, nothing
  have hkind4 : ∀ (st' : MS), RelW c B st' k → nGarb c B (pre ++ [i]) st' ≤ nGarb c B pre st + 2 →
      Phi c B st' ≤ Phi c B st →
      ∃ w, w + Phi c B st' ≤ Phi c B st + 1 ∧
        ((w = 0 ∧ RelW c B st' k ∧ GamOK c B (pre ++ [i]) st' k) ∨
         ∃ y : Key, y.done = k.done ∧ (norm c y, w) ∈ ngSuccs c cs k ∧ RelW c B st' (norm c y) ∧
           GamOK c B (pre ++ [i]) st' (norm c y)) := by
    intro st' hR' hn hphi
    by_cases h7 : 7 ≤ k.gam
    · exact ⟨0, by omega, Or.inl ⟨rfl, hR', Or.inl h7⟩⟩
    · have hle : nGarb c B pre st ≤ k.gam := by
        rcases hG with h | h
        · exact absurd h h7
        · exact h
      refine ⟨1, by omega, Or.inr ⟨{ k with gam := gInc2 k.gam }, rfl, ?_, ?_, ?_⟩⟩
      · simp only [ngSuccs]
        apply List.mem_append_right
        rw [if_pos (by omega)]; exact List.mem_singleton.2 rfl
      · exact rel_normW c hc (B := B) (st := st') (k := { k with gam := gInc2 k.gam }) ⟨hR'.hi, hR'.sub, hR'.fl, hR'.vals⟩
      · show 7 ≤ gInc2 k.gam ∨ nGarb c B (pre ++ [i]) st' ≤ gInc2 k.gam
        simp only [gInc2]; omega
  have hsame : ∀ (st' : MS), (∀ r, colOf c st' r = colOf c st r) → (∀ r ∈ i.regs, accd c.n pre r) →
      nGarb c B (pre ++ [i]) st' ≤ nGarb c B pre st := by
    intro st' hcol hacc
    have := hgarb st' [] (fun r hr ha hT => by
      rw [accd_append] at ha
      rcases ha with ha | ha
      · exact Or.inl ⟨ha, by rw [← hcol r]; exact hT⟩
      · exact Or.inl ⟨hacc r ha, by rw [← hcol r]; exact hT⟩)
    simpa using this
  cases i with
  | cmp a b =>
    have ha : a < B := hi a (by simp [Instr.regs])
    have hb : b < B := hi b (by simp [Instr.regs])
    have hacc : ∀ r ∈ (Instr.cmp a b).regs, accd c.n pre r := by
      rcases hng with h | ⟨_, _, h, _⟩
      · intro r hr; exact h r (by simpa [Instr.reads, Instr.regs] using hr)
      · cases h
    have hP' : Phi c B (stepMS st (.cmp a b)) = Phi c B st := rfl
    refine ⟨1, by omega, Or.inr ⟨{ k with flag := cmpCol (colOf c st a) (colOf c st b) }, rfl, ?_, ?_, ?_⟩⟩
    · simp only [ngSuccs]
      apply List.mem_append_left; apply List.mem_append_left; apply List.mem_append_left
      exact List.mem_flatMap.2 ⟨_, mem_srcsNG c hc hR hG ha (hacc a (by simp [Instr.regs])),
        List.mem_map.2 ⟨_, mem_srcsNG c hc hR hG hb (hacc b (by simp [Instr.regs])), rfl⟩⟩
    · apply rel_normW c hc
      exact ⟨fun r hr w => hR.hi r hr w, fun r hr hT => hR.sub r hr hT, Or.inl (flagOf_cmp c st a b), hR.vals⟩
    · have := hsame _ (fun r => colOf_cmp c st a b r) hacc
      rcases hG with h | h
      · exact Or.inl h
      · exact Or.inr (by show nGarb c B (pre ++ [Instr.cmp a b]) (stepMS st (Instr.cmp a b)) ≤ k.gam; omega)
  | mov d src =>
    have hd : d < B := hi d (by simp [Instr.regs])
    have hs : src < B := hi src (by simp [Instr.regs])
    have hcol := colOf_mov c st d src
    have hrest := restCols_eq c (B := B) (d := d) st (stepMS st (.mov d src)) (fun r hr => by rw [hcol]; simp [hr])
    have hRw : (colOf c st src = c.T ∨ colOf c st src ∈ k.cols) → RelW c B (stepMS st (.mov d src)) k := by
      intro hsrc
      refine ⟨fun r hr w => ?_, fun r hr hT => ?_, by rw [flagOf_mov]; exact hR.fl, ?_⟩
      · simp only [stepMS, step_mov_regs, hne r hr d hd, if_false]; exact hR.hi r hr w
      · rw [hcol] at hT ⊢
        split
        · rename_i h; rw [if_pos h] at hT
          rcases hsrc with h1 | h1
          · exact absurd h1 hT
          · exact h1
        · rename_i h; rw [if_neg h] at hT; exact hR.sub r hr hT
      · intro w hw r
        simp only [stepMS, step_mov_regs]
        split
        · exact hR.vals w hw src
        · exact hR.vals w hw r
    by_cases hsT : colOf c st src = c.T
    · -- d receives the all-T column: garbage op
      apply hkind4 _ (hRw (Or.inl hsT))
      · have := hgarb (stepMS st (.mov d src)) [d, src] (fun r hr ha hT => by
          by_cases hrd : r = d
          · exact Or.inr (by simp [hrd])
          · by_cases hrs : r = src
            · exact Or.inr (by simp [hrs])
            · left
              rw [accd_append] at ha
              have hr' : r ∉ (Instr.mov d src).regs := by simp [Instr.regs, hrd, hrs]
              refine ⟨ha.resolve_right hr', ?_⟩
              rw [hcol, if_neg hrd] at hT; exact hT)
        simpa using this
      · rw [Phi_split c hd, Phi_split c hd, hrest, hcol d, if_pos rfl, hsT]; simp
    · refine ⟨0, ?_, Or.inl ⟨rfl, hRw (Or.inr (hR.sub src hs hsT)), ?_⟩⟩
      · rw [Phi_split c hd, Phi_split c hd, hrest]; split <;> split <;> omega
      · have hsacc : accd c.n pre src := by
          rcases hng with h | ⟨a, b, h, hab, hna, hnb⟩
          · exact h src (by simp [Instr.reads])
          · injection h with h1 h2; subst h1; subst h2
            exact absurd (colT_of_vals c hc (hP _ (Nat.le_of_not_lt (fun h' => hnb (Or.inl h'))) hnb)) hsT
        have := hgarb (stepMS st (.mov d src)) [] (fun r hr ha hT => by
          by_cases hrd : r = d
          · subst hrd; rw [hcol, if_pos rfl] at hT; exact absurd hT hsT
          · left
            rw [accd_append] at ha
            rw [hcol, if_neg hrd] at hT
            refine ⟨?_, hT⟩
            rcases ha with ha | ha
            · exact ha
            · have : r = src := by simpa [Instr.regs, hrd] using ha
              subst this; exact hsacc)
        rcases hG with h | h
        · exact Or.inl h
        · exact Or.inr (by simp at this; omega)
  | cmov cd d src =>
    have hd : d < B := hi d (by simp [Instr.regs])
    have hs : src < B := hi src (by simp [Instr.regs])
    have hcd : cd ∈ cs := hci
    have hacc : ∀ r ∈ (Instr.cmov cd d src).regs, accd c.n pre r := by
      rcases hng with h | ⟨_, _, h, _⟩
      · intro r hr; exact h r (by simpa [Instr.reads, Instr.regs] using hr)
      · cases h
    have hdacc : accd c.n pre d := hacc d (by simp [Instr.regs])
    have hsacc : accd c.n pre src := hacc src (by simp [Instr.regs])
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
    obtain ⟨cd', hcd', hM⟩ : ∃ cd', cd' ∈ cs ∧ merge cd' k.flag X S = M := by
      rcases hR.fl with hf | hf
      · exact ⟨cd, hcd, by simp only [M]; rw [hf]⟩
      · exact ⟨cd.swap, hsw cd hcd, by simp only [M]; rw [hf, merge_swap]⟩
    have hPhi' : Phi c B st' = Pl c (restCols c B st d) + (if M ≠ c.T ∧ M ∈ restCols c B st d then 1 else 0) := by
      rw [Phi_split c hd, hrest, hcol d, if_pos rfl]
    have hPhi : Phi c B st = Pl c (restCols c B st d) + (if X ≠ c.T ∧ X ∈ restCols c B st d then 1 else 0) :=
      Phi_split c hd st
    have hother : ∀ A : List Col, (∀ r, r < B → r ≠ d → colOf c st r ≠ c.T → colOf c st r ∈ A) → M ∈ A →
        ∀ g, RelW c B st' { k with cols := A, gam := g } := by
      intro A hA hMA g
      refine ⟨hhi, fun r hr hT => ?_, by rw [hfl]; exact hR.fl, hvals⟩
      show colOf c st' r ∈ A
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
    -- garbage count when d's column becomes non-T (others unchanged, d and src accessed)
    have hgNT : M ≠ c.T → nGarb c B (pre ++ [Instr.cmov cd d src]) st' ≤ nGarb c B pre st := by
      intro hMT
      have := hgarb st' [] (fun r hr ha hT => by
        by_cases hrd : r = d
        · subst hrd; rw [hcol, if_pos rfl] at hT; exact absurd hT hMT
        · left
          rw [hcol, if_neg hrd] at hT
          refine ⟨?_, hT⟩
          rw [accd_append] at ha
          rcases ha with ha | ha
          · exact ha
          · exact hacc r ha)
      simpa using this
    have hGkeep : M ≠ c.T → GamOK c B (pre ++ [Instr.cmov cd d src]) st' k := by
      intro hMT
      rcases hG with h | h
      · exact Or.inl h
      · exact Or.inr (Nat.le_trans (hgNT hMT) h)
    by_cases hMX : M = X
    · refine ⟨0, ?_, Or.inl ⟨rfl, ?_, ?_⟩⟩
      · rw [hPhi', hPhi, hMX]; omega
      · refine ⟨hhi, fun r hr hT => ?_, by rw [hfl]; exact hR.fl, hvals⟩
        have e : colOf c st' r = colOf c st r := by rw [hcol]; split <;> simp_all [X]
        rw [e] at hT ⊢; exact hR.sub r hr hT
      · have := hsame st' (fun r => by rw [hcol]; split <;> simp_all [X]) hacc
        rcases hG with h | h
        · exact Or.inl h
        · exact Or.inr (Nat.le_trans this h)
    by_cases hMT : M = c.T
    · -- all-T result: garbage op
      apply hkind4 st' (hkeep (Or.inl hMT))
      · have := hgarb st' [d] (fun r hr ha hT => by
          by_cases hrd : r = d
          · exact Or.inr (by simp [hrd])
          · left
            rw [hcol, if_neg hrd] at hT
            refine ⟨?_, hT⟩
            rw [accd_append] at ha
            rcases ha with ha | ha
            · exact ha
            · exact hacc r ha)
        simp at this; omega
      · rw [hPhi', hPhi, if_neg (fun h => h.1 hMT)]; omega
    by_cases hMA : M ∈ k.cols
    · refine ⟨0, ?_, Or.inl ⟨rfl, hkeep (Or.inr hMA), hGkeep hMT⟩⟩
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
    · -- cmov into a garbage register: γ ≥ 1, γ := γ - 1
      have hg1 : 1 ≤ k.gam := gam_pos c hc hG hd hdacc hXT
      have hST : S ≠ c.T := by
        intro h; apply hMT
        show merge cd (flagOf c st) X S = c.T
        rw [hXT, h, merge_self]
        simp [flagOf, hc.hT, hc.hm]
      refine ⟨1, ?_, Or.inr ⟨{ k with cols := M :: k.cols, gam := gDec k.gam }, rfl, ?_, ?_, ?_⟩⟩
      · rw [hPhi', hPhi, if_neg (fun h => hMR h.2), if_neg (fun h => h.1 hXT)]; omega
      · simp only [ngSuccs]
        apply List.mem_append_left; apply List.mem_append_right
        rw [if_pos hg1]
        refine List.mem_flatMap.2 ⟨S, hR.sub src hs hST, List.mem_flatMap.2 ⟨cd', hcd', ?_⟩⟩
        have e : merge cd' k.flag c.T S = M := by rw [← hXT]; exact hM
        simp only [e, hcontains, Bool.or_false]
        simp [hMT]
      · exact rel_normW c hc (hother _ (fun r hr hrd hT => List.mem_cons_of_mem _ (hcov r hr hrd hT))
          List.mem_cons_self _)
      · show 7 ≤ gDec k.gam ∨ nGarb c B (pre ++ [Instr.cmov cd d src]) st' ≤ gDec k.gam
        have hdec := filter_len_dec (List.range B) List.nodup_range
          (fun r => decide (accd c.n pre r) && decide (colOf c st r = c.T))
          (fun r => decide (accd c.n (pre ++ [Instr.cmov cd d src]) r) && decide (colOf c st' r = c.T)) d
          (List.mem_range.2 hd) (by simp only [Bool.and_eq_true, decide_eq_true_eq]; exact ⟨hdacc, hXT⟩)
          (by simp only [Bool.and_eq_false_iff, decide_eq_false_iff_not]; right; rw [hcol, if_pos rfl]; exact hMT)
          (fun r _ hrd h => by
            simp only [Bool.and_eq_true, decide_eq_true_eq] at h ⊢
            rw [hcol, if_neg hrd] at h
            refine ⟨?_, h.2⟩
            rcases (accd_append _ _ _ _).1 h.1 with ha | ha
            · exact ha
            · exact hacc r ha)
        simp only [gDec]
        rcases hG with h | h
        · left; split <;> omega
        · simp only [nGarb] at h ⊢; split <;> omega
    have hXA : X ∈ k.cols := hR.sub d hd hXT
    have hcond : (M == X || M == c.T || k.cols.contains M) = false := by
      simp [hMX, hMT, hcontains, hMA]
    have hSs : S ∈ (if 1 ≤ k.gam then k.cols ++ [c.T] else k.cols) := mem_srcsNG c hc hR hG hs hsacc
    by_cases hXR : X ∈ restCols c B st d
    · refine ⟨2, ?_, Or.inr ⟨{ k with cols := M :: k.cols }, rfl, ?_, ?_, ?_⟩⟩
      · rw [hPhi', hPhi, if_neg (fun h => hMR h.2), if_pos ⟨hXT, hXR⟩]; omega
      · simp only [ngSuccs]
        apply List.mem_append_left; apply List.mem_append_left; apply List.mem_append_right
        refine List.mem_flatMap.2 ⟨X, hXA, List.mem_flatMap.2 ⟨S, hSs, List.mem_flatMap.2 ⟨cd', hcd', ?_⟩⟩⟩
        simp only [hM, hcond]; simp
      · exact rel_normW c hc (hother _ (fun r hr hrd hT => List.mem_cons_of_mem _ (hcov r hr hrd hT))
          List.mem_cons_self k.gam)
      · exact hGkeep hMT
    · refine ⟨1, ?_, Or.inr ⟨{ k with cols := M :: k.cols.erase X }, rfl, ?_, ?_, ?_⟩⟩
      · rw [hPhi', hPhi, if_neg (fun h => hMR h.2), if_neg (fun h => hXR h.2)]; omega
      · simp only [ngSuccs]
        apply List.mem_append_left; apply List.mem_append_left; apply List.mem_append_right
        refine List.mem_flatMap.2 ⟨X, hXA, List.mem_flatMap.2 ⟨S, hSs, List.mem_flatMap.2 ⟨cd', hcd', ?_⟩⟩⟩
        simp only [hM, hcond]; simp
      · apply rel_normW c hc
        refine hother _ (fun r hr hrd hT => List.mem_cons_of_mem _ ?_) List.mem_cons_self k.gam
        have hne' : colOf c st r ≠ X := by
          intro e; apply hXR
          exact List.mem_map.2 ⟨r, (List.Nodup.mem_erase_iff List.nodup_range).2 ⟨hrd, List.mem_range.2 hr⟩, e⟩
        exact (List.mem_erase_of_ne hne').2 (hcov r hr hrd hT)
      · exact hGkeep hMT

theorem permCol_eqT (hc : CtxOK c) {π : List Nat} (hπ : π.Perm (List.range c.m)) {x : Col} (hx : x.length = c.m) :
    permCol π x = c.T ↔ x = c.T := by
  have hTl : c.T.length = c.m := by simp [hc.hT]
  constructor
  · intro e; exact permCol_inj c hc hπ hx hTl (by rw [e, permCol_T c hc hπ])
  · intro e; rw [e, permCol_T c hc hπ]

theorem nGarb_view (hc : CtxOK c) (hG : c.ts.Nodup) {π : List Nat} (hπ : π.Perm (List.range c.m))
    (B : Nat) (pre : Program) (st : MS) : nGarb c B pre (view st (lane c π)) = nGarb c B pre st := by
  simp only [nGarb]
  congr 1
  apply List.filter_congr
  intro r _
  rw [colOf_view c hc hG hπ, decide_eq_decide.2 (permCol_eqT c hc hπ (len_colOf c hc st r))]

theorem canon_gam (G : List (List Nat)) (k : Key) : (canon c G k).gam = k.gam := by
  rcases canon_spec c G k with h | ⟨π, _, h⟩ <;> rw [h] <;> rfl

theorem canon_relNG (hc : CtxOK c) (hgo : GroupOK c G) {B : Nat} {pre : Program} {st : MS} {k : Key}
    (hR : RelW c B st k) (hG : GamOK c B pre st k) :
    ∃ f : List Int → List Int, (∀ w ∈ c.ts, f w ∈ c.ts) ∧ RelW c B (view st f) (canon c G k) ∧
      Phi c B (view st f) = Phi c B st ∧ GamOK c B pre (view st f) (canon c G k) ∧
      ∃ x, canon c G k = norm c x ∧ x.done = k.done := by
  have hgam : GamOK c B pre st (canon c G k) := by
    unfold GamOK; rw [canon_gam]; exact hG
  rcases canon_spec c G k with h | ⟨π, hπG, h⟩
  · refine ⟨id, fun w hw => hw, ?_, rfl, hgam, k, h, rfl⟩
    rw [h]; exact rel_normW c hc hR
  · have hπ := hgo.perm π hπG
    refine ⟨lane c π, fun w hw => lane_mem c hc hπ hw, ?_, phi_view c hc hgo.nodup hπ B st, ?_, act π k, h, rfl⟩
    · rw [h]; exact rel_normW c hc (relW_view c hc hgo.nodup hπ hR)
    · unfold GamOK; rw [nGarb_view c hc hgo.nodup hπ]; exact hgam

theorem checkNG_sound (hc : CtxOK c) (hs : SetCtxOK c) (G : List (List Nat)) (hgo : GroupOK c G)
    (cs : List Cond) (hsw : ∀ x ∈ cs, x.swap ∈ cs) (KB : Nat)
    (S : List (Key × Nat)) (look : Key → Option Nat) (hlook : ∀ k g, look k = some g → (k, g) ∈ S)
    (hchk : checkNG c G cs KB S look = true) (p : Program) (hp : p.length ≤ KB) (hcs : ∀ i ∈ p, condIn cs i)
    (hng : NGNormal c.n p) (o : Snap)
    (hsnap : ∀ w ∈ c.ts, ∀ j < c.n, (run compare (p.take (o j).2) (initOf c.n w)).regs (o j).1 = ((j : Nat) : Int)) :
    False := by
  simp only [checkNG, Bool.and_eq_true, beq_iff_eq, List.all_eq_true] at hchk
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

theorem lower_bound_NG (n KB : Nat) (cs : List Cond) (G : List (List Nat)) (hc : CtxOK (mkCtx n))
    (hs : SetCtxOK (mkCtx n)) (hgo : GroupOK (mkCtx n) G) (hsw : ∀ x ∈ cs, x.swap ∈ cs)
    (S : List (Key × Nat)) (look : Key → Option Nat) (hlook : ∀ k g, look k = some g → (k, g) ∈ S)
    (hcert : checkNG (mkCtx n) G cs KB S look = true) (p : Program) (o : Snap) (hp : p.length ≤ KB)
    (hcs : ∀ i ∈ p, condIn cs i) (hng : NGNormal n p)
    (hrel : ∀ x : Nat → Int, (∀ i < n, 0 ≤ x i ∧ x i < n) → SortsOK n x (snapOut p o (relaxInit n x n))) : False := by
  apply checkNG_sound (mkCtx n) hc hs G hgo cs hsw KB S look hlook hcert p hp hcs hng o
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

theorem checkNGPar_check (c : Ctx) (G : List (List Nat)) (cs : List Cond) (KB T : Nat) (hT : 0 < T)
    (S : List (Key × Nat)) (look : Key → Option Nat) (h : checkNGPar c G cs KB T S look = true) :
    checkNG c G cs KB S look = true := by
  simp only [checkNGPar, Bool.and_eq_true, List.all_eq_true, List.mem_map, List.mem_range] at h
  obtain ⟨hroot, hall⟩ := h
  simp only [checkNG, Bool.and_eq_true, List.all_eq_true]
  refine ⟨hroot, fun e he => ?_⟩
  have := hall _ ⟨shareOf T e.1, Nat.mod_lt _ hT, rfl⟩
  rw [task_spawn_get] at this
  simp only [List.all_eq_true, List.mem_filter] at this
  have h2 := this e ⟨he, by simp⟩
  simpa only [Bool.and_eq_true, List.all_eq_true] using h2

end LeanReflect
