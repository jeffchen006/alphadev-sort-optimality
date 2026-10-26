import LeanReflect.SetBasic
/-
  Rule G (enum PRUNING.md): input relabelling σ ∈ S_n. A test w (values of the inputs) maps to σ⋆w with
  (σ⋆w)[i] = w[σ i]; on columns σ acts by a permutation `pos σ` of the test positions. A key is replaced by a
  canonical image: the lexicographically least `norm (act σ k)`. Any choice is sound.
-/
namespace LeanReflect
open SortProof

def relabel (n : Nat) (σ : List Nat) (w : List Int) : List Int :=
  (List.range n).map fun i => w.getD (σ.getD i 0) 0

section
variable (c : Ctx)

/-- Position map of σ: test `t` goes to the index of `σ⋆ts[t]`. -/
def pos (σ : List Nat) : List Nat := c.ts.map fun w => c.ts.idxOf (relabel c.n σ w)

def permCol (π : List Nat) (col : Col) : Col := let a := col.toArray; π.map fun t => cget a t
def permF (π : List Nat) (f : List Ordering) : List Ordering := π.map fun t => f.getD t .eq

def act (π : List Nat) (k : Key) : Key :=
  { k with cols := k.cols.map (permCol π), flag := permF π k.flag }

/-- The relabellings used (all of S_n), as position maps. -/
def group : List (List Nat) := (perms (List.range c.n)).map (pos c)

def ordLt : Ordering → Ordering → Bool
  | .lt, .eq => true
  | .lt, .gt => true
  | .eq, .gt => true
  | _, _ => false

/-- Strict lexicographic order on lists (given a strict order and equality on elements). -/
def lexLt {α : Type} [BEq α] (lt : α → α → Bool) : List α → List α → Bool
  | [], [] => false
  | [], _ :: _ => true
  | _ :: _, [] => false
  | a :: as, b :: bs => lt a b || (a == b && lexLt lt as bs)

/-- Plane number of a flag vector: bit t = lt at test t, bit 32 + t = gt (the fast checker's order). -/
def flagNum (f : List Ordering) : Nat :=
  (f.zipIdx.map fun (o, t) => match o with | .lt => 2 ^ t | .gt => 2 ^ (32 + t) | .eq => 0).sum

def keyLt (x y : Key) : Bool :=
  decide (flagNum x.flag < flagNum y.flag) || (x.flag == y.flag &&
    (lexLt (fun a b => decide (colNum c a < colNum c b)) x.cols y.cols ||
      (x.cols == y.cols && lexLt (fun a b => !a && b) x.done y.done)))

/-- Least image in `keyLt` (lexicographic minimum: orbit-invariant, no hash). -/
def pickMin (best : Key) : List Key → Key
  | [] => best
  | x :: xs => pickMin (if keyLt c x best then x else best) xs

def pickMinF (best : List Ordering) : List (List Ordering) → List Ordering
  | [] => best
  | x :: xs => pickMinF (if flagNum x < flagNum best then x else best) xs

/-- Least image; full images are built only for relabellings with the least flag vector
  (`keyLt` compares flags first, so this is still the lexicographic minimum). -/
def canon (G : List (List Nat)) (k : Key) : Key :=
  let fl := fun π => canonF (permF π k.flag)
  let fmin := pickMinF (canonF k.flag) (G.map fl)
  pickMin c (norm c k) ((G.filter fun π => fl π == fmin).map fun π => norm c (act π k))

/-- Per successor: the cheap bound `#undone` on the raw successor first (61% of all successors for sort3),
  then canonical image + lookup / dead / full h. -/
def fastOK (G : List (List Nat)) (KB Gc : Nat) (look : Key → Option Nat) (k0 : Key) : Bool :=
  decide (KB < Gc + (undone c k0).length) || dead c k0 || succOKG c KB Gc look (canon c G k0)

def checkG (G : List (List Nat)) (cs : List Cond) (KB : Nat) (S : List (Key × Nat))
    (look : Key → Option Nat) : Bool :=
  look (canon c G (root c)) == some 0 &&
  S.all fun (k, g) => !isGoal c k &&
    (setSuccs c cs k).all fun (k', w) => fastOK c G KB (g + w) look k'

/-- `checkG` split into `T` parallel Tasks by key hash (`checkGPar_check`). -/
def checkGPar (G : List (List Nat)) (cs : List Cond) (KB T : Nat) (S : List (Key × Nat))
    (look : Key → Option Nat) : Bool :=
  look (canon c G (root c)) == some 0 &&
  ((List.range T).map fun r => Task.spawn fun _ =>
      (S.filter fun e => shareOf T e.1 == r).all fun (k, g) => !isGoal c k &&
        (setSuccs c cs k).all fun (k', w) => fastOK c G KB (g + w) look k').all (·.get)

/-- Untrusted search with canonical keys. -/
def searchG (G : List (List Nat)) (cs : List Cond) (KB : Nat) : Std.HashMap Key Nat := Id.run do
  let r := canon c G (root c)
  let mut vis : Std.HashMap Key Nat := (∅ : Std.HashMap Key Nat).insert r 0
  let mut buckets : Array (Array Key) := (Array.replicate (KB + 3) #[]).set! 0 #[r]
  for d in List.range (KB + 1) do
    for k in buckets[d]! do
      if vis[k]? == some d then
        for (k0, w) in setSuccs c cs k do
          let G' := d + w
          if G' + (undone c k0).length ≤ KB && !dead c k0 then
            let k' := canon c G k0
            let better := match vis[k']? with
              | some g' => G' < g'
              | none => true
            if better && G' ≤ KB && !dead c k' && G' + h c k' ≤ KB then
              vis := vis.insert k' G'
              buckets := buckets.modify G' (·.push k')
  return vis
end

def certOKG (n : Nat) (cs : List Cond) (KB : Nat) : Bool :=
  let c := mkCtx n
  let G := group c
  let S := searchG c G cs KB
  checkG c G cs KB S.toList (fun k => S[k]?)

end LeanReflect
