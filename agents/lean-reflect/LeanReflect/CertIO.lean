import LeanReflect.SymBasic
/-
  Reading and writing certificates (CERT_FORMAT.md). UNTRUSTED code: the theorem `lower_bound_G` holds for every
  list S and every lookup that returns only entries of S, so parsing errors can only make the check fail.
-/
namespace LeanReflect.CertIO
open LeanReflect SortProof

def colDigits (col : Col) : String := String.ofList (col.map fun v => Char.ofNat ('0'.toNat + v.toNat))
def flagDigits (f : List Ordering) : String :=
  String.ofList (f.map fun o => match o with | .eq => '0' | .lt => '1' | .gt => '2')
def doneMask (d : List Bool) : Nat := (d.zipIdx.map fun (b, j) => if b then 2 ^ j else 0).sum

/-- Write `S` (keys in this checker's test order) as a v1 certificate; returns the sha256 of the body. -/
def writeCert (c : Ctx) (iset : String) (KB : Nat) (rules : String) (S : List (Key × Nat)) (path : String) :
    IO String := do
  let mut ids : Std.HashMap Col Nat := ∅
  let mut cols : Array Col := #[]
  for (k, _) in S do
    for col in k.cols do
      if !ids.contains col then
        ids := ids.insert col cols.size
        cols := cols.push col
  let h ← IO.FS.Handle.mk path .write
  h.putStrLn s!"cert n={c.n} W={c.m} iset={iset} K={KB} model=out-set ng=0 rules={rules}"
  h.putStrLn ("W " ++ " ".intercalate (c.ts.map colDigits))
  h.putStrLn s!"C {cols.size}"
  for i in List.range cols.size do
    h.putStrLn s!"{i} {colDigits cols[i]!}"
  h.putStrLn s!"S {S.length}"
  for (k, g) in S do
    let cs := " ".intercalate (k.cols.map fun col => toString (ids.getD col 0))
    h.putStrLn s!"{g} {flagDigits k.flag} {doneMask k.done} {k.gam} {cs}"
  h.flush
  let out ← IO.Process.output { cmd := "sha256sum", args := #[path] }
  let sha := (out.stdout.splitOn " ").headD ""
  let h2 ← IO.FS.Handle.mk path .append
  h2.putStrLn s!"END {S.length} {sha}"
  return sha

def digitsToInts (s : String) : List Int := s.toList.map fun ch => (ch.toNat : Int) - ('0'.toNat : Int)

/-- Read a v1 certificate into (canonical key ↦ least g), in this checker's test order and canonical form. -/
def readCert (c : Ctx) (G : List (List Nat)) (path : String) : IO (Std.HashMap Key Nat × Nat) := do
  let h ← IO.FS.Handle.mk path .read
  let _hdr ← h.getLine
  let wl := ((← h.getLine).trimAsciiEnd.toString.splitOn " ").drop 1
  if wl.length != c.m then throw (IO.userError s!"W line has {wl.length} tests, expected {c.m}")
  -- file test t is my test myIdx[t]; my test u is file test filePos[u]
  let myIdx := wl.map fun s => c.ts.idxOf (digitsToInts s)
  if myIdx.any (· ≥ c.m) then throw (IO.userError "W line: unknown test")
  let filePos : Array Nat := Id.run do
    let mut a := Array.replicate c.m 0
    for t in List.range c.m do a := a.set! (myIdx.getD t 0) t
    return a
  let reorder {α : Type} [Inhabited α] (xs : Array α) : List α := (List.range c.m).map fun u => xs[filePos[u]!]!
  let cl := (← h.getLine).trimAsciiEnd.toString.splitOn " "
  let nc := (cl.getD 1 "0").toNat!
  let mut cols : Array Col := Array.mkEmpty nc
  for _ in List.range nc do
    let parts := (← h.getLine).trimAsciiEnd.toString.splitOn " "
    cols := cols.push (reorder (digitsToInts (parts.getD 1 "")).toArray)
  let sl := (← h.getLine).trimAsciiEnd.toString.splitOn " "
  let ns := (sl.getD 1 "0").toNat!
  let mut S : Std.HashMap Key Nat := ∅
  for _ in List.range ns do
    let parts := (← h.getLine).trimAsciiEnd.toString.splitOn " "
    let g := (parts.getD 0 "0").toNat!
    let fl := reorder ((parts.getD 1 "").toList.map (fun ch => match ch with
      | '1' => Ordering.lt | '2' => Ordering.gt | _ => Ordering.eq)).toArray
    let dm := (parts.getD 2 "0").toNat!
    let ks := (parts.drop 4).filter (· ≠ "") |>.map fun s => cols[s.toNat!]!
    let gm := (parts.getD 3 "0").toNat!
    let k : Key := { cols := ks, flag := fl, done := (List.range c.n).map fun j => dm / 2 ^ j % 2 == 1, gam := gm }
    let kc := canon c G k
    let better := match S[kc]? with
      | some g0 => decide (g < g0)
      | none => true
    if better then S := S.insert kc g
  return (S, ns)

end LeanReflect.CertIO
