def big : List Nat := List.range 2000
set_option maxRecDepth 1000000 in
theorem t1 : (big.foldl (fun acc k => (acc * 31 + k) % 1000003) 0 == 7) = false := by decide +kernel
