example (u v : Int) : compare u v = .eq ↔ u = v := by exact?
example (l : List Int) (a : Int) (h : a ∉ l) : l.idxOf a = l.length := by exact?
example (l : List Nat) (f : Nat → Bool) : l.length = (l.filter f).length + (l.filter (fun x => !f x)).length := by exact?
example (l : List Int) (i : Nat) (h : i < l.length) (d : Int) : l.getD i d = l[i] := by exact?
example (l : List Nat) (f : Nat → Int) (i : Nat) (h : i < l.length) (d : Int) (e : Nat) : (l.map f).getD i d = f (l.getD i e) := by
  simp [List.getD_eq_getElem?_getD, h]
example (m i : Nat) (h : i < m) (x d : Int) : (List.replicate m x).getD i d = x := by
  simp [List.getD_eq_getElem?_getD, h]
example (l : List Int) (i : Nat) (h : i < l.length) : l.getD i [] ∈ l := by sorry
