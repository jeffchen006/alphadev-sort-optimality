import LeanReflect.FileCert
import LeanReflect.Sort3G
/-
  sort4, k ≤ 15 (NOT the AlphaDev bound k ≤ 19): certificate certs/enum_sort4_I1_k15.cert (160021 states, written by
  proto/enum_cert.cpp), checked by the verified parallel checker. Rules W,P,G,S,D,H1,und,H3'. Trust: kernel + compiler.
-/
namespace LeanReflect
open SortProof

theorem ctxOK4 : CtxOK (mkCtx 4) := ⟨rfl, rfl, rfl, by decide, by decide, by decide, by decide, by decide⟩
theorem setCtxOK4 : SetCtxOK (mkCtx 4) := ⟨by decide, by decide⟩
theorem groupOK4 : GroupOK (mkCtx 4) (group (mkCtx 4)) := ⟨by decide, by decide⟩

theorem sort4_rs_lb15 : ∀ (p : Program) (o : Snap), p.length ≤ 15 → ¬ RelaxedSnap 4 p o :=
  fun p o hp => lower_bound_filePar 4 15 4 I1 ctxOK4 setCtxOK4 groupOK4 swap_I1 (by decide)
    (certFile "certs/enum_sort4_I1_k15.cert" 4) (by native_decide) p o hp (fun i _ => condIn_I1 i)

end LeanReflect
