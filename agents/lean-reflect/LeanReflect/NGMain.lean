import LeanReflect.NGRewrite
import LeanReflect.NGSound
/-
  Strict (x86) lower bound from an NG certificate: L10 (`ng_rewrite`, position-preserving NG normal form) +
  soundness of the NG set-model checker (`lower_bound_NG`).
-/
namespace LeanReflect
open SortProof

theorem lower_bound_strict (n KB : Nat) (hn2 : 2 ≤ n) (hn : n < 2 ^ 31 - 1) (G : List (List Nat))
    (hc : CtxOK (mkCtx n)) (hs : SetCtxOK (mkCtx n)) (hgo : GroupOK (mkCtx n) G)
    (S : List (Key × Nat)) (look : Key → Option Nat) (hlook : ∀ k g, look k = some g → (k, g) ∈ S)
    (hcert : checkNG (mkCtx n) G I1 KB S look = true) :
    ∀ (p : Program) (o : Snap), p.length ≤ KB → ¬ XSnap n p o := by
  intro p o hp hx
  obtain ⟨q, hql, hqn, hqr⟩ := NGR.ng_rewrite hn2 hn hx
  exact lower_bound_NG n KB I1 G hc hs hgo swap_I1 S look hlook hcert q o (by omega)
    (fun i _ => condIn_I1 i) hqn hqr

end LeanReflect
