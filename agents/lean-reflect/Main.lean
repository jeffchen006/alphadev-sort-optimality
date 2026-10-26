import LeanReflect.Basic
open LeanReflect

/-- `searchexe n KB I0|I1 T [nocheck]`: run the (untrusted) parallel search and the checker; print layer stats. -/
def main (args : List String) : IO Unit := do
  let c := mkCtx args[0]!.toNat!
  let KB := args[1]!.toNat!
  let cs := if args[2]! == "I0" then I0 else I1
  let T := (args[3]?.getD "1").toNat!
  let doCheck := args[4]? != some "nocheck"
  let out ← IO.getStdout
  let t0 ← IO.monoMsNow
  let r := root c
  let mut vis : Std.HashMap LeanReflect.Key Nat := (∅ : Std.HashMap LeanReflect.Key Nat).insert r 0
  let mut front : Array LeanReflect.Key := #[r]
  out.putStrLn s!"n={c.n} KB={KB} tests={c.m} T={T} h(root)={h c r}"; out.flush
  for d in List.range KB do
    let (nx, v) := expandLayerPar c cs KB d T front vis
    front := nx; vis := v
    let t ← IO.monoMsNow
    out.putStrLn s!"depth {d+1}: {nx.size} new, total {vis.size}, {t - t0} ms"; out.flush
  if doCheck then
    let S := vis.toList
    let ok ← IO.lazyPure fun _ => checkPar c cs KB T S (fun k => vis[k]?)
    let t ← IO.monoMsNow
    out.putStrLn s!"checkPar = {ok}, {t - t0} ms"; out.flush
