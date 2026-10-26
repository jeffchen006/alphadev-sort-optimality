import LeanLrat.SnapCmov
/-
  Normal form with a NOP suffix (work in progress, round 2): sat's rule `flags` and no self moves.
  Part 1: deleting a step that changes no register, and whose flag result is never read,
  keeps `RelaxedSnap` (snapshots after the step move one position down); the length is kept
  by a `nop` (= `mov 0 0`) at the end.
-/
namespace LeanLrat
open Std.Sat SortProof

def nopI : Instr := .mov 0 0

theorem step_nop {α : Type} (ord : α → α → Ordering) (s : State α) : step ord s nopI = s := by
  cases s; simp only [step, nopI, State.mk.injEq, and_true]
  funext r; simp only [upd]; split <;> simp_all

def isCmovI : Instr → Bool
  | .cmov _ _ _ => true
  | _ => false

/-- The flags at the start of `b` are never read: `b` has no cmov before its first cmp. -/
def FlagDead : Program → Prop
  | [] => True
  | i :: b => i.isCmp = true ∨ (isCmovI i = false ∧ FlagDead b)

theorem run_regs_eq {s s' : State Int} (b : Program) (hr : s.regs = s'.regs)
    (hf : s.flag = s'.flag ∨ FlagDead b) :
    ∀ m, (run compare (b.take m) s).regs = (run compare (b.take m) s').regs := by
  induction b generalizing s s' with
  | nil => intro m; simpa using hr
  | cons i b ih =>
    intro m
    cases m with
    | zero => simpa using hr
    | succ m =>
      simp only [List.take_succ_cons, run_cons]
      apply ih
      · funext r; rw [step_regs, step_regs, hr]
        rcases hf with hf | hf
        · rw [hf]
        · rcases hf with hc | ⟨hc, _⟩
          · cases i <;> simp_all [Instr.isCmp, writes]
          · cases i <;> simp_all [isCmovI, writes]
      · rcases hf with hf | hf
        · left; rw [step_flag, step_flag, hf, hr]
        · rcases hf with hc | ⟨hc, hb⟩
          · left; cases i <;> simp_all [Instr.isCmp, step_flag, opOf]
          · rcases hb' : decide (s.flag = s'.flag) with _ | _
            · right; exact hb
            · left; rw [step_flag, step_flag, hr, of_decide_eq_true hb']

/-- Snapshot positions after deleting the step at position `t`. -/
def shiftSnap (o : Snap) (t : Nat) : Snap :=
  fun j => ((o j).1, if (o j).2 ≤ t then (o j).2 else (o j).2 - 1)

/-- Deleting a step that keeps all registers, and whose flags are equal or never read. -/
theorem relaxed_delete {n : Nat} (a b : Program) (i : Instr) (o : Snap)
    (hno : ∀ (x : Nat → Int) (T : Int), (∀ i < n, x i < T) →
      (step compare (run compare a (relaxInit n x T)) i).regs = (run compare a (relaxInit n x T)).regs ∧
      ((step compare (run compare a (relaxInit n x T)) i).flag = (run compare a (relaxInit n x T)).flag ∨
        FlagDead b))
    (hot : ∀ j, (o j).2 ≤ (a ++ i :: b).length) (h : RelaxedSnap n (a ++ i :: b) o) :
    RelaxedSnap n (a ++ b ++ [nopI]) (shiftSnap o a.length) := by
  intro x T hx
  refine (sortsOK_congr (fun _ _ => rfl) (fun j _ => ?_)).mp (h x T hx)
  obtain ⟨hr, hf⟩ := hno x T hx
  simp only [snapOut, shiftSnap]
  have hj := hot j
  simp only [List.length_append, List.length_cons] at hj
  split
  · next hu =>
    rw [List.take_append_of_le_length hu, List.append_assoc, List.take_append_of_le_length hu]
  · next hu =>
    obtain ⟨m, hm⟩ : ∃ m, (o j).2 = a.length + 1 + m := ⟨(o j).2 - a.length - 1, by omega⟩
    have hmb : m ≤ b.length := by omega
    rw [hm, show a.length + 1 + m - 1 = a.length + m by omega]
    have e1 : (a ++ i :: b).take (a.length + 1 + m) = a ++ i :: b.take m := by
      rw [show a.length + 1 + m = a.length + (m + 1) by omega, List.take_length_add_append]; rfl
    have e2 : (a ++ b ++ [nopI]).take (a.length + m) = a ++ b.take m := by
      rw [List.append_assoc, List.take_length_add_append, List.take_append_of_le_length hmb]
    rw [e1, e2, run_append, run_append, run_cons]
    exact congrFun (run_regs_eq b hr hf m) _

/-! ### The normal form -/

/-- (N1) nops only at the end; (N2) no cmovl/cmovg before the first cmp; (N3) every cmp is read
  by a cmov before the next cmp; (N4) no self move `mov r, r` / `cmov r, r` except the nop. -/
structure Normal (p : Program) : Prop where
  nopSuffix : ∀ a b, p = a ++ nopI :: b → ∀ j ∈ b, j = nopI
  noEarly : ∀ a c d s b, p = a ++ Instr.cmov c d s :: b → (c = .l ∨ c = .g) → ∃ j ∈ a, j.isCmp = true
  cmpRead : ∀ a x y b, p = a ++ Instr.cmp x y :: b → ¬ FlagDead b
  noSelf : ∀ i ∈ p, i ≠ nopI → i.isCmp = false → dstOf i ≠ srcOf i

/-- Measure: sum of (position + c) over the non-nop steps. -/
def wsum : Nat → Program → Nat
  | _, [] => 0
  | c, i :: b => (if i = nopI then 0 else c) + wsum (c+1) b

def nn (p : Program) : Nat := p.countP (fun i => decide (i ≠ nopI))

theorem wsum_succ (c : Nat) (b : Program) : wsum (c+1) b = wsum c b + nn b := by
  induction b generalizing c with
  | nil => simp [wsum, nn]
  | cons i b ih =>
    simp only [wsum, nn, List.countP_cons] at *
    rw [ih]; by_cases h : i = nopI <;> simp [h] <;> omega

theorem wsum_append (c : Nat) (a b : Program) : wsum c (a ++ b) = wsum c a + wsum (c + a.length) b := by
  induction a generalizing c with
  | nil => simp [wsum]
  | cons i a ih => simp only [List.cons_append, wsum, ih, List.length_cons]; rw [show c + 1 + a.length = c + (a.length + 1) by omega]; omega

theorem wsum_nop (c : Nat) : wsum c [nopI] = 0 := by simp [wsum]

/-- Deleting step `i` (not a nop) and appending a nop lowers the measure. -/
theorem wsum_del (a b : Program) (i : Instr) (hi : i ≠ nopI) :
    wsum 1 (a ++ b ++ [nopI]) < wsum 1 (a ++ i :: b) := by
  rw [List.append_assoc, wsum_append, wsum_append, wsum_append, wsum_nop]
  simp only [wsum, hi, if_false]
  rw [wsum_succ (1 + a.length) b]; omega

/-- Moving a nop that has a non-nop after it to the end lowers the measure. -/
theorem wsum_movenop (a b : Program) (hb : 0 < nn b) :
    wsum 1 (a ++ b ++ [nopI]) < wsum 1 (a ++ nopI :: b) := by
  rw [List.append_assoc, wsum_append, wsum_append, wsum_append, wsum_nop]
  simp only [wsum, if_true]
  rw [wsum_succ (1 + a.length) b]; omega

/-! ### Existence of the normal form -/

theorem step_flag_nocmp {α : Type} (ord : α → α → Ordering) (s : State α) (i : Instr)
    (h : i.isCmp = false) : (step ord s i).flag = s.flag := by
  cases i with
  | mov => rfl
  | cmp => simp [Instr.isCmp] at h
  | cmov c d src => simp only [step]; split <;> rfl

theorem run_nocmp_flag {α : Type} (ord : α → α → Ordering) (a : Program) (s : State α)
    (h : ∀ j ∈ a, j.isCmp = false) : (run ord a s).flag = s.flag := by
  induction a generalizing s with
  | nil => rfl
  | cons i a ih =>
    rw [run_cons, ih _ (fun j hj => h j (by simp [hj]))]
    exact step_flag_nocmp _ _ _ (h i (by simp))

/-- The conditions of the search hypothesis `H` (length `k`, registers and snapshots bounded, iset). -/
def Allowed (n k : Nat) (iset : Cond → Bool) (p : Program) (o : Snap) : Prop :=
  p.length = k ∧ p.WF (n + k) ∧ (∀ j, (o j).1 < n + k) ∧ (∀ j, (o j).2 ≤ k) ∧ (∀ i ∈ p, i.inSet iset)

theorem allowed_del {n k : Nat} {iset : Cond → Bool} (hk : 0 < n + k) (a b : Program) (i : Instr) (o : Snap)
    (h : Allowed n k iset (a ++ i :: b) o) : Allowed n k iset (a ++ b ++ [nopI]) (shiftSnap o a.length) := by
  obtain ⟨hl, hw, hor, hot, hI⟩ := h
  refine ⟨by simp at hl ⊢; omega, ?_, fun j => hor j, fun j => ?_, ?_⟩
  · intro j hj r hr
    simp only [List.mem_append, List.mem_singleton] at hj
    rcases hj with (hj | hj) | rfl
    · exact hw j (by simp [hj]) r hr
    · exact hw j (by simp [hj]) r hr
    · simp [nopI, Instr.regs] at hr; omega
  · simp only [shiftSnap]; split <;> have := hot j <;> omega
  · intro j hj
    simp only [List.mem_append, List.mem_singleton] at hj
    rcases hj with (hj | hj) | rfl
    · exact hI j (by simp [hj])
    · exact hI j (by simp [hj])
    · rfl

theorem normalize (n k : Nat) (iset : Cond → Bool) (hk : 0 < n + k) :
    ∀ (p : Program) (o : Snap), Allowed n k iset p o → RelaxedSnap n p o →
      ∃ (p' : Program) (o' : Snap), Allowed n k iset p' o' ∧ RelaxedSnap n p' o' ∧ Normal p' := by
  intro p
  induction hm : wsum 1 p using Nat.strongRecOn generalizing p with
  | _ m ih =>
    intro o hA h
    -- one deletion step
    have del : ∀ a b i, p = a ++ i :: b → (i ≠ nopI ∨ 0 < nn b) →
        (∀ (x : Nat → Int) (T : Int), (∀ i < n, x i < T) →
          (step compare (run compare a (relaxInit n x T)) i).regs = (run compare a (relaxInit n x T)).regs ∧
          ((step compare (run compare a (relaxInit n x T)) i).flag = (run compare a (relaxInit n x T)).flag ∨
            FlagDead b)) →
        ∃ (p' : Program) (o' : Snap), Allowed n k iset p' o' ∧ RelaxedSnap n p' o' ∧ Normal p' := by
      intro a b i hp hi hno
      subst hp
      have hlt : wsum 1 (a ++ b ++ [nopI]) < m := by
        rw [← hm]; rcases hi with hi | hi
        · exact wsum_del a b i hi
        · by_cases e : i = nopI
          · subst e; exact wsum_movenop a b hi
          · exact wsum_del a b i e
      exact ih _ hlt _ rfl _ (allowed_del hk a b i o hA)
        (relaxed_delete a b i o hno (fun j => by have := hA.2.2.2.1 j; rw [hA.1]; exact this) h)
    by_cases h1 : ∀ a b, p = a ++ nopI :: b → ∀ j ∈ b, j = nopI
    · by_cases h2 : ∀ a c d s b, p = a ++ Instr.cmov c d s :: b → (c = .l ∨ c = .g) → ∃ j ∈ a, j.isCmp = true
      · by_cases h3 : ∀ a x y b, p = a ++ Instr.cmp x y :: b → ¬ FlagDead b
        · by_cases h4 : ∀ i ∈ p, i ≠ nopI → i.isCmp = false → dstOf i ≠ srcOf i
          · exact ⟨p, o, hA, h, ⟨h1, h2, h3, h4⟩⟩
          · -- a self move
            simp only [Classical.not_forall, Classical.not_not] at h4
            obtain ⟨i, hip, hin, hic, hds⟩ := h4
            obtain ⟨a, b, hp⟩ := List.mem_iff_append.mp hip
            refine del a b i hp (Or.inl hin) (fun x T _ => ⟨?_, Or.inl ?_⟩)
            · funext r; rw [step_regs]; split
              · next hh => rw [← hds, hh.1]
              · rfl
            · exact step_flag_nocmp _ _ _ hic
        · -- an unread cmp
          simp only [Classical.not_forall, Classical.not_not] at h3
          obtain ⟨a, x, y, b, hp, hfd⟩ := h3
          refine del a b _ hp (Or.inl (by simp [nopI])) (fun _ _ _ => ⟨?_, Or.inr hfd⟩)
          funext r; rw [step_regs]; simp [writes]
      · -- a cmovl / cmovg before the first cmp: flags are eq there, so it does nothing
        simp only [Classical.not_forall, not_exists, not_and] at h2
        obtain ⟨a, c, d, s, b, hp, hc, hno⟩ := h2
        refine del a b _ hp (Or.inl (by simp [nopI])) (fun x T _ => ?_)
        have hf : (run compare a (relaxInit n x T)).flag = .eq :=
          (run_nocmp_flag _ a _ (fun j hj => by cases e : j.isCmp; rfl; exact absurd e (hno j hj))).trans rfl
        have : (step compare (run compare a (relaxInit n x T)) (.cmov c d s)) = run compare a (relaxInit n x T) := by
          simp only [step, hf]; rcases hc with rfl | rfl <;> rfl
        rw [this]; exact ⟨rfl, Or.inl rfl⟩
    · -- a nop with a non-nop after it
      simp only [Classical.not_forall] at h1
      obtain ⟨a, b, hp, j, hj, hjn⟩ := h1
      refine del a b nopI hp (Or.inr ?_) (fun _ _ _ => by rw [step_nop]; exact ⟨rfl, Or.inl rfl⟩)
      exact List.countP_pos_iff.mpr ⟨j, hj, by simpa using hjn⟩

/-! ### The normal-form clauses hold for a `Normal` program -/

def noCC (i : Instr) : Prop := i.isCmp = false ∧ isCmovI i = false

theorem pendF_append (acc : Bool) (a b : Program) : pendF acc (a ++ b) = pendF (pendF acc a) b := by
  induction a generalizing acc with
  | nil => rfl
  | cons i a ih => exact ih _

theorem pendF_true (acc : Bool) (l : Program) (h : pendF acc l = true) :
    (acc = true ∧ ∀ j ∈ l, noCC j) ∨ ∃ a x y b, l = a ++ Instr.cmp x y :: b ∧ ∀ j ∈ b, noCC j := by
  induction l generalizing acc with
  | nil => left; simp only [pendF] at h; exact ⟨h, by simp⟩
  | cons i l ih =>
    rcases ih _ h with ⟨h1, h2⟩ | ⟨a, x, y, b, e, hb⟩
    · cases i with
      | cmp x y => right; exact ⟨[], x, y, l, rfl, h2⟩
      | cmov => simp at h1
      | mov d s =>
        left; refine ⟨h1, fun j hj => ?_⟩
        rcases List.mem_cons.mp hj with rfl | hj
        · exact ⟨rfl, rfl⟩
        · exact h2 j hj
    · right; exact ⟨i :: a, x, y, b, by simp [e], hb⟩

theorem flagDead_noCC (b c : Program) (hb : ∀ j ∈ b, noCC j) (hc : FlagDead c) : FlagDead (b ++ c) := by
  induction b with
  | nil => exact hc
  | cons i b ih =>
    have := hb i (by simp)
    right; exact ⟨this.2, ih (fun j hj => hb j (by simp [hj]))⟩

theorem split_at (q : Program) (t : Nat) (ht : t < q.length) :
    q = q.take t ++ q[t] :: q.drop (t+1) := by
  conv => lhs; rw [← List.take_append_drop t q]
  rw [List.drop_eq_getElem_cons ht]

theorem eq_nop (i : Instr) (h0 : opOf i = 0) (h1 : dstOf i = 0) (h2 : srcOf i = 0) : i = nopI := by
  cases i with
  | mov d s => simp_all [dstOf, srcOf, nopI]
  | cmp => simp [opOf] at h0
  | cmov c => cases c <;> simp [opOf] at h0

theorem take_succ_ins (q : Program) (t : Nat) (ht : t < q.length) :
    q.take (t+1) = q.take t ++ [ins q t] := by
  rw [List.take_add_one, List.getElem?_eq_getElem ht, ins_eq q t ht]; rfl

theorem eval_of_not (a : V → Bool) (c : Cl) (h : (∀ l ∈ c, a l.1 = !l.2) → False) :
    CNF.Clause.eval a c = true := by
  cases e : CNF.Clause.eval a c
  · exfalso; apply h
    intro l hl
    simp only [CNF.Clause.eval, List.any_eq_false] at e
    have := e l hl
    cases h1 : a l.1 <;> cases h2 : l.2 <;> simp_all
  · rfl

theorem isCmp_of_op1 (i : Instr) (h : opOf i = 1) : i.isCmp = true := by
  cases i with
  | cmp => rfl
  | mov => simp [opOf] at h
  | cmov c => cases c <;> simp [opOf] at h

theorem notCmp_of_op (i : Instr) (h : opOf i ≠ 1) : i.isCmp = false := by
  cases i with
  | cmp => simp [opOf] at h
  | mov => rfl
  | cmov => rfl

theorem opOf_le (i : Instr) : opOf i ≤ 5 := by
  cases i with
  | cmp => simp [opOf]
  | mov => simp [opOf]
  | cmov c => cases c <;> simp [opOf]

theorem op1_of_isCmp (i : Instr) (h : i.isCmp = true) : opOf i = 1 := by
  cases i with
  | cmp => rfl
  | mov => simp [Instr.isCmp] at h
  | cmov => simp [Instr.isCmp] at h

theorem pendF_step (acc : Bool) (i : Instr) :
    pendF acc [i] = if opOf i = 1 then true else if 2 ≤ opOf i then false else acc := by
  cases i with
  | cmp => simp [pendF, opOf]
  | mov => simp [pendF, opOf]
  | cmov c => cases c <;> simp [pendF, opOf]

theorem cmov_of_op (i : Instr) (h : opOf i = 2 ∨ opOf i = 3) : ∃ c d s, i = .cmov c d s ∧ (c = .l ∨ c = .g) := by
  cases i with
  | cmp => simp [opOf] at h
  | mov => simp [opOf] at h
  | cmov c d s => cases c <;> simp [opOf] at h <;> exact ⟨_, d, s, rfl, by simp⟩

theorem normCls_sat (n k : Nat) (types : List (List Nat)) (q : Program) (o : Snap)
    (hlen : q.length = k) (hN : Normal q) :
    ∀ c ∈ normCls k (n + k), CNF.Clause.eval (asg n types q o) c = true := by
  intro c hc
  simp only [normCls, List.mem_append, List.mem_cons, List.not_mem_nil, or_false, List.mem_flatMap,
    List.mem_range, List.mem_map, List.mem_filter] at hc
  rcases hc with (rfl | rfl | rfl) | ⟨t, ht, hc⟩
  · simp [CNF.Clause.eval, neg, asg]
  · simp [CNF.Clause.eval, neg, asg, pendF]
  · simp only [CNF.Clause.eval, List.any_cons, List.any_nil, neg, asg, ← hlen, List.take_length, Bool.or_false]
    cases hp : pendF false q
    · rfl
    · exfalso
      rcases pendF_true false q hp with ⟨h1, _⟩ | ⟨a, x, y, b, e, hb⟩
      · simp at h1
      · exact hN.cmpRead a x y b e (by simpa using flagDead_noCC b [] hb trivial)
  · have htq : t < q.length := by omega
    have hsp := split_at q t htq
    rw [← ins_eq q t htq] at hsp
    have hts := take_succ_ins q t htq
    have hsc : ∀ t', (q.take t').any Instr.isCmp = true ↔ ∃ j ∈ q.take t', j.isCmp = true := fun _ => by
      simp [List.any_eq_true]
    rcases hc with ((hc | ⟨r, _, o', ⟨ho, hor⟩, hc⟩) | hc) | hc
    · -- nop suffix
      split at hc
      · next h1 =>
        have key : opOf (ins q t) = 0 → dstOf (ins q t) = 0 → srcOf (ins q t) = 0 → ins q (t+1) = nopI := by
          intro a0 a1 a2
          have hn := eq_nop _ a0 a1 a2
          have hm : ins q (t+1) ∈ q.drop (t+1) := by
            rw [ins_eq q (t+1) (by omega)]
            exact List.mem_iff_getElem.mpr ⟨0, by simp; omega, by simp⟩
          rw [hn] at hsp
          exact hN.nopSuffix _ _ hsp _ hm
        simp only [List.mem_cons, List.not_mem_nil, or_false] at hc
        rcases hc with rfl | rfl | rfl <;>
        · apply eval_of_not; intro hall
          simp only [List.forall_mem_cons, List.not_mem_nil, false_implies, implies_true, forall_const, pos, neg, asg, Bool.not_true,
            Bool.not_false, beq_eq_false_iff_ne, beq_iff_eq, ne_eq, and_true] at hall
          have := key (by simpa using hall.1) (by simpa using hall.2.1) (by simpa using hall.2.2.1)
          have h4 := hall.2.2.2
          rw [this] at h4; simp [nopI, opOf, dstOf, srcOf] at h4
      · simp at hc
    · -- no self move
      subst hc
      apply eval_of_not; intro hall
      simp only [List.forall_mem_cons, List.not_mem_nil, false_implies, implies_true, forall_const, neg, asg, Bool.not_false, beq_iff_eq,
        and_true] at hall
      obtain ⟨a0, a1, a2⟩ := hall
      have hne : ins q t ≠ nopI := by
        intro e; rw [e] at a0 a1; simp only [nopI, opOf, dstOf] at a0 a1; subst a0 a1; simp at hor
      have hcf : (ins q t).isCmp = false := notCmp_of_op _ (by rw [a0]; intro h; subst h; simp at ho)
      exact hN.noSelf _ (ins_mem q t htq) hne hcf (by rw [a1, a2])
    · -- some cmp before
      have hsc1 : (q.take (t+1)).any Instr.isCmp = ((q.take t).any Instr.isCmp || (ins q t).isCmp) := by
        rw [hts, List.any_append]; simp
      rcases hc with rfl | rfl | rfl | rfl | rfl <;> apply eval_of_not <;> intro hall <;>
        simp only [List.forall_mem_cons, List.not_mem_nil, false_implies, implies_true, forall_const,
          pos, neg, asg, Bool.not_true, Bool.not_false, and_true] at hall
      · obtain ⟨h1, h2, h3⟩ := hall
        rw [hsc1, h2, Bool.false_or] at h1
        simp only [beq_eq_false_iff_ne] at h3
        exact h3 (op1_of_isCmp _ h1)
      · obtain ⟨h1, h2⟩ := hall
        rw [hsc1, h1, Bool.true_or] at h2; exact Bool.noConfusion h2
      · obtain ⟨h1, h2⟩ := hall
        rw [hsc1, isCmp_of_op1 _ (by simpa using h1), Bool.or_true] at h2; exact Bool.noConfusion h2
      all_goals
        obtain ⟨h1, h2⟩ := hall
        obtain ⟨cc, d, s', he, hcl⟩ := cmov_of_op (ins q t) (by simp at h1; omega)
        rw [he] at hsp
        obtain ⟨j, hj, hjc⟩ := hN.noEarly _ cc d s' _ hsp hcl
        rw [List.any_eq_false] at h2
        exact absurd hjc (by simp [h2 j hj])
    · -- pending unread cmp
      have hpd1 : pendF false (q.take (t+1)) = if opOf (ins q t) = 1 then true
          else if 2 ≤ opOf (ins q t) then false else pendF false (q.take t) := by
        rw [hts, pendF_append, pendF_step]
      have hop := opOf_le (ins q t)
      rcases hc with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl <;> apply eval_of_not <;> intro hall <;>
        simp only [List.forall_mem_cons, List.not_mem_nil, false_implies, implies_true, forall_const,
          pos, neg, asg, Bool.not_true, Bool.not_false, and_true, beq_iff_eq, beq_eq_false_iff_ne] at hall
      · obtain ⟨h1, h2⟩ := hall; rw [hpd1, if_pos h1] at h2; exact Bool.noConfusion h2
      · obtain ⟨h1, h2, h3, h4, h5, h6⟩ := hall
        rw [hpd1, h1] at h6
        split at h6
        · exact Bool.noConfusion h6
        · split at h6
          · omega
          · exact Bool.noConfusion h6
      · obtain ⟨h1, h2, h3⟩ := hall
        rw [hpd1, if_neg h2, h3] at h1
        split at h1 <;> exact Bool.noConfusion h1
      all_goals try
        (obtain ⟨h1, h2, h3⟩ := hall
         rw [hpd1, if_neg h2, if_pos (by omega)] at h1; exact Bool.noConfusion h1)
      obtain ⟨h1, h2⟩ := hall
      rcases pendF_true false _ h1 with ⟨h, _⟩ | ⟨a, x, y, b, e, hb⟩
      · exact Bool.noConfusion h
      · rw [e] at hsp
        apply hN.cmpRead a x y (b ++ ins q t :: q.drop (t+1)) (hsp.trans (by simp))
        exact flagDead_noCC _ _ hb (Or.inl (isCmp_of_op1 _ h2))

/-! ### Normal form is kept by renaming the non-nop prefix -/

theorem nop_split (p : Program) (h : ∀ a b, p = a ++ nopI :: b → ∀ j ∈ b, j = nopI) :
    ∃ pre m, p = pre ++ List.replicate m nopI ∧ nopI ∉ pre := by
  induction p with
  | nil => exact ⟨[], 0, rfl, by simp⟩
  | cons i p ih =>
    by_cases hi : i = nopI
    · subst hi
      have e : p = List.replicate p.length nopI := List.eq_replicate_iff.mpr ⟨rfl, h [] p rfl⟩
      refine ⟨[], p.length + 1, ?_, by simp⟩
      rw [List.replicate_succ, ← e]; rfl
    · obtain ⟨pre, m, e, hn⟩ := ih (fun a b hab => h (i :: a) b (by simp [hab]))
      refine ⟨i :: pre, m, by simp [e], ?_⟩
      simp only [List.mem_cons, not_or]; exact ⟨fun h' => hi h'.symm, hn⟩

section RenameNormal
variable (ρ : Nat → Nat) (hρ : ∀ a b, ρ a = ρ b → a = b)

theorem isCmp_rename (i : Instr) : (i.rename ρ).isCmp = i.isCmp := by cases i <;> rfl
theorem isCmovI_rename (i : Instr) : isCmovI (i.rename ρ) = isCmovI i := by cases i <;> rfl
theorem dstOf_rename (i : Instr) : dstOf (i.rename ρ) = ρ (dstOf i) := by cases i <;> rfl
theorem srcOf_rename (i : Instr) : srcOf (i.rename ρ) = ρ (srcOf i) := by cases i <;> rfl

theorem flagDead_rename (b : Program) : FlagDead (b.map (Instr.rename ρ)) ↔ FlagDead b := by
  induction b with
  | nil => exact Iff.rfl
  | cons i b ih => simp only [List.map_cons, FlagDead, isCmp_rename, isCmovI_rename, ih]

theorem flagDead_nops (b : Program) (m : Nat) : FlagDead (b ++ List.replicate m nopI) ↔ FlagDead b := by
  induction b with
  | nil =>
    simp only [List.nil_append, FlagDead, iff_true]
    induction m with
    | zero => trivial
    | succ m ih => right; exact ⟨rfl, ih⟩
  | cons i b ih => simp only [List.cons_append, FlagDead, ih]

theorem mem_rep (m : Nat) (j : Instr) (h : j ∈ List.replicate m nopI) : j = nopI :=
  List.eq_of_mem_replicate h

/-- A decomposition of `pre' ++ nops` at a non-nop step lies inside `pre'`. -/
theorem split_pre {pre' : Program} {m : Nat} {a b : Program} {i : Instr} (hi : i ≠ nopI)
    (e : pre' ++ List.replicate m nopI = a ++ i :: b) :
    ∃ b', pre' = a ++ i :: b' ∧ b = b' ++ List.replicate m nopI := by
  rcases List.append_eq_append_iff.mp e with ⟨a', h1, h2⟩ | ⟨c', h1, h2⟩
  · -- a = pre' ++ a'
    exfalso
    have : i ∈ List.replicate m nopI := by rw [h2]; simp
    exact hi (mem_rep m i this)
  · -- pre' = a ++ c'
    cases c' with
    | nil =>
      simp at h2
      exact absurd (mem_rep m i (by rw [← h2]; simp)) hi
    | cons x c' =>
      simp only [List.cons_append, List.cons.injEq] at h2
      obtain ⟨rfl, rfl⟩ := h2
      exact ⟨c', h1, rfl⟩

include hρ in
theorem normal_rename_pad (pre : Program) (m : Nat) (hn : nopI ∉ pre)
    (hN : Normal (pre ++ List.replicate m nopI)) :
    Normal (pre.map (Instr.rename ρ) ++ List.replicate m nopI) := by
  -- the renamed prefix has no nop
  have hnn : nopI ∉ pre.map (Instr.rename ρ) := by
    intro hm
    obtain ⟨i, hi, e⟩ := List.mem_map.mp hm
    cases i with
    | cmp => simp [Instr.rename, nopI] at e
    | cmov => simp [Instr.rename, nopI] at e
    | mov d s =>
      simp only [Instr.rename, nopI, Instr.mov.injEq] at e
      have hds : d = s := hρ _ _ (e.1.trans e.2.symm)
      have hne : Instr.mov d s ≠ nopI := fun h' => hn (h' ▸ hi)
      exact hN.noSelf _ (by simp [hi]) hne rfl (by simp [dstOf, srcOf, hds])
  -- transport a decomposition of the renamed prefix back
  have back : ∀ a i b', pre.map (Instr.rename ρ) = a ++ i :: b' →
      ∃ a0 i0 b0, pre = a0 ++ i0 :: b0 ∧ a0.map (Instr.rename ρ) = a ∧ i0.rename ρ = i ∧
        b0.map (Instr.rename ρ) = b' := by
    intro a i b' e
    obtain ⟨a0, r0, h1, h2, h3⟩ := List.map_eq_append_iff.mp e
    obtain ⟨i0, b0, h4, h5, h6⟩ := List.map_eq_cons_iff.mp h3
    exact ⟨a0, i0, b0, by rw [h1, h4], h2, h5, h6⟩
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro a b e j hj
    rcases List.append_eq_append_iff.mp e with ⟨a', _, h2⟩ | ⟨c', h1, h2⟩
    · exact mem_rep m j (by rw [h2]; simp [hj])
    · cases c' with
      | nil =>
        rw [List.nil_append] at h2
        exact mem_rep m j (by rw [← h2]; exact List.mem_cons_of_mem _ hj)
      | cons x c' =>
        simp only [List.cons_append, List.cons.injEq] at h2
        exact absurd (by rw [h1, ← h2.1]; simp) hnn
  · intro a c d s b e hc
    obtain ⟨b', h1, _⟩ := split_pre (i := Instr.cmov c d s) (by simp [nopI]) e
    obtain ⟨a0, i0, b0, h3, h4, h5, _⟩ := back a _ b' h1
    cases i0 with
    | cmp => simp [Instr.rename] at h5
    | mov => simp [Instr.rename] at h5
    | cmov c0 d0 s0 =>
      simp only [Instr.rename, Instr.cmov.injEq] at h5
      obtain ⟨rfl, -, -⟩ := h5
      obtain ⟨j, hj, hjc⟩ := hN.noEarly a0 _ d0 s0 (b0 ++ List.replicate m nopI) (by rw [h3]; simp) hc
      exact ⟨j.rename ρ, by rw [← h4]; exact List.mem_map_of_mem hj, by rw [isCmp_rename]; exact hjc⟩
  · intro a x y b e hfd
    obtain ⟨b', h1, h2⟩ := split_pre (i := Instr.cmp x y) (by simp [nopI]) e
    obtain ⟨a0, i0, b0, h3, _, h5, h6⟩ := back a _ b' h1
    cases i0 with
    | cmov => simp [Instr.rename] at h5
    | mov => simp [Instr.rename] at h5
    | cmp x0 y0 =>
      apply hN.cmpRead a0 x0 y0 (b0 ++ List.replicate m nopI) (by rw [h3]; simp)
      rw [flagDead_nops, ← flagDead_rename ρ, h6, ← flagDead_nops b' m, ← h2]; exact hfd
  · intro i hi hin hic
    rcases List.mem_append.mp hi with hi | hi
    · obtain ⟨i0, hi0, rfl⟩ := List.mem_map.mp hi
      have hne : i0 ≠ nopI := fun h' => hn (h' ▸ hi0)
      have := hN.noSelf i0 (by simp [hi0]) hne (by rw [← isCmp_rename ρ]; exact hic)
      rw [dstOf_rename, srcOf_rename]
      exact fun h' => this (hρ _ _ h')
    · exact absurd (mem_rep _ _ hi) hin

end RenameNormal

/-! ### Soundness with both rules (first-touch + normal form) -/

theorem run_nops' (m : Nat) (s : State Int) : run compare (List.replicate m nopI) s = s := by
  induction m with
  | zero => rfl
  | succ m ih => rw [List.replicate_succ, run_cons, step_nop, ih]

theorem canonical_pad (n : Nat) (L : Program) (m : Nat) (h : Canonical n L) :
    Canonical n (L ++ List.replicate m nopI) := by
  intro t ht
  by_cases htl : t < L.length
  · have e1 : (L ++ List.replicate m nopI)[t] = L[t] := List.getElem_append_left htl
    have e2 : (L ++ List.replicate m nopI).take t = L.take t := List.take_append_of_le_length (by omega)
    rw [e1, e2]; exact h t htl
  · have e1 : (L ++ List.replicate m nopI)[t] = nopI := by
      rw [List.getElem_append_right (by omega)]; simp
    rw [e1]; simp [nopI, dstOf, srcOf]

theorem snapCls_sat (n k : Nat) (types : List (List Nat)) (q : Program) (o : Snap) (hn : 2 ≤ n)
    (hlen : q.length = k) (hot : ∀ j, (o j).2 ≤ k) (h : RelaxedSnap n q o)
    (hsl : ∀ j, lastW q (o j).2 (o j).1 = none ∨ ∃ i, lastW q (o j).2 (o j).1 = some i ∧ opOf (ins q i) ≠ 0) :
    ∀ c ∈ snapCls n k, CNF.Clause.eval (asg n types q o) c = true := by
  intro c hc
  simp only [snapCls, List.mem_flatMap, List.mem_range, List.mem_append, List.mem_map] at hc
  obtain ⟨j, hj, ⟨m, hm, rfl⟩ | ⟨i', hi', rfl⟩⟩ := hc
  all_goals
    rcases hsl j with hno | ⟨i, hi, hop⟩
    · exact (no_init_out q hn h j hj (by rw [hlen]; exact hot j) hno).elim
    have h1 := (lastW_some q _ _ _ hi).1
    have h5 := opOf_le (ins q i)
    apply eval_of_not; intro hall
    simp only [List.forall_mem_cons, List.not_mem_nil, false_implies, implies_true, forall_const,
      pos, neg, asg, snapIdx, hi, Bool.not_true, Bool.not_false, and_true, beq_iff_eq,
      beq_eq_false_iff_ne] at hall
  · omega
  · obtain ⟨h0, h2, h3, h4, h6⟩ := hall
    have : i = i' := by omega
    subst this
    omega

theorem sound_norm_gen (n k : Nat) (i1 : Bool) (types : List (List Nat)) (hn : 2 ≤ n) (hc : Bool)
    (hH : hc = true → HcOK n k types) (hU : (encV n k i1 true types true hc).Unsat) :
    ∀ (p : Program) (o : Snap), p.length = k → Program.WF (n + k) p →
      (∀ j, (o j).1 < n + k) → (∀ j, (o j).2 ≤ k) → (∀ i ∈ p, i.inSet (isetOf i1)) →
      ¬ RelaxedSnap n p o := by
  intro p o hlen hWF hor hot hI h
  obtain ⟨p1, o1, ⟨hl1, hw1, hor1, hot1, hI1⟩, h1, hN⟩ :=
    normalize n k (isetOf i1) (by omega) p o ⟨hlen, hWF, hor, hot, hI⟩ h
  obtain ⟨pre, m, e, hnp⟩ := nop_split p1 hN.nopSuffix
  subst e
  have hwpre : Program.WF (n + k) pre := fun i hi r hr => hw1 i (by simp [hi]) r hr
  -- snapshots clamped into the prefix
  let o2 : Snap := fun j => ((o1 j).1, min (o1 j).2 pre.length)
  have h2 : RelaxedSnap n pre o2 := by
    intro x T hx
    refine (sortsOK_congr (fun _ _ => rfl) (fun j _ => ?_)).mp (h1 x T hx)
    simp only [snapOut, o2]
    by_cases hu : (o1 j).2 ≤ pre.length
    · rw [Nat.min_eq_left hu, List.take_append_of_le_length hu]
    · rw [Nat.min_eq_right (by omega), List.take_length, List.take_append, List.take_of_length_le (by omega),
        run_append, List.take_replicate, run_nops']
  let ρ := ρc n k pre
  let o' : Snap := fun j => (ρ (o2 j).1, (o2 j).2)
  have h3 : RelaxedSnap n (Program.rename ρ pre) o' :=
    relaxed_snap_perm _ _ (inv1 hwpre) (inv2 hwpre) (cls hwpre) h2
  have h4 : RelaxedSnap n (pad (Program.rename ρ pre) m) o' :=
    relaxed_snap_pad m (fun j => by simp only [o', o2, Program.rename, List.length_map]; exact Nat.min_le_right _ _) h3
  have hinj := inj_of_inv _ _ (inv1 hwpre)
  have hNorm : Normal (pre.map (Instr.rename ρ) ++ List.replicate m nopI) :=
    normal_rename_pad ρ hinj pre m hnp hN
  have hCan : Canonical n (pre.map (Instr.rename ρ) ++ List.replicate m nopI) :=
    canonical_pad n _ m (rename_canonical hwpre)
  have hl' : (pre.map (Instr.rename ρ) ++ List.replicate m nopI).length = k := by simp at hl1 ⊢; omega
  have hw' : Program.WF (n + k) (pre.map (Instr.rename ρ) ++ List.replicate m nopI) := by
    intro i hi r hr
    rcases List.mem_append.mp hi with hi | hi
    · obtain ⟨j, hj, rfl⟩ := List.mem_map.mp hi
      cases j <;> simp only [Instr.rename, Instr.regs, List.mem_cons, List.not_mem_nil, or_false] at hr <;>
        rcases hr with rfl | rfl <;> exact (cls2 hwpre _).mp (hwpre _ hj _ (by simp [Instr.regs]))
    · rw [mem_rep m i hi] at hr; simp [nopI, Instr.regs] at hr; omega
  have hot' : ∀ j, (o' j).2 ≤ k := fun j => by
    simp only [o', o2]; have := Nat.min_le_right (o1 j).2 pre.length; simp at hl1; omega
  have hI' : ∀ i ∈ pre.map (Instr.rename ρ) ++ List.replicate m nopI, i.inSet (isetOf i1) := by
    intro i hi
    rcases List.mem_append.mp hi with hi | hi
    · obtain ⟨j, hj, rfl⟩ := List.mem_map.mp hi
      rw [inSet_rename]; exact hI1 j (by simp [hj])
    · rw [mem_rep m i hi]; rfl
  -- snapshots chased to cmov slots
  let q' := pre.map (Instr.rename ρ) ++ List.replicate m nopI
  let o'' : Snap := fun j => ((chase q' (o' j).2 (o' j).1).2, (chase q' (o' j).2 (o' j).1).1)
  have hot'' : ∀ j, (o'' j).2 ≤ k := fun j => Nat.le_trans (chase_le q' _ _) (hot' j)
  have h5 : RelaxedSnap n q' o'' := by
    intro x T hx
    refine (sortsOK_congr (fun _ _ => rfl) (fun j _ => ?_)).mp (h4 x T hx)
    exact (chase_val q' compare (relaxInit n x T) _ _ (by rw [hl']; exact hot' j)).symm
  have := hU (asg n types q' o'')
  rw [sat_of_prog n k i1 true types true hc _ o'' hl' hw' hot'' hI' h5 (fun _ => hCan)
    (fun _ c hc => by
      rcases List.mem_append.mp hc with hc | hc
      · exact normCls_sat n k types _ o'' hl' hNorm c hc
      · exact snapCls_sat n k types q' o'' hn hl' hot'' h5 (fun j => chase_slot q' _ _) c hc)
    (fun e => hH e q' o'' hl' hot'' h5)] at this
  exact Bool.noConfusion this

theorem sound_norm (n k : Nat) (i1 : Bool) (types : List (List Nat)) (hn : 2 ≤ n)
    (hU : (encV n k i1 true types true).Unsat) :
    ∀ (p : Program) (o : Snap), p.length = k → Program.WF (n + k) p →
      (∀ j, (o j).1 < n + k) → (∀ j, (o j).2 ≤ k) → (∀ i ∈ p, i.inSet (isetOf i1)) →
      ¬ RelaxedSnap n p o :=
  sound_norm_gen n k i1 types hn false (by simp) hU

end LeanLrat
