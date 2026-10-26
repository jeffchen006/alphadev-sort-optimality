def f2 (n acc : Nat) : Nat :=
  Nat.rec (motive := fun _ => Nat → Nat) (fun acc => acc) (fun k ih acc => ih ((acc * 31 + k) % 1000003)) n acc
set_option maxRecDepth 1000000 in
theorem t1 : (f2 16000 0 == 0) = (f2 16000 0 == 0) := by decide +kernel
