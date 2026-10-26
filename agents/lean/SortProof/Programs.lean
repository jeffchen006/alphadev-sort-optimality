import SortProof.Load
import SortProof.Rename
/-
  Strict-model correctness of the AlphaDev programs (files owned by `spec`).
  Every theorem is checked by the KERNEL (`decide +kernel`, no `native_decide`).
-/
namespace SortProof

def sort3 : ParsedProg := program_file% "../../../programs/alphadev_sort3.s"
def sort4 : ParsedProg := program_file% "../../../programs/alphadev_sort4.s"
def sort5 : ParsedProg := program_file% "../../../programs/alphadev_sort5.s"

set_option maxRecDepth 100000

theorem sort3_facts : sort3.n = 3 ∧ sort3.k = 17 ∧ sort3.model = "mem" ∧
    sort3.prog.isMAD 3 = true ∧ sort3.outs = [] := by decide +kernel

theorem alphadev_sort3_x86 : XCorrect 3 sort3.prog := checkStrict_x86 (by decide +kernel)

theorem sort4_facts : sort4.n = 4 ∧ sort4.k = 28 ∧ sort4.model = "mem" ∧
    sort4.prog.isMAD 4 = true ∧ sort4.outs = [] := by decide +kernel

theorem alphadev_sort4_x86 : XCorrect 4 sort4.prog := checkStrict_x86 (by decide +kernel)

theorem sort5_facts : sort5.n = 5 ∧ sort5.k = 42 ∧ sort5.model = "mem" ∧
    sort5.prog.isMAD 5 = true ∧ sort5.outs = [] := by decide +kernel

theorem alphadev_sort5_x86 : XCorrect 5 sort5.prog := checkStrict_x86 (by decide +kernel)

end SortProof
