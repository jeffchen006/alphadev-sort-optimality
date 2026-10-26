/-
  Abstract machine (MODEL.md section 1).
  Registers are indexed by `Nat`: register `i < n` is `P i`, register `n + j` is `S j`.
  A register budget `R` is a well-formedness bound (`Program.WF R`), not part of the state.
  Values have any type `α`; the machine reads values only through a compare function `ord`.
  The flag state is one `Ordering` (lt / eq / gt); `X86.lean` proves that this is exact
  for the x86 flags `ZF SF OF` and the conditions L, G, LE, GE.
-/
namespace SortProof

/-- Condition codes of the cmov instructions in I0 (`l`, `g`) and I1 (`le`, `ge`). -/
inductive Cond where
  | l | g | le | ge
deriving DecidableEq, Repr, Inhabited

inductive Instr where
  | mov (d s : Nat)
  | cmp (a b : Nat)
  | cmov (c : Cond) (d s : Nat)
deriving DecidableEq, Repr, Inhabited

abbrev Program := List Instr

/-- Value of a condition code for a flag state. -/
def Cond.eval : Cond → Ordering → Bool
  | .l, o => o == .lt
  | .g, o => o == .gt
  | .le, o => o != .gt
  | .ge, o => o != .lt

/-- Instruction set I0 = mov, cmp, cmovl, cmovg. -/
def Cond.inI0 : Cond → Bool
  | .l | .g => true
  | _ => false

def Instr.inSet (iset : Cond → Bool) : Instr → Bool
  | .cmov c _ _ => iset c
  | _ => true

def Instr.regs : Instr → List Nat
  | .mov d s => [d, s]
  | .cmp a b => [a, b]
  | .cmov _ d s => [d, s]

/-- The register that the instruction can write (cmp writes only the flags). -/
def Instr.dest? : Instr → Option Nat
  | .mov d _ => some d
  | .cmp _ _ => none
  | .cmov _ d _ => some d

/-- All registers of the program are `< R`. -/
def Program.WF (R : Nat) (p : Program) : Prop := ∀ i ∈ p, ∀ r ∈ i.regs, r < R

structure State (α : Type) where
  regs : Nat → α
  flag : Ordering

def upd {α : Type} (f : Nat → α) (d : Nat) (v : α) : Nat → α :=
  fun r => if r = d then v else f r

def step {α : Type} (ord : α → α → Ordering) (s : State α) : Instr → State α
  | .mov d src => { s with regs := upd s.regs d (s.regs src) }
  | .cmp a b => { s with flag := ord (s.regs a) (s.regs b) }
  | .cmov c d src =>
      if c.eval s.flag then { s with regs := upd s.regs d (s.regs src) } else s

def run {α : Type} (ord : α → α → Ordering) (p : Program) (s : State α) : State α :=
  p.foldl (step ord) s

@[simp] theorem run_nil {α} (ord : α → α → Ordering) (s : State α) : run ord [] s = s := rfl
@[simp] theorem run_cons {α} (ord : α → α → Ordering) (i : Instr) (p : Program) (s : State α) :
    run ord (i :: p) s = run ord p (step ord s i) := rfl
theorem run_append {α} (ord : α → α → Ordering) (p q : Program) (s : State α) :
    run ord (p ++ q) s = run ord q (run ord p s) := by
  simp [run, List.foldl_append]

def State.map {α β : Type} (f : α → β) (s : State α) : State β :=
  { regs := fun r => f (s.regs r), flag := s.flag }

/-- Sorting specification: output registers `P0..P{n-1}` hold the inputs in ascending order,
  i.e. they equal `List.mergeSort` of the input list (core Lean's verified sort). -/
def SortsOK (n : Nat) (x y : Nat → Int) : Prop :=
  (List.range n).map y = ((List.range n).map x).mergeSort (fun a b => decide (a ≤ b))

instance (n : Nat) (x y : Nat → Int) : Decidable (SortsOK n x y) := by
  unfold SortsOK; infer_instance

/-- Strict model: correct for every initial state (every input, every garbage value
  of the scratch registers, every flag state). Values are unbounded `Int`;
  `X86.lean` transfers this to 32-bit registers. -/
def StrictCorrect (n : Nat) (p : Program) : Prop :=
  ∀ s : State Int, SortsOK n s.regs (run compare p s).regs

/-- Strict model with outputs read from registers `o j` (used for MODEL.md §4.3 `model=out`:
  `out j, S` is `mov O_j, S` into a fresh register `O_j` that nothing reads). -/
def StrictCorrectO (n : Nat) (o : Nat → Nat) (p : Program) : Prop :=
  ∀ s : State Int, SortsOK n s.regs (fun j => (run compare p s).regs (o j))

/-- Initial state of the relaxed model: `P i = x i`, every scratch register = `T`, flags = eq. -/
def relaxInit (n : Nat) (x : Nat → Int) (T : Int) : State Int :=
  { regs := fun r => if r < n then x r else T, flag := .eq }

/-- Relaxed model (MODEL.md section 2): correct whenever all inputs are `< T`,
  all scratch registers start as `T`, and the flags start as eq. -/
def RelaxedCorrect (n : Nat) (p : Program) : Prop :=
  ∀ (x : Nat → Int) (T : Int), (∀ i < n, x i < T) →
    SortsOK n x (run compare p (relaxInit n x T)).regs

end SortProof
