import SortProof.Snap
/-
  Shared definitions for rule NG (enum PRUNING v3, theory L10).
  A register is *accessed* after a prefix `pre` if it is an input (`r < n`) or appears in an instruction of `pre`.
  A program is *NG-normal* if every instruction reads only accessed registers, except a *garbage move* `mov a b`
  with `a ≠ b` both not accessed (both then hold `T` in the relaxed run).
-/
namespace LeanReflect
open SortProof

/-- Registers an instruction reads (a cmov reads its destination too). -/
def _root_.SortProof.Instr.reads : Instr → List Nat
  | .mov _ s => [s]
  | .cmp a b => [a, b]
  | .cmov _ d s => [d, s]

def accd (n : Nat) (pre : Program) (r : Nat) : Prop := r < n ∨ ∃ i ∈ pre, r ∈ i.regs

instance (n : Nat) (pre : Program) (r : Nat) : Decidable (accd n pre r) := by
  unfold accd; infer_instance

/-- The NG condition for instruction `i` after prefix `pre`. -/
def ngOK (n : Nat) (pre : Program) (i : Instr) : Prop :=
  (∀ r ∈ i.reads, accd n pre r) ∨
  (∃ a b, i = .mov a b ∧ a ≠ b ∧ ¬ accd n pre a ∧ ¬ accd n pre b)

def NGNormal (n : Nat) (q : Program) : Prop := ∀ t (h : t < q.length), ngOK n (q.take t) q[t]

end LeanReflect
