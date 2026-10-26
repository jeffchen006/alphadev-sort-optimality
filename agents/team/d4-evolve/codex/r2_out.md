No `k <= 31` solution or improved near miss was found. The known `c=8, k=33` program passed the strict judge again.

Exact exclusions at `k=31`, `R=11`:

- **Six CakeML-verified UNSAT cases:** delete any two merge copies at instruction numbers `{17,21,27,31}`. Only their consuming conditional moves’ sources and conditions may change.
- **Three further solver UNSAT cases:** delete `(2,17)`, `(2,21)`, or `(2,31)`. All write sources and conditional-move conditions are free; destinations and comparisons stay fixed. Independent proof checking remains incomplete.

Three suffix comparisons after the fixed prefix are also excluded by the ten-orders/eight-paths bound.

The free-suffix and interleaving searches ended **UNKNOWN**. No family-wide impossibility follows.

[Report and exact scopes](work/r2_report.md) · [Programs and near misses](work/r2_near.txt) · [Strict-passing 33-instruction control](work/r2_control33_correct.txt)