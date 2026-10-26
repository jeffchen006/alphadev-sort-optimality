import LeanReflect.PLoad
import LeanReflect.PCheck2
/-
  The store check as one Boolean, for `native_decide`. `storeFile` is an opaque constant: logically some store,
  at run time the loaded certificate file (untrusted loader; `lower_bound_store3` holds for every store).
  `f4` is a closed constant (persistent at module start: no shared reference counts in the parallel check).
  Closed-term extraction is off for `storeCheck` so that the file is never loaded at module start.
-/
namespace LeanReflect.FP
open SortProof LeanReflect

def f4 : FC := mkFC (mkCtx 4)

unsafe def storeFileImpl (path : String) : Store :=
  let act : IO Store := do
    let t0 ← IO.monoMsNow
    let (s, log) ← loadStore f4 path 16
    let t1 ← IO.monoMsNow
    IO.eprintln s!"storeFile: {t1 - t0} ms: {log}"
    Runtime.markPersistent s
  match unsafeBaseIO act.toBaseIO with
  | Except.ok s => s
  | Except.error _ => default

@[implemented_by storeFileImpl]
opaque storeFile (path : String) : Store

set_option compiler.extract_closed false in
def storeCheck (path : String) (KB T : Nat) : Bool :=
  checkStore3 f4 KB T (storeFile path) (keyP f4.c (root f4.c))

end LeanReflect.FP
