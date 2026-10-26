import LeanReflect.PStore
import LeanReflect.CertIO
/-
  UNTRUSTED loader: certificate file (format v1) → packed `Store`. Soundness never depends on this code
  (`lookF_sound`, `checkStore_checkNG`); a wrong store can only make the check fail.
  The S section is parsed in parallel chunks; each state is canonicalized (`canonP`) and stored as file column ids
  plus the index of the relabelling that maps it to the canonical key.
-/
namespace LeanReflect.FP
open SortProof LeanReflect

structure LCfg where
  n : Nat
  m : Nat
  ib : Nat
  mcA : Nat
  rbA : Nat
  rbB : Nat
  filePos : Array Nat
  cols : Array PCol
  nsl : Nat

/-- Output of one parse task. -/
structure Part where
  dA : ByteArray
  hA : Array Nat
  dB : ByteArray
  hB : Array Nat
  bad : Nat
  firstBad : String

def bitLen (x : Nat) : Nat := if x = 0 then 0 else 1 + bitLen (x / 2)
termination_by x
decreasing_by omega

@[inline] def isDigit (b : UInt8) : Bool := 48 ≤ b && b ≤ 57

/-- Natural number at `i`; returns (value, index after the digits). -/
partial def natAt (d : ByteArray) (i : Nat) (acc : Nat := 0) : Nat × Nat :=
  if i < d.size && isDigit (d.get! i) then natAt d (i + 1) (acc * 10 + (d.get! i - 48).toNat) else (acc, i)

partial def skipSp (d : ByteArray) (i : Nat) : Nat := if i < d.size && d.get! i == 32 then skipSp d (i + 1) else i

partial def readIds (d : ByteArray) (i : Nat) (acc : Array Nat) : Array Nat × Nat :=
  let i := skipSp d i
  if i < d.size && isDigit (d.get! i) then
    let (v, j) := natAt d i
    readIds d j (acc.push v)
  else (acc, i)

partial def lineEnd (d : ByteArray) (i : Nat) : Nat := if i < d.size && d.get! i != 10 then lineEnd d (i + 1) else i

def pushLE (out : ByteArray) (x : Nat) (nb : Nat) : ByteArray := Id.run do
  let mut o := out
  let mut y := x
  for _ in [0:nb] do
    o := o.push (y % 256).toUInt8
    y := y / 256
  return o

/-- Encode a canonical key (cols in key order given as ids), g and relabelling index. -/
def encRec (cfg : LCfg) (kc : PKey) (g pi : Nat) (ids : List Nat) (rb : Nat) (out : ByteArray) : ByteArray :=
  let m := cfg.m
  let n := cfg.n
  let o := 2 * m
  let mm := 2 ^ m - 1
  let fl := kc.fl.toNat
  let dbits := (kc.done.zipIdx.map fun (b, j) => if b then 2 ^ j else 0).sum
  let h := (fl % 2 ^ 32 &&& mm) + ((fl / 2 ^ 32 &&& mm) <<< m) + (dbits <<< o) + ((kc.gam % 8) <<< (o + n)) +
    ((g % 32) <<< (o + n + 3)) + ((ids.length % 16) <<< (o + n + 8))
  let rest := (ids.zipIdx.map fun (id, j) => id <<< (5 + j * cfg.ib)).sum + pi
  pushLE (pushLE out h 8) rest (rb - 8)

/-- Parse one state line starting at `i`; returns the raw key, g, ids. -/
def parseLine (cfg : LCfg) (d : ByteArray) (i : Nat) : Option (PKey × Nat × Array Nat) :=
  let (g, i) := natAt d i
  let i := skipSp d i
  let fs := i
  let i := skipSp d (i + cfg.m)
  let (dm, i) := natAt d i
  let i := skipSp d i
  let (gm, i) := natAt d i
  let (ids, _) := readIds d i #[]
  let fl := (List.range cfg.m).foldl (fun (acc : UInt64) u =>
    let ch := d.get! (fs + cfg.filePos.getD u 0)
    if ch == 49 then acc ||| ((1 : UInt64) <<< u.toUInt64)
    else if ch == 50 then acc ||| ((1 : UInt64) <<< (32 + u).toUInt64) else acc) 0
  if ids.any (· ≥ cfg.cols.size) then none else
  some ({ cols := ids.toList.map fun id => cfg.cols[id]!, fl, done := (List.range cfg.n).map fun j => dm / 2 ^ j % 2 == 1,
          gam := gm }, g, ids)

def dummyStore (cfg : LCfg) : Store :=
  { n := cfg.n
    m := cfg.m
    cols := #[]
    tabs := #[]
    ib := 0
    rbA := 0
    nA := 0
    dA := ByteArray.empty
    rbB := 0
    nB := 0
    dB := ByteArray.empty
    nsl := cfg.nsl
    sl := ByteArray.empty }

def procLine (f : FC) (tabs : Array (Array Nat)) (cfg : LCfg) (d : ByteArray) (i : Nat) (p : Part) : Part :=
  match parseLine cfg d i with
  | none => { p with bad := p.bad + 1, firstBad := if p.bad == 0 then "parse" else p.firstBad }
  | some (k, g, ids) =>
    let kc := canonP f k
    let pi := (List.range tabs.size).find? fun t =>
      let tab := tabs[t]!
      canonF (permFl tab k.fl) == kc.fl && normP f (actP tab k) == kc
    match pi with
    | none => { p with bad := p.bad + 1, firstBad := if p.bad == 0 then "no relabelling" else p.firstBad }
    | some t =>
      let tab := tabs[t]!
      let ord := kc.cols.filterMap fun col => ids.toList.find? fun id => permCol tab cfg.cols[id]! == col
      if ord.length != kc.cols.length || ord.length > 15 then
        { p with bad := p.bad + 1, firstBad := if p.bad == 0 then "column order" else p.firstBad }
      else
        let sl := slotOf (dummyStore cfg) kc
        if ord.length ≤ cfg.mcA then { p with dA := encRec cfg kc g t ord cfg.rbA p.dA, hA := p.hA.push sl }
        else { p with dB := encRec cfg kc g t ord cfg.rbB p.dB, hB := p.hB.push sl }

/-- Parse the lines whose start lies in [lo, hi). -/
partial def procRange (f : FC) (tabs : Array (Array Nat)) (cfg : LCfg) (d : ByteArray) (lo hi : Nat) (p : Part) : Part :=
  if lo < hi then
    let e := lineEnd d lo
    procRange f tabs cfg d (e + 1) hi (if e > lo then procLine f tabs cfg d lo p else p)
  else p

/-- Next line start at or after `i` (i = 0 or just after a newline). -/
partial def alignLine (d : ByteArray) (i : Nat) : Nat :=
  if i == 0 then 0 else if i ≥ d.size then d.size else if d.get! (i - 1) == 10 then i else alignLine d (i + 1)

def wr32 (sl : ByteArray) (p : Nat) (v : Nat) : ByteArray :=
  ((((sl.set! (4 * p) (v % 256).toUInt8).set! (4 * p + 1) (v / 256 % 256).toUInt8).set! (4 * p + 2)
    (v / 65536 % 256).toUInt8).set! (4 * p + 3) (v / 16777216 % 256).toUInt8)

/-- Insert slot value `v` (record `idx` of area d/rb) starting at `p`; on a key already present keep the min g.
  Returns (slots, data, isDup). -/
partial def insSlot (s : Store) (isB : Bool) (idx : Nat) (sl d : ByteArray) (p : Nat) : ByteArray × ByteArray × Bool :=
  let v := rd32 sl (4 * p)
  if v == 0 then (wr32 sl p ((if isB then 2 ^ 31 else 0) + idx + 1), d, false) else
  let s' := { s with sl := sl, dA := if isB then s.dA else d, dB := if isB then d else s.dB }
  let oB := v >>> 31 == 1
  let oi := ((v &&& 0x7FFFFFFF) - 1).toNat
  let rbN := if isB then s.rbB else s.rbA
  let rbO := if oB then s.rbB else s.rbA
  let dO := if oB then s'.dB else s'.dA
  if oB == isB && oi == idx then (sl, d, false) else
  if (rd64 dO (oi * rbO) &&& hdrMask s) == (rd64 d (idx * rbN) &&& hdrMask s) then
    let eN := decRec s' d rbN idx
    let eO := decRec s' dO rbO oi
    if eN.1 == eO.1 then (sl, d, true) else insSlot s isB idx sl d ((p + 1) % s.nsl)
  else insSlot s isB idx sl d ((p + 1) % s.nsl)

def zeros (n : Nat) : ByteArray := Id.run do
  let mut blk : ByteArray := ByteArray.emptyWithCapacity (1 <<< 20)
  for _ in [0:1 <<< 20] do blk := blk.push 0
  let mut z : ByteArray := ByteArray.emptyWithCapacity (n + 8)
  for _ in [0:n / (1 <<< 20)] do z := z ++ blk
  for _ in [0:n % (1 <<< 20)] do z := z.push 0
  return z

def nextPow2 (x : Nat) : Nat := 2 ^ bitLen x

/-- Load a v1 certificate; `T` parse tasks per chunk. Returns the store and a log. -/
def loadStore (f : FC) (path : String) (T : Nat) (chunk : Nat := 1 <<< 28) : IO (Store × String) := do
  let c := f.c
  let h ← IO.FS.Handle.mk path .read
  let hdr ← h.getLine
  let wl := ((← h.getLine).trimAsciiEnd.toString.splitOn " ").drop 1
  let myIdx := wl.map fun s => c.ts.idxOf (CertIO.digitsToInts s)
  let filePos : Array Nat := Id.run do
    let mut a := Array.replicate c.m 0
    for t in List.range c.m do a := a.set! (myIdx.getD t 0) t
    return a
  let nc := (((← h.getLine).trimAsciiEnd.toString.splitOn " ").getD 1 "0").toNat!
  let mut cols : Array PCol := Array.mkEmpty nc
  for _ in [0:nc] do
    let ln ← h.getLine
    let parts := ln.trimAsciiEnd.toString.splitOn " "
    let ds := (CertIO.digitsToInts (parts.getD 1 "")).toArray
    cols := cols.push (colP c ((List.range c.m).map fun u => ds.getD (filePos[u]!) 0))
  let ns := (((← h.getLine).trimAsciiEnd.toString.splitOn " ").getD 1 "0").toNat!
  let ib := max 1 (bitLen (nc - 1))
  let mcA := 8
  let rbA := 8 + (5 + ib * mcA + 7) / 8
  let rbB := 8 + (5 + ib * 15 + 7) / 8
  let nsl := nextPow2 (ns + ns / 2)
  let tabs := f.ptab.toArray
  let cfg : LCfg := { n := c.n, m := c.m, ib, mcA, rbA, rbB, filePos, cols, nsl }
  let mut dA : ByteArray := ByteArray.emptyWithCapacity (ns * rbA + 16)
  let mut dB : ByteArray := ByteArray.emptyWithCapacity (1 <<< 20)
  let mut sl : ByteArray := zeros (4 * nsl)
  let base : Store := { dummyStore cfg with cols, tabs, ib, rbA, rbB }
  let mut nA := 0
  let mut nB := 0
  let mut bad := 0
  let mut dups := 0
  let mut firstBad := ""
  let mut carry : ByteArray := ByteArray.empty
  let mut done := false
  let mut endLine := ""
  while !done do
    let buf ← h.read chunk.toUSize
    let isLast := buf.size == 0
    let d0 := carry ++ buf
    -- cut at the last newline (or take all at EOF)
    let cut := if isLast then d0.size else Id.run do
      let mut j := d0.size
      while j > 0 && d0.get! (j - 1) != 10 do j := j - 1
      return j
    let d := d0.extract 0 cut
    carry := d0.extract cut d0.size
    -- END is the last line of the file: look at the last line of this piece
    let lastStart := Id.run do
      let mut j := if d.size > 0 then d.size - 1 else 0
      while j > 0 && d.get! (j - 1) != 10 do j := j - 1
      return j
    let endPos := if d.size > 0 && d.get! lastStart == 69 then lastStart else d.size
    if endPos < d.size then
      endLine := String.fromUTF8! (d.extract endPos (lineEnd d endPos))
      done := true
    if isLast then done := true
    let lim := endPos
    let bnd := (List.range (T + 1)).map fun r => alignLine d (min lim (r * lim / T))
    let tasks := (List.range T).map fun r => Task.spawn fun _ =>
      procRange f tabs cfg d (bnd.getD r 0) (bnd.getD (r + 1) 0)
        { dA := ByteArray.empty, hA := #[], dB := ByteArray.empty, hB := #[], bad := 0, firstBad := "" }
    for t in tasks do
      let p := t.get
      if p.bad > 0 && bad == 0 then firstBad := p.firstBad
      bad := bad + p.bad
      let a0 := nA
      dA := dA ++ p.dA
      nA := nA + p.hA.size
      for j in [0:p.hA.size] do
        let s' := { base with nA := nA, dA := ByteArray.empty }
        let (sl', dA', dup) := insSlot s' false (a0 + j) sl dA (p.hA[j]!)
        sl := sl'; dA := dA'
        if dup then dups := dups + 1
      let b0 := nB
      dB := dB ++ p.dB
      nB := nB + p.hB.size
      for j in [0:p.hB.size] do
        let s' := { base with nB := nB, dA := dA }
        let (sl', dB', dup) := insSlot s' true (b0 + j) sl dB (p.hB[j]!)
        sl := sl'; dB := dB'
        if dup then dups := dups + 1
  dA := dA ++ ByteArray.mk (Array.replicate 16 0)
  dB := dB ++ ByteArray.mk (Array.replicate 16 0)
  let st : Store := { base with nA, dA, nB, dB, sl }
  let log := s!"header: {hdr.trimAsciiEnd} | C {nc} (ib {ib}) | S {ns} | stored A {nA} (rb {rbA}) B {nB} (rb {rbB}) | " ++
    s!"slots {nsl} | bad {bad} {firstBad} | dup {dups} | {endLine}"
  return (st, log)

end LeanReflect.FP
