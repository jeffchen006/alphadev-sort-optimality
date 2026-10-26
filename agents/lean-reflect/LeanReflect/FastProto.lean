import Std.Data.HashMap
import LeanReflect.Basic
/-
  PROTOTYPE (speed test, not verified yet): packed NG checker for n ≤ 4, m ≤ 32 tests.
  Column = bit planes: plane v (v < 4) = lanes holding value v; T = no plane. lo = plane0 | plane1 << 32,
  hi = plane2 | plane3 << 32. Flags: lt | gt << 32.
-/
namespace LeanReflect.Fast

structure PCol where
  lo : UInt64
  hi : UInt64
deriving DecidableEq, Hashable, Inhabited, Repr

def M32 : UInt64 := 0xFFFFFFFF

@[inline] def PCol.plane (c : PCol) (v : Nat) : UInt64 :=
  match v with
  | 0 => c.lo &&& M32
  | 1 => c.lo >>> 32
  | 2 => c.hi &&& M32
  | _ => c.hi >>> 32

@[inline] def pcLt (a b : PCol) : Bool := a.hi < b.hi || (a.hi == b.hi && a.lo < b.lo)

structure PKey where
  cols : Array PCol
  fl : UInt64
  done : Nat
  gam : Nat
deriving DecidableEq, Hashable, Inhabited

structure FCtx where
  n : Nat
  m : Nat
  mask : UInt64
  tc : Array PCol           -- target column j: plane j = mask
  inv : Array (Array Nat)   -- inv[t][v] = input index of value v in test t (v = n -> n)
  ptab : Array (Array UInt64) -- per relabelling: 4 x 256 table entries (bit permutation of a 32-bit mask)

@[inline] def permMask (tab : Array UInt64) (x : UInt64) : UInt64 :=
  tab[(x &&& 255).toNat]! ||| tab[256 + ((x >>> 8) &&& 255).toNat]! |||
  tab[512 + ((x >>> 16) &&& 255).toNat]! ||| tab[768 + ((x >>> 24) &&& 255).toNat]!

@[inline] def permCol (tab : Array UInt64) (c : PCol) : PCol :=
  { lo := permMask tab (c.lo &&& M32) ||| (permMask tab (c.lo >>> 32) <<< 32)
    hi := permMask tab (c.hi &&& M32) ||| (permMask tab (c.hi >>> 32) <<< 32) }

@[inline] def permFl (tab : Array UInt64) (f : UInt64) : UInt64 :=
  permMask tab (f &&& M32) ||| (permMask tab (f >>> 32) <<< 32)

@[inline] def canonF (f : UInt64) : UInt64 :=
  let lt := f &&& M32
  let gt := f >>> 32
  let x := lt ||| gt
  if x == 0 then f else
    let b := x &&& (0 - x)
    if gt &&& b != 0 then gt ||| (lt <<< 32) else f

/-- lt mask of a < b (one-hot planes, T above everything). -/
@[inline] def ltMask (fc : FCtx) (a b : PCol) : UInt64 :=
  let a0 := a.plane 0; let a1 := a.plane 1; let a2 := a.plane 2; let a3 := a.plane 3
  let b0 := b.plane 0; let b1 := b.plane 1; let b2 := b.plane 2; let b3 := b.plane 3
  let bT := fc.mask &&& ~~~(b0 ||| b1 ||| b2 ||| b3)
  (a0 &&& (b1 ||| b2 ||| b3 ||| bT)) ||| (a1 &&& (b2 ||| b3 ||| bT)) ||| (a2 &&& (b3 ||| bT)) ||| (a3 &&& bT)

@[inline] def cmpFl (fc : FCtx) (a b : PCol) : UInt64 := ltMask fc a b ||| (ltMask fc b a <<< 32)

/-- Condition mask: 0 l, 1 g, 2 le, 3 ge. -/
@[inline] def condMask (fc : FCtx) (cd : Nat) (f : UInt64) : UInt64 :=
  match cd with
  | 0 => f &&& M32
  | 1 => f >>> 32
  | 2 => fc.mask &&& ~~~(f >>> 32)
  | _ => fc.mask &&& ~~~(f &&& M32)

@[inline] def merge (C : UInt64) (d s : PCol) : PCol :=
  let Cf := C ||| (C <<< 32)
  { lo := (s.lo &&& Cf) ||| (d.lo &&& ~~~Cf), hi := (s.hi &&& Cf) ||| (d.hi &&& ~~~Cf) }

def Tc : PCol := ⟨0, 0⟩

def sortCols (a : Array PCol) : Array PCol := Id.run do
  let mut a := a
  for i in [1:a.size] do
    let mut j := i
    while j > 0 && pcLt a[j]! a[j-1]! do
      a := a.swapIfInBounds j (j-1)
      j := j - 1
  return a

def norm (fc : FCtx) (k : PKey) : PKey := Id.run do
  let cs := sortCols k.cols
  let mut d := k.done
  for j in [0:fc.n] do
    if cs.contains fc.tc[j]! then d := d ||| (1 <<< j)
  return { k with cols := cs, done := d }

def colsLt (a b : Array PCol) : Bool := Id.run do
  if a.size != b.size then return a.size < b.size
  for i in [0:a.size] do
    if a[i]! != b[i]! then return pcLt a[i]! b[i]!
  return false

def canon (fc : FCtx) (k : PKey) : PKey := Id.run do
  let k0 := norm fc k
  let mut best := k0
  let mut bf := canonF k.fl
  -- least flag image first
  for tab in fc.ptab do
    let f := canonF (permFl tab k.fl)
    if f < bf then bf := f
  let mut hv := canonF k.fl == bf
  for tab in fc.ptab do
    if canonF (permFl tab k.fl) == bf then
      let img := norm fc { k with cols := k.cols.map (permCol tab), fl := canonF (permFl tab k.fl) }
      if !hv || colsLt img.cols best.cols then
        best := img; hv := true
  return best

@[inline] def undoneMask (fc : FCtx) (k : PKey) : Nat := ((1 <<< fc.n) - 1) ^^^ (k.done &&& ((1 <<< fc.n) - 1))
def popc (x : Nat) : Nat := Id.run do
  let mut c := 0
  let mut y := x
  while y > 0 do
    c := c + y % 2; y := y / 2
  return c
@[inline] def und (fc : FCtx) (k : PKey) : Nat := popc (undoneMask fc k)

def dead (fc : FCtx) (k : PKey) : Bool := Id.run do
  let u := undoneMask fc k
  for j in [0:fc.n] do
    if (u >>> j) % 2 == 1 then
      let mut acc : UInt64 := 0
      for c in k.cols do acc := acc ||| c.plane j
      if acc != fc.mask then return true
  return false

/-- Least number of masks covering `full` (search by size). -/
partial def coverMin (full : UInt64) (ms : Array UInt64) : Nat :=
  let rec go (s i : Nat) (acc : UInt64) : Bool :=
    if s == 0 then acc == full
    else if i ≥ ms.size then false
    else go (s - 1) (i + 1) (acc ||| ms[i]!) || go s (i + 1) acc
  let rec loop (s : Nat) : Nat := if s > ms.size then ms.size + 1 else if go s 0 0 then s else loop (s + 1)
  loop 0

def maxCover (fc : FCtx) (k : PKey) : Nat := Id.run do
  let u := undoneMask fc k
  let mut mx := 0
  for j in [0:fc.n] do
    if (u >>> j) % 2 == 1 then
      let cv := coverMin fc.mask (k.cols.map (·.plane j))
      if cv > mx then mx := cv
  return mx

@[inline] def laneVal (fc : FCtx) (c : PCol) (t : Nat) : Nat :=
  let b := (1 : UInt64) <<< t.toUInt64
  if c.plane 0 &&& b != 0 then 0 else if c.plane 1 &&& b != 0 then 1
  else if c.plane 2 &&& b != 0 then 2 else if c.plane 3 &&& b != 0 then 3 else fc.n

def clog2 (x : Nat) : Nat := Id.run do
  let mut e := 0
  while (1 <<< e) < x do e := e + 1
  return e

def hc (fc : FCtx) (k : PKey) : Nat := Id.run do
  let u := undoneMask fc k
  let mut sg : Array Nat := Array.mkEmpty fc.m
  let mut us : Array Nat := Array.mkEmpty fc.m
  for t in [0:fc.m] do
    let lt := (k.fl >>> t.toUInt64) &&& 1
    let gt := (k.fl >>> (32 + t).toUInt64) &&& 1
    let mut s := (lt + 2 * gt).toNat
    let mut p := 3
    for c in k.cols do
      s := s + p * fc.inv[t]![laneVal fc c t]!
      p := p * 5
    sg := sg.push s
    let mut v := 0
    let mut q := 1
    for j in [0:fc.n] do
      if (u >>> j) % 2 == 1 then
        v := v + q * fc.inv[t]![j]!
        q := q * 5
    us := us.push v
  let mut mx := 0
  for t in [0:fc.m] do
    -- distinct usig values among lanes with the same sig
    let mut seen : Array Nat := #[]
    for t2 in [0:fc.m] do
      if sg[t2]! == sg[t]! && !seen.contains us[t2]! then seen := seen.push us[t2]!
    if seen.size > mx then mx := seen.size
  return clog2 mx

def h (fc : FCtx) (k : PKey) : Nat :=
  let ud := und fc k
  hc fc k + max ud (ud + maxCover fc k - 2)

/-- NG successors (as enum_out NG=1, I1). -/
def succs (fc : FCtx) (k : PKey) : Array (PKey × Nat) := Id.run do
  let A := k.cols
  let tok := 1 ≤ k.gam
  let srcs := if tok then A.push Tc else A
  let mut out : Array (PKey × Nat) := #[]
  for a in srcs do
    for b in srcs do
      out := out.push ({ k with fl := canonF (cmpFl fc a b) }, 1)
  for D in A do
    for S in srcs do
      for cd in [0:4] do
        let M := merge (condMask fc cd k.fl) D S
        if !(M == D || M == Tc || A.contains M) then
          out := out.push (norm fc { k with cols := (A.erase D).push M }, 1)
          out := out.push (norm fc { k with cols := A.push M }, 2)
  if tok then
    for S in A do
      for cd in [0:4] do
        let M := merge (condMask fc cd k.fl) Tc S
        if !(M == Tc || A.contains M) then
          out := out.push (norm fc { k with cols := A.push M, gam := if k.gam == 7 then 7 else k.gam - 1 }, 1)
  if k.gam < 7 then out := out.push ({ k with gam := min (k.gam + 2) 7 }, 1)
  return out

def stateOK (fc : FCtx) (KB : Nat) (look : PKey → Option Nat) (k : PKey) (g : Nat) : Bool :=
  und fc k != 0 && (succs fc k).all fun (k0, w) =>
    let G := g + w
    KB < G + und fc k0 || dead fc k0 ||
      (let kc := canon fc k0
       (match look kc with | some g' => g' ≤ G | none => false) || KB < G + h fc kc)

/-! ## loading a v1 certificate (prototype: lanes in the file's W order) -/

def digits (s : String) : Array Nat := (s.toList.map fun ch => ch.toNat - '0'.toNat).toArray

def mkFCtx (n : Nat) (W : Array (Array Nat)) : FCtx := Id.run do
  let m := W.size
  let mask : UInt64 := (1 <<< m.toUInt64) - 1
  let tc := (Array.range n).map fun j =>
    if j < 2 then (⟨mask <<< (32 * j).toUInt64, 0⟩ : PCol) else ⟨0, mask <<< (32 * (j - 2)).toUInt64⟩
  let inv := W.map fun w => (Array.range (n + 1)).map fun v => (w.findIdx? (· == v)).getD n
  -- relabellings: σ ∈ S_n; (σ⋆w)[i] = w[σ i]; new lane t holds old lane π t with W[π t] = σ⋆W[t]
  let sig : List (List Nat) := LeanReflect.perms (List.range n)
  let mut ptab : Array (Array UInt64) := #[]
  for σ in sig do
    let π := W.map fun w =>
      let w2 := (Array.range n).map fun i => w[σ.getD i 0]!
      (W.findIdx? (· == w2)).getD 0
    -- new bit t = old bit π t: table over old bytes
    let mut tab : Array UInt64 := Array.replicate 1024 0
    for t in [0:m] do
      let ob := π[t]!
      let byte := ob / 8
      let bit := ob % 8
      for v in [0:256] do
        if (v >>> bit) % 2 == 1 then
          tab := tab.modify (byte * 256 + v) (· ||| ((1 : UInt64) <<< t.toUInt64))
    ptab := ptab.push tab
  return { n, m, mask, tc, inv, ptab }

def parseCol (n : Nat) (ds : Array Nat) : PCol := Id.run do
  let mut lo : UInt64 := 0
  let mut hi : UInt64 := 0
  for t in [0:ds.size] do
    let v := ds[t]!
    if v < n then
      let b : UInt64 := (1 : UInt64) <<< ((v % 2) * 32 + t).toUInt64
      if v < 2 then lo := lo ||| b else hi := hi ||| b
  return ⟨lo, hi⟩

def parseFl (ds : Array Nat) : UInt64 := Id.run do
  let mut f : UInt64 := 0
  for t in [0:ds.size] do
    if ds[t]! == 1 then f := f ||| ((1 : UInt64) <<< t.toUInt64)
    else if ds[t]! == 2 then f := f ||| ((1 : UInt64) <<< (32 + t).toUInt64)
  return f

def loadCert (path : String) : IO (FCtx × Std.HashMap PKey Nat × Nat) := do
  let h ← IO.FS.Handle.mk path .read
  let hdr ← h.getLine
  let n := ((hdr.splitOn "n=").getD 1 "0" |>.takeWhile Char.isDigit).toNat!
  let wl := ((← h.getLine).trimAsciiEnd.toString.splitOn " ").drop 1
  let W := (wl.map digits).toArray
  let fc := mkFCtx n W
  let nc := (((← h.getLine).trimAsciiEnd.toString.splitOn " ").getD 1 "0").toNat!
  let mut cols : Array PCol := Array.mkEmpty nc
  for _ in [0:nc] do
    let parts := (← h.getLine).trimAsciiEnd.toString.splitOn " "
    cols := cols.push (parseCol n (digits (parts.getD 1 "")))
  let ns := (((← h.getLine).trimAsciiEnd.toString.splitOn " ").getD 1 "0").toNat!
  let mut S : Std.HashMap PKey Nat := Std.HashMap.emptyWithCapacity ns
  for _ in [0:ns] do
    let parts := (← h.getLine).trimAsciiEnd.toString.splitOn " "
    let g := (parts.getD 0 "0").toNat!
    let fl := canonF (parseFl (digits (parts.getD 1 "")))
    let dm := (parts.getD 2 "0").toNat!
    let gm := (parts.getD 3 "0").toNat!
    let cs := ((parts.drop 4).filter (· ≠ "")).toArray.map fun s => cols[s.toNat!]!
    let kc := canon fc { cols := cs, fl, done := dm, gam := gm }
    match S[kc]? with
    | some g0 => if g < g0 then S := S.insert kc g
    | none => S := S.insert kc g
  return (fc, S, ns)

end LeanReflect.Fast
