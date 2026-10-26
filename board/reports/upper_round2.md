# upper — round 2 report (2026-10-25)

## Result in one line
No program shorter than AlphaDev found, in the base model or in I2 (I1 + cmove/cmovne/xchg). Table of best lengths is unchanged:
k_out = 11 / 20 / 32 for n = 3 / 4 / 5 (L_AD = 17 / 28 / 42). New: sort5 k=32 with lower critical-path depth, and large statistics for `bounds`.

## Done
1. **sort5 k_out = 31 attack (I1), search only, ~1e10 more proposals**
   - Seeds: all 13,866 distinct 9-comparator sort5 networks enumerated (`src/allnets.py`); 2000 random ones turned into naive code and
     descended by MCMC (8 s each). 177 reach 32, 1129 reach 33, none reach 31. Pass 2 (60 s each) on the 177: 158 stay at 32, none reach 31.
   - 300 random distinct k=32 programs, delete 1 instruction, 31 slots, 25 s each from the same program with restarts: none correct.
   - Restricted cmp count: c <= 8 from merge-insertion code (bounds/fj5_7cmp.s) gives k = 41 (8 cmp); c <= 7 gives 52. From scratch, nothing with c <= 8 and k <= 33.
   - The new register-rename and mov-substitute moves (round 1 end) are used in all runs.
2. **Statistics for `bounds`** (`runs/r4/stats_s4k20.txt`, `stats_s5k32.txt`; files `*_coll.txt.gz`; script `src/stats.py`)
   - sort4 k=20: 1.48 M distinct programs, always c=5, m in 10..15, v in 5..0, every block >= 2 cmov.
   - sort5 k=32: 1.25 M distinct programs, always c=9, (m,v) from (18,5) to (23,0), every block >= 2 cmov (max 4 in one block).
   - bounds cites them as support for "shortest => every block >= 2 cmov" (their inbox 22:09). Samples only, not a proof.
3. **I2 = I1 + cmove, cmovne, xchg** (spec confirmed semantics, MODEL v1.8 §4.6, judge `--iset I2`)
   - sim/MCMC/pycheck support I2. Runs: sort3 k=10 (20 min), sort4 k=19 (2 x 40 min + 55 min), sort5 k=31 (3 x 40 min + 33-slot descent, plus earlier 60 min).
     Nothing shorter. I2 sort3 = 11, sort4 = 20, sort5 = 32 found from scratch (judge --strict --iset I2 PASS on one). No gain from cmove/cmovne/xchg.
4. **Depth tie-break for `latency`** (`-depth U|E w` in mcmc; checked with latency's prog.py via `src/depthchk.py`)
   - sort5 k=32: depth U=10, E=10 (AlphaDev 42: 13/11; my round-1 I0 program: 11/10): `programs/found/upper_sort5_k32_depthU10.s`, judge PASS; x86 asked (low priority).
   - sort4 k=20: best depth 6 (U and E), 4 chains. Depth 5 not found.
5. **Warm starts**: sat accepted the k=20/k=32 files as SAT phase hints (inbox). Artifact script proposal sent to spec (mm_00 ok; `upper_00_search` seeded run proposed).

## Updated upper-bound table (unchanged lengths)
| model | iset | n=3 | n=4 | n=5 |
|---|---|---|---|---|
| M_AD L | I1 (I2) | 17 | 28 | 42 |
| M_out k_out | I1, I2 | 11 | 20 | 32 |
| M_out k_out | I0 | 11 | 20 | 32 |
| MM+ L | I1 | 15 (optimal, critic) | 26 | 39 |

## Negative evidence (search only, NOT a proof)
- sort5 k_out = 31: now ~2e10 proposals in total over I1/I1x/I2, scratch + 2000 network seeds + 300 warm starts: no hit. sort4 k=19: ~1e10: no hit.
- Every found 32 (sort5) and 20 (sort4) has c = 9 / 5 and every block >= 2 cmov. A shorter program, if it exists, must have a different shape (e.g. c = 7 or 8 with very good routing, but those searches reach only 41).

## Open / next
1. The only unsearched shapes: c <= 8 with k <= 31 (our best 41). `sat` per-c cases decide these; my search is too weak there.
2. MM+ sort4 25 / sort5 38 not found (round 1 only). Depth 5 (sort4 k=20) and depth < 10 (sort5 k=32) open. VarSort not done.
