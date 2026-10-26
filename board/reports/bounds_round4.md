# bounds — round 4 report (2026-10-25): SORT5_IDEAS idea 1 (restriction x_i = max/min) tested — REFUTED as stated

Model: M_out, I1, T-relaxed, permutations. Tool: `agents/bounds/restrict.py` (own simulator).
Restriction to x_i = max (x_i then acts as T = +inf) / x_i = min (acts as -inf: NOT in our model, reported only).
Simplification: remove cmps with a fixed outcome on the restricted inputs; constant cmovs -> mov / delete; drop the output
of x_i; dead-code elimination; copy coalescing (mov D,S with S unused later -> rename). Every reduced program is VERIFIED to
sort all (n-1)! permutations (0 failures). d_i = k - (length of the reduced program).

## Data (samples of upper's correct shortest programs, every 74th / 250th)
| n | programs | k | need d ≥ | max_i d_i (max restr.) | best over all 2n restrictions | AlphaDev |
|---|---|---|---|---|---|---|
| 4 | 19 972 | 20 | 9 (20 − 11) | 6: 39, 7: 1247, 8: 18204, 9: 482 | 7: 5, 8: 18416, 9: 1551 | sort4_28 repo: 8 |
| 5 | 3 475 | 32 | 12 (32 − 20) | 11: 1605, 12: 1870 | 11: 1605, 12: 1870 | sort5_42: 11 |
Reduced lengths: n=4 -> 11..18 (11 = optimal sort3 in 4 % of the cases); n=5 -> 20..25.

## Conclusion
- The inequality "k ≥ k_out(n−1) + d" needs d ≥ 9 (n=4) / 12 (n=5) for EVERY program. Real SHORTEST programs already have
  d = 6–8 (n=4) and d = 11 (n=5, incl. AlphaDev sort5_42) under this simplification, so no proof of d ≥ 9 / 12 for this
  simplification can exist. The restricted sub-program is in general NOT an optimal sort(n−1) program (lengths 12–18 for
  sort3, 21–25 for sort4).
- d_min for n=4: ≤ 6 (single max restriction) and ≤ 7 (best of 8 restrictions) from the sample; an exact minimum over all
  k = 20 programs would need enum's full list, but it cannot reach 9 (counterexamples above), so I did not run it.
- For n=5 the data do NOT suggest d ≥ 12: half of the sample (and AlphaDev's 42) has d = 11. Idea 1 would give at most
  k ≥ 31 even with an ideal proof. Not sent to theory as a candidate; sent as a negative result.
- Possible repair (open): count instructions that serve x_i in ALL restrictions jointly (they differ per i), or use a
  stronger reduction (re-optimisation), but then d is no longer a local, provable quantity.

## Other
- The old n=4 case c=8 cross-check was killed (not by me; enum already proved k_out(4) = 20). No cores in use now.
