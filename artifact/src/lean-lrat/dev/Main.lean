import LeanLrat
import Lean.Meta.Tactic.BVDecide.LRAT.Trim
import Std.Tactic.BVDecide.LRAT.Parser
/-
  Untrusted tool (its output is only an input for the trusted check):
    lrat-tool dimacs <n> <k> <I0|I1|I0c|I1c> <types> <out.cnf>    write `enc n k i1 canon types norm hc` in DIMACS
    lrat-tool check  <n> <k> <I0|I1|I0c|I1c> <types> <proof.lrat> run `checkCert` compiled (same code as the theorem)
  <types> = `all` (all weak order types) or a file with one type per line, e.g. `0 1 1`.
-/
open LeanLrat

def parseTypes (n : Nat) (spec : String) : IO (List (List Nat)) := do
  if spec == "all" then return weakOrderTypes n
  let txt ← IO.FS.readFile spec
  let ls := (txt.splitOn "\n").map String.trim |>.filter (fun l => l != "" && !l.startsWith "#")
  return ls.map fun l => ((l.splitOn " ").filter (· != "")).map String.toNat!

def parseI (s : String) : Bool := s.startsWith "I1"
/-- `I1c` / `I0c` = with the first-touch rule. -/
def parseC (s : String) : Bool := (s.drop 2).toString.contains 'c' || (s.drop 2).toString.contains 'n' 
/-- `I1n` / `I0n` = first-touch rule + normal form (nop suffix, flags, no self moves). -/
def parseN (s : String) : Bool := (s.drop 2).toString.contains 'n'
/-- `...h` = with the hcmp cut (types must be distinct permutations). -/
def parseH (s : String) : Bool := (s.drop 2).toString.contains 'h' 

def main (args : List String) : IO UInt32 := do
  match args with
  | ["cube", n, k, i, ts, cube, out] =>
    -- cube = comma list of signed DIMACS literals, e.g. "12,-40"; CNF = addUnits (enc ...) cube
    let (n, k, i1, canon, norm, hc) := (n.toNat!, k.toNat!, parseI i, parseC i, parseN i, parseH i)
    let types ← parseTypes n ts
    let us := (cube.splitOn ",").filter (· != "") |>.map fun l =>
      let z := l.toInt!; (z.natAbs - 1, decide (0 < z))
    IO.FS.writeFile out (addUnits (enc n k i1 canon types norm hc) us).dimacs
    return 0
  | ["var", n, k, i, ts, vname] =>
    -- DIMACS id of `op t o` / `dst t r` / `src t r`, vname like "op:0:1"
    let (n, k) := (n.toNat!, k.toNat!)
    let _ := i
    let types ← parseTypes n ts
    let d := dimsOf n k types
    let a := (vname.splitOn ":").toArray
    let x := a[1]!.toNat!; let y := a[2]!.toNat!
    let v : V := if a[0]! == "op" then .op x y else if a[0]! == "dst" then .dst x y else .src x y
    IO.println s!"{layout d d.bases v + 1}"
    return 0
  | ["dimacs", n, k, i, ts, out] =>
    let (n, k, i1, canon, norm, hc) := (n.toNat!, k.toNat!, parseI i, parseC i, parseN i, parseH i)
    let types ← parseTypes n ts
    let t0 ← IO.monoMsNow
    let cnf := enc n k i1 canon types norm hc
    IO.FS.writeFile out cnf.dimacs
    let t1 ← IO.monoMsNow
    IO.println s!"n={n} k={k} {i} types={types.length} clauses={cnf.clauses.size} layoutOK={layoutOK n k i1 canon types norm hc} ({t1-t0} ms)"
    return 0
  | ["check", n, k, i, ts, proof] =>
    let (n, k, i1, canon, norm, hc) := (n.toNat!, k.toNat!, parseI i, parseC i, parseN i, parseH i)
    let types ← parseTypes n ts
    let cert ← IO.FS.readFile proof
    let t0 ← IO.monoMsNow
    let ok ← IO.lazyPure (fun _ => layoutOK n k i1 canon types norm hc && Std.Tactic.BVDecide.Reflect.verifyCert (enc n k i1 canon types norm hc) cert)
    let t1 ← IO.monoMsNow
    IO.println s!"checkCert n={n} k={k} {i} types={types.length}: {ok} ({t1-t0} ms)"
    return (if ok then 0 else 1)
  | ["names", n, k, i, ts, out] =>
    -- DIMACS variable v (1-based) = decode (v - 1); one line per variable that occurs in the CNF
    let (n, k, i1, canon, norm, hc) := (n.toNat!, k.toNat!, parseI i, parseC i, parseN i, parseH i)
    let types ← parseTypes n ts
    let d := dimsOf n k types
    let b := d.bases
    let vs := (encList n k i1 canon types norm hc).foldl (fun acc c => c.foldl (fun acc l => acc.insert (layout d b l.1)) acc) (Std.HashSet.emptyWithCapacity : Std.HashSet Nat)
    let sorted := vs.toArray.qsort (· < ·)
    let lines := sorted.map fun m => s!"c v {m+1} {reprStr (decode d b m)}"
    IO.FS.writeFile out (String.intercalate "\n" lines.toList ++ "\n")
    IO.println s!"{sorted.size} variables"
    return 0
  | ["trim", inp, out] =>
    -- untrusted: Lean's LRAT trimmer (as used by bv_decide); output is text LRAT
    let t0 ← IO.monoMsNow
    let proof ← Std.Tactic.BVDecide.LRAT.loadLRATProof inp
    let trimmed ← IO.ofExcept (← IO.lazyPure (fun _ => Lean.Meta.Tactic.BVDecide.LRAT.trim proof))
    IO.FS.writeFile out (Std.Tactic.BVDecide.LRAT.lratProofToString trimmed)
    let t1 ← IO.monoMsNow
    IO.println s!"trim: {proof.size} -> {trimmed.size} steps ({t1-t0} ms)"
    return 0
  | _ => IO.eprintln "usage: see Main.lean"; return 2
