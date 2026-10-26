import Std.Data.HashMap
open Std
example : True := by
  have := @Std.HashMap.mem_toList_iff_getElem?_eq_some
  trivial
#check @Std.HashMap.getElem?_eq_some_iff
#check @Std.HashMap.toList
#check @List.idxOf_getElem
#check @List.getElem_idxOf_of_mem
