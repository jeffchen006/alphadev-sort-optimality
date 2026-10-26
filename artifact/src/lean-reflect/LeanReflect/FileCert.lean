import LeanReflect.SymSound
import LeanReflect.CertIO
/-
  A certificate from a FILE as the list `S` of `lower_bound_G`. `certFile` is an opaque constant: logically some
  list, at run time (native_decide) the parsed and canonicalized file. Sound because `lower_bound_G` holds for EVERY
  list S; native_decide's trust (the compiler) then also covers `implemented_by` and the file read.
  The lookup `lookOf` re-checks the full key against the array entry, so `lookOf_sound` needs no HashMap lemma.
-/
namespace LeanReflect
open SortProof

unsafe def certFileImpl (path : String) (n : Nat) : Array (Key × Nat) :=
  match unsafeBaseIO (CertIO.readCert (mkCtx n) (group (mkCtx n)) path |>.toBaseIO) with
  | .ok (S, _) => S.toArray
  | .error _ => #[]

@[implemented_by certFileImpl]
opaque certFile (path : String) (n : Nat) : Array (Key × Nat)

/-- Index of every key (untrusted). -/
def indexOf (A : Array (Key × Nat)) : Std.HashMap Key Nat :=
  A.foldl (init := ((∅ : Std.HashMap Key Nat), 0)) (fun (m, i) e => (m.insert e.1 i, i + 1)) |>.1

def lookIn (A : Array (Key × Nat)) (ix : Std.HashMap Key Nat) (k : Key) : Option Nat :=
  match ix[k]? with
  | some i => match A[i]? with
    | some e => if e.1 = k then some e.2 else none
    | none => none
  | none => none

theorem lookIn_sound (A : Array (Key × Nat)) (ix : Std.HashMap Key Nat) (k : Key) (g : Nat)
    (h : lookIn A ix k = some g) : (k, g) ∈ A.toList := by
  unfold lookIn at h
  split at h
  · split at h
    · rename_i e he
      split at h
      · rename_i hk
        simp at h
        have := Array.mem_of_getElem? he
        rw [← h, ← hk]
        exact Array.mem_toList_iff.2 this
      · simp at h
    · simp at h
  · simp at h

def checkFile (n KB : Nat) (cs : List Cond) (A : Array (Key × Nat)) : Bool :=
  let c := mkCtx n
  checkG c (group c) cs KB A.toList (lookIn A (indexOf A))

theorem lower_bound_file (n KB : Nat) (cs : List Cond) (hc : CtxOK (mkCtx n)) (hs : SetCtxOK (mkCtx n))
    (hgo : GroupOK (mkCtx n) (group (mkCtx n))) (hsw : ∀ x ∈ cs, x.swap ∈ cs) (A : Array (Key × Nat))
    (h : checkFile n KB cs A = true) :
    ∀ (p : Program) (o : Snap), p.length ≤ KB → (∀ i ∈ p, condIn cs i) → ¬ RelaxedSnap n p o :=
  lower_bound_G n KB cs _ hc hs hgo hsw A.toList _ (lookIn_sound A _) h

end LeanReflect
