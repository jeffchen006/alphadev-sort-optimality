import LeanReflect.SymBasic
open LeanReflect

/-- `symexe n KB I0|I1 [nocheck]`: set model + rule G (untrusted search) + checkG. -/
def main (args : List String) : IO Unit := do
  let c := mkCtx args[0]!.toNat!
  let KB := args[1]!.toNat!
  let cs := if args[2]! == "I0" then I0 else I1
  let G := group c
  let out ← IO.getStdout
  let t0 ← IO.monoMsNow
  let S := searchG c G cs KB
  let cnt := (List.range (KB + 1)).map fun g => S.fold (fun a _ v => if v == g then a + 1 else a) 0
  let t1 ← IO.monoMsNow
  out.putStrLn s!"n={c.n} KB={KB} |G|={G.length} states={S.size} per-g={cnt} search {t1 - t0} ms"; out.flush
  if args[3]? == some "stats" then
    for g in List.range (KB + 1) do
      let (ns, nsucc) := S.fold (fun (a : Nat × Nat) k v => if v == g then (a.1 + 1, a.2 + (setSuccs c cs k).length) else a) (0, 0)
      out.putStrLn s!"g={g}: states {ns}, successors {nsucc}"; out.flush
  if args[3]? == some "prof" then
    -- how each successor is resolved: found / und-pruned / dead / h-pruned / missing
    let mut a := (0, 0, 0, 0, 0)
    for (k, g) in S.toList do
      for (k0, w) in setSuccs c cs k do
        let k' := canon c G k0
        let G' := g + w
        match S[k']? with
        | some g' => if g' ≤ G' then a := (a.1 + 1, a.2) else a := (a.1, a.2.1, a.2.2.1, a.2.2.2.1, a.2.2.2.2 + 1)
        | none =>
          if KB < G' + (undone c k').length then a := (a.1, a.2.1 + 1, a.2.2)
          else if dead c k' then a := (a.1, a.2.1, a.2.2.1 + 1, a.2.2.2)
          else if KB < G' + h c k' then a := (a.1, a.2.1, a.2.2.1, a.2.2.2.1 + 1, a.2.2.2.2)
          else a := (a.1, a.2.1, a.2.2.1, a.2.2.2.1, a.2.2.2.2 + 1)
    out.putStrLn s!"found {a.1}, und-pruned {a.2.1}, dead {a.2.2.1}, h-pruned {a.2.2.2.1}, missing {a.2.2.2.2}"
  if args[3]? != some "nocheck" && args[3]? != some "stats" && args[3]? != some "prof" then
    let ok ← IO.lazyPure fun _ => checkG c G cs KB S.toList (fun k => S[k]?)
    let t2 ← IO.monoMsNow
    out.putStrLn s!"checkG = {ok}, {t2 - t1} ms"; out.flush
