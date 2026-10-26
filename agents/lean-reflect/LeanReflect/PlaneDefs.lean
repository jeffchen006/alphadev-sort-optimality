import LeanReflect.FastP
/-
  Meaning of the fast (bit-plane) representation in terms of the list spec, and well-formedness.
  Plane v (v < 4) of a column: bits 32·(v % 2) + t of `lo` (v < 2) or `hi` (v ≥ 2), t < 32.
-/
namespace LeanReflect.FP
open SortProof LeanReflect

def bitU (x : UInt64) (i : Nat) : Bool := x.toNat.testBit i

def planeBit (p : PCol) (v t : Nat) : Bool :=
  if v < 2 then bitU p.lo (32 * v + t) else bitU p.hi (32 * (v - 2) + t)

/-- Value of lane t: the least v < n whose plane has bit t, else n (= T). -/
def laneValS (n : Nat) (p : PCol) (t : Nat) : Nat :=
  if 1 ≤ n ∧ planeBit p 0 t then 0 else
  if 2 ≤ n ∧ planeBit p 1 t then 1 else
  if 3 ≤ n ∧ planeBit p 2 t then 2 else
  if 4 ≤ n ∧ planeBit p 3 t then 3 else n

def decodeCol (c : Ctx) (p : PCol) : Col := (List.range c.m).map fun t => ((laneValS c.n p t : Nat) : Int)

def decodeFl (c : Ctx) (fl : UInt64) : List Ordering :=
  (List.range c.m).map fun t => if bitU fl t then .lt else if bitU fl (32 + t) then .gt else .eq

def decodeK (c : Ctx) (k : PKey) : Key :=
  { cols := k.cols.map (decodeCol c), flag := decodeFl c k.fl, done := k.done, gam := k.gam }

/-- Well-formed column: plane bits only in lanes < m, only planes v < n, at most one plane per lane. -/
def WFcol (c : Ctx) (p : PCol) : Prop :=
  ∀ v < 4, ∀ t < 32, planeBit p v t = true → t < c.m ∧ v < c.n ∧ ∀ v' < v, planeBit p v' t = false

/-- Well-formed flags: lt bits and gt bits only in lanes < m, never both. -/
def WFfl (c : Ctx) (fl : UInt64) : Prop :=
  ∀ t < 32, (bitU fl t = true → t < c.m ∧ bitU fl (32 + t) = false) ∧ (bitU fl (32 + t) = true → t < c.m)

instance (c : Ctx) (p : PCol) : Decidable (WFcol c p) := by unfold WFcol; infer_instance
instance (c : Ctx) (fl : UInt64) : Decidable (WFfl c fl) := by unfold WFfl; infer_instance

def WFkey (c : Ctx) (k : PKey) : Prop := (∀ p ∈ k.cols, WFcol c p) ∧ WFfl c k.fl

/-- Facts about the fast context, checked by `decide`/`rfl` for a fixed `n`. -/
structure FCOK (f : FC) : Prop where
  hm : f.c.m ≤ 32
  hn1 : 1 ≤ f.c.n
  hn4 : f.c.n ≤ 4
  mask : f.mask = (1 <<< f.c.m.toUInt64) - 1
  tcode : f.tcode = ⟨0, 0⟩
  tc : f.tc.map (decodeCol f.c) = f.c.tc
  tcWF : ∀ p ∈ f.tc, WFcol f.c p
  inv : ∀ t < f.c.m, ∀ v ≤ f.c.n, f.inv.getD (t * 8 + v) 0 = (f.c.ts.getD t []).idxOf ((v : Nat) : Int)
  ptab : f.ptab = (group f.c).map mkTab
  grp : f.grp = group f.c

end LeanReflect.FP
