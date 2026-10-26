import LeanReflect.Basic
namespace KProto
open LeanReflect SortProof

def insertCol (x : Col) : List Col → List Col
  | [] => [x]
  | y :: ys => if colLe x y then x :: y :: ys else y :: insertCol x ys
def isortCol : List Col → List Col
  | [] => []
  | x :: xs => insertCol x (isortCol xs)

def normK (c : Ctx) (k : Key) : Key :=
  { cols := isortCol k.cols
    flag := canonF k.flag
    done := (List.range c.n).map (fun j => k.done.getD j false || k.cols.contains (c.tc.getD j [])) }
def succsK (c : Ctx) (cs : List Cond) (k : Key) : List Key := (ais c cs k).map fun a => normK c (a.apply c k)

def clog2F : Nat → Nat → Nat
  | 0, _ => 0
  | f+1, x => if x ≤ 1 then 0 else clog2F f ((x + 1) / 2) + 1
def clog2K (x : Nat) : Nat := clog2F x x

def hcK (c : Ctx) (k : Key) : Nat :=
  let arrs := k.cols.map List.toArray
  let rows := (List.range c.m).map fun i => (stateSigA c k arrs i, usig c k i)
  clog2K (maxList (rows.map fun r => dc (fun r' => r'.2) (rows.filter fun r' => r'.1 == r.1)))
def hK (c : Ctx) (k : Key) : Nat := hcK c k + max (undone c k).length ((undone c k).length + maxCover c k - 2)

def rootK (c : Ctx) : Key :=
  normK c { cols := (List.range c.n).map (fun i => c.ts.map (fun w => w.getD i 0))
            flag := List.replicate c.m .eq
            done := List.replicate c.n false }

def c3 : Ctx := mkCtx 3
/-- a deeper state: follow the first non-dead successors -/
def deep : Nat → Key → Key
  | 0, k => k
  | d+1, k => match (succsK c3 I1 k).filter (fun k' => !dead c3 k' && k'.cols.length ≥ k.cols.length) |>.reverse with
    | k' :: _ => deep d k'
    | [] => k
def grow : Nat → Key → Key
  | 0, k => k
  | d+1, k => match (succsK c3 I1 k).filter (fun k' => !dead c3 k' && k'.cols.length > k.cols.length) |>.reverse with
    | k' :: _ => grow d k'
    | [] => k
def k4 : Key := grow 3 (rootK c3)
#eval k4
#eval (succsK c3 I1 k4).length
#eval (succsK c3 I1 (rootK c3)).length
