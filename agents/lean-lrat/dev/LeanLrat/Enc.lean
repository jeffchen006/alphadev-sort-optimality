import Std.Sat.CNF
import SortProof.Machine
/-
  CNF encoder, v2 (content encoding, no symmetry breaking).
  Question: is there a program of length `k` over registers `0..R-1` (R = n + k), instruction set
  I0 (`i1 = false`) or I1 (`i1 = true`), with snapshot outputs (MODEL.md §4.3 M_out), that sorts
  every input in the list `types` in the relaxed model (scratch = T, flags = eq)?
  An input type is a list of `n` naturals (ranks); entry `i` is taken `% n`, so every input is `< T`.
  Any list of types gives a sound encoding: a correct program sorts every type (see `Sound.lean`).

  Register CONTENT c ∈ {0..n}: c < n = "holds input x_c", c = n = T. Content compare for type w
  uses the rank `rkC w c` (rank of x_c, and n for T).

  Variables (structured type `V`, relabelled to `Nat` by `layout`):
    op t o     : step t has opcode o (0 mov, 1 cmp, 2 cmovl, 3 cmovg, 4 cmovle, 5 cmovge)
    dst t r    : first operand of step t is register r
    src t r    : second operand of step t is register r
    val w t r c: for type w, before step t, register r has content c
    lt w t, gt w t : flag state before step t
    dv w t c, sv w t c : content of the first / second operand at step t
    wr w t     : step t writes its first operand (mov, or cmov with true condition)
    nv w t c   : content of the first operand AFTER step t
    os j m     : output j = initial content of P_m (m < n), or = `nv` of step m - n (m ≥ n)
    tc t r     : register r is an operand of some step < t (only with `canon`)
    sc t, pd t : some cmp before step t / an unread cmp is pending before step t (only with `norm`)
    ag t w w'  : types w, w' have the same content run up to time t (only with `hc`, forced true only)
    cnt t w i c: at least c of ag t w 0 .. ag t w (i-1) are true (forced true only)
    gc t c     : at least c cmp steps at positions ≥ t (forced false only)
  With `canon = true`, the first-touch rule of `Canon.lean` is added (symmetry breaking).
-/
namespace LeanLrat
open Std.Sat SortProof

inductive V where
  | op (t o : Nat)
  | dst (t r : Nat)
  | src (t r : Nat)
  | val (w t r c : Nat)
  | lt (w t : Nat)
  | gt (w t : Nat)
  | dv (w t c : Nat)
  | sv (w t c : Nat)
  | wr (w t : Nat)
  | nv (w t c : Nat)
  | os (j m : Nat)
  | tc (t r : Nat)
  | sc (t : Nat)
  | pd (t : Nat)
  | ag (t w w' : Nat)
  | cnt (t w i c : Nat)
  | gc (t c : Nat)
deriving DecidableEq, Repr, Inhabited

abbrev Cl := CNF.Clause V

@[inline] def pos (x : V) : Literal V := (x, true)
@[inline] def neg (x : V) : Literal V := (x, false)

/-- Rank of input `i` in the type row `row` (a number `< n`). -/
def xOf (n : Nat) (row : List Nat) (i : Nat) : Nat := (row.getD i 0) % n

/-- Rank of content `c` for type `w`: rank of `x_c` for `c < n`, and `n` (= T) else. -/
def rkC (n : Nat) (row : List Nat) (c : Nat) : Nat :=
  if c < n then xOf n row c else n

/-- Initial content of register `r`: `r` for `r < n` (input `x_r`), else `n` (T). -/
def initC (n r : Nat) : Nat := if r < n then r else n

/-- The sorted input list of type `w` (core `List.mergeSort`, as in `SortsOK`). -/
def sortedInt (n : Nat) (row : List Nat) : List Int :=
  ((List.range n).map (fun i => (xOf n row i : Int))).mergeSort (fun a b => decide (a ≤ b))

/-- Contents that are a correct output `j` for type `w`. -/
def good (n : Nat) (row : List Nat) (j : Nat) : List Nat :=
  (List.range n).filter fun c => decide ((xOf n row c : Int) = (sortedInt n row).getD j 0)

/-- At most one of `f 0, ..., f (m-1)` (pairwise). -/
def amo (m : Nat) (f : Nat → V) : List Cl :=
  (List.range m).flatMap fun i =>
    (List.range m).flatMap fun j => if i < j then [[neg (f i), neg (f j)]] else []

def alo (m : Nat) (f : Nat → V) : Cl := (List.range m).map fun i => pos (f i)

/-- Number of opcodes: 4 for I0, 6 for I1. -/
def nOps (i1 : Bool) : Nat := if i1 then 6 else 4

/-- Program clauses: each field is one-hot; opcodes `≥ nOps i1` are off. -/
def progCls (n k R : Nat) (i1 : Bool) : List Cl :=
  ((List.range k).flatMap fun t =>
    (alo (nOps i1) (V.op t) :: amo 6 (V.op t)) ++
    ((List.range 6).filter (fun o => nOps i1 ≤ o)).map (fun o => [neg (.op t o)]) ++
    (alo R (V.dst t) :: amo R (V.dst t)) ++
    (alo R (V.src t) :: amo R (V.src t))) ++
  ((List.range n).flatMap fun j => alo (n + k) (V.os j) :: amo (n + k) (V.os j))

/-- Per (type w, step t, register r, content c): operand contents and register update. -/
def regCls (w t r c : Nat) : List Cl :=
  [ [neg (.dst t r), neg (.val w t r c), pos (.dv w t c)],
    [neg (.dst t r), pos (.val w t r c), neg (.dv w t c)],
    [neg (.src t r), neg (.val w t r c), pos (.sv w t c)],
    [neg (.src t r), pos (.val w t r c), neg (.sv w t c)],
    [neg (.dst t r), neg (.nv w t c), pos (.val w (t+1) r c)],
    [neg (.dst t r), pos (.nv w t c), neg (.val w (t+1) r c)],
    [pos (.dst t r), neg (.val w t r c), pos (.val w (t+1) r c)],
    [pos (.dst t r), pos (.val w t r c), neg (.val w (t+1) r c)] ]

/-- Per (type w, step t, content c): new content of the first operand. -/
def nvCls (w t c : Nat) : List Cl :=
  [ [neg (.wr w t), neg (.sv w t c), pos (.nv w t c)],
    [neg (.wr w t), pos (.sv w t c), neg (.nv w t c)],
    [pos (.wr w t), neg (.dv w t c), pos (.nv w t c)],
    [pos (.wr w t), pos (.dv w t c), neg (.nv w t c)] ]

/-- Per (type w, step t): write flag and flag update. -/
def stepCls (n : Nat) (row : List Nat) (w t : Nat) : List Cl :=
  [ [neg (.op t 0), pos (.wr w t)],
    [neg (.op t 1), neg (.wr w t)],
    [neg (.op t 2), neg (.lt w t), pos (.wr w t)],
    [neg (.op t 2), pos (.lt w t), neg (.wr w t)],
    [neg (.op t 3), neg (.gt w t), pos (.wr w t)],
    [neg (.op t 3), pos (.gt w t), neg (.wr w t)],
    [neg (.op t 4), pos (.gt w t), pos (.wr w t)],
    [neg (.op t 4), neg (.gt w t), neg (.wr w t)],
    [neg (.op t 5), pos (.lt w t), pos (.wr w t)],
    [neg (.op t 5), neg (.lt w t), neg (.wr w t)],
    [pos (.op t 1), neg (.lt w t), pos (.lt w (t+1))],
    [pos (.op t 1), pos (.lt w t), neg (.lt w (t+1))],
    [pos (.op t 1), neg (.gt w t), pos (.gt w (t+1))],
    [pos (.op t 1), pos (.gt w t), neg (.gt w (t+1))] ] ++
  (List.range (n+1)).flatMap fun c => (List.range (n+1)).flatMap fun d =>
    [ [neg (.op t 1), neg (.dv w t c), neg (.sv w t d),
        (.lt w (t+1), decide (rkC n row c < rkC n row d))],
      [neg (.op t 1), neg (.dv w t c), neg (.sv w t d),
        (.gt w (t+1), decide (rkC n row d < rkC n row c))] ]

/-- Output clauses of type `w`. -/
def outCls (n k : Nat) (row : List Nat) (w : Nat) : List Cl :=
  (List.range n).flatMap fun j =>
    ((List.range n).filter (fun m => !(good n row j).contains m)).map (fun m => [neg (.os j m)]) ++
    (List.range k).map fun i => neg (.os j (n + i)) :: (good n row j).map (fun c => pos (.nv w i c))

def simCls (n k R : Nat) (row : List Nat) (w : Nat) : List Cl :=
  -- initial state
  ((List.range R).flatMap fun r => (List.range (n+1)).map fun c =>
      [(.val w 0 r c, initC n r == c)]) ++
  [[neg (.lt w 0)], [neg (.gt w 0)]] ++
  -- steps
  ((List.range k).flatMap fun t =>
    stepCls n row w t ++
    ((List.range (n+1)).flatMap fun c => nvCls w t c) ++
    (List.range R).flatMap fun r => (List.range (n+1)).flatMap fun c => regCls w t r c) ++
  -- outputs
  outCls n k row w

/-- First-touch rule (symmetry breaking, `Canon.lean`): register `r` (not the first of its class
  `[0, n)` / `[n, R)`) is an operand only if `r - 1` was touched before (or is the first operand). -/
def canonCls (n k R : Nat) : List Cl :=
  ((List.range R).map fun r => [neg (.tc 0 r)]) ++
  ((List.range k).flatMap fun t => (List.range R).flatMap fun r =>
    [ [neg (.tc (t+1) r), pos (.tc t r), pos (.dst t r), pos (.src t r)],
      [neg (.tc t r), pos (.tc (t+1) r)],
      [neg (.dst t r), pos (.tc (t+1) r)],
      [neg (.src t r), pos (.tc (t+1) r)] ] ++
    (if r = 0 ∨ r = n then [] else
      [ [neg (.dst t r), pos (.tc t (r-1))],
        [neg (.src t r), pos (.tc t (r-1)), pos (.dst t (r-1))] ]))

/-- Normal form rules (`Normal.lean`): nops (`mov 0, 0`) only at the end, no self move except the
  nop, no cmovl/cmovg before the first cmp, every cmp read by a cmov before the next cmp / the end. -/
def normCls (k R : Nat) : List Cl :=
  [[neg (.sc 0)], [neg (.pd 0)], [neg (.pd k)]] ++
  ((List.range k).flatMap fun t =>
    -- nop suffix
    (if t + 1 < k then
      [ [neg (.op t 0), neg (.dst t 0), neg (.src t 0), pos (.op (t+1) 0)],
        [neg (.op t 0), neg (.dst t 0), neg (.src t 0), pos (.dst (t+1) 0)],
        [neg (.op t 0), neg (.dst t 0), neg (.src t 0), pos (.src (t+1) 0)] ] else []) ++
    -- no self moves
    ((List.range R).flatMap fun r => ([0, 2, 3, 4, 5].filter fun o => !(o == 0 && r == 0)).map fun o =>
      [neg (.op t o), neg (.dst t r), neg (.src t r)]) ++
    -- some cmp before
    [ [neg (.sc (t+1)), pos (.sc t), pos (.op t 1)], [neg (.sc t), pos (.sc (t+1))],
      [neg (.op t 1), pos (.sc (t+1))], [neg (.op t 2), pos (.sc t)], [neg (.op t 3), pos (.sc t)] ] ++
    -- pending unread cmp
    [ [neg (.op t 1), pos (.pd (t+1))],
      [neg (.pd t), pos (.op t 2), pos (.op t 3), pos (.op t 4), pos (.op t 5), pos (.pd (t+1))],
      [neg (.pd (t+1)), pos (.op t 1), pos (.pd t)],
      [neg (.pd (t+1)), pos (.op t 1), neg (.op t 2)], [neg (.pd (t+1)), pos (.op t 1), neg (.op t 3)],
      [neg (.pd (t+1)), pos (.op t 1), neg (.op t 4)], [neg (.pd (t+1)), pos (.op t 1), neg (.op t 5)],
      [neg (.pd t), neg (.op t 1)] ])

/-- Rule snapcmov (`SnapCmov.lean`): every output is the value written by a cmov step. -/
def snapCls (n k : Nat) : List Cl :=
  (List.range n).flatMap fun j =>
    ((List.range n).map fun m => [neg (.os j m)]) ++
    (List.range k).map fun i => [neg (.os j (n + i)), pos (.op i 2), pos (.op i 3), pos (.op i 4), pos (.op i 5)]

/-- Largest class threshold `2^m + 1 ≤ W` that the cut uses. -/
def cmax (W : Nat) : Nat := (List.range W).foldl (fun a m => if 2 ^ m + 1 ≤ W then 2 ^ m + 1 else a) 0

/-- Cut hcmp part 2 (`Hcmp.lean`): a class of `≥ 2^m + 1` types that agree up to step `t` needs
  `≥ m + 1` cmp steps at positions `≥ t`. Only for types that are distinct permutations. -/
def hcmpCls (k W : Nat) : List Cl :=
  let C := cmax W
  -- agreement, forced true
  ((List.range W).flatMap fun w => (List.range W).map fun w' => [pos (.ag 0 w w')]) ++
  ((List.range k).flatMap fun t => (List.range W).flatMap fun w => (List.range W).flatMap fun w' =>
    [true, false].flatMap fun a => [true, false].map fun b =>
      [neg (.ag t w w'), (.lt w (t+1), !a), (.lt w' (t+1), !a), (.gt w (t+1), !b), (.gt w' (t+1), !b),
       pos (.ag (t+1) w w')]) ++
  -- class counters, forced true
  ((List.range (k+1)).flatMap fun t => (List.range W).flatMap fun w =>
    [pos (.cnt t w 0 0)] :: ((List.range W).flatMap fun i => (List.range (C+1)).flatMap fun c =>
      [neg (.cnt t w i c), pos (.cnt t w (i+1) c)] ::
      (if c < C then [[neg (.cnt t w i c), neg (.ag t w i), pos (.cnt t w (i+1) (c+1))]] else []))) ++
  -- cmp suffix counters, forced false
  ((List.range (k+1)).map fun t => [pos (.gc t 0)]) ++
  ((List.range C).map fun c => [neg (.gc k (c+1))]) ++
  ((List.range k).flatMap fun t => (List.range C).flatMap fun c =>
    [ [neg (.gc t (c+1)), pos (.op t 1), pos (.gc (t+1) (c+1))],
      [neg (.gc t (c+1)), pos (.gc (t+1) c), pos (.gc (t+1) (c+1))] ]) ++
  -- the cut
  ((List.range (k+1)).flatMap fun t => (List.range W).flatMap fun w =>
    ((List.range W).filter fun m => 2 ^ m + 1 ≤ C).map fun m =>
      [neg (.cnt t w W (2 ^ m + 1)), pos (.gc t (m+1))])

/-- The structured CNF. -/
def encList (n k : Nat) (i1 canon : Bool) (types : List (List Nat)) (norm : Bool := false)
    (hc : Bool := false) : List Cl :=
  progCls n k (n + k) i1 ++ (if canon then canonCls n k (n + k) else []) ++
    (if norm then normCls k (n + k) ++ snapCls n k else []) ++
    (if hc then hcmpCls k types.length else []) ++
    (List.range types.length).flatMap (fun w => simCls n k (n + k) (types.getD w []) w)

def encV (n k : Nat) (i1 canon : Bool) (types : List (List Nat)) (norm : Bool := false)
    (hc : Bool := false) : CNF V :=
  ⟨(encList n k i1 canon types norm hc).toArray⟩

/-! Dense numbering of the variables. Correctness of `decode ∘ layout` is checked by computation. -/

structure Dims where
  n : Nat
  k : Nat
  R : Nat
  W : Nat

def Dims.sizes (d : Dims) : List Nat :=
  [6 * d.k, d.k * d.R, d.k * d.R, d.W * (d.k+1) * d.R * (d.n+1), d.W * (d.k+1), d.W * (d.k+1),
   d.W * d.k * (d.n+1), d.W * d.k * (d.n+1), d.W * d.k, d.W * d.k * (d.n+1), d.n * (d.n + d.k),
   (d.k+1) * d.R, 2 * (d.k+1), (d.k+1) * d.W * d.W, (d.k+1) * d.W * (d.W+1) * (d.W+2), (d.k+1) * (d.W+2)]

/-- Start offsets of the segments. -/
def Dims.bases (d : Dims) : Array Nat := ((List.range 17).map fun i => ((d.sizes).take i).sum).toArray

def layout (d : Dims) (b : Array Nat) : V → Nat
  | .op t o => b[0]! + t * 6 + o
  | .dst t r => b[1]! + t * d.R + r
  | .src t r => b[2]! + t * d.R + r
  | .val w t r c => b[3]! + ((w * (d.k+1) + t) * d.R + r) * (d.n+1) + c
  | .lt w t => b[4]! + w * (d.k+1) + t
  | .gt w t => b[5]! + w * (d.k+1) + t
  | .dv w t c => b[6]! + (w * d.k + t) * (d.n+1) + c
  | .sv w t c => b[7]! + (w * d.k + t) * (d.n+1) + c
  | .wr w t => b[8]! + w * d.k + t
  | .nv w t c => b[9]! + (w * d.k + t) * (d.n+1) + c
  | .os j m => b[10]! + j * (d.n + d.k) + m
  | .tc t r => b[11]! + t * d.R + r
  | .sc t => b[12]! + t
  | .pd t => b[12]! + (d.k+1) + t
  | .ag t w w' => b[13]! + (t * d.W + w) * d.W + w'
  | .cnt t w i c => b[14]! + ((t * d.W + w) * (d.W+1) + i) * (d.W+2) + c
  | .gc t c => b[15]! + t * (d.W+2) + c

def decode (d : Dims) (b : Array Nat) (m : Nat) : V :=
  let wtc (x : Nat) : Nat × Nat × Nat := let y := x / (d.n+1); (y / d.k, y % d.k, x % (d.n+1))
  if m < b[1]! then let x := m - b[0]!; .op (x / 6) (x % 6)
  else if m < b[2]! then let x := m - b[1]!; .dst (x / d.R) (x % d.R)
  else if m < b[3]! then let x := m - b[2]!; .src (x / d.R) (x % d.R)
  else if m < b[4]! then
    let x := m - b[3]!
    let c := x % (d.n+1); let y := x / (d.n+1)
    let r := y % d.R; let z := y / d.R
    .val (z / (d.k+1)) (z % (d.k+1)) r c
  else if m < b[5]! then let x := m - b[4]!; .lt (x / (d.k+1)) (x % (d.k+1))
  else if m < b[6]! then let x := m - b[5]!; .gt (x / (d.k+1)) (x % (d.k+1))
  else if m < b[7]! then let (w, t, c) := wtc (m - b[6]!); .dv w t c
  else if m < b[8]! then let (w, t, c) := wtc (m - b[7]!); .sv w t c
  else if m < b[9]! then let x := m - b[8]!; .wr (x / d.k) (x % d.k)
  else if m < b[10]! then let (w, t, c) := wtc (m - b[9]!); .nv w t c
  else if m < b[11]! then let x := m - b[10]!; .os (x / (d.n + d.k)) (x % (d.n + d.k))
  else if m < b[12]! then let x := m - b[11]!; .tc (x / d.R) (x % d.R)
  else if m < b[13]! then let x := m - b[12]!; if x < d.k + 1 then .sc x else .pd (x - (d.k+1))
  else if m < b[14]! then let x := m - b[13]!; .ag (x / d.W / d.W) (x / d.W % d.W) (x % d.W)
  else if m < b[15]! then
    let x := m - b[14]!; let c := x % (d.W+2); let y := x / (d.W+2)
    .cnt (y / (d.W+1) / d.W) (y / (d.W+1) % d.W) (y % (d.W+1)) c
  else let x := m - b[15]!; .gc (x / (d.W+2)) (x % (d.W+2))

def dimsOf (n k : Nat) (types : List (List Nat)) : Dims := ⟨n, k, n + k, types.length⟩

/-- The CNF over `Nat` that is given to the SAT solver (`CNF.dimacs` adds 1 to every variable). -/
def enc (n k : Nat) (i1 canon : Bool) (types : List (List Nat)) (norm : Bool := false)
    (hc : Bool := false) : CNF Nat :=
  let d := dimsOf n k types
  (encV n k i1 canon types norm hc).relabel (layout d d.bases)

/-- Computational check: `decode` inverts `layout` on every variable of the CNF. -/
def layoutOK (n k : Nat) (i1 canon : Bool) (types : List (List Nat)) (norm : Bool := false)
    (hc : Bool := false) : Bool :=
  let d := dimsOf n k types
  let b := d.bases
  (encList n k i1 canon types norm hc).all fun c => c.all fun l => decode d b (layout d b l.1) == l.1

/-! Order types. -/

/-- All functions `Fin len → Fin n` as lists. -/
def allFuns : Nat → Nat → List (List Nat)
  | 0, _ => [[]]
  | len+1, n => (allFuns len n).flatMap fun l => (List.range n).map fun v => v :: l

def isWeakOrderType (n : Nat) (l : List Nat) : Bool :=
  (List.range n).all fun v => decide (v ∈ l) || (List.range n).all fun u => decide (v ≤ u → u ∉ l)

/-- All weak order types of `n` elements, as rank vectors with image `{0, ..., m-1}`. -/
def weakOrderTypes (n : Nat) : List (List Nat) := (allFuns n n).filter (isWeakOrderType n)

end LeanLrat
