import LeanReflect.SymBasic
/-
  Set model with rule NG (enum PRUNING v3): the key carries γ = number of garbage registers holding T (7 = unbounded).
  Ops (as enum_out with NG=1):
    T may be read (cmp operand, cmov source) only if γ ≥ 1;
    cmov into a T register (a garbage register) needs γ ≥ 1, cost 1, γ := γ − 1 (7 stays 7);
    garbage op (a garbage move, or any op that leaves an all-T value): cost 1, γ := min (γ + 2) 7, only if γ < 7.
  All other ops as in `setSuccs`.
-/
namespace LeanReflect
open SortProof

section
variable (c : Ctx)

def gDec (g : Nat) : Nat := if g = 7 then 7 else g - 1
def gInc2 (g : Nat) : Nat := min (g + 2) 7

def ngSuccs (cs : List Cond) (k : Key) : List (Key × Nat) :=
  let A := k.cols
  let srcs := if 1 ≤ k.gam then A ++ [c.T] else A
  (srcs.flatMap fun a => srcs.map fun b => (norm c { k with flag := cmpCol a b }, 1)) ++
  (A.flatMap fun D => srcs.flatMap fun S => cs.flatMap fun cd =>
    let M := merge cd k.flag D S
    if M == D || M == c.T || A.contains M then []
    else [(norm c { k with cols := M :: A.erase D }, 1), (norm c { k with cols := M :: A }, 2)]) ++
  (if 1 ≤ k.gam then
    (A.flatMap fun S => cs.flatMap fun cd =>
      let M := merge cd k.flag c.T S
      if M == c.T || A.contains M then [] else [(norm c { k with cols := M :: A, gam := gDec k.gam }, 1)])
   else []) ++
  (if k.gam < 7 then [(norm c { k with gam := gInc2 k.gam }, 1)] else [])

def checkNG (G : List (List Nat)) (cs : List Cond) (KB : Nat) (S : List (Key × Nat))
    (look : Key → Option Nat) : Bool :=
  look (canon c G (root c)) == some 0 &&
  S.all fun (k, g) => !isGoal c k &&
    (ngSuccs c cs k).all fun (k', w) => fastOK c G KB (g + w) look k'

def checkNGPar (G : List (List Nat)) (cs : List Cond) (KB T : Nat) (S : List (Key × Nat))
    (look : Key → Option Nat) : Bool :=
  look (canon c G (root c)) == some 0 &&
  ((List.range T).map fun r => Task.spawn fun _ =>
      (S.filter fun e => shareOf T e.1 == r).all fun (k, g) => !isGoal c k &&
        (ngSuccs c cs k).all fun (k', w) => fastOK c G KB (g + w) look k').all (·.get)

/-- Untrusted search (buckets by cost). -/
def searchNG (G : List (List Nat)) (cs : List Cond) (KB : Nat) : Std.HashMap Key Nat := Id.run do
  let r := canon c G (root c)
  let mut vis : Std.HashMap Key Nat := (∅ : Std.HashMap Key Nat).insert r 0
  let mut buckets : Array (Array Key) := (Array.replicate (KB + 3) #[]).set! 0 #[r]
  for d in List.range (KB + 1) do
    for k in buckets[d]! do
      if vis[k]? == some d then
        for (k0, w) in ngSuccs c cs k do
          let G' := d + w
          if G' + (undone c k0).length ≤ KB && !dead c k0 then
            let k' := canon c G k0
            let better := match vis[k']? with
              | some g' => decide (G' < g')
              | none => true
            if better && G' ≤ KB && !dead c k' && G' + h c k' ≤ KB then
              vis := vis.insert k' G'
              buckets := buckets.modify G' (·.push k')
  return vis
end

end LeanReflect
