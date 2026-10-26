import Lean
import SortProof.Load
import SortProof.Checker
import SortProof.Snap
/-
  Upper side: the M_out forms of AlphaDev's sort3 / sort4 (spec's `programs/out/`, k = 11 / 20) are correct
  in the strict RS model (all Int inputs, all garbage, all flags) and on x86; checked by the kernel (`decide +kernel`)
  with lean's verified checker `checkStrictO` (frozen v1). All `out` lines of these files can be read at the end.
-/
namespace LeanReflect.Pos
open SortProof
set_option maxRecDepth 100000

/-- Snapshot spec "every output read at the end". -/
def endSnap (p : Program) (o : Nat → Nat) : Snap := fun j => (o j, p.length)

theorem strictO_to_snap {n : Nat} {o : Nat → Nat} {p : Program} (h : StrictCorrectO n o p) :
    StrictSnap n p (endSnap p o) := by
  intro s
  have := h s
  show SortsOK n s.regs (fun j => (run compare (p.take p.length) s).regs (o j))
  rw [List.take_length]; exact this

theorem strictSnap_to_relaxed {n : Nat} {p : Program} {o : Snap} (h : StrictSnap n p o) : RelaxedSnap n p o :=
  fun x T _ => by
    have := h (relaxInit n x T)
    exact (sortsOK_congr (fun i hi => by simp [relaxInit, hi]) (fun _ _ => rfl)).mp this

/-- Remove the parser's `out` movs (`mov (outBase + j), R`). -/
def stripOuts (p : Program) : Program :=
  p.filter fun i => match i with
    | .mov d _ => decide (d < outBase)
    | _ => true

/-- Source register `R` of `out j, R`. -/
def outSrc (p : Program) (j : Nat) : Nat :=
  match p.find? (fun i => match i with | .mov d _ => d == outBase + j | _ => false) with
  | some (.mov _ s) => s
  | _ => j

def ad3 : ParsedProg := program_file% "../../../programs/out/alphadev_sort3_17_repo_out.s"
def ad4 : ParsedProg := program_file% "../../../programs/out/alphadev_sort4_28_repo_out.s"
def p3 : Program := stripOuts ad3.prog
def p4 : Program := stripOuts ad4.prog

theorem p3_len : ad3.n = 3 ∧ p3.length = 11 := by decide +kernel
theorem p4_len : ad4.n = 4 ∧ p4.length = 20 := by decide +kernel

theorem p3_strict : StrictSnap 3 p3 (endSnap p3 (outSrc ad3.prog)) :=
  strictO_to_snap (checkStrictO_sound (by decide +kernel))
theorem p3_x86 : XSnap 3 p3 (endSnap p3 (outSrc ad3.prog)) := strictSnap_to_x86 p3_strict

theorem p4_strict : StrictSnap 4 p4 (endSnap p4 (outSrc ad4.prog)) :=
  strictO_to_snap (checkStrictO_sound (by decide +kernel))
theorem p4_x86 : XSnap 4 p4 (endSnap p4 (outSrc ad4.prog)) := strictSnap_to_x86 p4_strict

end LeanReflect.Pos
