/-
  Kernel-speed probe: packed sort3 successor generation (not yet linked to lean-reflect's model).
  Column = Nat, 2 bits per test (6 tests), value 0..2, T = 3. Flag = Nat, 2 bits per test (0 lt, 1 eq, 2 gt).
-/
namespace KPacked

def M : Nat := 6
def digit (c i : Nat) : Nat := (c >>> (2 * i)) % 4

def cmpCol (a b : Nat) : Nat :=
  (List.range M).foldl (fun acc i =>
    let x := digit a i; let y := digit b i
    acc + (if x < y then 0 else if x == y then 1 else 2) * 4 ^ i) 0

/-- 12-bit mask, 0b11 at tests where condition `c` (0 l, 1 g, 2 le, 3 ge) holds under flag `f`. -/
def condMask (c f : Nat) : Nat :=
  (List.range M).foldl (fun acc i =>
    let o := digit f i
    let ok := match c with
      | 0 => o == 0 | 1 => o == 2 | 2 => o != 2 | _ => o != 0
    if ok then acc + 3 * 4 ^ i else acc) 0

def TC : Nat := 4095
def merge (m d s : Nat) : Nat := (s &&& m) ||| (d &&& (4095 - m))

def ins (x : Nat) : List Nat → List Nat
  | [] => [x]
  | y :: ys => if x ≤ y then x :: y :: ys else y :: ins x ys

def eraseOne (x : Nat) : List Nat → List Nat
  | [] => []
  | y :: ys => if x == y then ys else y :: eraseOne x ys

def writeCol (cols : List Nat) (d : Option Nat) (v : Nat) : List Nat :=
  let base := match d with | some c => eraseOne c cols | none => cols
  if v == TC then base else ins v base

def dedup : List Nat → List Nat
  | [] => []
  | x :: xs => let r := dedup xs; if r.contains x then r else x :: r

/-- All successor column lists (writes) and flags (cmps) of a state. -/
def succs (cols : List Nat) (f : Nat) : List (List Nat × Nat) :=
  let u := dedup cols
  let srcs := u ++ [TC]
  let dsts := u.map some ++ [none]
  let masks := [0, 1, 2, 3].map (condMask · f)
  (srcs.flatMap fun a => srcs.map fun b => (cols, cmpCol a b)) ++
  (dsts.flatMap fun d => srcs.flatMap fun s =>
    (writeCol cols d s, f) :: masks.map fun m => (writeCol cols d (merge m (d.getD TC) s), f))

def root : List Nat := [0b101001000110, 0b011000100100, 0b000110011001]  -- placeholder columns

def score (l : List (List Nat × Nat)) : Nat := l.foldl (fun acc p => acc + p.1.length + p.1.headD 0 + p.2) 0

end KPacked
