import LeanReflect.NGBasic
open LeanReflect

/-- `ngexe n KB` : NG-model search (untrusted) + checkNG; per-g counts. -/
def main (args : List String) : IO Unit := do
  let c := mkCtx args[0]!.toNat!
  let KB := args[1]!.toNat!
  let G := group c
  let out ← IO.getStdout
  let t0 ← IO.monoMsNow
  let S := searchNG c G I1 KB
  let cnt := (List.range (KB + 1)).map fun g => S.fold (fun a _ v => if v == g then a + 1 else a) 0
  out.putStrLn s!"n={c.n} KB={KB} states={S.size} per-g={cnt}"; out.flush
  let ok ← IO.lazyPure fun _ => checkNG c G I1 KB S.toList (fun k => S[k]?)
  let t1 ← IO.monoMsNow
  out.putStrLn s!"checkNG = {ok}, {t1 - t0} ms"
