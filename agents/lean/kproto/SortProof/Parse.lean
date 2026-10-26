import SortProof.Checker
/-
  Parser for the program file format of MODEL.md §5 (pure function, core `Init` only).
  `P<i>` ↦ register `i` (requires `i < n`), `S<j>` ↦ register `n + j`.
  `out j, R` (model=out) ↦ `mov (outBase + j), R`; output `j` is then read from `outBase + j`.
  The parser is NOT verified; its output can be inspected with `#eval` (see Programs.lean),
  and the theorems state the checked `Program` by its parsed value.
-/
namespace SortProof

def outBase : Nat := 1000000

structure ParsedProg where
  n : Nat
  model : String
  prog : Program
  /-- output register of `j` (default `j`) -/
  outs : List (Nat × Nat)
  /-- counted instructions (all except `out`) -/
  k : Nat
deriving Repr

def ParsedProg.outReg (pp : ParsedProg) (j : Nat) : Nat :=
  match pp.outs.find? (fun e => e.1 == j) with
  | some e => e.2
  | none => j

def digitsToNat? (cs : List Char) : Option Nat :=
  if cs.isEmpty || !cs.all Char.isDigit then none
  else some (cs.foldl (fun acc c => 10 * acc + (c.toNat - '0'.toNat)) 0)

/-- Split on spaces, tabs and commas. -/
def tokens (cs : List Char) : List (List Char) :=
  let step := fun (acc : List (List Char) × List Char) (c : Char) =>
    if c == ' ' || c == '\t' || c == ',' || c == '\r' then
      (if acc.2.isEmpty then acc.1 else acc.2.reverse :: acc.1, [])
    else (acc.1, c :: acc.2)
  let r := cs.foldl step ([], [])
  (if r.2.isEmpty then r.1 else r.2.reverse :: r.1).reverse

def parseReg (n : Nat) : List Char → Except String Nat
  | 'P' :: ds => match digitsToNat? ds with
    | some i => if i < n then .ok i else .error s!"P{i} out of range (n = {n})"
    | none => .error "bad P register"
  | 'S' :: ds => match digitsToNat? ds with
    | some j => if n + j < outBase then .ok (n + j) else .error "S register too large"
    | none => .error "bad S register"
  | cs => .error s!"bad register {String.ofList cs}"

/-- One instruction line (comment already removed). `none` = `out` line. -/
def parseInstr (n : Nat) (op : String) (a b : List Char) :
    Except String (Instr ⊕ (Nat × Nat)) := do
  if op == "out" then
    match digitsToNat? a with
    | some j =>
      if j < n then
        let r ← parseReg n b
        return .inr (j, r)
      else throw s!"out {j}: index out of range"
    | none => throw "bad out index"
  let d ← parseReg n a
  let s ← parseReg n b
  match op with
  | "mov" => return .inl (.mov d s)
  | "cmp" => return .inl (.cmp d s)
  | "cmovl" => return .inl (.cmov .l d s)
  | "cmovg" => return .inl (.cmov .g d s)
  | "cmovle" => return .inl (.cmov .le d s)
  | "cmovge" => return .inl (.cmov .ge d s)
  | _ => throw s!"unknown opcode {op}"

def headerVal (key : String) (line : List Char) : Option (List Char) :=
  let k := key.toList ++ ['=']
  (tokens line).findSome? fun t => if t.take k.length == k then some (t.drop k.length) else none

def parseProgram (src : String) : Except String ParsedProg := do
  let lines := (src.splitOn "\n").map String.toList
  -- header: first comment line with `n=`
  let some hdr := lines.find? (fun l => l.head? == some '#' && (headerVal "n" (l.drop 1)).isSome)
    | throw "no header with n="
  let some n := (headerVal "n" (hdr.drop 1)).bind digitsToNat?
    | throw "bad n="
  let model := ((headerVal "model" (hdr.drop 1)).map String.ofList).getD "reg"
  let mut prog : Program := []
  let mut outs : List (Nat × Nat) := []
  let mut k := 0
  for l in lines do
    let body := tokens (l.takeWhile (· != '#'))
    match body with
    | [] => pure ()
    | [op, a, b] =>
      match ← parseInstr n (String.ofList op) a b with
      | .inl i => prog := prog ++ [i]; k := k + 1
      | .inr (j, r) =>
        prog := prog ++ [.mov (outBase + j) r]
        outs := (j, outBase + j) :: outs.filter (fun e => e.1 != j)
    | _ => throw s!"bad line: {String.ofList l}"
  return { n, model, prog, outs, k }

def parseOrEmpty (src : String) : ParsedProg :=
  match parseProgram src with
  | .ok pp => pp
  | .error _ => { n := 0, model := "error", prog := [], outs := [], k := 0 }

/-- MODEL.md §4.2 operand rules of M_AD: P (memory) never in cmp/cmov, no `mov P, P`. -/
def Instr.isMAD (n : Nat) : Instr → Bool
  | .mov d s => !(d < n && s < n)
  | .cmp a b => !(a < n) && !(b < n)
  | .cmov _ d s => !(d < n) && !(s < n)

def Program.isMAD (n : Nat) (p : Program) : Bool := p.all (Instr.isMAD n)

def Program.inI0 (p : Program) : Bool := p.all (Instr.inSet Cond.inI0)

end SortProof
