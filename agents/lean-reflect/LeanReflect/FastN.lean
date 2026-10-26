import LeanReflect.NGBasic
/-
  Fast NG checker on numeric codes, mirroring the list spec (`ngSuccs`, `norm`, `canon`, `fastOK`, `h`) function by
  function. A column (m test values, lane 0 first) is the base-5 number with lane 0 as the most significant digit; a
  flag vector is the base-3 number with digit 0 = lt, 1 = eq, 2 = gt. Numeric order = the spec's lexicographic order.
-/
namespace LeanReflect.FN
open SortProof LeanReflect

structure KeyN where
  cols : List Nat
  fl : Nat
  done : List Bool
  gam : Nat
deriving DecidableEq, Hashable, Repr, Inhabited

/-- Fixed data of the fast checker (derived from the list context). -/
structure FC where
  c : Ctx
  p5 : Array Nat          -- 5^k, k ≤ m
  p3 : Array Nat          -- 3^k, k ≤ m
  tcode : Nat             -- code of T
  tc : List Nat           -- codes of the targets
  eqF : Nat               -- code of the all-eq flag vector
  topF : Nat              -- 3^m - 1
  tsA : Array (List Int)  -- tests

def ordOf (d : Nat) : Ordering := if d = 0 then .lt else if d = 1 then .eq else .gt

section
variable (f : FC)

@[inline] def digit (code i : Nat) : Nat := code / f.p5.getD (f.c.m - 1 - i) 1 % 5
@[inline] def fdigit (fl i : Nat) : Nat := fl / f.p3.getD (f.c.m - 1 - i) 1 % 3

/-- Digit-wise select (LSB first recursion over k digits). -/
def mergeR (cd : Cond) : Nat → Nat → Nat → Nat → Nat
  | 0, _, _, _ => 0
  | k + 1, fl, d, s =>
    mergeR cd k (fl / 3) (d / 5) (s / 5) * 5 + (if cd.eval (ordOf (fl % 3)) then s % 5 else d % 5)

def cmpR : Nat → Nat → Nat → Nat
  | 0, _, _ => 0
  | k + 1, a, b => cmpR k (a / 5) (b / 5) * 3 + (if a % 5 < b % 5 then 0 else if a % 5 = b % 5 then 1 else 2)

def mergeN (cd : Cond) (fl d s : Nat) : Nat := mergeR cd f.c.m fl d s
def cmpN (a b : Nat) : Nat := cmpR f.c.m a b
def canonFN (fl : Nat) : Nat := if f.eqF < fl then f.topF - fl else fl

/-- Lane permutation: new lane t = old lane π t. -/
def permN (π : List Nat) (code : Nat) : Nat := π.foldl (fun acc t => acc * 5 + digit f code t) 0
def permFN (π : List Nat) (fl : Nat) : Nat := π.foldl (fun acc t => acc * 3 + fdigit f fl t) 0

def normN (k : KeyN) : KeyN :=
  { k with
    cols := k.cols.mergeSort (fun a b => decide (a ≤ b))
    fl := canonFN f k.fl
    done := (List.range f.c.n).map (fun j => k.done.getD j false || k.cols.contains (f.tc.getD j 0)) }

def actN (π : List Nat) (k : KeyN) : KeyN := { k with cols := k.cols.map (permN f π), fl := permFN f π k.fl }

def keyLtN (x y : KeyN) : Bool :=
  decide (x.fl < y.fl) || (x.fl == y.fl &&
    (lexLt (fun a b => decide (a < b)) x.cols y.cols || (x.cols == y.cols && lexLt (fun a b => !a && b) x.done y.done)))

def pickMinN (best : KeyN) : List KeyN → KeyN
  | [] => best
  | x :: xs => pickMinN (if keyLtN x best then x else best) xs

def pickMinFN (best : Nat) : List Nat → Nat
  | [] => best
  | x :: xs => pickMinFN (if x < best then x else best) xs

def canonN (G : List (List Nat)) (k : KeyN) : KeyN :=
  let fl := fun π => canonFN f (permFN f π k.fl)
  let fmin := pickMinFN (canonFN f k.fl) (G.map fl)
  pickMinN (normN f k) ((G.filter fun π => fl π == fmin).map fun π => normN f (actN f π k))

def undoneN (k : KeyN) : List Nat := (List.range f.c.n).filter fun j => !(k.done.getD j false)

def deadN (k : KeyN) : Bool :=
  (undoneN f k).any fun j => (List.range f.c.m).any fun i => !(k.cols.any fun col => digit f col i == j)

def stateSigN (k : KeyN) (i : Nat) : Ordering × List Nat :=
  let w := f.tsA.getD i []
  (ordOf (fdigit f k.fl i), k.cols.map fun col => w.idxOf (digit f col i : Int))

def usigN (k : KeyN) (i : Nat) : List Nat :=
  let w := f.tsA.getD i []
  (undoneN f k).map fun (j : Nat) => w.idxOf ((j : Nat) : Int)

def hcN (k : KeyN) : Nat :=
  let rows := (List.range f.c.m).map fun i => (stateSigN f k i, usigN f k i)
  clog2 (maxList (rows.map fun r => dc (fun r' => r'.2) (rows.filter fun r' => r'.1 == r.1)))

def coversN (cols : List Nat) (j : Nat) : Bool :=
  (List.range f.c.m).all fun i => cols.any fun col => digit f col i == j

def coverFromN (A : List Nat) (j : Nat) : Nat → Nat → Nat
  | 0, s => s
  | k + 1, s => if (combs s A).any (fun F => coversN f F j) then s else coverFromN A j k (s + 1)

def coverLBN (k : KeyN) (j : Nat) : Nat :=
  let A := dd k.cols
  coverFromN f A j (A.length + 1) 0

def maxCoverN (k : KeyN) : Nat := maxList ((undoneN f k).map (coverLBN f k))

def hN (k : KeyN) : Nat := hcN f k + max (undoneN f k).length ((undoneN f k).length + maxCoverN f k - 2)

def succOKGN (KB G : Nat) (look : KeyN → Option Nat) (k' : KeyN) : Bool :=
  (match look k' with
   | some g' => decide (g' ≤ G)
   | none => false) ||
  deadN f k' || decide (KB < G + hN f k')

def fastOKN (G : List (List Nat)) (KB Gc : Nat) (look : KeyN → Option Nat) (k0 : KeyN) : Bool :=
  decide (KB < Gc + (undoneN f k0).length) || deadN f k0 || succOKGN f KB Gc look (canonN f G k0)

def ngSuccsN (cs : List Cond) (k : KeyN) : List (KeyN × Nat) :=
  let A := k.cols
  let srcs := if 1 ≤ k.gam then A ++ [f.tcode] else A
  (srcs.flatMap fun a => srcs.map fun b => (normN f { k with fl := cmpN f a b }, 1)) ++
  (A.flatMap fun D => srcs.flatMap fun S => cs.flatMap fun cd =>
    let M := mergeN f cd k.fl D S
    if M == D || M == f.tcode || A.contains M then []
    else [(normN f { k with cols := M :: A.erase D }, 1), (normN f { k with cols := M :: A }, 2)]) ++
  (if 1 ≤ k.gam then
    (A.flatMap fun S => cs.flatMap fun cd =>
      let M := mergeN f cd k.fl f.tcode S
      if M == f.tcode || A.contains M then [] else [(normN f { k with cols := M :: A, gam := gDec k.gam }, 1)])
   else []) ++
  (if k.gam < 7 then [(normN f { k with gam := gInc2 k.gam }, 1)] else [])

def stateOKN (G : List (List Nat)) (cs : List Cond) (KB : Nat) (look : KeyN → Option Nat) (k : KeyN) (g : Nat) : Bool :=
  !(undoneN f k).isEmpty && (ngSuccsN f cs k).all fun (k', w) => fastOKN f G KB (g + w) look k'
end

def ofDigits (b : Nat) (ds : List Nat) : Nat := ds.foldl (fun a d => a * b + d) 0

def mkFC (c : Ctx) : FC :=
  { c := c
    p5 := (Array.range (c.m + 1)).map (5 ^ ·)
    p3 := (Array.range (c.m + 1)).map (3 ^ ·)
    tcode := ofDigits 5 (List.replicate c.m c.n)
    tc := (List.range c.n).map fun j => ofDigits 5 (List.replicate c.m j)
    eqF := ofDigits 3 (List.replicate c.m 1)
    topF := 3 ^ c.m - 1
    tsA := c.ts.toArray }

/-- Encode a list key (for loading certificates). -/
def encCol (col : Col) : Nat := ofDigits 5 (col.map Int.toNat)
def encFl (fl : List Ordering) : Nat :=
  ofDigits 3 (fl.map fun o => match o with | .lt => 0 | .eq => 1 | .gt => 2)
def encKey (k : Key) : KeyN := { cols := k.cols.map encCol, fl := encFl k.flag, done := k.done, gam := k.gam }

end LeanReflect.FN
