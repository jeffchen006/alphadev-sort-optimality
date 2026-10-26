import LeanReflect.NGBasic
/-
  Fast NG checker on bit planes (n ≤ 4 values + T, m ≤ 32 tests), mirroring the list spec (`ngSuccs`, `norm`, `canon`,
  `fastOK`, `hB`). Column: plane v (v < 4) in bits 32v..32v+31 of the 128-bit number hi·2^64 + lo; lane t holds the
  least v whose plane has bit t (T if none). Flags: lt in bits 0..31, gt in bits 32..63.
  The proofs that these functions equal the spec after decoding are in FastPSound.lean.
-/
namespace LeanReflect.FP
open SortProof LeanReflect

structure PCol where
  lo : UInt64
  hi : UInt64
deriving DecidableEq, Hashable, Inhabited, Repr

structure PKey where
  cols : List PCol
  fl : UInt64
  done : List Bool
  gam : Nat
deriving DecidableEq, Hashable, Inhabited, Repr

def M32 : UInt64 := 0xFFFFFFFF

@[inline] def PCol.p0 (c : PCol) : UInt64 := c.lo &&& M32
@[inline] def PCol.p1 (c : PCol) : UInt64 := c.lo >>> 32
@[inline] def PCol.p2 (c : PCol) : UInt64 := c.hi &&& M32
@[inline] def PCol.p3 (c : PCol) : UInt64 := c.hi >>> 32
/-- One-hot plane of value v (lanes whose least set plane is v). -/
@[inline] def PCol.oh (c : PCol) (v : Nat) : UInt64 :=
  match v with
  | 0 => c.p0
  | 1 => c.p1 &&& ~~~c.p0
  | 2 => c.p2 &&& ~~~(c.p0 ||| c.p1)
  | _ => c.p3 &&& ~~~(c.p0 ||| c.p1 ||| c.p2)

/-- 128-bit number of a column (the spec's `colNum` after decoding, for well-formed columns). -/
@[inline] def numP (c : PCol) : Nat := c.hi.toNat * 2 ^ 64 + c.lo.toNat
@[inline] def pLt (a b : PCol) : Bool := a.hi < b.hi || (a.hi == b.hi && a.lo < b.lo)

/-- Fixed data (derived from the list context). -/
structure FC where
  c : Ctx
  mask : UInt64                 -- lanes < m
  tcode : PCol                  -- T
  tc : List PCol                -- targets
  inv : Array Nat               -- inv[t * 8 + v] = idxOf v in test t (v ≤ n)
  ptab : List (Array Nat)       -- per π ∈ group: 4 × 256 bit-permutation table (values < 2^32)
  grp : List (List Nat)         -- the group (position maps)

section
variable (f : FC)

@[inline] def permMask (tab : Array Nat) (x : UInt64) : UInt64 :=
  (tab.getD (x &&& 255).toNat 0 ||| tab.getD (256 + ((x >>> 8) &&& 255).toNat) 0 |||
   tab.getD (512 + ((x >>> 16) &&& 255).toNat) 0 ||| tab.getD (768 + ((x >>> 24) &&& 255).toNat) 0).toUInt64

@[inline] def permCol (tab : Array Nat) (c : PCol) : PCol :=
  { lo := permMask tab c.p0 ||| (permMask tab c.p1 <<< 32)
    hi := permMask tab c.p2 ||| (permMask tab c.p3 <<< 32) }

@[inline] def permFl (tab : Array Nat) (fl : UInt64) : UInt64 :=
  permMask tab (fl &&& M32) ||| (permMask tab (fl >>> 32) <<< 32)

/-- Spec `canonF`: if the first non-eq lane is gt, swap lt and gt. -/
@[inline] def canonF (fl : UInt64) : UInt64 :=
  let lt := fl &&& M32
  let gt := fl >>> 32
  let x := lt ||| gt
  if x == 0 then fl else
    let b := x &&& (0 - x)
    if gt &&& b != 0 then gt ||| (lt <<< 32) else fl

@[inline] def ltMask (a b : PCol) : UInt64 :=
  let a0 := a.oh 0; let a1 := a.oh 1; let a2 := a.oh 2; let a3 := a.oh 3
  let b0 := b.oh 0; let b1 := b.oh 1; let b2 := b.oh 2; let b3 := b.oh 3
  let bge1 := f.mask &&& ~~~b0
  let bge2 := bge1 &&& ~~~b1
  let bge3 := bge2 &&& ~~~b2
  let bT := bge3 &&& ~~~b3
  (a0 &&& bge1) ||| (a1 &&& bge2) ||| (a2 &&& bge3) ||| (a3 &&& bT)

@[inline] def cmpFl (a b : PCol) : UInt64 := ltMask f a b ||| (ltMask f b a <<< 32)

@[inline] def condMask (cd : Cond) (fl : UInt64) : UInt64 :=
  match cd with
  | .l => fl &&& M32
  | .g => fl >>> 32
  | .le => f.mask &&& ~~~(fl >>> 32)
  | .ge => f.mask &&& ~~~(fl &&& M32)

@[inline] def merge (C : UInt64) (d s : PCol) : PCol :=
  let Cf := C ||| (C <<< 32)
  { lo := (s.lo &&& Cf) ||| (d.lo &&& ~~~Cf), hi := (s.hi &&& Cf) ||| (d.hi &&& ~~~Cf) }

def insertP (x : PCol) : List PCol → List PCol
  | [] => [x]
  | y :: ys => if pLt y x then y :: insertP x ys else x :: y :: ys

def sortP : List PCol → List PCol
  | [] => []
  | x :: xs => insertP x (sortP xs)

def normP (k : PKey) : PKey :=
  { k with
    cols := sortP k.cols
    fl := canonF k.fl
    done := (List.range f.c.n).map (fun j => k.done.getD j false || k.cols.contains (f.tc.getD j default)) }

def actP (tab : Array Nat) (k : PKey) : PKey :=
  { k with cols := k.cols.map (permCol tab), fl := permFl tab k.fl }

def lexLtP : List PCol → List PCol → Bool
  | [], [] => false
  | [], _ :: _ => true
  | _ :: _, [] => false
  | a :: as, b :: bs => pLt a b || (a == b && lexLtP as bs)

def keyLtP (x y : PKey) : Bool :=
  decide (x.fl < y.fl) || (x.fl == y.fl &&
    (lexLtP x.cols y.cols || (x.cols == y.cols && lexLt (fun a b => !a && b) x.done y.done)))

def pickMinP (best : PKey) : List PKey → PKey
  | [] => best
  | x :: xs => pickMinP (if keyLtP x best then x else best) xs

def pickMinFP (best : UInt64) : List UInt64 → UInt64
  | [] => best
  | x :: xs => pickMinFP (if x < best then x else best) xs

/-- The relabellings whose flag image is least (depends on the flags only). -/
def candsP (fl : UInt64) : List (Array Nat) :=
  let flm := fun tab => canonF (permFl tab fl)
  let fmin := pickMinFP (canonF fl) (f.ptab.map flm)
  f.ptab.filter fun tab => flm tab == fmin

def canonWith (cands : List (Array Nat)) (k : PKey) : PKey :=
  pickMinP (normP f k) (cands.map fun tab => normP f (actP tab k))

/-- Spec `canon` (flag images first, full images only for the least flag image). -/
def canonP (k : PKey) : PKey :=
  let fl := fun tab => canonF (permFl tab k.fl)
  let fmin := pickMinFP (canonF k.fl) (f.ptab.map fl)
  pickMinP (normP f k) ((f.ptab.filter fun tab => fl tab == fmin).map fun tab => normP f (actP tab k))

def undoneP (k : PKey) : List Nat := (List.range f.c.n).filter fun j => !(k.done.getD j false)

def orPlane (cols : List PCol) (j : Nat) : UInt64 := cols.foldl (fun a c => a ||| c.oh j) 0

def deadP (k : PKey) : Bool := (undoneP f k).any fun j => orPlane k.cols j != f.mask

@[inline] def laneVal (c : PCol) (t : Nat) : Nat :=
  let b : UInt64 := (1 : UInt64) <<< t.toUInt64
  if c.p0 &&& b != 0 then 0 else if f.c.n ≤ 1 then f.c.n else
  if c.p1 &&& b != 0 then 1 else if f.c.n ≤ 2 then f.c.n else
  if c.p2 &&& b != 0 then 2 else if f.c.n ≤ 3 then f.c.n else
  if c.p3 &&& b != 0 then 3 else f.c.n

@[inline] def laneFl (fl : UInt64) (t : Nat) : Nat :=
  if (fl >>> t.toUInt64) &&& 1 != 0 then 0 else if (fl >>> (32 + t).toUInt64) &&& 1 != 0 then 2 else 1

/-- Row codes: flag + per-column input index (base 5 digits); undone-output indices. -/
def sigCode (k : PKey) (t : Nat) : Nat :=
  k.cols.foldl (fun a c => a * 5 + f.inv.getD (t * 8 + laneVal f c t) 0) (laneFl k.fl t)

def usCode (u : List Nat) (t : Nat) : Nat :=
  u.foldl (fun a j => a * 5 + f.inv.getD (t * 8 + j) 0) 0

def hcP (k : PKey) : Nat :=
  let u := undoneP f k
  let rows := (List.range f.c.m).map fun t => (sigCode f k t, usCode f u t)
  clog2 (maxList (rows.map fun r => dc (fun r' => r'.2) (rows.filter fun r' => r'.1 == r.1)))

/-- For each row: no later row equals it (dc counts exactly these, per class). -/
def lastFlags : List (Nat × Nat) → List Bool
  | [] => []
  | r :: L => (!L.any (fun r2 => r2.1 == r.1 && r2.2 == r.2)) :: lastFlags L

def cntClass (RL : List ((Nat × Nat) × Bool)) (p : Nat) : Nat :=
  RL.foldl (fun a e => if e.2 && e.1.1 == p then a + 1 else a) 0

/-- `hcP` computed in O(m²) without closures over lists of lists (`hcP2_eq : hcP2 = hcP`). -/
def hcP2 (k : PKey) : Nat :=
  let u := undoneP f k
  let rows := (List.range f.c.m).map fun t => (sigCode f k t, usCode f u t)
  let RL := rows.zip (lastFlags rows)
  clog2 (rows.foldl (fun a r => max a (cntClass RL r.1)) 0)

/-- Is there an `s`-subset of `ms` whose OR with `acc` is `full`? (= `(combs s ms).any`.) -/
def coverDFS (full : UInt64) : Nat → List UInt64 → UInt64 → Bool
  | 0, _, acc => acc == full
  | _ + 1, [], _ => false
  | s + 1, x :: xs, acc => coverDFS full s xs (acc ||| x) || coverDFS full (s + 1) xs acc

def coverFromP (ms : List UInt64) : Nat → Nat → Nat
  | 0, s => s
  | k + 1, s => if coverDFS f.mask s ms 0 then s else coverFromP ms k (s + 1)

def maxCoverBP (k : PKey) (b : Nat) : Nat :=
  let A := dd k.cols
  maxList ((undoneP f k).map fun j => coverFromP f (A.map (·.oh j)) (min (A.length + 1) b) 0)

def hBP (k : PKey) (b : Nat) : Nat :=
  hcP2 f k + max (undoneP f k).length ((undoneP f k).length + maxCoverBP f k b - 2)

def succOKGP (KB G : Nat) (look : PKey → Option Nat) (k' : PKey) : Bool :=
  (match look k' with
   | some g' => decide (g' ≤ G)
   | none => false) ||
  deadP f k' || decide (KB < G + hBP f k' (KB + 3 - G))

def fastOKP (KB Gc : Nat) (look : PKey → Option Nat) (k0 : PKey) : Bool :=
  decide (KB < Gc + (undoneP f k0).length) || deadP f k0 || succOKGP f KB Gc look (canonP f k0)

/-- Pruning by `hB` computed lazily: H1 + #undone first, then the cover search with the least useful cap. -/
def hPrune (KB G : Nat) (k : PKey) : Bool :=
  let u := (undoneP f k).length
  let hc := hcP2 f k
  decide (KB < G + hc + u) ||
    decide (KB < G + hc + max u (u + maxCoverBP f k (KB + 3 - G - hc - u) - 2))

def fastOKP2 (cands : List (Array Nat)) (KB Gc : Nat) (look : PKey → Option Nat) (k0 : PKey) : Bool :=
  decide (KB < Gc + (undoneP f k0).length) || deadP f k0 ||
    (let kc := canonWith f cands k0
     (match look kc with
      | some g' => decide (g' ≤ Gc)
      | none => false) || hPrune f KB Gc kc)

/-- The spec's successor list, on planes. -/
def ngSuccsP (cs : List Cond) (k : PKey) : List (PKey × Nat) :=
  let A := k.cols
  let srcs := if 1 ≤ k.gam then A ++ [f.tcode] else A
  (srcs.flatMap fun a => srcs.map fun b => (normP f { k with fl := cmpFl f a b }, 1)) ++
  (A.flatMap fun D => srcs.flatMap fun S => cs.flatMap fun cd =>
    let M := merge (condMask f cd k.fl) D S
    if M == D || M == f.tcode || A.contains M then []
    else [(normP f { k with cols := M :: A.erase D }, 1), (normP f { k with cols := M :: A }, 2)]) ++
  (if 1 ≤ k.gam then
    (A.flatMap fun S => cs.flatMap fun cd =>
      let M := merge (condMask f cd k.fl) f.tcode S
      if M == f.tcode || A.contains M then [] else [(normP f { k with cols := M :: A, gam := gDec k.gam }, 1)])
   else []) ++
  (if k.gam < 7 then [(normP f { k with gam := gInc2 k.gam }, 1)] else [])

def stateOKP (cs : List Cond) (KB : Nat) (look : PKey → Option Nat) (k : PKey) (g : Nat) : Bool :=
  !(undoneP f k).isEmpty && (ngSuccsP f cs k).all fun (k', w) => fastOKP f KB (g + w) look k'

/-- `(ngSuccsP f cs k).all P` without building the list (`ngAll_eq`). -/
def ngAll (cs : List Cond) (k : PKey) (P : PKey × Nat → Bool) : Bool :=
  let A := k.cols
  let srcs := if 1 ≤ k.gam then A ++ [f.tcode] else A
  (srcs.all fun a => srcs.all fun b => P (normP f { k with fl := cmpFl f a b }, 1)) &&
  (A.all fun D => srcs.all fun S => cs.all fun cd =>
    let M := merge (condMask f cd k.fl) D S
    M == D || M == f.tcode || A.contains M ||
      (P (normP f { k with cols := M :: A.erase D }, 1) && P (normP f { k with cols := M :: A }, 2))) &&
  (!(1 ≤ k.gam) ||
    (A.all fun S => cs.all fun cd =>
      let M := merge (condMask f cd k.fl) f.tcode S
      M == f.tcode || A.contains M || P (normP f { k with cols := M :: A, gam := gDec k.gam }, 1))) &&
  (!(k.gam < 7) || P (normP f { k with gam := gInc2 k.gam }, 1))

/-- Fused check; the candidates of the parent flags serve every successor with the same flags. -/
def stateOKP2 (cs : List Cond) (KB : Nat) (look : PKey → Option Nat) (k : PKey) (g : Nat) : Bool :=
  let cp := candsP f (canonF k.fl)
  !(undoneP f k).isEmpty && ngAll f cs k fun (k', w) =>
    fastOKP2 f (if k'.fl == canonF k.fl then cp else candsP f k'.fl) KB (g + w) look k'
end

/-! ## construction from the list context -/

def colP (c : Ctx) (col : Col) : PCol := Id.run do
  let mut lo : UInt64 := 0
  let mut hi : UInt64 := 0
  for (v, t) in col.zipIdx do
    if 0 ≤ v ∧ v < c.n then
      let b : UInt64 := (1 : UInt64) <<< ((v.toNat % 2) * 32 + t).toUInt64
      if v < 2 then lo := lo ||| b else hi := hi ||| b
  return ⟨lo, hi⟩

def flP (fl : List Ordering) : UInt64 := Id.run do
  let mut x : UInt64 := 0
  for (o, t) in fl.zipIdx do
    match o with
    | .lt => x := x ||| ((1 : UInt64) <<< t.toUInt64)
    | .gt => x := x ||| ((1 : UInt64) <<< (32 + t).toUInt64)
    | .eq => pure ()
  return x

def keyP (c : Ctx) (k : Key) : PKey := { cols := k.cols.map (colP c), fl := flP k.flag, done := k.done, gam := k.gam }

/-- Bit-permutation table for a position map π (new bit t = old bit π t): entry `byte * 256 + v` is the OR of
  `2^t` over the lanes t whose source bit `π t` lies in that byte and is set in `v`. -/
def tabEntry (π : List Nat) (e : Nat) : Nat :=
  (π.zipIdx.filter fun (ob, _) => ob / 8 == e / 256 && (e % 256).testBit (ob % 8)).foldl
    (fun acc (_, t) => acc ||| 2 ^ t) 0

def mkTab (π : List Nat) : Array Nat := (Array.range 1024).map (tabEntry π)

def mkFC (c : Ctx) : FC :=
  { c := c
    mask := (1 <<< c.m.toUInt64) - 1
    tcode := colP c c.T
    tc := c.tc.map (colP c)
    inv := (Array.range (c.m * 8)).map fun i => (c.ts.getD (i / 8) []).idxOf ((i % 8 : Nat) : Int)
    ptab := (group c).map mkTab
    grp := group c }

end LeanReflect.FP
