# Seven failed k=31 models: handoff for w7-style repair

All seven models fail the strict out judge. The conservative evaluator reproduces every prior failure count. It treats unknown scratch values and flags as undefined. The independent scalar simulator uses scratch value 9 and initial equal flags. Its counts describe that one initial state. The strict judge records reject strict correctness.

| Program | Prior conservative failures | Scalar failures | Scalar strict failures | Wrong output counts |
|---|---:|---:|---:|---|
| `variants_broad_v01_model01.s` | 153 | 153 | 48 | `{2: 153, 1: 27}` |
| `variants_broad_v01_model02.s` | 144 | 144 | 72 | `{1: 144}` |
| `variants_broad_v04_model01.s` | 90 | 90 | 36 | `{2: 90}` |
| `variants_broad_v10_model01.s` | 98 | 98 | 48 | `{1: 98}` |
| `variants_broad_v13_model01.s` | 461 | 461 | 120 | `{3: 222, 4: 173, 0: 213, 2: 233, 1: 244}` |
| `variants_broad_v17_model01.s` | 27 | 27 | 12 | `{1: 27, 2: 18}` |
| `variants_broad_v19_model01.s` | 153 | 153 | 60 | `{1: 99, 2: 153}` |

112 non-contiguous four-position windows are ready in `round4/repair/tasks.json`. Each window can change all six opcodes, both operands, and every output snapshot. Each seed has one additional register. All other instruction positions remain fixed. The planned solver is the copied w7 rank-value SAT encoder, with the top-scratch initial-state relaxation. Every candidate requires the strict judge. Each limit is UNKNOWN. Completed UNSAT certificates will be checked with drat-trim.

The exact failure inputs, output dependencies, value-loss positions, and selected windows are in `round4/handoff/analysis.json`. The copies of all seven programs are in this directory.

Assumptions: [A2,A11]. The finite register set limits the exclusion. The repair search changes the value skeleton; it does not impose A4, A8, A12, or A15.
