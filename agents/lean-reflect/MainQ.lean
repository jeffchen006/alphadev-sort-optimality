import LeanReflect.PLoad
import LeanReflect.PCheck2
open LeanReflect LeanReflect.FP SortProof

def countFail (f : FC) (KB : Nat) (s : Store) (isB : Bool) (T N r : Nat) : IO (Nat × Nat) := do
  let mut bad := 0
  let mut first := N
  let mut i := r
  let mut cnt := 0
  while i < N do
    let e := if isB then decRec s s.dB s.rbB i else decRec s s.dA s.rbA i
    if !recOK3 f KB s e then
      bad := bad + 1
      if first == N then first := i
    cnt := cnt + 1
    if r == 0 && cnt % (1 <<< 18) == 0 then
      IO.eprintln s!"[{← IO.monoMsNow}] task 0: {cnt} of ~{N / T} ({if isB then "B" else "A"}), failures so far {bad}"
    i := i + T
  return (bad, first)

unsafe def mainU (args : List String) : IO UInt32 := do
  let n := args[0]!.toNat!
  let path := args[1]!
  let KB := args[2]!.toNat!
  let T := (args[3]?.getD "16").toNat!
  let f ← Runtime.markPersistent (mkFC (mkCtx n))
  let t0 ← IO.monoMsNow
  let (s, log) ← loadStore f path T
  let t1 ← IO.monoMsNow
  IO.println s!"load {t1 - t0} ms: {log}"
  let s ← Runtime.markPersistent s
  let rP := keyP f.c (root f.c)
  IO.println s!"root canon lookup: {lookF s (canonP f rP)}"
  let t2 ← IO.monoMsNow
  let mut bad := 0
  for (isB, N) in [(false, s.nA), (true, s.nB)] do
    let tasks ← (List.range T).mapM fun r => IO.asTask (countFail f KB s isB T N r)
    for t in tasks do
      match t.get with
      | .ok (b, fi) =>
        if b > 0 then IO.println s!"area {if isB then "B" else "A"} task: {b} failures, first index {fi} g {(if isB then decRec s s.dB s.rbB fi else decRec s s.dA s.rbA fi).2}"
        bad := bad + b
      | .error e => IO.println s!"task error {e}"; bad := bad + 1
  let t3 ← IO.monoMsNow
  let tot := s.nA + s.nB
  IO.println s!"checked {tot} states, failures {bad}, {t3 - t2} ms, {(tot * 1000) / (max 1 (t3 - t2))} states/s (T={T}, KB={KB})"
  return if bad == 0 && lookF s (canonP f rP) == some 0 then 0 else 1

@[implemented_by mainU] opaque mainImpl (args : List String) : IO UInt32
def main (args : List String) : IO UInt32 := mainImpl args
