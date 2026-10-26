def bal : Nat → Nat → Nat → Nat
  | 0, lo, _ => (lo * 31 + 7) % 10000003
  | d+1, lo, w => if w ≤ 1 then (lo * 31 + 7) % 10000003 else
      (bal d lo (w / 2) + bal d (lo + w / 2) (w - w / 2)) % 10000003
#eval bal 30 0 1000000
set_option maxRecDepth 100000 in
theorem t1 : bal 30 0 1000000 = 685006 := by decide +kernel
