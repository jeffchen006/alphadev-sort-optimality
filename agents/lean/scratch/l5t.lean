import SortProof.L5
import SortProof.Programs
import SortProof.AllPrograms
open SortProof
def testSnap (n : Nat) (q : Program) : Nat × Nat × Bool :=
  let t := l5prog n q
  let ok := (reps n).all fun c =>
    sortsCheck n (vecRegs c) (snapOut t.out t.snap (relaxInit n (vecRegs c) n))
  (q.length, t.out.length, ok)
#eval testSnap 3 sort3.prog
#eval testSnap 4 sort4.prog
#eval testSnap 5 sort5.prog
#eval testSnap 3 SortProof.All.orig_alphadev_sort3_17_suppG.prog
#eval testSnap 3 SortProof.All.orig_alphadev_sort3_20_suppG.prog
#eval testSnap 3 SortProof.All.orig_alphadev_sort3_19_suppG.prog
#eval testSnap 4 SortProof.All.orig_alphadev_sort4_31_suppG.prog
#eval testSnap 5 SortProof.All.orig_alphadev_sort5_45_suppG.prog
#eval testSnap 5 SortProof.All.found_upper_sort5_I0_L42_mem.prog
#eval (l5prog 3 sort3.prog).out
#eval (List.range 3).map (l5prog 3 sort3.prog).snap
