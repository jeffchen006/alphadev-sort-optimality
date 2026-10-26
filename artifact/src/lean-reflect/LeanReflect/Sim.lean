import LeanReflect.Lemmas
/-
  Simulation: a concrete multi-state (one machine state per test) is related to a key;
  every concrete instruction is matched by an abstract instruction in `ais`.
-/
namespace LeanReflect
open SortProof
set_option linter.unusedSectionVars false
set_option linter.unusedSimpArgs false

/-- Facts about the context, all checked by `decide`/`rfl` for a fixed `n`. -/
structure CtxOK (c : Ctx) : Prop where
  hm : c.m = c.ts.length
  hT : c.T = List.replicate c.m (c.n : Int)
  htc : c.tc = (List.range c.n).map fun (j : Nat) => List.replicate c.m ((j : Nat) : Int)
  ne : c.ts ≠ []
  len : ∀ w ∈ c.ts, w.length = c.n
  noT : ∀ w ∈ c.ts, (c.n : Int) ∉ w
  lt : ∀ w ∈ c.ts, ∀ i < c.n, xOf w i < c.n
  perm : ∀ w ∈ c.ts, ((List.range c.n).map (xOf w)).Perm ((List.range c.n).map fun (j : Nat) => ((j : Nat) : Int))

/-- A concrete multi-state: one machine state per test. -/
abbrev MS := List Int → State Int

section
variable (c : Ctx)

def colOf (st : MS) (r : Nat) : Col := c.ts.map fun w => (st w).regs r
def flagOf (st : MS) : List Ordering := c.ts.map fun w => (st w).flag
def regCols (B : Nat) (st : MS) : List Col := (List.range B).map (colOf c st)

/-- Every register value of a test `w` is an input value of `w` or `T = n`. -/
def Vals (st : MS) : Prop := ∀ w ∈ c.ts, ∀ r, (st w).regs r ∈ w ∨ (st w).regs r = c.n

structure Rel (B : Nat) (st : MS) (k : Key) : Prop where
  hi : ∀ r, B ≤ r → ∀ w, (st w).regs r = c.n
  cnt : ∀ col, col ≠ c.T → (regCols c B st).count col = k.cols.count col
  fl : flagOf c st = k.flag ∨ flagOf c st = k.flag.map Ordering.swap
  vals : Vals c st

/-- Weak relation (set model, Lemma S): every non-T register column is a key column. -/
structure RelW (B : Nat) (st : MS) (k : Key) : Prop where
  hi : ∀ r, B ≤ r → ∀ w, (st w).regs r = c.n
  sub : ∀ r, r < B → colOf c st r ≠ c.T → colOf c st r ∈ k.cols
  fl : flagOf c st = k.flag ∨ flagOf c st = k.flag.map Ordering.swap
  vals : Vals c st

/-- One step on every test. -/
def stepMS (st : MS) (i : Instr) : MS := fun w => step compare (st w) i
end

/-! ## step lemmas -/

theorem step_mov_regs (s : State Int) (d src r : Nat) :
    (step compare s (.mov d src)).regs r = if r = d then s.regs src else s.regs r := by
  simp [step, upd]

theorem step_cmov_regs (s : State Int) (cd : Cond) (d src r : Nat) :
    (step compare s (.cmov cd d src)).regs r =
      if r = d then (if cd.eval s.flag then s.regs src else s.regs d) else s.regs r := by
  by_cases h : cd.eval s.flag <;> by_cases hr : r = d <;> simp [step, upd, h, hr]

theorem step_cmp_regs (s : State Int) (a b : Nat) : (step compare s (.cmp a b)).regs = s.regs := rfl
theorem step_cmp_flag (s : State Int) (a b : Nat) :
    (step compare s (.cmp a b)).flag = compare (s.regs a) (s.regs b) := rfl
theorem step_mov_flag (s : State Int) (d src : Nat) : (step compare s (.mov d src)).flag = s.flag := rfl
theorem step_cmov_flag (s : State Int) (cd : Cond) (d src : Nat) :
    (step compare s (.cmov cd d src)).flag = s.flag := by
  by_cases h : cd.eval s.flag <;> simp [step, h]

section
variable (c : Ctx)

theorem colOf_mov (st : MS) (d src r : Nat) :
    colOf c (stepMS st (.mov d src)) r = if r = d then colOf c st src else colOf c st r := by
  by_cases hr : r = d <;> simp [colOf, stepMS, step_mov_regs, hr]

theorem colOf_cmov (st : MS) (cd : Cond) (d src r : Nat) :
    colOf c (stepMS st (.cmov cd d src)) r =
      if r = d then merge cd (flagOf c st) (colOf c st d) (colOf c st src) else colOf c st r := by
  by_cases hr : r = d
  · simp only [hr, if_true, colOf, flagOf, merge_map, stepMS, step_cmov_regs]
  · simp [hr, colOf, stepMS, step_cmov_regs]

theorem colOf_cmp (st : MS) (a b r : Nat) : colOf c (stepMS st (.cmp a b)) r = colOf c st r := rfl

theorem flagOf_cmp (st : MS) (a b : Nat) :
    flagOf c (stepMS st (.cmp a b)) = cmpCol (colOf c st a) (colOf c st b) := by
  simp [flagOf, colOf, cmpCol_map, stepMS, step_cmp_flag]

theorem flagOf_mov (st : MS) (d src : Nat) : flagOf c (stepMS st (.mov d src)) = flagOf c st := rfl
theorem flagOf_cmov (st : MS) (cd : Cond) (d src : Nat) :
    flagOf c (stepMS st (.cmov cd d src)) = flagOf c st := by
  simp [flagOf, stepMS, step_cmov_flag]

/-! ## columns and `T` -/

theorem colOf_hi (hc : CtxOK c) {B : Nat} {st : MS} (hhi : ∀ r, B ≤ r → ∀ w, (st w).regs r = c.n)
    {r : Nat} (hr : B ≤ r) : colOf c st r = c.T := by
  simp [colOf, hhi r hr, hc.hT, hc.hm, List.map_const']

theorem mem_cols (_hc : CtxOK c) {B : Nat} {st : MS} {k : Key} (hR : Rel c B st k) {r : Nat}
    (hr : r < B) (hT : colOf c st r ≠ c.T) : colOf c st r ∈ k.cols := by
  apply mem_of_count_pos
  rw [← hR.cnt _ hT]
  apply count_pos_of_mem
  exact List.mem_map.2 ⟨r, List.mem_range.2 hr, rfl⟩

theorem Rel.toW (hc : CtxOK c) {B : Nat} {st : MS} {k : Key} (hR : Rel c B st k) : RelW c B st k :=
  ⟨hR.hi, fun _ hr hT => mem_cols c hc hR hr hT, hR.fl, hR.vals⟩

theorem mem_srcs (hc : CtxOK c) {B : Nat} {st : MS} {k : Key} (hR : Rel c B st k) {r : Nat}
    (hr : r < B) : colOf c st r ∈ k.cols.eraseDups ++ [c.T] := by
  by_cases hT : colOf c st r = c.T
  · simp [hT]
  · exact List.mem_append_left _ (List.mem_eraseDups.2 (mem_cols c hc hR hr hT))

/-- The abstract destination of concrete register `d`. -/
def dOpt (st : MS) (d : Nat) : Option Col := if colOf c st d = c.T then none else some (colOf c st d)

theorem dOpt_getD (st : MS) (d : Nat) : (dOpt c st d).getD c.T = colOf c st d := by
  unfold dOpt; split <;> simp_all

theorem mem_dsts (hc : CtxOK c) {B : Nat} {st : MS} {k : Key} (hR : Rel c B st k) {d : Nat}
    (hd : d < B) : dOpt c st d ∈ k.cols.eraseDups.map some ++ [none] := by
  unfold dOpt
  split
  · simp
  · rename_i hT
    exact List.mem_append_left _ (List.mem_map.2 ⟨_, List.mem_eraseDups.2 (mem_cols c hc hR hd hT), rfl⟩)

/-! ## counts after a write -/

theorem count_writeCol (cols : List Col) (st : MS) (d : Nat) (v col : Col) (hcol : col ≠ c.T)
    (hmem : colOf c st d ≠ c.T → colOf c st d ∈ cols) :
    (writeCol c cols (dOpt c st d) v).count col + (if colOf c st d == col then 1 else 0)
      = cols.count col + (if v == col then 1 else 0) := by
  have hTc : c.T ≠ col := Ne.symm hcol
  unfold writeCol dOpt
  by_cases hT : colOf c st d = c.T
  · simp only [hT, if_true]
    by_cases hv : v = c.T
    · subst hv; simp [hTc]
    · simp [hv, List.count_cons, hTc]
  · simp only [hT, if_false]
    have hm := hmem hT
    by_cases e : colOf c st d = col
    · have hpos : 0 < cols.count col := by rw [← e]; exact count_pos_of_mem hm
      by_cases hv : v = c.T
      · subst hv; simp [hTc, e, List.count_erase]; omega
      · simp [hv, e, List.count_cons, List.count_erase]; split <;> omega
    · by_cases hv : v = c.T
      · subst hv; simp [hTc, e, List.count_erase]
      · simp [hv, e, List.count_cons, List.count_erase]

theorem regCols_count_write (B : Nat) (st st' : MS) (d : Nat) (hd : d < B) (v col : Col)
    (h : ∀ r, colOf c st' r = if r = d then v else colOf c st r) :
    (regCols c B st').count col + (if colOf c st d == col then 1 else 0)
      = (regCols c B st).count col + (if v == col then 1 else 0) := by
  have : regCols c B st' = (List.range B).map (fun r => if r = d then v else colOf c st r) := by
    simp only [regCols]; apply List.map_congr_left; intro r _; exact h r
  rw [this]
  exact count_map_update (colOf c st) d v col (List.range B) List.nodup_range (List.mem_range.2 hd)

/-! ## the simulation lemma -/

def condIn (cs : List Cond) : Instr → Prop
  | .cmov cd _ _ => cd ∈ cs
  | _ => True

theorem rel_write (hc : CtxOK c) {B : Nat} {st : MS} {k : Key} (hR : Rel c B st k) (i : Instr)
    (d : Nat) (hd : d < B) (v : Col)
    (hcol : ∀ r, colOf c (stepMS st i) r = if r = d then v else colOf c st r)
    (hfl : flagOf c (stepMS st i) = flagOf c st)
    (hhi : ∀ r, B ≤ r → ∀ w, (stepMS st i w).regs r = c.n)
    (hvals : Vals c (stepMS st i)) :
    Rel c B (stepMS st i) { k with cols := writeCol c k.cols (dOpt c st d) v } := by
  refine ⟨hhi, ?_, ?_, hvals⟩
  · intro col hcolT
    have h1 := regCols_count_write c B st (stepMS st i) d hd v col hcol
    have h2 := count_writeCol c k.cols st d v col hcolT (fun hT => mem_cols c hc hR hd hT)
    have h3 := hR.cnt col hcolT
    simp only at *
    omega
  · rw [hfl]; exact hR.fl

theorem sim (hc : CtxOK c) (cs : List Cond) (hsw : ∀ x ∈ cs, x.swap ∈ cs)
    {B : Nat} {st : MS} {k : Key} (hR : Rel c B st k) (i : Instr) (hi : ∀ r ∈ i.regs, r < B)
    (hci : condIn cs i) : ∃ a ∈ ais c cs k, Rel c B (stepMS st i) (a.apply c k) := by
  have hne : ∀ r, B ≤ r → ∀ (d : Nat), d < B → r ≠ d := fun r hr d hd => by omega
  cases i with
  | cmp a b =>
    refine ⟨.cmp (colOf c st a) (colOf c st b), ?_, ?_⟩
    · simp only [ais]
      exact List.mem_append_left _ (List.mem_flatMap.2 ⟨_, mem_srcs c hc hR (hi a (by simp [Instr.regs])),
        List.mem_map.2 ⟨_, mem_srcs c hc hR (hi b (by simp [Instr.regs])), rfl⟩⟩)
    · refine ⟨fun r hr w => hR.hi r hr w, ?_, ?_, ?_⟩
      · intro col hcol; exact hR.cnt col hcol
      · left; simp only [AI.apply]; exact flagOf_cmp c st a b
      · exact hR.vals
  | mov d src =>
    have hd : d < B := hi d (by simp [Instr.regs])
    have hs : src < B := hi src (by simp [Instr.regs])
    refine ⟨.mov (dOpt c st d) (colOf c st src), ?_, ?_⟩
    · simp only [ais]
      exact List.mem_append_right _ (List.mem_flatMap.2 ⟨_, mem_dsts c hc hR hd,
        List.mem_flatMap.2 ⟨_, mem_srcs c hc hR hs, List.mem_cons_self⟩⟩)
    · apply rel_write c hc hR _ d hd _ (colOf_mov c st d src) (flagOf_mov c st d src)
      · intro r hr w
        simp only [stepMS, step_mov_regs, hne r hr d hd, if_false]; exact hR.hi r hr w
      · intro w hw r
        simp only [stepMS, step_mov_regs]
        split
        · exact hR.vals w hw src
        · exact hR.vals w hw r
  | cmov cd d src =>
    have hd : d < B := hi d (by simp [Instr.regs])
    have hs : src < B := hi src (by simp [Instr.regs])
    have hcd : cd ∈ cs := hci
    have hhi : ∀ r, B ≤ r → ∀ w, (stepMS st (.cmov cd d src) w).regs r = c.n := by
      intro r hr w
      simp only [stepMS, step_cmov_regs, hne r hr d hd, if_false]; exact hR.hi r hr w
    have hvals : Vals c (stepMS st (.cmov cd d src)) := by
      intro w hw r
      simp only [stepMS, step_cmov_regs]
      split
      · split
        · exact hR.vals w hw src
        · exact hR.vals w hw d
      · exact hR.vals w hw r
    have hmerge : ∀ cd', merge cd' k.flag (colOf c st d) (colOf c st src)
        = merge cd (flagOf c st) (colOf c st d) (colOf c st src) → cd' ∈ cs →
        ∃ a ∈ ais c cs k, Rel c B (stepMS st (.cmov cd d src)) (a.apply c k) := by
      intro cd' heq hcd'
      refine ⟨.cmov cd' (dOpt c st d) (colOf c st src), ?_, ?_⟩
      · simp only [ais]
        exact List.mem_append_right _ (List.mem_flatMap.2 ⟨_, mem_dsts c hc hR hd,
          List.mem_flatMap.2 ⟨_, mem_srcs c hc hR hs,
            List.mem_cons_of_mem _ (List.mem_map.2 ⟨cd', hcd', rfl⟩)⟩⟩)
      · simp only [AI.apply, dOpt_getD, heq]
        exact rel_write c hc hR _ d hd _ (colOf_cmov c st cd d src) (flagOf_cmov c st cd d src) hhi hvals
    rcases hR.fl with hf | hf
    · exact hmerge cd (by rw [hf]) hcd
    · exact hmerge cd.swap (by rw [hf, merge_swap]) (hsw cd hcd)

theorem rel_norm (hc : CtxOK c) {B : Nat} {st : MS} {k : Key} (hR : Rel c B st k) :
    Rel c B st (norm c k) := by
  refine ⟨hR.hi, ?_, ?_, hR.vals⟩
  · intro col hcol
    rw [hR.cnt col hcol]; simp only [norm]
    exact ((List.mergeSort_perm k.cols colLe).count_eq col).symm
  · simp only [norm]
    rcases canonF_cases k.flag with h | h <;> rw [h]
    · exact hR.fl
    · rcases hR.fl with hf | hf
      · right; rw [hf, swap_swap_map]
      · left; exact hf

theorem apply_done (k : Key) (a : AI) : (a.apply c k).done = k.done := by
  cases a <;> rfl

theorem norm_done (k : Key) (j : Nat) (hj : j < c.n) :
    (norm c k).done.getD j false = (k.done.getD j false || k.cols.contains (c.tc.getD j [])) := by
  simp [norm, List.getD_eq_getElem?_getD, hj]

end
end LeanReflect
