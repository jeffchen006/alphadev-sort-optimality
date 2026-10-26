import LeanReflect.FastP
import LeanReflect.CertIO
open LeanReflect LeanReflect.FP

def loadP (f : FC) (path : String) : IO (Std.HashMap PKey Nat × Nat) := do
  let c := f.c
  let h ← IO.FS.Handle.mk path .read
  let _ ← h.getLine
  let wl := ((← h.getLine).trimAsciiEnd.toString.splitOn " ").drop 1
  let myIdx := wl.map fun s => c.ts.idxOf (CertIO.digitsToInts s)
  let filePos : Array Nat := Id.run do
    let mut a := Array.replicate c.m 0
    for t in List.range c.m do a := a.set! (myIdx.getD t 0) t
    return a
  let reorder {α : Type} [Inhabited α] (xs : Array α) : List α := (List.range c.m).map fun u => xs[filePos[u]!]!
  let nc := (((← h.getLine).trimAsciiEnd.toString.splitOn " ").getD 1 "0").toNat!
  let mut cols : Array PCol := Array.mkEmpty nc
  for _ in [0:nc] do
    let parts := (← h.getLine).trimAsciiEnd.toString.splitOn " "
    cols := cols.push (colP c (reorder (CertIO.digitsToInts (parts.getD 1 "")).toArray))
  let ns := (((← h.getLine).trimAsciiEnd.toString.splitOn " ").getD 1 "0").toNat!
  let mut S : Std.HashMap PKey Nat := Std.HashMap.emptyWithCapacity ns
  for _ in [0:ns] do
    let parts := (← h.getLine).trimAsciiEnd.toString.splitOn " "
    let g := (parts.getD 0 "0").toNat!
    let fl := flP (reorder ((parts.getD 1 "").toList.map (fun ch => match ch with
      | '1' => Ordering.lt | '2' => Ordering.gt | _ => Ordering.eq)).toArray)
    let dm := (parts.getD 2 "0").toNat!
    let gm := (parts.getD 3 "0").toNat!
    let cs := ((parts.drop 4).filter (· ≠ "")).map fun s => cols[s.toNat!]!
    let k : PKey := { cols := cs, fl, done := (List.range c.n).map fun j => dm / 2 ^ j % 2 == 1, gam := gm }
    let kc := canonP f k
    match S[kc]? with
    | some g0 => if g < g0 then S := S.insert kc g
    | none => S := S.insert kc g
  return (S, ns)

/-- `pexe n FILE KB T [limit]` -/
def main (args : List String) : IO UInt32 := do
  let f := mkFC (mkCtx args[0]!.toNat!)
  let path := args[1]!
  let KB := args[2]!.toNat!
  let T := (args[3]?.getD "1").toNat!
  let lim := (args[4]?.getD "0").toNat!
  let out ← IO.getStdout
  let t0 ← IO.monoMsNow
  let (S, ns) ← loadP f path
  let t1 ← IO.monoMsNow
  out.putStrLn s!"loaded {ns} lines -> {S.size} keys in {t1 - t0} ms"; out.flush
  let arr ← IO.lazyPure fun _ => S.toArray
  let arr := if lim > 0 then arr.extract 0 lim else arr
  let sz := (arr.size + T - 1) / T
  let t2 ← IO.monoMsNow
  let tasks := (List.range T).map fun r => Task.spawn fun _ => Id.run do
    let mut bad := 0
    for i in [r * sz : min arr.size ((r + 1) * sz)] do
      let (k, g) := arr[i]!
      if !stateOKP2 f I1 KB (fun x => S[x]?) k g then bad := bad + 1
    return bad
  let bad ← IO.lazyPure fun _ => tasks.foldl (fun a t => a + t.get) 0
  let t3 ← IO.monoMsNow
  out.putStrLn s!"checked {arr.size} states, failures {bad}, {t3 - t2} ms, {(arr.size * 1000) / (max 1 (t3 - t2))} states/s (T={T})"
  return if bad == 0 then 0 else 1
