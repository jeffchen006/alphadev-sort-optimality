import LeanReflect.SymSound
import KProto.Kernel
/-
  Kernel-reducible form of lean-reflect's set-model + S_n checker `checkG`.
  `checkGK = checkG` by the same equalities (normK_eq, hK_eq, rootK_eq); then `lower_bound_G` applies.
-/
namespace KProto
open LeanReflect SortProof

def setSuccsK (c : Ctx) (cs : List Cond) (k : Key) : List (Key × Nat) :=
  let A := k.cols
  let srcs := A ++ [c.T]
  (srcs.flatMap fun a => srcs.map fun b => (normK c { k with flag := cmpCol a b }, 1)) ++
  (A.flatMap fun D => srcs.flatMap fun S => cs.flatMap fun cd =>
    let M := merge cd k.flag D S
    if M == D || M == c.T || A.contains M then []
    else [(normK c { k with cols := M :: A.erase D }, 1), (normK c { k with cols := M :: A }, 2)]) ++
  (srcs.flatMap fun S => cs.flatMap fun cd =>
    let M := merge cd k.flag c.T S
    if M == c.T || A.contains M then [] else [(normK c { k with cols := M :: A }, 1)])

theorem setSuccsK_eq (c : Ctx) (cs : List Cond) (k : Key) : setSuccsK c cs k = setSuccs c cs k := by
  simp only [setSuccsK, setSuccs, normK_eq]

def canonK (c : Ctx) (G : List (List Nat)) (k : Key) : Key :=
  let fl := fun π => canonF (permF π k.flag)
  let fmin := pickMinF (canonF k.flag) (G.map fl)
  pickMin (normK c k) ((G.filter fun π => fl π == fmin).map fun π => normK c (act π k))

theorem canonK_eq (c : Ctx) (G : List (List Nat)) (k : Key) : canonK c G k = canon c G k := by
  simp only [canonK, canon, normK_eq]

def succOKGK (c : Ctx) (KB G : Nat) (look : Key → Option Nat) (k' : Key) : Bool :=
  (match look k' with
   | some g' => decide (g' ≤ G)
   | none => false) ||
  dead c k' || decide (KB < G + hK c k')

theorem succOKGK_eq (c : Ctx) (KB G : Nat) (look : Key → Option Nat) :
    succOKGK c KB G look = succOKG c KB G look := by
  funext k'; simp only [succOKGK, succOKG, hK_eq]; cases look k' <;> rfl

def fastOKK (c : Ctx) (G : List (List Nat)) (KB Gc : Nat) (look : Key → Option Nat) (k0 : Key) : Bool :=
  decide (KB < Gc + (undone c k0).length) || dead c k0 || succOKGK c KB Gc look (canonK c G k0)

theorem fastOKK_eq (c : Ctx) (G : List (List Nat)) (KB Gc : Nat) (look : Key → Option Nat) :
    fastOKK c G KB Gc look = fastOK c G KB Gc look := by
  funext k0; simp only [fastOKK, fastOK, succOKGK_eq, canonK_eq]

/-- Per-state part of `checkG`. -/
def stateOKG (c : Ctx) (G : List (List Nat)) (cs : List Cond) (KB : Nat) (look : Key → Option Nat)
    (e : Key × Nat) : Bool :=
  !isGoal c e.1 && (setSuccsK c cs e.1).all fun (k', w) => fastOKK c G KB (e.2 + w) look k'

theorem lower_bound_treeG (n KB : Nat) (cs : List Cond) (hc : CtxOK (mkCtx n)) (hs : SetCtxOK (mkCtx n))
    (hgo : GroupOK (mkCtx n) (group (mkCtx n))) (hsw : ∀ x ∈ cs, x.swap ∈ cs) (t : BT2)
    (hroot : lookT2 (mkCtx n).m n t (canonK (mkCtx n) (group (mkCtx n)) (rootK (mkCtx n))) = some 0)
    (hall : (t.toList (mkCtx n).m n).all
      (stateOKG (mkCtx n) (group (mkCtx n)) cs KB (lookT2 (mkCtx n).m n t)) = true) :
    ∀ (p : Program) (o : Snap), p.length ≤ KB → (∀ i ∈ p, condIn cs i) → ¬ RelaxedSnap n p o := by
  apply lower_bound_G n KB cs (group (mkCtx n)) hc hs hgo hsw (t.toList (mkCtx n).m n) (lookT2 (mkCtx n).m n t)
    (fun k g h => BT2.find_sound _ n t _ k g h)
  simp only [checkG, Bool.and_eq_true, beq_iff_eq, List.all_eq_true]
  refine ⟨by rw [← rootK_eq, ← canonK_eq]; exact hroot, fun e he => ?_⟩
  have := List.all_eq_true.mp hall e he
  simp only [stateOKG, setSuccsK_eq, fastOKK_eq, Bool.and_eq_true, List.all_eq_true] at this
  exact this

end KProto
