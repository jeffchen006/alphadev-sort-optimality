import LeanLrat.Enc
import SortProof.Snap
/-
  Soundness of the encoder (v2, content encoding): every relaxed-correct program in the snapshot
  model (`RelaxedSnap`) of length k over n + k registers, opcodes in I0 / I1, gives a satisfying
  assignment of `encV n k i1 types`, for ANY list `types`. So `Unsat` implies that no such
  program exists.

  The assignment runs the machine on CONTENTS (`Nat`, `c < n` = "holds x_c", `n` = T) with the
  compare `ordC` of the type; `run_map` maps this run to the `Int` run of `RelaxedSnap`.
-/
namespace LeanLrat
open Std.Sat SortProof

/-! Instruction fields as the encoder sees them. -/

def opOf : Instr → Nat
  | .mov _ _ => 0
  | .cmp _ _ => 1
  | .cmov .l _ _ => 2
  | .cmov .g _ _ => 3
  | .cmov .le _ _ => 4
  | .cmov .ge _ _ => 5

/-- The instruction set of the encoding: I1 (all four conditions) or I0. -/
def isetOf (i1 : Bool) : Cond → Bool := if i1 then (fun _ => true) else Cond.inI0

def dstOf : Instr → Nat
  | .mov d _ => d
  | .cmp a _ => a
  | .cmov _ d _ => d

def srcOf : Instr → Nat
  | .mov _ s => s
  | .cmp _ b => b
  | .cmov _ _ s => s

/-- Operands of all steps, in order (first operand first). -/
def touch (p : Program) : List Nat := p.flatMap fun i => [dstOf i, srcOf i]

/-- The first-touch rule (see `Canon.lean`), on programs. -/
def Canonical (n : Nat) (q : Program) : Prop :=
  ∀ t (ht : t < q.length),
    (0 < dstOf q[t] → dstOf q[t] ≠ n → dstOf q[t] - 1 ∈ touch (q.take t)) ∧
    (0 < srcOf q[t] → srcOf q[t] ≠ n →
      srcOf q[t] - 1 ∈ touch (q.take t) ∨ srcOf q[t] - 1 = dstOf q[t])

/-- Flag scan: `true` iff the last cmp of the list is not followed by a cmov (start value `acc`). -/
def pendF : Bool → Program → Bool
  | acc, [] => acc
  | acc, i :: l => pendF (match i with
      | .cmp _ _ => true
      | .cmov _ _ _ => false
      | _ => acc) l

def writes : Instr → Ordering → Bool
  | .mov _ _, _ => true
  | .cmp _ _, _ => false
  | .cmov c _ _, o => c.eval o

theorem writes_cmp (i : Instr) (f : Ordering) (h : opOf i = 1) : writes i f = false := by
  cases i with
  | mov => simp [opOf] at h
  | cmp => rfl
  | cmov c => cases c <;> simp [opOf] at h

theorem step_regs {α : Type} (ord : α → α → Ordering) (s : State α) (i : Instr) (r : Nat) :
    (step ord s i).regs r =
      if dstOf i = r ∧ writes i s.flag = true then s.regs (srcOf i) else s.regs r := by
  cases i with
  | mov d src =>
    simp only [step, upd, dstOf, srcOf, writes, and_true]
    by_cases h : r = d
    · subst h; simp
    · simp [h, Ne.symm h]
  | cmp a b => simp [step, writes]
  | cmov c d src =>
    simp only [step, dstOf, srcOf, writes]
    by_cases hc : c.eval s.flag = true
    · simp only [hc, if_true, upd, and_true]
      by_cases h : r = d
      · subst h; simp
      · simp [h, Ne.symm h]
    · simp [hc]

theorem step_flag {α : Type} (ord : α → α → Ordering) (s : State α) (i : Instr) :
    (step ord s i).flag =
      if opOf i = 1 then ord (s.regs (dstOf i)) (s.regs (srcOf i)) else s.flag := by
  cases i with
  | mov d src => simp [step, opOf]
  | cmp a b => simp [step, opOf, dstOf, srcOf]
  | cmov c d src =>
    cases c <;> simp only [step, opOf] <;> split <;> simp

/-! The assignment defined by a program `q` and snapshots `o`. -/

section Asg
variable (n : Nat) (types : List (List Nat)) (q : Program) (o : Snap)

def X (w : Nat) : Nat → Int := fun i => (xOf n (types.getD w []) i : Int)

/-- Value of a content for type `w`. -/
def fC (w c : Nat) : Int := (rkC n (types.getD w []) c : Int)

def ordC (w : Nat) (a b : Nat) : Ordering := compare (fC n types w a) (fC n types w b)

def cinit : State Nat := ⟨fun r => initC n r, .eq⟩

/-- Content state of type `w` before step `t`. -/
def cs (w t : Nat) : State Nat := run (ordC n types w) (q.take t) (cinit n)

def ins (t : Nat) : Instr := q.getD t default

/-- The last step `< t` that can write register `r` (mov or cmov with first operand `r`). -/
def lastW : Nat → Nat → Option Nat
  | 0, _ => none
  | t+1, r => if opOf (ins q t) ≠ 1 ∧ dstOf (ins q t) = r then some t else lastW t r

/-- Index of the snapshot slot: `r` (initial content) or `n + i` (written at step `i`). -/
def snapIdx (t r : Nat) : Nat :=
  match lastW q t r with
  | some i => n + i
  | none => r

open Classical in
noncomputable def asg : V → Bool
  | .op t o => opOf (ins q t) == o
  | .dst t r => dstOf (ins q t) == r
  | .src t r => srcOf (ins q t) == r
  | .val w t r c => decide ((cs n types q w t).regs r = c)
  | .lt w t => (cs n types q w t).flag == .lt
  | .gt w t => (cs n types q w t).flag == .gt
  | .dv w t c => decide ((cs n types q w t).regs (dstOf (ins q t)) = c)
  | .sv w t c => decide ((cs n types q w t).regs (srcOf (ins q t)) = c)
  | .wr w t => writes (ins q t) (cs n types q w t).flag
  | .nv w t c => decide ((cs n types q w (t+1)).regs (dstOf (ins q t)) = c)
  | .os j m => snapIdx n q (o j).2 (o j).1 == m
  | .tc t r => decide (r ∈ touch (q.take t))
  | .sc t => (q.take t).any Instr.isCmp
  | .pd t => pendF false (q.take t)
  | .ag t w w' => decide (∀ t' ≤ t, cs n types q w t' = cs n types q w' t')
  | .cnt t w i c => decide (c ≤ (List.range i).countP
      (fun w' => decide (∀ t' ≤ t, cs n types q w t' = cs n types q w' t')))
  | .gc t c => decide (c ≤ ((q.drop t).filter Instr.isCmp).length)

theorem ins_eq (t : Nat) (ht : t < q.length) : ins q t = q[t] := by
  simp [ins, List.getD_eq_getElem?_getD, ht]

theorem cs_succ (w t : Nat) (ht : t < q.length) :
    cs n types q w (t+1) = step (ordC n types w) (cs n types q w t) (ins q t) := by
  have h1 : q.take (t+1) = q.take t ++ [q[t]] := by
    rw [List.take_add_one, List.getElem?_eq_getElem ht]; rfl
  simp only [cs, h1, run_append, ins_eq q t ht]
  rfl

theorem cs_zero (w : Nat) : cs n types q w 0 = cinit n := by simp [cs]

theorem ins_mem (t : Nat) (ht : t < q.length) : ins q t ∈ q := by
  rw [ins_eq q t ht]; exact List.getElem_mem ht

/-- The `Int` run of the relaxed model is the content run, mapped by `fC`. -/
theorem relax_eq (w t : Nat) :
    run compare (q.take t) (relaxInit n (X n types w) (n : Int)) = (cs n types q w t).map (fC n types w) := by
  have h0 : relaxInit n (X n types w) (n : Int) = (cinit n).map (fC n types w) := by
    simp only [relaxInit, cinit, State.map, fC, rkC, initC, X]
    congr 1; funext r
    by_cases hr : r < n <;> simp [hr]
  rw [h0]
  exact run_map (ordC n types w) compare (fC n types w) (fun _ _ => rfl) _ _

theorem lastW_lt (t r i : Nat) (h : lastW q t r = some i) : i < t := by
  induction t with
  | zero => simp [lastW] at h
  | succ t ih =>
    simp only [lastW] at h
    split at h
    · simp at h; omega
    · have := ih h; omega

theorem snap_content (w : Nat) : ∀ t, t ≤ q.length → ∀ r, (cs n types q w t).regs r =
    match lastW q t r with
    | some i => (cs n types q w (i+1)).regs (dstOf (ins q i))
    | none => initC n r := by
  intro t
  induction t with
  | zero => intro _ r; simp [lastW, cs_zero, cinit]
  | succ t ih =>
    intro ht r
    by_cases h : opOf (ins q t) ≠ 1 ∧ dstOf (ins q t) = r
    · simp only [lastW, h, if_true, ne_eq, not_false_eq_true, and_self]
    · have hl : lastW q (t+1) r = lastW q t r := by simp only [lastW]; rw [if_neg h]
      rw [hl, ← ih (by omega) r, cs_succ n types q w t (by omega), step_regs]
      rw [if_neg]
      intro ⟨hd, hw⟩
      apply h
      refine ⟨fun h1 => ?_, hd⟩
      rw [writes_cmp _ _ h1] at hw
      exact Bool.noConfusion hw

end Asg

/-! Generic clause lemmas. -/

theorem eval_alo (a : V → Bool) (m : Nat) (f : Nat → V) (i : Nat) (hi : i < m) (h : a (f i) = true) :
    CNF.Clause.eval a (alo m f) = true := by
  simp only [CNF.Clause.eval, alo, List.any_map, List.any_eq_true, List.mem_range]
  exact ⟨i, hi, by simp [pos, h]⟩

theorem eval_amo (a : V → Bool) (m : Nat) (f : Nat → V)
    (h : ∀ i j, i < j → a (f i) = true → a (f j) = true → False) :
    ∀ c ∈ amo m f, CNF.Clause.eval a c = true := by
  intro c hc
  simp only [amo, List.mem_flatMap, List.mem_range] at hc
  obtain ⟨i, _, j, _, hc⟩ := hc
  split at hc
  · simp only [List.mem_singleton] at hc
    subst hc
    cases hi : a (f i) <;> cases hj : a (f j) <;> simp [neg, hi, hj]
    exact h i j (by assumption) hi hj
  · simp at hc

theorem cmp_lt_eq (v u : Nat) : (compare (v : Int) (u : Int) == .lt) = decide (v < u) := by
  by_cases h : v < u
  · simp [h, Int.compare_eq_lt.mpr (by omega : (v : Int) < u)]
  · have : compare (v : Int) (u : Int) ≠ .lt := fun h' => h (by have := Int.compare_eq_lt.mp h'; omega)
    simp [h, this]

theorem cmp_gt_eq (v u : Nat) : (compare (v : Int) (u : Int) == .gt) = decide (u < v) := by
  by_cases h : u < v
  · simp [h, Int.compare_eq_gt.mpr (by omega : (u : Int) < v)]
  · have : compare (v : Int) (u : Int) ≠ .gt := fun h' => h (by have := Int.compare_eq_gt.mp h'; omega)
    simp [h, this]

theorem xOf_lt (n : Nat) (row : List Nat) (i : Nat) (hi : i < n) : xOf n row i < n :=
  Nat.mod_lt _ (by omega)

/-! Each clause family holds. -/

section Families
variable (n k : Nat) (i1 : Bool) (types : List (List Nat)) (q : Program) (o : Snap)
  (hlen : q.length = k) (hI0 : ∀ i ∈ q, i.inSet (isetOf i1) = true) (hWF : q.WF (n + k))
  (hor : ∀ j, (o j).1 < n + k) (hot : ∀ j, (o j).2 ≤ k) (hcorr : RelaxedSnap n q o)

include hlen hI0 in
theorem opOf_lt (t : Nat) (ht : t < k) : opOf (ins q t) < nOps i1 := by
  have hm := hI0 _ (ins_mem q t (hlen ▸ ht))
  generalize ins q t = i at hm
  cases i1 <;> cases i with
  | mov => simp [opOf, nOps]
  | cmp => simp [opOf, nOps]
  | cmov c d s => cases c <;> simp_all [opOf, Instr.inSet, Cond.inI0, isetOf, nOps]

include hlen hWF in
theorem dstOf_lt (t : Nat) (ht : t < k) : dstOf (ins q t) < n + k := by
  have hm := hWF _ (ins_mem q t (hlen ▸ ht))
  generalize ins q t = i at hm
  cases i <;> simp_all [dstOf, Instr.regs]

include hlen hWF in
theorem srcOf_lt (t : Nat) (ht : t < k) : srcOf (ins q t) < n + k := by
  have hm := hWF _ (ins_mem q t (hlen ▸ ht))
  generalize ins q t = i at hm
  cases i <;> simp_all [srcOf, Instr.regs]

include hcorr in
/-- The snapshot content of a correct program is a correct output. -/
theorem out_good (w j : Nat) (hj : j < n) :
    (cs n types q w (o j).2).regs (o j).1 ∈ good n (types.getD w []) j := by
  have h := hcorr (X n types w) (n : Int)
    (fun i hi => by simp only [X]; have := xOf_lt n (types.getD w []) i hi; omega)
  unfold SortsOK at h
  have hS : ((List.range n).map (X n types w)).mergeSort (fun a b => decide (a ≤ b))
      = sortedInt n (types.getD w []) := rfl
  rw [hS] at h
  have he : snapOut q o (relaxInit n (X n types w) (n : Int)) j
      = fC n types w ((cs n types q w (o j).2).regs (o j).1) := by
    simp only [snapOut, relax_eq]; rfl
  have hy : fC n types w ((cs n types q w (o j).2).regs (o j).1) = (sortedInt n (types.getD w [])).getD j 0 := by
    rw [← he, ← h]; simp [List.getD_eq_getElem?_getD, List.getElem?_map, hj]
  have hmem : (sortedInt n (types.getD w [])).getD j 0 ∈ sortedInt n (types.getD w []) := by
    rw [← h]; simp only [List.getD_eq_getElem?_getD, List.getElem?_map, List.getElem?_range hj,
      Option.map_some, Option.getD_some, List.mem_map, List.mem_range]; exact ⟨j, hj, rfl⟩
  simp only [sortedInt, List.mem_mergeSort, List.mem_map, List.mem_range] at hmem
  obtain ⟨i, hi, hiy⟩ := hmem
  have hxi := xOf_lt n (types.getD w []) i hi
  generalize (cs n types q w (o j).2).regs (o j).1 = c at hy ⊢
  simp only [good, List.mem_filter, List.mem_range, decide_eq_true_eq]
  simp only [fC, rkC] at hy
  by_cases hc : c < n
  · simp only [hc, if_true] at hy
    exact ⟨hc, hy⟩
  · simp only [hc, if_false] at hy
    have := hy.trans hiy.symm
    omega

theorem good_lt (row : List Nat) (j c : Nat) (h : c ∈ good n row j) : c < n := by
  simp only [good, List.mem_filter, List.mem_range] at h; exact h.1

include types hlen hot hcorr in
theorem snapIdx_lt (j : Nat) (hj : j < n) : snapIdx n q (o j).2 (o j).1 < n + k := by
  have hg := out_good n types q o hcorr 0 j hj
  rw [snap_content n types q 0 _ (by have := hot j; omega)] at hg
  simp only [snapIdx]
  split
  · next i hi => have := lastW_lt q _ _ _ hi; have := hot j; omega
  · next hi =>
    rw [hi] at hg
    have := good_lt n _ j _ hg
    simp only [initC] at this
    split at this <;> omega

include hlen hI0 hWF hot hcorr in
theorem progCls_sat : ∀ c ∈ progCls n k (n + k) i1, CNF.Clause.eval (asg n types q o) c = true := by
  intro c hc
  simp only [progCls, List.mem_append, List.mem_flatMap, List.mem_range, List.mem_cons,
    List.mem_map, List.mem_filter] at hc
  rcases hc with ⟨t, ht, hc⟩ | ⟨j, hj, hc⟩
  · rcases hc with (((rfl | hc) | ⟨u, ⟨_, hu⟩, rfl⟩) | (rfl | hc)) | (rfl | hc)
    · exact eval_alo _ _ _ _ (opOf_lt k i1 q hlen hI0 t ht) (by simp [asg])
    · exact eval_amo _ _ _ (fun i j hij hi hj => by simp [asg] at hi hj; omega) c hc
    · have := opOf_lt k i1 q hlen hI0 t ht
      have hu' : nOps i1 ≤ u := by simpa using hu
      simp [CNF.Clause.eval, neg, asg]; omega
    · exact eval_alo _ _ _ _ (dstOf_lt n k q hlen hWF t ht) (by simp [asg])
    · exact eval_amo _ _ _ (fun i j hij hi hj => by simp [asg] at hi hj; omega) c hc
    · exact eval_alo _ _ _ _ (srcOf_lt n k q hlen hWF t ht) (by simp [asg])
    · exact eval_amo _ _ _ (fun i j hij hi hj => by simp [asg] at hi hj; omega) c hc
  · rcases hc with rfl | hc
    · exact eval_alo _ _ _ _ (snapIdx_lt n k types q o hlen hot hcorr j hj) (by simp [asg])
    · exact eval_amo _ _ _ (fun i j hij hi hj => by simp [asg] at hi hj; omega) c hc

include hlen in
theorem regCls_sat (w t r c : Nat) (ht : t < k) :
    ∀ cl ∈ regCls w t r c, CNF.Clause.eval (asg n types q o) cl = true := by
  intro cl hc
  have hs := cs_succ n types q w t (hlen ▸ ht)
  simp only [regCls, List.mem_cons, List.not_mem_nil, or_false] at hc
  rcases hc with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl <;>
  · simp only [CNF.Clause.eval, List.any_cons, List.any_nil, pos, neg, asg, hs, step_regs]
    by_cases h1 : dstOf (ins q t) = r <;> by_cases h2 : srcOf (ins q t) = r <;>
      by_cases h3 : writes (ins q t) (cs n types q w t).flag = true <;> simp_all

include hlen in
theorem nvCls_sat (w t c : Nat) (ht : t < k) :
    ∀ cl ∈ nvCls w t c, CNF.Clause.eval (asg n types q o) cl = true := by
  intro cl hc
  have hs := cs_succ n types q w t (hlen ▸ ht)
  simp only [nvCls, List.mem_cons, List.not_mem_nil, or_false] at hc
  rcases hc with rfl | rfl | rfl | rfl <;>
  · simp only [CNF.Clause.eval, List.any_cons, List.any_nil, pos, neg, asg, hs, step_regs]
    by_cases h3 : writes (ins q t) (cs n types q w t).flag = true <;> simp_all

include hlen in
theorem stepCls_sat (w t : Nat) (ht : t < k) :
    ∀ c ∈ stepCls n (types.getD w []) w t, CNF.Clause.eval (asg n types q o) c = true := by
  intro c hc
  have hs := cs_succ n types q w t (hlen ▸ ht)
  simp only [stepCls, List.mem_append, List.mem_cons, List.not_mem_nil, or_false,
    List.mem_flatMap, List.mem_range] at hc
  rcases hc with (rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl) |
    ⟨v, _, u, _, hc⟩
  rotate_left 14
  · rcases hc with rfl | rfl
    all_goals
      simp only [CNF.Clause.eval, List.any_cons, List.any_nil, neg, asg, hs, step_flag, Bool.or_false]
      by_cases h1 : opOf (ins q t) = 1
      · by_cases h2 : (cs n types q w t).regs (dstOf (ins q t)) = v
        · by_cases h3 : (cs n types q w t).regs (srcOf (ins q t)) = u
          · simp only [h1, h2, h3, if_true, ordC, fC, cmp_lt_eq, cmp_gt_eq]; simp
          · simp [h3]
        · simp [h2]
      · simp [h1]
  all_goals
    simp only [CNF.Clause.eval, List.any_cons, List.any_nil, pos, neg, asg, hs, step_flag]
    generalize ins q t = i
    generalize (cs n types q w t).flag = f
    cases i with
    | mov => simp [opOf, writes]
    | cmp => simp [opOf, writes]
    | cmov c d s => cases c <;> cases f <;> simp [opOf, writes, Cond.eval]

include hlen hot hcorr in
theorem outCls_sat (w : Nat) :
    ∀ c ∈ outCls n k (types.getD w []) w, CNF.Clause.eval (asg n types q o) c = true := by
  intro c hc
  simp only [outCls, List.mem_flatMap, List.mem_range, List.mem_append, List.mem_map,
    List.mem_filter] at hc
  obtain ⟨j, hj, ⟨m, ⟨hm, hng⟩, rfl⟩ | ⟨i, hi, rfl⟩⟩ := hc
  · -- initial content `m < n` that is not a correct output
    have hg := out_good n types q o hcorr w j hj
    rw [snap_content n types q w _ (by have := hot j; omega)] at hg
    simp only [CNF.Clause.eval, List.any_cons, List.any_nil, neg, asg, Bool.or_false]
    simp only [snapIdx]
    split
    · next i' hi' => simp; omega
    · next hi' =>
      rw [hi'] at hg
      simp only [initC] at hg
      by_cases hr : (o j).1 = m
      · subst hr; simp only [hm, if_true] at hg
        simp only [List.getD_eq_getElem?_getD] at hg
        simp [List.contains_iff_mem, hg] at hng
      · simp [hr]
  · -- slot `n + i`
    have hg := out_good n types q o hcorr w j hj
    rw [snap_content n types q w _ (by have := hot j; omega)] at hg
    simp only [CNF.Clause.eval, List.any_cons, neg, asg]
    simp only [snapIdx]
    split
    · next i' hi' =>
      rw [hi'] at hg
      by_cases he : i' = i
      · subst he
        simp only at hg
        have hmem := List.mem_map_of_mem (f := fun c => pos (V.nv w i' c)) hg
        simp only [List.any_eq_true, Bool.or_eq_true]
        right
        exact ⟨_, hmem, by simp [pos, asg]⟩
      · have : n + i' ≠ n + i := by omega
        simp only [this, beq_iff_eq, Bool.not_eq_true', decide_false, Bool.not_false,
          Bool.true_or, Bool.or_eq_true]
        left; simp [he]
    · next hi' =>
      rw [hi'] at hg
      have := good_lt n _ j _ hg
      simp only [initC] at this
      have : (o j).1 ≠ n + i := by split at this <;> omega
      simp [this]

include hlen hot hcorr in
theorem simCls_sat (w : Nat) :
    ∀ c ∈ simCls n k (n + k) (types.getD w []) w, CNF.Clause.eval (asg n types q o) c = true := by
  intro c hc
  simp only [simCls, List.mem_append] at hc
  rcases hc with ((hc | hc) | hc) | hc
  · simp only [List.mem_flatMap, List.mem_map, List.mem_range] at hc
    obtain ⟨r, _, v, _, rfl⟩ := hc
    simp only [CNF.Clause.eval, List.any_cons, List.any_nil, Bool.or_false, asg, cs_zero, cinit]
    by_cases h : initC n r = v <;> simp [h]
  · simp only [List.mem_cons, List.not_mem_nil, or_false] at hc
    rcases hc with rfl | rfl <;> simp [CNF.Clause.eval, neg, asg, cs_zero, cinit]
  · simp only [List.mem_flatMap, List.mem_range, List.mem_append] at hc
    obtain ⟨t, ht, (hc | ⟨c', _, hc⟩) | ⟨r, _, c', _, hc⟩⟩ := hc
    · exact stepCls_sat n k types q o hlen w t ht c hc
    · exact nvCls_sat n k types q o hlen w t c' ht c hc
    · exact regCls_sat n k types q o hlen w t r c' ht c hc
  · exact outCls_sat n k types q o hlen hot hcorr w c hc

theorem touch_take_succ (t : Nat) (ht : t < q.length) :
    touch (q.take (t+1)) = touch (q.take t) ++ [dstOf (ins q t), srcOf (ins q t)] := by
  have h1 : q.take (t+1) = q.take t ++ [q[t]] := by
    rw [List.take_add_one, List.getElem?_eq_getElem ht]; rfl
  rw [h1, ins_eq q t ht]
  simp only [touch, List.flatMap_append, List.flatMap_cons, List.flatMap_nil, List.append_nil]

include hlen in
theorem canonCls_sat (hcan : Canonical n q) :
    ∀ c ∈ canonCls n k (n + k), CNF.Clause.eval (asg n types q o) c = true := by
  intro c hc
  simp only [canonCls, List.mem_append, List.mem_map, List.mem_flatMap, List.mem_range] at hc
  rcases hc with ⟨r, _, rfl⟩ | ⟨t, ht, r, _, hc⟩
  · simp [CNF.Clause.eval, neg, asg, touch]
  · have hs := touch_take_succ q t (by omega)
    have hcn := hcan t (by omega)
    rw [← ins_eq q t (by omega)] at hcn
    simp only [List.mem_append, List.mem_cons, List.not_mem_nil, or_false] at hc
    rcases hc with hc4 | hc
    · rcases hc4 with rfl | rfl | rfl | rfl <;>
      · simp only [CNF.Clause.eval, List.any_cons, List.any_nil, pos, neg, asg, hs,
          List.mem_append, List.mem_cons, List.not_mem_nil, or_false]
        by_cases h1 : r ∈ touch (List.take t q) <;>
          by_cases h2 : dstOf (ins q t) = r <;> by_cases h3 : srcOf (ins q t) = r <;> simp_all <;>
          exact ⟨fun h => h2 h.symm, fun h => h3 h.symm⟩
    split at hc
    · simp at hc
    · next hr =>
      simp only [List.mem_cons, List.not_mem_nil, or_false] at hc
      rcases hc with rfl | rfl
      · simp only [CNF.Clause.eval, List.any_cons, List.any_nil, pos, neg, asg]
        by_cases h2 : dstOf (ins q t) = r
        · have := hcn.1 (by omega) (by omega); rw [h2] at this; simp [h2, this]
        · simp [h2]
      · simp only [CNF.Clause.eval, List.any_cons, List.any_nil, pos, neg, asg]
        by_cases h2 : srcOf (ins q t) = r
        · rcases hcn.2 (by omega) (by omega) with h | h
          · rw [h2] at h; simp [h2, h]
          · rw [h2] at h; simp [h2, ← h]
        · simp [h2]

end Families

theorem encV_eval (n k : Nat) (i1 canon : Bool) (types : List (List Nat)) (norm hc : Bool) (a : V → Bool) :
    (encV n k i1 canon types norm hc).eval a = (encList n k i1 canon types norm hc).all (CNF.Clause.eval a) := by
  simp [encV, CNF.eval]

/-- Every allowed program (canonical if `canon`) gives a satisfying assignment. -/
theorem sat_of_prog (n k : Nat) (i1 canon : Bool) (types : List (List Nat)) (norm hc : Bool)
    (q : Program) (o : Snap)
    (hlen : q.length = k) (hWF : q.WF (n + k)) (hot : ∀ j, (o j).2 ≤ k)
    (hI0 : ∀ i ∈ q, i.inSet (isetOf i1)) (hq : RelaxedSnap n q o) (hcan : canon = true → Canonical n q)
    (hnorm : norm = true → ∀ c ∈ normCls k (n + k) ++ snapCls n k, CNF.Clause.eval (asg n types q o) c = true)
    (hhc : hc = true → ∀ c ∈ hcmpCls k types.length, CNF.Clause.eval (asg n types q o) c = true) :
    (encV n k i1 canon types norm hc).eval (asg n types q o) = true := by
  rw [encV_eval, List.all_eq_true]
  intro c hcm
  simp only [encList, List.mem_append, List.mem_flatMap, List.mem_range] at hcm
  rcases hcm with (((hc' | hc') | hc') | hc') | ⟨w, _, hc'⟩
  · exact progCls_sat n k i1 types q o hlen hI0 hWF hot hq c hc'
  · cases canon
    · simp at hc'
    · exact canonCls_sat n k types q o hlen (hcan rfl) c (by simpa using hc')
  · cases norm
    · simp at hc'
    · exact hnorm rfl c (by simpa using hc')
  · cases hc
    · simp at hc'
    · exact hhc rfl c (by simpa using hc')
  · exact simCls_sat n k types q o hlen hot hq w c hc'

end LeanLrat
