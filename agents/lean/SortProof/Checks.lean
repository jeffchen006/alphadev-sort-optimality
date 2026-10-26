import SortProof.Programs
/-
  Sanity checks (kernel). Fubini numbers and negative tests of the checker.
-/
namespace SortProof
set_option maxRecDepth 100000

/-- One representative per weak order type: Fubini numbers 1, 3, 13, 75, 541. -/
theorem reps_card : (reps 1).length = 1 ∧ (reps 2).length = 3 ∧ (reps 3).length = 13 ∧
    (reps 4).length = 75 ∧ (reps 5).length = 541 := by decide +kernel

/-- Dropping the last store of AlphaDev sort3 breaks it. -/
theorem neg_dropLast : checkStrict 3 sort3.prog.dropLast = false := by decide +kernel

/-- Changing the first `cmovl` of sort3 to `cmovle` is caught (or still correct): we record the value. -/
theorem neg_swap_cond :
    checkStrict 3 (sort3.prog.set 4 (.cmov .g 5 4)) = false := by decide +kernel

/-- A program whose output depends on scratch garbage is rejected by the taint check. -/
theorem neg_garbage : checkStrict 2 [.mov 0 2, .mov 1 2] = false := by decide +kernel

/-- A program whose output depends on the initial flags is rejected. -/
theorem neg_flags : checkStrict 2 [.cmov .l 0 1] = false := by decide +kernel

/-- The textbook compare-exchange `(P0, P1)` with one scratch register is accepted. -/
theorem pos_cx : checkStrict 2 [.mov 2 0, .cmp 0 1, .cmov .g 0 1, .cmov .g 1 2] = true := by
  decide +kernel

/-- Using the strict checker on it gives the x86 theorem. -/
theorem cx_x86 : XCorrect 2 [.mov 2 0, .cmp 0 1, .cmov .g 0 1, .cmov .g 1 2] :=
  checkStrict_x86 pos_cx

end SortProof
