import LeanLrat.Canon
import SortProof.SortFacts
/-
  Rule `snapcmov` (sat): every output snapshot can be taken at a value written by a cmov.
  `chase` follows mov copies back to their source; `chase_val` keeps the snapshot value (for every
  run); an initial input is never a correct output (n ≥ 2), so the chased slot is a cmov write.
-/
namespace LeanLrat
open Std.Sat SortProof

section
variable (q : Program)

/-- State before step `t` of a run from `s`. -/
def stA {α : Type} (ord : α → α → Ordering) (s : State α) (t : Nat) : State α := run ord (q.take t) s

theorem stA_succ {α : Type} (ord : α → α → Ordering) (s : State α) (t : Nat) (ht : t < q.length) :
    stA q ord s (t+1) = step ord (stA q ord s t) (ins q t) := by
  have h1 : q.take (t+1) = q.take t ++ [q[t]] := by
    rw [List.take_add_one, List.getElem?_eq_getElem ht]; rfl
  simp only [stA, h1, run_append, ins_eq q t ht]
  rfl

theorem snap_gen {α : Type} (ord : α → α → Ordering) (s : State α) :
    ∀ t, t ≤ q.length → ∀ r, (stA q ord s t).regs r =
    match lastW q t r with
    | some i => (stA q ord s (i+1)).regs (dstOf (ins q i))
    | none => s.regs r := by
  intro t
  induction t with
  | zero => intro _ r; simp [lastW, stA]
  | succ t ih =>
    intro ht r
    by_cases h : opOf (ins q t) ≠ 1 ∧ dstOf (ins q t) = r
    · simp only [lastW, h, if_true, ne_eq, not_false_eq_true, and_self]
    · have hl : lastW q (t+1) r = lastW q t r := by simp only [lastW]; rw [if_neg h]
      rw [hl, ← ih (by omega) r, stA_succ q ord s t (by omega), step_regs]
      rw [if_neg]
      intro ⟨hd, hw⟩
      apply h
      refine ⟨fun h1 => ?_, hd⟩
      rw [writes_cmp _ _ h1] at hw
      exact Bool.noConfusion hw

/-- Follow mov copies back. -/
def chase (t r : Nat) : Nat × Nat :=
  match h : lastW q t r with
  | none => (t, r)
  | some i => if opOf (ins q i) = 0 then chase i (srcOf (ins q i)) else (t, r)
termination_by t
decreasing_by exact lastW_lt q t r i h

theorem chase_spec (P : Nat → Nat → Nat × Nat → Prop)
    (hnone : ∀ t r, lastW q t r = none → P t r (t, r))
    (hmov : ∀ t r i, lastW q t r = some i → opOf (ins q i) = 0 →
      P i (srcOf (ins q i)) (chase q i (srcOf (ins q i))) → P t r (chase q i (srcOf (ins q i))))
    (hother : ∀ t r i, lastW q t r = some i → opOf (ins q i) ≠ 0 → P t r (t, r)) :
    ∀ t r, P t r (chase q t r) := by
  intro t
  induction t using Nat.strongRecOn with
  | _ t ih =>
    intro r
    rw [chase]
    split
    · next h => exact hnone t r h
    · next i h =>
      split
      · next hm => exact hmov t r i h hm (ih i (lastW_lt q t r i h) _)
      · next hm => exact hother t r i h hm

theorem chase_val {α : Type} (ord : α → α → Ordering) (s : State α) (t r : Nat) (ht : t ≤ q.length) :
    (stA q ord s (chase q t r).1).regs (chase q t r).2 = (stA q ord s t).regs r := by
  revert ht
  refine chase_spec q (fun t r c => t ≤ q.length → (stA q ord s c.1).regs c.2 = (stA q ord s t).regs r)
    (fun _ _ _ _ => rfl) ?_ (fun _ _ _ _ _ _ => rfl) t r
  intro t r i h hm ih ht
  have hit := lastW_lt q t r i h
  rw [ih (by omega), snap_gen q ord s t ht r, h]
  simp only
  rw [stA_succ q ord s i (by omega), step_regs]
  have hw : writes (ins q i) (stA q ord s i).flag = true := by
    generalize ins q i = x at hm; cases x with
    | mov => rfl
    | cmp => simp [opOf] at hm
    | cmov c => cases c <;> simp [opOf] at hm
  simp [hw]

theorem chase_le (t r : Nat) : (chase q t r).1 ≤ t := by
  refine chase_spec q (fun t _ c => c.1 ≤ t) (fun _ _ _ => Nat.le_refl _) ?_ (fun _ _ _ _ _ => Nat.le_refl _) t r
  intro t r i h _ ih
  have := lastW_lt q t r i h; omega

theorem chase_slot (t r : Nat) :
    lastW q (chase q t r).1 (chase q t r).2 = none ∨
      ∃ i, lastW q (chase q t r).1 (chase q t r).2 = some i ∧ opOf (ins q i) ≠ 0 := by
  refine chase_spec q (fun _ _ c => lastW q c.1 c.2 = none ∨ ∃ i, lastW q c.1 c.2 = some i ∧ opOf (ins q i) ≠ 0)
    (fun t r h => Or.inl h) (fun _ _ _ _ _ ih => ih) (fun t r i h hm => Or.inr ⟨i, h, hm⟩) t r

theorem lastW_some (t r i : Nat) (h : lastW q t r = some i) : opOf (ins q i) ≠ 1 ∧ dstOf (ins q i) = r := by
  induction t with
  | zero => simp [lastW] at h
  | succ t ih =>
    simp only [lastW] at h
    split at h
    · next hh => simp at h; subst h; exact hh
    · exact ih h

theorem chase_reg (k : Nat) (hWF : q.WF k) (t r : Nat) (ht : t ≤ q.length) (hr : r < k) :
    (chase q t r).2 < k := by
  revert ht hr
  refine chase_spec q (fun t r c => t ≤ q.length → r < k → c.2 < k) (fun _ _ _ _ h => h) ?_
    (fun _ _ _ _ _ _ h => h) t r
  intro t r i h _ ih ht _
  have hit := lastW_lt q t r i h
  exact ih (by omega) (hWF _ (ins_mem q i (by omega)) _ (srcOf_mem _))

/-- For `n ≥ 2`, a correct snapshot is never an initial register (never written before it). -/
theorem no_init_out {n : Nat} (hn : 2 ≤ n) {o : Snap} (h : RelaxedSnap n q o) (j : Nat) (hj : j < n)
    (ht : (o j).2 ≤ q.length) (hnone : lastW q (o j).2 (o j).1 = none) : False := by
  have hval : ∀ (x : Nat → Int) (T : Int), snapOut q o (relaxInit n x T) j =
      if (o j).1 < n then x (o j).1 else T := by
    intro x T
    have := snap_gen q compare (relaxInit n x T) (o j).2 ht (o j).1
    rw [hnone] at this
    simp only [snapOut]; exact this
  by_cases hr : (o j).1 < n
  · -- input A: x_r = 1, others 0; input B: x_r = 0, others 1
    have hA := h (fun i => if i = (o j).1 then 1 else 0) 2 (fun i _ => by split <;> omega)
    have hB := h (fun i => if i = (o j).1 then 0 else 1) 2 (fun i _ => by split <;> omega)
    have a1 := sortsOK_rank_lt hA hj
    have b1 := sortsOK_rank_le hB hj
    rw [hval, if_pos hr, if_pos rfl, cnt_ind] at a1
    rw [hval, if_pos hr, if_pos rfl, cnt_ind] at b1
    simp [hr] at a1 b1
    omega
  · have hC := h (fun _ => 0) 1 (fun _ _ => by omega)
    have c1 := sortsOK_rank_lt hC hj
    rw [hval, if_neg hr] at c1
    have hc : ∀ m, cnt (fun _ => (0 : Int)) 1 m = m := fun m => by
      induction m with
      | zero => rfl
      | succ m ih => simp [cnt, ih]
    rw [hc] at c1
    omega

end

end LeanLrat
