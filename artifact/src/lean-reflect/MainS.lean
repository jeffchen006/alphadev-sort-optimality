import LeanReflect.SetBasic
open LeanReflect

/-- `setexe n KB I0|I1`: set-model search (untrusted) + checkS; per-g counts. -/
def main (args : List String) : IO Unit := do
  let c := mkCtx args[0]!.toNat!
  let KB := args[1]!.toNat!
  let cs := if args[2]! == "I0" then I0 else I1
  let out ← IO.getStdout
  let t0 ← IO.monoMsNow
  let S := searchS c cs KB
  let cnt := (List.range (KB + 1)).map fun g => S.fold (fun a _ v => if v == g then a + 1 else a) 0
  let t1 ← IO.monoMsNow
  out.putStrLn s!"n={c.n} KB={KB} states={S.size} per-g={cnt} search {t1 - t0} ms"; out.flush
  if args[3]? != some "nocheck" then
    let ok ← IO.lazyPure fun _ => checkS c cs KB S.toList (fun k => S[k]?)
    let t2 ← IO.monoMsNow
    out.putStrLn s!"checkS = {ok}, {t2 - t1} ms"; out.flush
