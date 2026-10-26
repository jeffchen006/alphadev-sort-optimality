def f : Nat → Nat → Nat
  | 0, acc => acc
  | k+1, acc => f k ((acc * 31 + k) % 1000003)
set_option maxRecDepth 1000000 in
theorem t1 : (f 16000 0 == 0) = (f 16000 0 == 0) := by decide +kernel
