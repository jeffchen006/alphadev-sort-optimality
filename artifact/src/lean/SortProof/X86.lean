import SortProof.Machine
/-
  x86-64 layer: 32-bit general registers and the status flags CF ZF SF OF,
  with the Intel SDM definitions of CMP, MOV, CMOVcc (see SEMANTICS.md).
  Main result: `xrun_abs`, the x86 machine is simulated exactly by the abstract
  machine over `Int` with `compare` (signed order).
-/
namespace SortProof

structure XState where
  regs : Nat → BitVec 32
  cf : Bool
  zf : Bool
  sf : Bool
  of : Bool

/-- CMP a, b: compute a - b, set CF ZF SF OF, discard the result (SDM Vol. 2A "CMP", "SUB"). -/
def xcmp (s : XState) (a b : BitVec 32) : XState :=
  let t := a - b
  { s with
    cf := decide (a.toNat < b.toNat)           -- borrow out of the unsigned subtraction
    zf := t == 0#32
    sf := t.msb
    of := (a.msb != b.msb) && (t.msb != a.msb) }  -- signed overflow of a - b

/-- CMOVcc condition (SDM Vol. 2A "CMOVcc", Table B-1 condition codes). -/
def Cond.xeval (s : XState) : Cond → Bool
  | .l => s.sf != s.of                       -- CMOVL / CMOVNGE : SF ≠ OF
  | .g => !s.zf && (s.sf == s.of)            -- CMOVG / CMOVNLE : ZF = 0 and SF = OF
  | .le => s.zf || (s.sf != s.of)            -- CMOVLE / CMOVNG : ZF = 1 or SF ≠ OF
  | .ge => s.sf == s.of                      -- CMOVGE / CMOVNL : SF = OF

def xstep (s : XState) : Instr → XState
  | .mov d src => { s with regs := upd s.regs d (s.regs src) }
  | .cmp a b => xcmp s (s.regs a) (s.regs b)
  | .cmov c d src => if c.xeval s then { s with regs := upd s.regs d (s.regs src) } else s

def xrun (p : Program) (s : XState) : XState := p.foldl xstep s

/-- Abstraction: values = signed value `toInt`; flag state = the order that the conditions see. -/
def XState.flagOrd (s : XState) : Ordering :=
  if s.sf != s.of then .lt else if s.zf then .eq else .gt

def XState.abs (s : XState) : State Int :=
  { regs := fun r => (s.regs r).toInt, flag := s.flagOrd }

/-- Every x86 flag combination maps to one `Ordering`, and all four conditions are functions
  of it. (This fails for cmove/cmovne; those are outside I1.) -/
theorem xeval_eq (s : XState) (c : Cond) : c.xeval s = c.eval s.flagOrd := by
  cases c <;> cases hs : s.sf <;> cases ho : s.of <;> cases hz : s.zf <;>
    simp [Cond.xeval, Cond.eval, XState.flagOrd, hs, ho, hz]

/-- After `cmp a, b`: SF ≠ OF ⇔ a < b (signed). Kernel proof via `toInt` arithmetic
  (an earlier `bv_decide` proof added a native-code axiom). -/
theorem cmp_sf_of (a b : BitVec 32) :
    ((a - b).msb != ((a.msb != b.msb) && ((a - b).msb != a.msb))) = a.slt b := by
  have ha1 := BitVec.le_toInt a
  have ha2 := BitVec.toInt_lt (x := a)
  have hb1 := BitVec.le_toInt b
  have hb2 := BitVec.toInt_lt (x := b)
  simp only [BitVec.msb_eq_toInt, BitVec.toInt_sub, BitVec.slt, Int.bmod] at *
  have e : ((2 ^ 32 : Nat) : Int) = 4294967296 := by decide
  rw [e]
  generalize a.toInt = A at *
  generalize b.toInt = B at *
  simp only [Nat.add_one_sub_one] at *
  have e2 : (2 : Int) ^ 31 = 2147483648 := by decide
  rw [e2] at *
  split <;> by_cases h1 : A < B <;> by_cases h2 : A < 0 <;> by_cases h3 : B < 0 <;>
    simp only [h1, h2, h3, decide_true, decide_false] <;> (try simp) <;> omega

/-- After `cmp a, b`: ZF ⇔ a = b. -/
theorem cmp_zf (a b : BitVec 32) : ((a - b) == 0#32) = (a == b) := by
  by_cases h : a = b
  · subst h; simp
  · have : a - b ≠ 0#32 := by bv_omega
    rw [beq_eq_false_iff_ne.mpr this, beq_eq_false_iff_ne.mpr h]
theorem xcmp_flagOrd (s : XState) (a b : BitVec 32) :
    (xcmp s a b).flagOrd = compare a.toInt b.toInt := by
  have e1 := cmp_sf_of a b
  have e2 := cmp_zf a b
  have hf : (xcmp s a b).flagOrd =
      if a.slt b then .lt else if (a == b) then .eq else .gt := by
    show (if ((a - b).msb != ((a.msb != b.msb) && ((a - b).msb != a.msb))) = true then Ordering.lt
      else if ((a - b) == 0#32) = true then .eq else .gt) = _
    rw [e1, e2]
  rw [hf]
  by_cases h1 : a.slt b
  · have : a.toInt < b.toInt := BitVec.slt_iff_toInt_lt.mp h1
    rw [if_pos h1, Int.compare_eq_lt.mpr this]
  · have h2 : ¬ a.toInt < b.toInt := fun h => h1 (BitVec.slt_iff_toInt_lt.mpr h)
    rw [if_neg h1]
    by_cases h3 : a = b
    · subst h3; simp
    · have h4 : a.toInt ≠ b.toInt := fun h => h3 (BitVec.toInt_inj.mp h)
      have h5 : b.toInt < a.toInt := by omega
      have h6 : (a == b) = false := by simpa using h3
      rw [h6, Int.compare_eq_gt.mpr h5]; rfl

theorem xstep_abs (s : XState) (i : Instr) : (xstep s i).abs = step compare s.abs i := by
  cases i with
  | mov d src =>
    simp only [xstep, step, XState.abs, XState.flagOrd]
    congr 1; funext r; simp only [upd]; split <;> rfl
  | cmp a b =>
    simp only [xstep, step]
    have := xcmp_flagOrd s (s.regs a) (s.regs b)
    simp only [XState.abs] at *
    rw [this]; rfl
  | cmov c d src =>
    have hf : s.abs.flag = s.flagOrd := rfl
    simp only [xstep, step, xeval_eq, hf]
    by_cases hc : c.eval s.flagOrd = true
    · simp only [hc, if_true]
      simp only [XState.abs, XState.flagOrd]
      congr 1; funext r; simp only [upd]; split <;> rfl
    · simp only [hc]; rfl

/-- Simulation: running on x86 then abstracting = abstracting then running abstractly. -/
theorem xrun_abs (p : Program) (s : XState) : (xrun p s).abs = run compare p s.abs := by
  induction p generalizing s with
  | nil => rfl
  | cons i p ih =>
    show (xrun p (xstep s i)).abs = run compare p (step compare s.abs i)
    rw [ih, xstep_abs]

/-- x86 correctness: for every 32-bit register file and every flag state, the outputs
  `P0..P{n-1}` hold the inputs sorted ascending as signed 32-bit numbers. -/
def XCorrect (n : Nat) (p : Program) : Prop :=
  ∀ s : XState, SortsOK n (fun r => (s.regs r).toInt) (fun r => ((xrun p s).regs r).toInt)

theorem strict_to_x86 {n : Nat} {p : Program} (h : StrictCorrect n p) : XCorrect n p := by
  intro s
  have := h s.abs
  rw [← xrun_abs] at this
  exact this

def XCorrectO (n : Nat) (o : Nat → Nat) (p : Program) : Prop :=
  ∀ s : XState, SortsOK n (fun r => (s.regs r).toInt) (fun j => ((xrun p s).regs (o j)).toInt)

theorem strictO_to_x86 {n : Nat} {o : Nat → Nat} {p : Program} (h : StrictCorrectO n o p) :
    XCorrectO n o p := by
  intro s
  have := h s.abs
  rw [← xrun_abs] at this
  exact this

end SortProof
