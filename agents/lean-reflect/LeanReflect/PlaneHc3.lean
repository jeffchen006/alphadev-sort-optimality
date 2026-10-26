import LeanReflect.FastP
/-
  `hcP3`: the H1 class bound `hcP2` with row codes in arrays and counting loops (no lists of pairs).
  `hcP3_eq : hcP3 f k = hcP2 f k` for every `f` and `k`.
-/
namespace LeanReflect.FP
open SortProof LeanReflect

@[specialize] def cntUp (p : Nat → Bool) : Nat → Nat
  | 0 => 0
  | j + 1 => cntUp p j + (if p j then 1 else 0)

/-- `p lo || p (lo+1) || … || p (lo+d-1)`. -/
@[specialize] def anyFrom (p : Nat → Bool) (lo : Nat) : Nat → Bool
  | 0 => false
  | d + 1 => p lo || anyFrom p (lo + 1) d

@[specialize] def maxUp (g : Nat → Nat) : Nat → Nat
  | 0 => 0
  | j + 1 => max (maxUp g j) (g j)

section
variable (f : FC)

def hcP3 (k : PKey) : Nat :=
  let m := f.c.m
  let u := undoneP f k
  let S : Array Nat := (Array.range m).map (sigCode f k)
  let U : Array Nat := (Array.range m).map (usCode f u)
  let L : Array Bool := (Array.range m).map fun j =>
    !anyFrom (fun j' => S.getD j' 0 == S.getD j 0 && U.getD j' 0 == U.getD j 0) (j + 1) (m - (j + 1))
  clog2 (maxUp (fun i => cntUp (fun j => L.getD j false && S.getD j 0 == S.getD i 0) m) m)

def hPrune3 (KB G : Nat) (k : PKey) : Bool :=
  let u := (undoneP f k).length
  let hc := hcP3 f k
  decide (KB < G + hc + u) ||
    decide (KB < G + hc + max u (u + maxCoverBP f k (KB + 3 - G - hc - u) - 2))
end

/-! ## Proof -/

theorem cntUp_congr {p q : Nat → Bool} : ∀ n, (∀ j < n, p j = q j) → cntUp p n = cntUp q n
  | 0, _ => rfl
  | n + 1, h => by
    simp only [cntUp]; rw [cntUp_congr n (fun j hj => h j (by omega)), h n (by omega)]

theorem maxUp_congr {g g' : Nat → Nat} : ∀ n, (∀ j < n, g j = g' j) → maxUp g n = maxUp g' n
  | 0, _ => rfl
  | n + 1, h => by
    simp only [maxUp]; rw [maxUp_congr n (fun j hj => h j (by omega)), h n (by omega)]

theorem anyFrom_congr {p q : Nat → Bool} : ∀ d lo, (∀ j, lo ≤ j → j < lo + d → p j = q j) →
    anyFrom p lo d = anyFrom q lo d
  | 0, _, _ => rfl
  | d + 1, lo, h => by
    simp only [anyFrom]; rw [h lo (by omega) (by omega), anyFrom_congr d (lo + 1) (fun j h1 h2 => h j (by omega) (by omega))]

theorem zip_self' {α : Type} : ∀ l : List α, l.zip l = l.map fun x => (x, x)
  | [] => rfl
  | a :: l => by simp [zip_self' l]

theorem anyFrom_eq (p : Nat → Bool) : ∀ d lo, anyFrom p lo d = (List.range' lo d).any p
  | 0, lo => rfl
  | d + 1, lo => by simp only [anyFrom, List.range'_succ, List.any_cons, anyFrom_eq p d (lo + 1)]

theorem getD_mapRange {α : Type} (m : Nat) (h : Nat → α) (d : α) {j : Nat} (hj : j < m) :
    ((Array.range m).map h).getD j d = h j := by
  simp [Array.getD, hj]

theorem foldl_cnt {α : Type} (P : α → Bool) (h : Nat → α) : ∀ m (a : Nat),
    ((List.range m).map h).foldl (fun a e => if P e then a + 1 else a) a = a + cntUp (fun j => P (h j)) m
  | 0, a => by simp [cntUp]
  | m + 1, a => by
    rw [List.range_succ, List.map_append, List.foldl_append, foldl_cnt P h m a]
    simp only [List.map_cons, List.map_nil, List.foldl_cons, List.foldl_nil, cntUp]
    split <;> omega

theorem foldl_max {α : Type} (F : α → Nat) (h : Nat → α) : ∀ m (a : Nat),
    ((List.range m).map h).foldl (fun a r => max a (F r)) a = max a (maxUp (fun j => F (h j)) m)
  | 0, a => by simp [maxUp]
  | m + 1, a => by
    rw [List.range_succ, List.map_append, List.foldl_append, foldl_max F h m a]
    simp only [List.map_cons, List.map_nil, List.foldl_cons, List.foldl_nil, maxUp]
    omega

theorem lastFlags_eq : ∀ L : List (Nat × Nat), lastFlags L =
    (List.range L.length).map fun i => !((L.drop (i + 1)).any fun r2 => r2.1 == (L.getD i (0, 0)).1 && r2.2 == (L.getD i (0, 0)).2)
  | [] => rfl
  | r :: L => by
    rw [lastFlags, lastFlags_eq L, List.length_cons, List.range_succ_eq_map, List.map_cons, List.map_map]
    rfl

theorem drop_map_range {α : Type} (h : Nat → α) (m i : Nat) :
    ((List.range m).map h).drop i = (List.range' i (m - i)).map h := by
  rw [← List.map_drop]; congr 1
  apply List.ext_getElem (by simp)
  intro j h1 h2
  simp [List.getElem_range']

theorem hcP3_eq (f : FC) (k : PKey) : hcP3 f k = hcP2 f k := by
  unfold hcP3 hcP2
  dsimp only
  congr 1
  generalize hu : undoneP f k = u
  let g : Nat → Nat × Nat := fun t => (sigCode f k t, usCode f u t)
  have hrows : ((List.range f.c.m).map fun t => (sigCode f k t, usCode f u t)) = (List.range f.c.m).map g := rfl
  rw [hrows]
  have hlen : ((List.range f.c.m).map g).length = f.c.m := by simp
  have hgetD : ∀ i < f.c.m, ((List.range f.c.m).map g).getD i (0, 0) = g i := by
    intro i hi; simp [List.getD_eq_getElem?_getD, hi, g]
  have hL : lastFlags ((List.range f.c.m).map g) = (List.range f.c.m).map fun j =>
      !anyFrom (fun j' => sigCode f k j' == sigCode f k j && usCode f u j' == usCode f u j) (j + 1) (f.c.m - (j + 1)) := by
    rw [lastFlags_eq, hlen]
    apply List.map_congr_left
    intro i hi
    have hi := List.mem_range.1 hi
    rw [hgetD i hi, drop_map_range, anyFrom_eq, List.any_map]
    rfl
  rw [hL, List.zip_map, foldl_max]
  simp only [Nat.zero_max]
  apply maxUp_congr
  intro i hi
  simp only [Function.comp_def, cntClass]
  have : ((List.range f.c.m).zip (List.range f.c.m)).map (Prod.map g fun j =>
      !anyFrom (fun j' => sigCode f k j' == sigCode f k j && usCode f u j' == usCode f u j) (j + 1) (f.c.m - (j + 1))) =
      (List.range f.c.m).map fun j => (g j, !anyFrom (fun j' => sigCode f k j' == sigCode f k j && usCode f u j' == usCode f u j)
        (j + 1) (f.c.m - (j + 1))) := by
    rw [zip_self', List.map_map]; rfl
  rw [this, foldl_cnt, Nat.zero_add]
  apply cntUp_congr
  intro j hj
  simp only [getD_mapRange _ _ _ hj, getD_mapRange _ _ _ hi, g]
  congr 2
  apply anyFrom_congr
  intro j' h1 h2
  simp only [getD_mapRange _ _ _ (show j' < f.c.m by omega)]

theorem hPrune3_eq (f : FC) (KB G : Nat) (k : PKey) : hPrune3 f KB G k = hPrune f KB G k := by
  unfold hPrune3 hPrune; rw [hcP3_eq]

end LeanReflect.FP
