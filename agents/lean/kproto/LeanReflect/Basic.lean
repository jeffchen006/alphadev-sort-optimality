import SortProof.Machine
import Std.Data.HashMap
/-
  lean-reflect: abstract states and the checker (computational part).
  Model: M_out / "RS" (MODEL.md §4.3) in the relaxed semantics (§2), registers unbounded (any `Nat`).
  Test inputs = the n! strict permutations of 0..n-1 (a subset of all inputs: sound for a lower bound).
  A column = the values of one register on all tests (a `List Int`, one entry per test).
  A key = (multiset of non-T columns of ALL registers, flag vector (polarity-canonical), outputs taken).
-/
namespace LeanReflect
open SortProof

instance : Hashable Ordering := ⟨fun o => hash o.ctorIdx⟩

abbrev Col := List Int

/-! ## Test inputs -/

def insertAll (a : Nat) : List Nat → List (List Nat)
  | [] => [[a]]
  | b :: l => (a :: b :: l) :: (insertAll a l).map (b :: ·)

def perms : List Nat → List (List Nat)
  | [] => [[]]
  | a :: l => (perms l).flatMap (insertAll a)

/-- The test inputs: all permutations of `0..n-1`. -/
def tests (n : Nat) : List (List Int) := (perms (List.range n)).map (·.map Int.ofNat)

/-- Input vector of a test. -/
def xOf (w : List Int) : Nat → Int := fun i => w.getD i 0

/-- Relaxed initial state of a test: `T = n`. -/
def initOf (n : Nat) (w : List Int) : State Int := relaxInit n (xOf w) n

/-! ## Context: data fixed by `n` (precomputed once) -/

structure Ctx where
  n : Nat
  ts : List (List Int)
  m : Nat
  T : Col
  tc : List Col

def mkCtx (n : Nat) : Ctx :=
  let ts := tests n
  { n := n, ts := ts, m := ts.length, T := List.replicate ts.length (n : Int)
    tc := (List.range n).map fun (j : Nat) => List.replicate ts.length (Int.ofNat j) }

/-! ## Columns -/

def colLe : Col → Col → Bool
  | [], _ => true
  | _ :: _, [] => false
  | a :: as, b :: bs => a < b || (a == b && colLe as bs)

def cmpCol : Col → Col → List Ordering
  | a :: as, b :: bs => compare a b :: cmpCol as bs
  | _, _ => []

/-- Result column of `cmov c D, S`: per test, `S` if the condition holds, else `D`. -/
def merge (c : Cond) : List Ordering → Col → Col → Col
  | o :: os, a :: as, b :: bs => (if c.eval o then b else a) :: merge c os as bs
  | _, _, _ => []

/-- Polarity canonical form: the first non-eq entry is `lt`. -/
def canonF (f : List Ordering) : List Ordering :=
  match f.find? (· != .eq) with
  | some .gt => f.map Ordering.swap
  | _ => f

/-- Array access with default 0 (O(1)); `cget l.toArray i = l.getD i 0` (`cget_toArray`). -/
def cget (a : Array Int) (i : Nat) : Int := a.getD i 0

structure Key where
  cols : List Col
  flag : List Ordering
  done : List Bool
deriving DecidableEq, Hashable, Repr

section
variable (c : Ctx)

def norm (k : Key) : Key :=
  { cols := k.cols.mergeSort colLe
    flag := canonF k.flag
    done := (List.range c.n).map (fun j => k.done.getD j false || k.cols.contains (c.tc.getD j [])) }

/-- Write column `v` into a register that holds column `d = some col` or `T` (`d = none`). -/
def writeCol (cols : List Col) (d : Option Col) (v : Col) : List Col :=
  let base := match d with
    | some col => cols.erase col
    | none => cols
  if v == c.T then base else v :: base

inductive AI where
  | cmp (a b : Col)
  | mov (d : Option Col) (s : Col)
  | cmov (cd : Cond) (d : Option Col) (s : Col)

def AI.apply (k : Key) : AI → Key
  | .cmp a b => { k with flag := cmpCol a b }
  | .mov d s => { k with cols := writeCol c k.cols d s }
  | .cmov cd d s => { k with cols := writeCol c k.cols d (merge cd k.flag (d.getD c.T) s) }

/-- All abstract instructions from key `k`; `cs` = the cmov conditions of the instruction set. -/
def ais (cs : List Cond) (k : Key) : List AI :=
  let srcs := k.cols.eraseDups ++ [c.T]
  let dsts := k.cols.eraseDups.map some ++ [none]
  (srcs.flatMap fun a => srcs.map fun b => AI.cmp a b) ++
  (dsts.flatMap fun d => srcs.flatMap fun s => AI.mov d s :: cs.map fun cd => AI.cmov cd d s)

def succs (cs : List Cond) (k : Key) : List Key := (ais c cs k).map fun a => norm c (a.apply c k)

def root : Key :=
  norm c { cols := (List.range c.n).map (fun i => c.ts.map (fun w => w.getD i 0))
           flag := List.replicate c.m .eq
           done := List.replicate c.n false }

/-! ## Pruning -/

def undone (k : Key) : List Nat := (List.range c.n).filter fun j => !(k.done.getD j false)

def isGoal (k : Key) : Bool := (undone c k).isEmpty

/-- Rule D: some test lacks a value that an undone output still needs. -/
def dead (k : Key) : Bool :=
  let arrs := k.cols.map List.toArray
  (undone c k).any fun j => (List.range c.m).any fun i => !(arrs.any fun a => cget a i == (j : Int))

/-- `stateSig` with the columns given as arrays (O(1) access); equal to `stateSig` (`stateSigA_eq`). -/
def stateSigA (k : Key) (arrs : List (Array Int)) (i : Nat) : Ordering × List Nat :=
  let w := c.ts.getD i []
  (k.flag.getD i .eq, arrs.map fun a => w.idxOf (cget a i))

/-- Index content of test `i`: flag and, per column, the input index of the value (T -> n). -/
def stateSig (k : Key) (i : Nat) : Ordering × List Nat :=
  let w := c.ts.getD i []
  (k.flag.getD i .eq, k.cols.map fun col => w.idxOf (col.getD i 0))

/-- Input index of every undone output in test `i`. -/
def usig (k : Key) (i : Nat) : List Nat :=
  let w := c.ts.getD i []
  (undone c k).map fun (j : Nat) => w.idxOf ((j : Nat) : Int)
end

/-- Number of distinct values of `f` on `l`. -/
def dc {α β : Type} [BEq β] (f : α → β) : List α → Nat
  | [] => 0
  | a :: l => if l.any (fun b => f b == f a) then dc f l else dc f l + 1

/-- Least `e` with `x ≤ 2^e`. -/
def clog2 (x : Nat) : Nat := if x ≤ 1 then 0 else clog2 ((x + 1) / 2) + 1

def maxList : List Nat → Nat
  | [] => 0
  | a :: l => max a (maxList l)

section
variable (c : Ctx)

/-- Rule H1: lower bound on the number of cmp still needed. -/
def hc (k : Key) : Nat :=
  let arrs := k.cols.map List.toArray
  let rows := (List.range c.m).map fun i => (stateSigA c k arrs i, usig c k i)
  clog2 (maxList (rows.map fun r => dc (fun r' => r'.2) (rows.filter fun r' => r'.1 == r.1)))

/-! ### Rule H3' (enum PRUNING.md): cover numbers -/

/-- Duplicate-free copy (keeps the last occurrence). -/
def dd {α : Type} [DecidableEq α] : List α → List α
  | [] => []
  | a :: l => if a ∈ l then dd l else a :: dd l

/-- All sublists of length `s`. -/
def combs {α : Type} : Nat → List α → List (List α)
  | 0, _ => [[]]
  | _ + 1, [] => []
  | s + 1, a :: l => (combs s l).map (a :: ·) ++ combs (s + 1) l

/-- `cols` covers value `j`: on every test some column holds `j`. -/
def covers (cols : List Col) (j : Nat) : Bool :=
  (List.range c.m).all fun i => cols.any fun col => col.getD i 0 == ((j : Nat) : Int)

/-- `covers` on array columns. -/
def coversA (cols : List (Array Int)) (j : Nat) : Bool :=
  (List.range c.m).all fun i => cols.any fun a => cget a i == ((j : Nat) : Int)

/-- Least `s ≤ |A|` such that some `s` distinct columns of `A` cover `j` (search with fuel; `|A| + 1` if none). -/
def coverFrom (A : List (Array Int)) (j : Nat) : Nat → Nat → Nat
  | 0, s => s
  | f + 1, s => if (combs s A).any (fun F => coversA c F j) then s else coverFrom A j f (s + 1)

def coverLB (k : Key) (j : Nat) : Nat :=
  let A := dd k.cols
  coverFrom c (A.map List.toArray) j (A.length + 1) 0

def maxCover (k : Key) : Nat := maxList ((undone c k).map (coverLB c k))

/-- Admissible lower bound on the remaining length:
  cmps (H1) + cmovs, where #cmov ≥ #undone and (H3') #cmov ≥ #undone + max_j cover_j − 2. -/
def h (k : Key) : Nat := hc c k + max (undone c k).length ((undone c k).length + maxCover c k - 2)

/-! ## The checker -/

def succOK (KB g : Nat) (look : Key → Option Nat) (k' : Key) : Bool :=
  (match look k' with
   | some g' => decide (g' ≤ g + 1)
   | none => false) ||
  dead c k' || decide (KB < g + 1 + h c k')

def check (cs : List Cond) (KB : Nat) (S : List (Key × Nat)) (look : Key → Option Nat) : Bool :=
  look (root c) == some 0 &&
  S.all fun (k, g) => !isGoal c k && (succs c cs k).all (succOK c KB g look)

/-! ## The (untrusted) search: layered BFS with dedup and f-bound pruning -/

def expandLayer (cs : List Cond) (KB d : Nat) (front : Array Key) (vis : Std.HashMap Key Nat) :
    Array Key × Std.HashMap Key Nat := Id.run do
  let mut next : Array Key := #[]
  let mut vis := vis
  for k in front do
    for k' in succs c cs k do
      if !vis.contains k' && !dead c k' && d + 1 + h c k' ≤ KB then
        vis := vis.insert k' (d + 1)
        next := next.push k'
  return (next, vis)

def search (cs : List Cond) (KB : Nat) : Std.HashMap Key Nat := Id.run do
  let r := root c
  let mut vis : Std.HashMap Key Nat := (∅ : Std.HashMap Key Nat).insert r 0
  let mut front : Array Key := #[r]
  for d in List.range KB do
    let (nx, v) := expandLayer c cs KB d front vis
    front := nx
    vis := v
  return vis

/-! ## Parallel versions (same logic; `Task.spawn f |>.get = f ()` by definition) -/

def shareOf (T : Nat) (k : Key) : Nat := (hash k).toNat % T

def checkPar (cs : List Cond) (KB T : Nat) (S : List (Key × Nat)) (look : Key → Option Nat) : Bool :=
  look (root c) == some 0 &&
  ((List.range T).map fun r => Task.spawn fun _ =>
      (S.filter fun e => shareOf T e.1 == r).all fun (k, g) =>
        !isGoal c k && (succs c cs k).all (succOK c KB g look)).all (·.get)

/-- One BFS layer, candidates computed in `T` parallel chunks (untrusted). -/
def expandLayerPar (cs : List Cond) (KB d T : Nat) (front : Array Key) (vis : Std.HashMap Key Nat) :
    Array Key × Std.HashMap Key Nat := Id.run do
  let sz := (front.size + T - 1) / T + 1
  let tasks := (List.range T).map fun r => Task.spawn fun _ => Id.run do
    let mut out : Array Key := #[]
    for k in front.extract (r * sz) ((r + 1) * sz) do
      for k' in succs c cs k do
        if !vis.contains k' && !dead c k' && d + 1 + h c k' ≤ KB then
          out := out.push k'
    return out
  let mut next : Array Key := #[]
  let mut vis := vis
  for t in tasks do
    for k' in t.get do
      if !vis.contains k' then
        vis := vis.insert k' (d + 1)
        next := next.push k'
  return (next, vis)

def searchPar (cs : List Cond) (KB T : Nat) : Std.HashMap Key Nat := Id.run do
  let r := root c
  let mut vis : Std.HashMap Key Nat := (∅ : Std.HashMap Key Nat).insert r 0
  let mut front : Array Key := #[r]
  for d in List.range KB do
    let (nx, v) := expandLayerPar c cs KB d T front vis
    front := nx
    vis := v
  return vis
end

def certOKPar (n : Nat) (cs : List Cond) (KB T : Nat) : Bool :=
  let c := mkCtx n
  let S := searchPar c cs KB T
  checkPar c cs KB T S.toList (fun k => S[k]?)

def certOK (n : Nat) (cs : List Cond) (KB : Nat) : Bool :=
  let c := mkCtx n
  let S := search c cs KB
  check c cs KB S.toList (fun k => S[k]?)

def I0 : List Cond := [.l, .g]
def I1 : List Cond := [.l, .g, .le, .ge]

end LeanReflect
