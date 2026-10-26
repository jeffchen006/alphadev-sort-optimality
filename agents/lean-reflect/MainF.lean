import LeanReflect.FastProto
open LeanReflect.Fast

/-- `fastexe FILE KB T [limit]`: prototype packed NG checker (speed test). -/
def main (args : List String) : IO UInt32 := do
  let path := args[0]!
  let KB := args[1]!.toNat!
  let T := (args[2]?.getD "1").toNat!
  let lim := (args[3]?.getD "0").toNat!
  let out ← IO.getStdout
  let t0 ← IO.monoMsNow
  let (fc, S, ns) ← loadCert path
  let t1 ← IO.monoMsNow
  out.putStrLn s!"loaded {ns} lines -> {S.size} keys in {t1 - t0} ms"; out.flush
  let arr ← IO.lazyPure fun _ => S.toArray
  let arr := if lim > 0 then arr.extract 0 lim else arr
  let sz := (arr.size + T - 1) / T
  let tasks := (List.range T).map fun r => Task.spawn fun _ => Id.run do
    let mut bad := 0
    for i in [r * sz : min arr.size ((r + 1) * sz)] do
      let (k, g) := arr[i]!
      if !stateOK fc KB (fun x => S[x]?) k g then bad := bad + 1
    return bad
  let bad ← IO.lazyPure fun _ => tasks.foldl (fun a t => a + t.get) 0
  let t2 ← IO.monoMsNow
  out.putStrLn s!"checked {arr.size} states, failures {bad}, {t2 - t1} ms, {(arr.size * 1000) / (max 1 (t2 - t1))} states/s (T={T})"
  return if bad == 0 then 0 else 1
