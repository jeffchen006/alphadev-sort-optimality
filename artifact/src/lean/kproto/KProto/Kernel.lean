import LeanReflect.Sound
import KProto.Measure
/-
  Kernel-reducible form of lean-reflect's checker.
  `checkK` = `check` with: insertion sort instead of `List.mergeSort` (well-founded, does not
  reduce in the kernel), `clog2` by fuel, and a binary tree lookup instead of `Std.HashMap`.
  `checkK_eq : checkK = check`, so lean-reflect's `check_sound` applies unchanged.
-/
namespace KProto
open LeanReflect SortProof

/-! ### colLe is a total order on columns -/

theorem colLe_total : ∀ a b : Col, (colLe a b || colLe b a) = true
  | [], _ => by simp [colLe]
  | _ :: _, [] => by simp [colLe]
  | a :: as, b :: bs => by
    have ih := colLe_total as bs
    simp only [colLe, Bool.or_eq_true, Bool.and_eq_true, beq_iff_eq, decide_eq_true_eq] at ih ⊢
    rcases Int.lt_trichotomy a b with h | h | h
    · left; left; exact h
    · subst h; rcases ih with h' | h'
      · left; right; exact ⟨rfl, h'⟩
      · right; right; exact ⟨rfl, h'⟩
    · right; left; exact h

theorem colLe_trans : ∀ a b c : Col, colLe a b = true → colLe b c = true → colLe a c = true
  | [], _, _, _, _ => by simp [colLe]
  | _ :: _, [], _, h, _ => by simp [colLe] at h
  | _ :: _, _ :: _, [], _, h => by simp [colLe] at h
  | a :: as, b :: bs, c :: cs, h1, h2 => by
    simp only [colLe, Bool.or_eq_true, Bool.and_eq_true, beq_iff_eq, decide_eq_true_eq] at h1 h2 ⊢
    rcases h1 with h1 | ⟨rfl, h1⟩ <;> rcases h2 with h2 | ⟨rfl, h2⟩
    · left; omega
    · left; exact h1
    · left; exact h2
    · right; exact ⟨rfl, colLe_trans as bs cs h1 h2⟩

theorem colLe_antisymm : ∀ a b : Col, colLe a b = true → colLe b a = true → a = b
  | [], [], _, _ => rfl
  | [], _ :: _, _, h => by simp [colLe] at h
  | _ :: _, [], h, _ => by simp [colLe] at h
  | a :: as, b :: bs, h1, h2 => by
    simp only [colLe, Bool.or_eq_true, Bool.and_eq_true, beq_iff_eq, decide_eq_true_eq] at h1 h2
    rcases h1 with h1 | ⟨rfl, h1⟩ <;> rcases h2 with h2 | ⟨h2e, h2⟩
    · omega
    · omega
    · omega
    · rw [colLe_antisymm as bs h1 h2]

/-! ### insertion sort = mergeSort -/

theorem insertCol_perm (x : Col) : ∀ l : List Col, List.Perm (insertCol x l) (x :: l)
  | [] => List.Perm.refl _
  | y :: ys => by
    simp only [insertCol]
    split
    · exact List.Perm.refl _
    · exact ((insertCol_perm x ys).cons y).trans (List.Perm.swap x y ys)

theorem isortCol_perm : ∀ l : List Col, List.Perm (isortCol l) l
  | [] => List.Perm.refl _
  | x :: xs => (insertCol_perm x _).trans ((isortCol_perm xs).cons x)

theorem insertCol_sorted (x : Col) : ∀ l : List Col, l.Pairwise (fun a b => colLe a b = true) →
    (insertCol x l).Pairwise (fun a b => colLe a b = true)
  | [], _ => by simp [insertCol]
  | y :: ys, h => by
    simp only [insertCol]
    have hy := List.pairwise_cons.mp h
    split
    · rename_i hxy
      refine List.Pairwise.cons ?_ h
      intro z hz
      rcases List.mem_cons.mp hz with rfl | hz
      · exact hxy
      · exact colLe_trans _ _ _ hxy (hy.1 z hz)
    · rename_i hxy
      have hyx : colLe y x = true := by
        have := colLe_total x y; simp_all
      refine List.Pairwise.cons ?_ (insertCol_sorted x ys hy.2)
      intro z hz
      have hz' := (insertCol_perm x ys).subset hz
      rcases List.mem_cons.mp hz' with rfl | hz'
      · exact hyx
      · exact hy.1 z hz'

theorem isortCol_sorted : ∀ l : List Col, (isortCol l).Pairwise (fun a b => colLe a b = true)
  | [] => List.Pairwise.nil
  | x :: xs => insertCol_sorted x _ (isortCol_sorted xs)

theorem isortCol_eq (l : List Col) : isortCol l = l.mergeSort colLe := by
  apply List.Perm.eq_of_pairwise (le := fun a b => colLe a b = true)
  · intro a b _ _ h1 h2; exact colLe_antisymm a b h1 h2
  · exact isortCol_sorted l
  · exact List.pairwise_mergeSort (le := colLe) (fun a b c h1 h2 => colLe_trans a b c h1 h2)
      (fun a b => colLe_total a b) l
  · exact (isortCol_perm l).trans (List.mergeSort_perm l colLe).symm

/-! ### the kernel forms agree with lean-reflect's functions -/

theorem normK_eq (c : Ctx) (k : Key) : normK c k = norm c k := by
  simp only [normK, norm, isortCol_eq]

theorem succsK_eq (c : Ctx) (cs : List Cond) (k : Key) : succsK c cs k = succs c cs k := by
  simp only [succsK, succs, normK_eq]

theorem clog2F_eq : ∀ (f x : Nat), x ≤ f → clog2F f x = clog2 x
  | 0, x, h => by
    have : x = 0 := by omega
    subst this; simp [clog2F, clog2]
  | f + 1, x, h => by
    rw [clog2]
    simp only [clog2F]
    split
    · rfl
    · rw [clog2F_eq f ((x + 1) / 2) (by omega)]

theorem hK_eq (c : Ctx) (k : Key) : hK c k = h c k := by
  simp only [hK, h, hcK, hc, clog2K, clog2F_eq _ _ (Nat.le_refl _)]

theorem rootK_eq (c : Ctx) : rootK c = root c := by
  simp only [rootK, root, normK_eq]

/-! ### binary tree lookup -/

/-- Packed code of a key (any injective-enough code works: `find` re-checks the key). -/
def colCode : Col → Nat
  | [] => 1
  | a :: as => colCode as * 8 + (a.toNat % 8)

def keyCode (k : Key) : Nat :=
  let a := k.cols.foldl (fun acc col => acc * 2 ^ 20 + colCode col) 1
  let b := k.flag.foldl (fun acc o => acc * 4 + o.ctorIdx) a
  k.done.foldl (fun acc d => acc * 2 + (if d then 1 else 0)) b

inductive BT where
  | leaf
  | node (l : BT) (code : Nat) (k : Key) (g : Nat) (r : BT)

def BT.find : BT → Nat → Key → Option Nat
  | .leaf, _, _ => none
  | .node l code k g r, c, k' =>
    if c < code then l.find c k' else if code < c then r.find c k' else if k = k' then some g else none

def BT.toList : BT → List (Key × Nat)
  | .leaf => []
  | .node l _ k g r => l.toList ++ (k, g) :: r.toList

theorem BT.find_sound : ∀ (t : BT) (c : Nat) (k : Key) (g : Nat), t.find c k = some g → (k, g) ∈ t.toList
  | .leaf, _, _, _, h => by simp [BT.find] at h
  | .node l code k0 g0 r, c, k, g, h => by
    simp only [BT.find] at h
    simp only [BT.toList, List.mem_append, List.mem_cons]
    split at h
    · exact Or.inl (BT.find_sound l c k g h)
    · split at h
      · exact Or.inr (Or.inr (BT.find_sound r c k g h))
      · split at h
        · rename_i hk; subst hk; simp at h; subst h; exact Or.inr (Or.inl rfl)
        · simp at h

def lookT (t : BT) (k : Key) : Option Nat := t.find (keyCode k) k

/-! ### the kernel checker -/

def succOKK (c : Ctx) (KB g : Nat) (look : Key → Option Nat) (k' : Key) : Bool :=
  (match look k' with
   | some g' => decide (g' ≤ g + 1)
   | none => false) ||
  dead c k' || decide (KB < g + 1 + hK c k')

/-- Per-state part of the check. -/
def stateOK (c : Ctx) (cs : List Cond) (KB : Nat) (look : Key → Option Nat) (e : Key × Nat) : Bool :=
  !isGoal c e.1 && (succsK c cs e.1).all (succOKK c KB e.2 look)

theorem succOKK_eq (c : Ctx) (KB g : Nat) (look : Key → Option Nat) :
    succOKK c KB g look = succOK c KB g look := by
  funext k'; simp only [succOKK, succOK, hK_eq]; cases look k' <;> rfl

theorem stateOK_eq (c : Ctx) (cs : List Cond) (KB : Nat) (look : Key → Option Nat) (e : Key × Nat) :
    stateOK c cs KB look e = (!isGoal c e.1 && (succs c cs e.1).all (succOK c KB e.2 look)) := by
  simp only [stateOK, succsK_eq, succOKK_eq]

/-- Kernel-only lower bound from a tree certificate, given the root test and the per-state test. -/
theorem lower_bound_tree (n KB : Nat) (cs : List Cond) (hc : CtxOK (mkCtx n))
    (hsw : ∀ x ∈ cs, x.swap ∈ cs) (t : BT)
    (hroot : lookT t (rootK (mkCtx n)) = some 0)
    (hall : t.toList.all (stateOK (mkCtx n) cs KB (lookT t)) = true) :
    ∀ (p : Program) (o : Snap), p.length ≤ KB → (∀ i ∈ p, condIn cs i) → ¬ RelaxedSnap n p o := by
  intro p o hp hcs hrs
  have hchk : check (mkCtx n) cs KB t.toList (lookT t) = true := by
    simp only [check, Bool.and_eq_true, beq_iff_eq, List.all_eq_true]
    refine ⟨by rw [← rootK_eq]; exact hroot, fun e he => ?_⟩
    have := List.all_eq_true.mp hall e he
    rw [stateOK_eq] at this
    simpa [Bool.and_eq_true, List.all_eq_true] using this
  -- same argument as lean-reflect's `lower_bound`, with S = t.toList, look = lookT t
  apply check_sound (mkCtx n) hc cs hsw KB t.toList (lookT t)
    (fun k g h => BT.find_sound t _ k g h) hchk p hp hcs o
  intro w hw j hj
  have hx : ∀ i < n, xOf w i < (n : Int) := hc.lt w hw
  have hsort := hrs (xOf w) n hx
  simp only [SortsOK] at hsort
  have hs : ((List.range n).map (xOf w)).mergeSort (fun a b => decide (a ≤ b))
      = (List.range n).map (fun (j : Nat) => ((j : Nat) : Int)) := sorted_of_perm n _ (hc.perm w hw)
  rw [hs] at hsort
  have := (List.map_inj_left.1 hsort) j (List.mem_range.2 hj)
  simp only [snapOut] at this
  exact this

end KProto

/-! ### Compact certificate: keys stored as Nat codes (cheap to elaborate) -/
namespace KProto
open LeanReflect SortProof

/-- Digits (base 32) of a key: ncols, all column entries, flag indices, done bits. -/
def keyDigits (k : Key) : List Nat :=
  [k.cols.length] ++ k.cols.flatMap (fun col => col.map Int.toNat) ++ k.flag.map (·.ctorIdx) ++
    k.done.map (fun b => if b then 1 else 0)

def code32 (l : List Nat) : Nat := l.foldl (fun acc d => acc * 32 + d) 1

def keyCode2 (k : Key) : Nat := code32 (keyDigits k)

def digsAux : Nat → Nat → List Nat → List Nat
  | 0, _, acc => acc
  | f + 1, c, acc => if c < 32 then acc else digsAux f (c / 32) (c % 32 :: acc)

def ordOf : Nat → Ordering
  | 0 => .lt | 1 => .eq | _ => .gt

def takeCols (m : Nat) : Nat → List Nat → List Col × List Nat
  | 0, l => ([], l)
  | j + 1, l =>
    let (rest, l') := takeCols m j (l.drop m)
    ((l.take m).map Int.ofNat :: rest, l')

/-- Decoder for `m` tests and `n` outputs. -/
def decodeKey (m n code : Nat) : Key :=
  match digsAux code code [] with
  | [] => { cols := [], flag := [], done := [] }
  | nc :: rest =>
    let (cols, rest) := takeCols m nc rest
    { cols := cols, flag := (rest.take m).map ordOf, done := ((rest.drop m).take n).map (· == 1) }

inductive BT2 where
  | leaf
  | node (l : BT2) (code g : Nat) (r : BT2)

def BT2.find (m n : Nat) : BT2 → Nat → Key → Option Nat
  | .leaf, _, _ => none
  | .node l code g r, c, k =>
    if c < code then l.find m n c k else if code < c then r.find m n c k
    else if decodeKey m n code = k then some g else none

def BT2.toList (m n : Nat) : BT2 → List (Key × Nat)
  | .leaf => []
  | .node l code g r => l.toList m n ++ (decodeKey m n code, g) :: r.toList m n

theorem BT2.find_sound (m n : Nat) : ∀ (t : BT2) (c : Nat) (k : Key) (g : Nat),
    t.find m n c k = some g → (k, g) ∈ t.toList m n
  | .leaf, _, _, _, h => by simp [BT2.find] at h
  | .node l code g0 r, c, k, g, h => by
    simp only [BT2.find] at h
    simp only [BT2.toList, List.mem_append, List.mem_cons]
    split at h
    · exact Or.inl (BT2.find_sound m n l c k g h)
    · split at h
      · exact Or.inr (Or.inr (BT2.find_sound m n r c k g h))
      · split at h
        · rename_i hk; simp at h; subst h; rw [hk]; exact Or.inr (Or.inl rfl)
        · simp at h

def lookT2 (m n : Nat) (t : BT2) (k : Key) : Option Nat := t.find m n (keyCode2 k) k

theorem lower_bound_tree2 (n KB : Nat) (cs : List Cond) (hc : CtxOK (mkCtx n))
    (hsw : ∀ x ∈ cs, x.swap ∈ cs) (t : BT2)
    (hroot : lookT2 (mkCtx n).m n t (rootK (mkCtx n)) = some 0)
    (hall : (t.toList (mkCtx n).m n).all (stateOK (mkCtx n) cs KB (lookT2 (mkCtx n).m n t)) = true) :
    ∀ (p : Program) (o : Snap), p.length ≤ KB → (∀ i ∈ p, condIn cs i) → ¬ RelaxedSnap n p o := by
  intro p o hp hcs hrs
  have hchk : check (mkCtx n) cs KB (t.toList (mkCtx n).m n) (lookT2 (mkCtx n).m n t) = true := by
    simp only [check, Bool.and_eq_true, beq_iff_eq, List.all_eq_true]
    refine ⟨by rw [← rootK_eq]; exact hroot, fun e he => ?_⟩
    have := List.all_eq_true.mp hall e he
    rw [stateOK_eq] at this
    simpa [Bool.and_eq_true, List.all_eq_true] using this
  apply check_sound (mkCtx n) hc cs hsw KB (t.toList (mkCtx n).m n) (lookT2 (mkCtx n).m n t)
    (fun k g h => BT2.find_sound _ n t _ k g h) hchk p hp hcs o
  intro w hw j hj
  have hx : ∀ i < n, xOf w i < (n : Int) := hc.lt w hw
  have hsort := hrs (xOf w) n hx
  simp only [SortsOK] at hsort
  have hs : ((List.range n).map (xOf w)).mergeSort (fun a b => decide (a ≤ b))
      = (List.range n).map (fun (j : Nat) => ((j : Nat) : Int)) := sorted_of_perm n _ (hc.perm w hw)
  rw [hs] at hsort
  have := (List.map_inj_left.1 hsort) j (List.mem_range.2 hj)
  simp only [snapOut] at this
  exact this

end KProto
