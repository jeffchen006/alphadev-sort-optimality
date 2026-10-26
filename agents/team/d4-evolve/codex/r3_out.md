Saved [20,669 correct programs](work/r3_designs.txt) from **31,146 routing attempts**, plus [498 canonical-input skeletons](work/r3_skeleton_index.json).

Best correct lengths:

| Family | k |
|---|---:|
| c=7 Ford–Johnson | 52 |
| c=8 loser-first | 44 |
| c=8 unbalanced fifth-input insertion | 44 |
| c=8 unbalanced loser insertion | 45 |
| c=8 deferred loser with recomparison | 54 |

All saved programs passed the C scorer on 541 weak orders. Each family’s shortest program passed the strict judge.

No `k<=31` solution was found. The best observed `k=31` near miss fails **237** orders, above the retention threshold. SAT and bounded `dagx` searches gave no exact exclusion.

[Report](work/r3_report.md) includes generators, counts, and search limits.