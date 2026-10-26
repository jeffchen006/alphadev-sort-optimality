import LeanReflect.CertIO
open LeanReflect LeanReflect.CertIO

/-- `certexe export n KB I0|I1 FILE` : run the (untrusted) search, write a v1 certificate.
    `certexe check  n KB I0|I1 FILE`  : read a v1 certificate, canonicalize, run the verified checker `checkG`. -/
def main (args : List String) : IO UInt32 := do
  let mode := args[0]!
  let c := mkCtx args[1]!.toNat!
  let KB := args[2]!.toNat!
  let iset := args[3]!
  let cs := if iset == "I0" then I0 else I1
  let path := args[4]!
  let G := group c
  let out ← IO.getStdout
  let t0 ← IO.monoMsNow
  if mode == "export" then
    let S := searchG c G cs KB
    let sha ← writeCert c iset KB "W,P,G,S,D,H1,und" S.toList path
    let t1 ← IO.monoMsNow
    out.putStrLn s!"exported {S.size} states to {path}, sha256 {sha}, {t1 - t0} ms"
    return 0
  else
    let (S, nl) ← readCert c G path
    let t1 ← IO.monoMsNow
    out.putStrLn s!"read {nl} state lines -> {S.size} canonical keys, {t1 - t0} ms"; out.flush
    let ok ← IO.lazyPure fun _ => checkG c G cs KB S.toList (fun k => S[k]?)
    let t2 ← IO.monoMsNow
    out.putStrLn s!"checkG = {ok}, {t2 - t1} ms"
    return if ok then 0 else 1
