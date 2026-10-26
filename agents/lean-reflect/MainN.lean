import LeanReflect.FastN
import LeanReflect.CertIO
open LeanReflect LeanReflect.FN

/-- Load a v1 certificate into canonical numeric keys (lanes reordered to the context's test order). -/
def loadN (f : FC) (G : List (List Nat)) (path : String) : IO (Std.HashMap KeyN Nat × Nat) := do
  let c := f.c
  let h ← IO.FS.Handle.mk path .read
  let _ ← h.getLine
  let wl := ((← h.getLine).trimAsciiEnd.toString.splitOn " ").drop 1
  let myIdx := wl.map fun s => c.ts.idxOf (CertIO.digitsToInts s)
  let filePos : Array Nat := Id.run do
    let mut a := Array.replicate c.m 0
    for t in List.range c.m do a := a.set! (myIdx.getD t 0) t
    return a
  let nc := (((← h.getLine).trimAsciiEnd.toString.splitOn " ").getD 1 "0").toNat!
  let mut cols : Array Nat := Array.mkEmpty nc
  for _ in [0:nc] do
    let parts := (← h.getLine).trimAsciiEnd.toString.splitOn " "
    let ds := (parts.getD 1 "").toList.toArray.map fun ch => ch.toNat - '0'.toNat
    cols := cols.push (ofDigits 5 ((List.range c.m).map fun u => ds[filePos[u]!]!))
  let ns := (((← h.getLine).trimAsciiEnd.toString.splitOn " ").getD 1 "0").toNat!
  let mut S : Std.HashMap KeyN Nat := Std.HashMap.emptyWithCapacity ns
  for _ in [0:ns] do
    let parts := (← h.getLine).trimAsciiEnd.toString.splitOn " "
    let g := (parts.getD 0 "0").toNat!
    let fds := (parts.getD 1 "").toList.toArray.map fun ch => match ch with | '1' => 0 | '2' => 2 | _ => 1
    let fl := ofDigits 3 ((List.range c.m).map fun u => fds[filePos[u]!]!)
    let dm := (parts.getD 2 "0").toNat!
    let gm := (parts.getD 3 "0").toNat!
    let cs := ((parts.drop 4).filter (· ≠ "")).map fun s => cols[s.toNat!]!
    let k : KeyN := { cols := cs, fl, done := (List.range c.n).map fun j => dm / 2 ^ j % 2 == 1, gam := gm }
    let kc := canonN f G k
    match S[kc]? with
    | some g0 => if g < g0 then S := S.insert kc g
    | none => S := S.insert kc g
  return (S, ns)

/-- `nexe n FILE KB T [limit]` -/
def main (args : List String) : IO UInt32 := do
  let f := mkFC (mkCtx args[0]!.toNat!)
  let G := group f.c
  let path := args[1]!
  let KB := args[2]!.toNat!
  let T := (args[3]?.getD "1").toNat!
  let lim := (args[4]?.getD "0").toNat!
  let out ← IO.getStdout
  let t0 ← IO.monoMsNow
  let (S, ns) ← loadN f G path
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
      if !stateOKN f G I1 KB (fun x => S[x]?) k g then bad := bad + 1
    return bad
  let bad ← IO.lazyPure fun _ => tasks.foldl (fun a t => a + t.get) 0
  let t3 ← IO.monoMsNow
  out.putStrLn s!"checked {arr.size} states, failures {bad}, {t3 - t2} ms, {(arr.size * 1000) / (max 1 (t3 - t2))} states/s (T={T})"
  return if bad == 0 then 0 else 1
