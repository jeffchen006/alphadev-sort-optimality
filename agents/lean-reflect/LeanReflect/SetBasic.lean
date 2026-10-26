import LeanReflect.Basic
/-
  Set model (enum's Lemma S, PRUNING.md): a key holds a SET A of non-T columns that covers every register
  (A ⊇ non-T register columns). Operations and costs:
    cmp a, b (a, b ∈ A ∪ {T})                         cost 1
    cmovX in place on D ∈ A:   A := {M} ∪ A \ {D}      cost 1
    cmovX into a copy of D ∈ A: A := {M} ∪ A           cost 2   (mov + cmov)
    cmovX on a T register:      A := {M} ∪ A           cost 1
  where M = (X holds ? S : D). Ops with M = D, M = T or M ∈ A are not generated (the concrete step is then a no-op
  on the set: cost 0). mov is not an op (cost 0). The cost bound uses the potential
  Φ = #non-T registers − #distinct non-T register columns (proof in SetSound.lean).
-/
namespace LeanReflect
open SortProof

section
variable (c : Ctx)

/-- Set-model successors with their cost. -/
def setSuccs (cs : List Cond) (k : Key) : List (Key × Nat) :=
  let A := k.cols
  let srcs := A ++ [c.T]
  (srcs.flatMap fun a => srcs.map fun b => (norm c { k with flag := cmpCol a b }, 1)) ++
  (A.flatMap fun D => srcs.flatMap fun S => cs.flatMap fun cd =>
    let M := merge cd k.flag D S
    if M == D || M == c.T || A.contains M then []
    else [(norm c { k with cols := M :: A.erase D }, 1), (norm c { k with cols := M :: A }, 2)]) ++
  (srcs.flatMap fun S => cs.flatMap fun cd =>
    let M := merge cd k.flag c.T S
    if M == c.T || A.contains M then [] else [(norm c { k with cols := M :: A }, 1)])

def succOKG (KB G : Nat) (look : Key → Option Nat) (k' : Key) : Bool :=
  (match look k' with
   | some g' => decide (g' ≤ G)
   | none => false) ||
  dead c k' || decide (KB < G + hB c k' (KB + 3 - G))

def checkS (cs : List Cond) (KB : Nat) (S : List (Key × Nat)) (look : Key → Option Nat) : Bool :=
  look (root c) == some 0 &&
  S.all fun (k, g) => !isGoal c k && (setSuccs c cs k).all fun (k', w) => succOKG c KB (g + w) look k'

/-- Untrusted search for the set model: buckets by cost (edges of cost 1 and 2). -/
def searchS (cs : List Cond) (KB : Nat) : Std.HashMap Key Nat := Id.run do
  let r := root c
  let mut vis : Std.HashMap Key Nat := (∅ : Std.HashMap Key Nat).insert r 0
  let mut buckets : Array (Array Key) := (Array.replicate (KB + 3) #[]).set! 0 #[r]
  for d in List.range (KB + 1) do
    for k in buckets[d]! do
      if vis[k]? == some d then
        for (k', w) in setSuccs c cs k do
          let G := d + w
          let better := match vis[k']? with
            | some g' => G < g'
            | none => true
          if better && G ≤ KB && !dead c k' && G + h c k' ≤ KB then
            vis := vis.insert k' G
            buckets := buckets.modify G (·.push k')
  return vis
end

def certOKS (n : Nat) (cs : List Cond) (KB : Nat) : Bool :=
  let c := mkCtx n
  let S := searchS c cs KB
  checkS c cs KB S.toList (fun k => S[k]?)

end LeanReflect
