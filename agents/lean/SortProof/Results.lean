import SortProof.L5
import SortProof.Programs
/-
  End results in the AlphaDev memory model MM (theory remark 2 + main theorem shape).
-/
namespace SortProof

theorem isMAD_MMProg {n : Nat} {p : Program} (h : p.isMAD n = true) : MMProg n p := by
  intro i hi
  have := List.all_eq_true.mp h i hi
  cases i <;> simp [Instr.isMAD, MMInstr] at this ⊢ <;> omega

/-- Upper bound in MM: the AlphaDev memory programs are MM programs (MM-1) of length 17 / 28 / 42
  and sort on x86 (all inputs, garbage, flags). -/
theorem alphadev_mm :
    (MMProg 3 sort3.prog ∧ sort3.prog.length = 17 ∧ XCorrect 3 sort3.prog) ∧
    (MMProg 4 sort4.prog ∧ sort4.prog.length = 28 ∧ XCorrect 4 sort4.prog) ∧
    (MMProg 5 sort5.prog ∧ sort5.prog.length = 42 ∧ XCorrect 5 sort5.prog) :=
  ⟨⟨isMAD_MMProg (by decide +kernel), by decide +kernel, alphadev_sort3_x86⟩,
   ⟨isMAD_MMProg (by decide +kernel), by decide +kernel, alphadev_sort4_x86⟩,
   ⟨isMAD_MMProg (by decide +kernel), by decide +kernel, alphadev_sort5_x86⟩⟩

/-- The shape of the final AlphaDev optimality claim, for n = 3 in I1: if the rule-free RS search
  at k = 10 (registers < 13) finds nothing, then no MM program of length ≤ 16 sorts on x86,
  so AlphaDev's 17 is optimal. `lean-lrat` / `lean-reflect` supply `H`. -/
theorem sort3_optimal_of
    (H : ∀ (p : Program) (o : Snap), p.length = 10 → Program.WF (3 + 10) p →
      (∀ j, (o j).1 < 3 + 10) → (∀ j, (o j).2 ≤ 10) → (∀ i ∈ p, i.inSet (fun _ => true)) →
      ¬ RelaxedSnap 3 p o) :
    ∀ q : Program, MMProg 3 q → q.length ≤ 16 → ¬ XCorrect 3 q := by
  intro q hq hl
  exact mm_lower_bound 3 10 (fun _ => true) (by decide) (by decide) H q hq (by omega)
    (fun i _ => by cases i <;> rfl)

end SortProof
