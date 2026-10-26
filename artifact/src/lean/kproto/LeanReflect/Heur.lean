import LeanReflect.Sim
import SortProof.Snap
/-
  Soundness of the pruning rules:
  * Rule D (`dead`): a value that an undone output still needs is in no register (on some test).
  * Write count: every undone (absent) output needs its own non-cmp instruction.
  * Rule H1 (`hc`): tests with equal index content stay together until a cmp splits them (into <= 2 parts);
    at the time of a snapshot all tests of a part agree on the index of that output.
-/
namespace LeanReflect
open SortProof
set_option linter.unusedSectionVars false
set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

-- `Instr.isCmp` is lean's (SortProof.Snap): true exactly for `cmp`.

def ncmp (q : Program) : Nat := (q.filter Instr.isCmp).length
def nwr (q : Program) : Nat := (q.filter fun i => !i.isCmp).length

theorem ncmp_cons (i : Instr) (q : Program) : ncmp (i :: q) = ncmp q + (if i.isCmp then 1 else 0) := by
  cases h : i.isCmp <;> simp [ncmp, List.filter_cons, h]

theorem nwr_cons (i : Instr) (q : Program) : nwr (i :: q) = nwr q + (if i.isCmp then 0 else 1) := by
  cases h : i.isCmp <;> simp [nwr, List.filter_cons, h]

theorem ncmp_add_nwr : ∀ q : Program, ncmp q + nwr q = q.length
  | [] => rfl
  | i :: q => by
    rw [ncmp_cons, nwr_cons, List.length_cons, ← ncmp_add_nwr q]
    split <;> omega

theorem length_filter_split {α : Type} (f : α → Bool) :
    ∀ l : List α, l.length = (l.filter f).length + (l.filter fun x => !f x).length
  | [] => rfl
  | a :: l => by
    have := length_filter_split f l
    cases h : f a <;> simp [List.filter_cons, h] <;> omega

theorem nodup_all_eq_len {α : Type} : ∀ l : List α, l.Nodup → (∀ a ∈ l, ∀ b ∈ l, a = b) → l.length ≤ 1
  | [], _, _ => by simp
  | [_], _, _ => by simp
  | a :: b :: l, hnd, h => by
    exfalso
    have : a = b := h a (by simp) b (by simp)
    subst this
    simp at hnd

section
variable (c : Ctx)

/-- Output `j` (value `j`) is held by one register on all tests. -/
def Pres (st : MS) (j : Nat) : Prop := ∃ r, ∀ w ∈ c.ts, (st w).regs r = ((j : Nat) : Int)

/-- Every output in `U` is snapshotted at some time `t ≤ |q|` of the remaining program `q`. -/
def Fut (st : MS) (q : Program) (U : List Nat) : Prop :=
  ∀ j ∈ U, ∃ t ≤ q.length, ∃ r, ∀ w ∈ c.ts, (run compare (q.take t) (st w)).regs r = ((j : Nat) : Int)

theorem Fut_mono {st : MS} {q : Program} {U U' : List Nat} (h : ∀ j ∈ U', j ∈ U) (hF : Fut c st q U) :
    Fut c st q U' := fun j hj => hF j (h j hj)

theorem Fut_step {st : MS} {i : Instr} {q : Program} {U : List Nat} (hF : Fut c st (i :: q) U)
    (hA : ∀ j ∈ U, ¬ Pres c st j) : Fut c (stepMS st i) q U := by
  intro j hj
  obtain ⟨t, ht, r, hr⟩ := hF j hj
  cases t with
  | zero => exact absurd ⟨r, fun w hw => by simpa using hr w hw⟩ (hA j hj)
  | succ t =>
    refine ⟨t, by simp at ht; omega, r, fun w hw => ?_⟩
    have := hr w hw
    simpa [List.take_succ_cons, run_cons, stepMS] using this

theorem Fut_nil {st : MS} {U : List Nat} (hF : Fut c st [] U) (hA : ∀ j ∈ U, ¬ Pres c st j) : U = [] := by
  cases U with
  | nil => rfl
  | cons j U =>
    exfalso
    obtain ⟨t, ht, r, hr⟩ := hF j (by simp)
    exact hA j (by simp) ⟨r, fun w hw => by simpa using hr w hw⟩
end

/-! ## values only move -/

theorem step_val (s : State Int) (i : Instr) (r : Nat) : ∃ r', (step compare s i).regs r = s.regs r' := by
  cases i with
  | cmp a b => exact ⟨r, rfl⟩
  | mov d src =>
    rw [step_mov_regs]; split
    · exact ⟨src, rfl⟩
    · exact ⟨r, rfl⟩
  | cmov cd d src =>
    rw [step_cmov_regs]; split
    · split
      · exact ⟨src, rfl⟩
      · exact ⟨d, rfl⟩
    · exact ⟨r, rfl⟩

theorem run_val : ∀ (q : Program) (s : State Int) (r : Nat), ∃ r', (run compare q s).regs r = s.regs r'
  | [], s, r => ⟨r, rfl⟩
  | i :: q, s, r => by
    obtain ⟨r1, h1⟩ := run_val q (step compare s i) r
    obtain ⟨r2, h2⟩ := step_val s i r1
    exact ⟨r2, by rw [run_cons, h1, h2]⟩

def _root_.SortProof.Instr.dst : Instr → Nat
  | .cmp _ _ => 0
  | .mov d _ => d
  | .cmov _ d _ => d

/-- Registers other than the destination are unchanged. -/
theorem step_off (s : State Int) (i : Instr) (hi : i.isCmp = false) (r : Nat) (hr : r ≠ i.dst) :
    (step compare s i).regs r = s.regs r := by
  cases i with
  | cmp a b => simp [Instr.isCmp] at hi
  | mov d src => rw [step_mov_regs]; simp [Instr.dst] at hr; simp [hr]
  | cmov cd d src => rw [step_cmov_regs]; simp [Instr.dst] at hr; simp [hr]

section
variable (c : Ctx)

theorem getD_map_lt {α β : Type} (l : List α) (f : α → β) (i : Nat) (h : i < l.length) (d : β) (e : α) :
    (l.map f).getD i d = f (l.getD i e) := by
  simp [List.getD_eq_getElem?_getD, h]

theorem getD_mem {α : Type} (l : List α) (i : Nat) (h : i < l.length) (e : α) : l.getD i e ∈ l := by
  simp [List.getD_eq_getElem?_getD, h]

theorem getD_colOf (hc : CtxOK c) (st : MS) (r i : Nat) (hi : i < c.m) :
    (colOf c st r).getD i 0 = (st (c.ts.getD i [])).regs r := by
  rw [hc.hm] at hi
  exact getD_map_lt _ _ i hi 0 []

theorem getD_T (hc : CtxOK c) (i : Nat) (hi : i < c.m) : c.T.getD i 0 = (c.n : Int) := by
  simp [hc.hT, List.getD_eq_getElem?_getD, hi]

/-! ## Rule D -/

theorem not_dead (hc : CtxOK c) {B : Nat} {st : MS} {k : Key} {q : Program} (hR : RelW c B st k)
    (hF : Fut c st q (undone c k)) : dead c k = false := by
  simp only [dead, List.any_eq_false, Bool.not_eq_true', Bool.not_eq_false']
  intro j hj hany
  obtain ⟨i, hi', hneg⟩ := List.any_eq_true.1 hany
  have hjn : j < c.n := by simp [undone] at hj; exact hj.1
  have hi : i < c.m := List.mem_range.1 hi'
  have hw : c.ts.getD i [] ∈ c.ts := getD_mem _ i (hc.hm ▸ hi) []
  obtain ⟨t, _, r, hr⟩ := hF j hj
  obtain ⟨r', hr'⟩ := run_val (q.take t) (st (c.ts.getD i [])) r
  have hv : (st (c.ts.getD i [])).regs r' = (j : Int) := by rw [← hr', hr _ hw]
  have hrB : r' < B := by
    rcases Nat.lt_or_ge r' B with h | h
    · exact h
    · have := hR.hi r' h (c.ts.getD i []); rw [hv] at this; omega
  have hcolT : colOf c st r' ≠ c.T := by
    intro h
    have h1 := getD_colOf c hc st r' i hi
    rw [h, getD_T c hc i hi, hv] at h1; omega
  have hpos : (k.cols.any fun col => col.getD i 0 == (j : Int)) = true :=
    List.any_eq_true.2 ⟨_, hR.sub _ hrB hcolT, by rw [getD_colOf c hc st r' i hi, hv]; simp⟩
  rw [hpos] at hneg; exact absurd hneg (by decide)

/-! ## write count -/

theorem und_le (hc : CtxOK c) : ∀ (q : Program) (st : MS) (U : List Nat), U.Nodup →
    (∀ j ∈ U, ¬ Pres c st j) → Fut c st q U → U.length ≤ nwr q
  | [], st, U, _, hA, hF => by simp [Fut_nil c hF hA]
  | i :: q, st, U, hnd, hA, hF => by
    classical
    let st' := stepMS st i
    let f : Nat → Bool := fun j => decide (Pres c st' j)
    have hsplit := length_filter_split f U
    have hmemK : ∀ j, j ∈ U.filter (fun x => !f x) ↔ j ∈ U ∧ ¬ Pres c st' j := by
      intro j; simp [f, List.mem_filter]
    have ih := und_le hc q st' (U.filter fun x => !f x) (hnd.filter _)
      (fun j hj => ((hmemK j).1 hj).2)
      (Fut_mono c (fun j hj => ((hmemK j).1 hj).1) (Fut_step c hF hA))
    have hrem : (U.filter f).length ≤ (if i.isCmp then 0 else 1) := by
      cases hi : i.isCmp
      · simp only [Bool.false_eq_true, if_false]
        apply nodup_all_eq_len _ (hnd.filter _)
        have hreg : ∀ j ∈ U.filter f, ∀ w ∈ c.ts, (st' w).regs i.dst = (j : Int) := by
          intro j hj w hw
          have hj' := List.mem_filter.1 hj
          obtain ⟨r, hr⟩ := of_decide_eq_true hj'.2
          by_cases hrd : r = i.dst
          · subst hrd; exact hr w hw
          · exfalso
            apply hA j hj'.1
            refine ⟨r, fun w' hw' => ?_⟩
            have := hr w' hw'
            simp only [st', stepMS] at this
            rwa [step_off (st w') i hi r hrd] at this
        intro a ha b hb
        obtain ⟨w0, hw0⟩ : ∃ w0, w0 ∈ c.ts := List.exists_mem_of_ne_nil _ hc.ne
        have := (hreg a ha w0 hw0).symm.trans (hreg b hb w0 hw0)
        exact_mod_cast this
      · simp only [if_true]
        have : U.filter f = [] := by
          apply List.filter_eq_nil_iff.2
          intro j hj hfj
          apply hA j hj
          obtain ⟨r, hr⟩ := of_decide_eq_true hfj
          cases i with
          | cmp a b => exact ⟨r, fun w hw => hr w hw⟩
          | mov _ _ => simp [Instr.isCmp] at hi
          | cmov _ _ _ => simp [Instr.isCmp] at hi
        simp [this]
    rw [nwr_cons]
    omega
end

end LeanReflect
