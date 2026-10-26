# C2 manifest (d2-lattice, DIRECTION_A)
Scope (judge R2): at most two written values (mov or cmov results, each copy counted) hold non-lattice full columns;
in V1 they are never cmp operands or outputs; V2 allows them as cmp operands. k <= 31 (dead-mov padding), 120 strict orders.

## Encoders (copies; sha256)
- V1: src/threshold_sat.py e3d39668... = codex-fleet/w10/src/threshold_sat.py (with partial_sat.py 1b02cc84..., partial_gap.py 87c20a74...)
- V2: src/threshold_cmpx.py = V1 + cmp operand may be an exception (bits from the exception rows). Judge-reviewed.

## Base CNFs (base/base_k31_c{C}[_v2].cnf, .json has sha256, variables, clauses, position_choices)
- V1 C=9..15: `python3 src/build.py C 31`  == `threshold_sat.py --tag T --k 31 --c C` (n=5, strict, first pair P0/P1, symmetry on)
  = ThresholdEncoding(5, 31, C, permutations(5), None, True, None, None, True). C=9 sha 92bd9e5c... = w10 round5.
- V2 C=7..15: `python3 src/build.py C 31 v2` (same call on threshold_cmpx.py).

## Cases
Case (C, i, j): base + units position_choices[0][i], position_choices[1][j]; m = 31-C is "absent";
cases (m,m), (i,m) i<m, (i,j) i<j<m: 1+m+C(m,2) per C. V1 C=9: w10 runs case index 0..126, d2 runs 127..253.
Runner: `python3 src/run.py --cs C [--variant v2] --workers N --limit S [--cases i:j,...]`.
UNSAT counts only when bin/lrat-check prints "c VERIFIED". Files: results/<case>.json, proofs/<case>.{cnf,lrat}.zst.

## Cubes (UNKNOWN cases)
`python3 src/cube.py C I J [v1|v2] T0 T1` -> cubes/<case>.json (chain cubes on the sizes of cmp blocks 0, 1);
`python3 src/checkcover.py cubes/<case>.json` -> cover certificate (CNF {NOT cube} UNSAT, LRAT verified).
Run the cubes: `python3 src/run.py --cubes <case> [--variant v2] ...` -> results/<case>_qNNN.json.

## Controls
- src/control_v2.py controls/ctl_v2.s 36 11: V1 UNSAT, V2 SAT (one compared non-lattice value).
- src/control_v2.py controls/lat32_0.s 32 9: V1 SAT, V2 SAT (pure-lattice k=32 optimum).
- judge: sort3 (n=3) k=11 SAT, k=10 UNSAT on both encoders.
