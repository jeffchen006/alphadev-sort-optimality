import LeanReflect.Basic
open LeanReflect
theorem cget_toArray (l : List Int) (i : Nat) : cget l.toArray i = l.getD i 0 := by
  simp [cget, Array.getD, List.getD_eq_getElem?_getD]
  split <;> simp_all
