import LeanReflect.PLoad
import LeanReflect.PCheck
open LeanReflect LeanReflect.FP SortProof

/-- Successor statistics (untrusted, for tuning). -/
unsafe def mainU (args : List String) : IO UInt32 := do
  let n := args[0]!.toNat!
  let path := args[1]!
  let KB := args[2]!.toNat!
  let lim := (args[3]?.getD "2000").toNat!
  let f ← Runtime.markPersistent (mkFC (mkCtx n))
  let (s, log) ← loadStore f path 16
  IO.println log
  let s ← Runtime.markPersistent s
  let mut tot := 0; let mut und := 0; let mut dead := 0; let mut found := 0; let mut hp := 0; let mut fail := 0
  let mut ncand := 0; let mut cmpS := 0
  let step := max 1 (s.nA / lim)
  let mut i := 0
  while i < s.nA do
    let (k, g) := decRec s s.dA s.rbA i
    for (k', w) in ngSuccsP f I1 k do
      tot := tot + 1
      let Gc := g + w
      if KB < Gc + (undoneP f k').length then und := und + 1
      else if deadP f k' then dead := dead + 1
      else
        let cands := candsP f k'.fl
        ncand := ncand + cands.length
        if k'.fl != canonF k.fl then cmpS := cmpS + 1
        let kc := canonWith f cands k'
        match lookF s kc with
        | some g' => if g' ≤ Gc then found := found + 1 else if hPrune f KB Gc kc then hp := hp + 1 else fail := fail + 1
        | none => if hPrune f KB Gc kc then hp := hp + 1 else fail := fail + 1
    i := i + step
  let ns := s.nA / step
  let mut cA := 0; let mut cB := 0; let mut cAB := 0; let mut cHP := 0; let mut cAny := 0
  let mut ii := 0
  while ii < s.nA do
    let (k, g) := decRec s s.dA s.rbA ii
    for (k', w) in ngSuccsP f I1 k do
      let Gc := g + w
      let u := (undoneP f k').length
      if !(KB < Gc + u) && !deadP f k' then
        cAny := cAny + 1
        let hc := hcP2 f k'
        let a := decide (KB < Gc + hc + u)
        let b := decide (KB < Gc + max u (u + maxCoverBP f k' (KB + 3 - Gc - u) - 2))
        if a then cA := cA + 1
        if b then cB := cB + 1
        if a && b then cAB := cAB + 1
        if hPrune f KB Gc k' then cHP := cHP + 1
    ii := ii + step
  IO.println s!"raw non-dead {cAny}: hc+u {cA}, cover-only {cB}, both {cAB}, hPrune {cHP}"
  -- phase timings over the same sample
  let sample := (List.range ns).map fun j => decRec s s.dA s.rbA (j * step)
  let t0 ← IO.monoMsNow
  let mut a0 := 0
  for (k, _) in sample do
    for (k', _) in ngSuccsP f I1 k do a0 := a0 + k'.cols.length
  let t1 ← IO.monoMsNow
  let mut a1 := 0
  for (k, g) in sample do
    for (k', w) in ngSuccsP f I1 k do
      if !(KB < g + w + (undoneP f k').length) && !deadP f k' then
        a1 := a1 + (canonWith f (candsP f k'.fl) k').cols.length
  let t2 ← IO.monoMsNow
  let mut a2 := 0
  for (k, g) in sample do
    for (k', w) in ngSuccsP f I1 k do
      if !(KB < g + w + (undoneP f k').length) && !deadP f k' then
        let kc := canonWith f (candsP f k'.fl) k'
        a2 := a2 + (lookF s kc).getD 0
  let t3 ← IO.monoMsNow
  let mut a3 := 0
  for (k, g) in sample do
    for (k', w) in ngSuccsP f I1 k do
      if !(KB < g + w + (undoneP f k').length) && !deadP f k' then
        let kc := canonWith f (candsP f k'.fl) k'
        a3 := a3 + hcP2 f kc
  let t4 ← IO.monoMsNow
  let mut a4 := 0
  for (k, g) in sample do
    for (k', w) in ngSuccsP f I1 k do
      if !(KB < g + w + (undoneP f k').length) && !deadP f k' then
        let kc := canonWith f (candsP f k'.fl) k'
        a4 := a4 + (if hPrune f KB (g + w) kc then 1 else 0)
  let t5 ← IO.monoMsNow
  let mut a5 := 0
  for (k, g) in sample do
    a5 := a5 + (if recOK f KB s (k, g) then 1 else 0)
  let t6 ← IO.monoMsNow
  IO.println s!"ms: succs {t1-t0} | +canon {t2-t1} | +canon+look {t3-t2} | +canon+hc {t4-t3} | +canon+hPrune {t5-t4} | full recOK {t6-t5}  ({a0+a1+a2+a3+a4+a5})"
  IO.println s!"states {ns}: succ/state {tot / ns}, und {und}, dead {dead}, found {found}, hPrune {hp}, fail {fail}, cands/canon {ncand * 100 / max 1 (found + hp + fail)}%, flagchange {cmpS}"
  return 0

@[implemented_by mainU] opaque mainImpl (args : List String) : IO UInt32
def main (args : List String) : IO UInt32 := mainImpl args
