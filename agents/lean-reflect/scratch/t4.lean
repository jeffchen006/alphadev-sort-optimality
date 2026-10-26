example (l : List Int) : l.eraseDups.Nodup := by exact?
example (l l' : List Int) (h : l.Nodup) (s : l ⊆ l') : l.length ≤ l'.length := by exact?
