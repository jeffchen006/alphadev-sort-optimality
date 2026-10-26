**Checked: all 44 pools returned `NONE <= 31`.** No qualifying FOUND path was produced.
I also removed the `012` copy in a **strict-judge PASS length-33 program**: four moves, 18 cmovs, 11 comparisons.

Notation: `∧` = min; `∨` = max. Let `A=012`, `B=01|02|12`, `C=0|1|2`, `D=34`, `E=3|4`.
`p=A∨D`, `r=A∨E`, `l=C∧D`, `f=B∧E`, `j=B∧D`, `m=C∨D`, `core=x0∧(x1∨x2)`.
`ai=A∧xi`, `bi=B∧xi`, `ci=C∧xi`; `V=A∧E`, `T=C∧E`, `U=A∨T`, `H=V∨D`, `Z=B∨D`.

All pool files below are in `codex_work/r3/`. `N31` means `NONE <= 31`. Sizes include inputs.
Exact definitions, network alignments, and logs are in the [manifest](/path/to/repo/agents/team/d7-structure/codex_work/r3/manifest.json) and [run table](/path/to/repo/agents/team/d7-structure/codex_work/r3/summary.tsv).

| Idea | Pool file | Size | R | Result |
|---|---|---:|---:|---|
| Add p,r | pool_41_p_r.txt | 25 | 9 | N31 |
| Add p,l | pool_41_p_l.txt | 25 | 9 | N31 |
| Add p,core | pool_41_p_core.txt | 25 | 9 | N31 |
| Add p,f | pool_41_p_f.txt | 25 | 9 | N31 |
| Add p,j | pool_41_p_j.txt | 25 | 9 | N31 |
| Add l,m | pool_41_l_m.txt | 25 | 9 | N31 |
| Add j,f | pool_41_j_f.txt | 25 | 9 | N31 |
| Distributed minima a3,a4 | pool_41_a3_a4.txt | 25 | 9 | N31 |
| Rebuild A through 01,02 | pool_41_a01_a02.txt | 25 | 9 | N31 |
| Add 01,p | pool_41_a01_p.txt | 25 | 9 | N31 |
| Add 02,p | pool_41_a02_p.txt | 25 | 9 | N31 |
| Distributed minima b3,b4 | pool_41_b3_b4.txt | 25 | 9 | N31 |
| Distributed minima c3,c4 | pool_41_c3_c4.txt | 25 | 9 | N31 |
| Add p,c3 | pool_41_p_c3.txt | 25 | 9 | N31 |
| Add p,c4 | pool_41_p_c4.txt | 25 | 9 | N31 |
| Replace V by p; add core,r | pool_41_ref_core_r.txt | 25 | 9 | N31 |
| Replace V by p; add a3,a4 | pool_41_ref_v3_v4.txt | 25 | 9 | N31 |
| Three routes using C<D | pool_41_cd_l.txt | 26 | 9 | N31 |
| Two pivots using B<E | pool_41_be_l.txt | 25 | 9 | N31 |
| Three routes using C≤D | pool_41_cd_le.txt | 26 | 9 | N31 |
| Two pivots using B≤E | pool_41_be_le.txt | 25 | 9 | N31 |
| Net103 + V,m | pool_103_vm.txt | 25 | 9 | N31 |
| Net103 + V,core | pool_103_vcore.txt | 25 | 9 | N31 |
| Net103 + m,core | pool_103_mcore.txt | 25 | 9 | N31 |
| Net103 + V,j | pool_103_vj.txt | 25 | 9 | N31 |
| Net103 + m,B∨E | pool_103_mr.txt | 25 | 9 | N31 |
| Net103 + a3,a4 | pool_103_vinputs.txt | 25 | 9 | N31 |
| Union with aligned net105 | pool_41_union105.txt | 25 | 9 | N31 |
| Union with aligned net109 | pool_41_union109.txt | 25 | 9 | N31 |
| Union with aligned net17 | pool_41_union17.txt | 25 | 9 | N31 |
| Union with aligned net34 | pool_41_union34.txt | 25 | 9 | N31 |
| Union with aligned net43 | pool_41_union43.txt | 25 | 9 | N31 |
| Union with aligned net82 | pool_41_union82.txt | 25 | 9 | N31 |
| Complete adaptive merge | pool_merge8.txt | 23 | 10 | N31 |
| Net41 minus T + adaptive merge | pool_41_merge8_not.txt | 27 | 10 | N31 |
| Net41 minus U + adaptive merge | pool_41_merge8_nou.txt | 27 | 10 | N31 |
| Net41 minus V + adaptive merge | pool_41_merge8_nov.txt | 27 | 10 | N31 |
| Net41 minus H + adaptive merge | pool_41_merge8_noh.txt | 27 | 10 | N31 |
| Net41 minus Z + adaptive merge | pool_41_merge8_noz.txt | 27 | 10 | N31 |
| Entire net41 + alternate merge | pool_41_merge8_exchange.txt | 27 | 10 | N31 |
| Nested pivots, conditions l/l | pool_41_nested_l_l.txt | 26 | 9 | N31 |
| Nested pivots, conditions le/le | pool_41_nested_le_le.txt | 26 | 9 | N31 |
| Nested pivots, conditions l/le | pool_41_nested_l_le.txt | 26 | 9 | N31 |
| Nested pivots, conditions le/l | pool_41_nested_le_l.txt | 26 | 9 | N31 |
| Four-move restricted search† | pool_41_copy4.txt | 23 | 10 | NONE ≤32 |

† This additional run used a modified solver: at most four moves, at most ten comparisons, and no recomputation of an existing column.

The fifth copy preserves comparison reuse in the displayed nine-comparison plan.
`cmp(A,T)` computes U and V; U overwrites A because T must survive for OUT3.
OUT0 needs A later, under the flag from `cmp(V,D)`.
My four-move schedule delays U, repeats `cmp(A,T)`, and adds `cmp(A,D)`.
The restricted search found no length-32 solution with four moves and 18 new-term cmovs.

The [length-33 program](/path/to/repo/agents/team/d7-structure/codex_work/r3/avoid_a_copy_33.s) passed `judge.py --strict --model out`. Searches used two workers at `nice -n 10`; summed search durations were 11.5 minutes.