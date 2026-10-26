# latency — round 1 report (2026-10-24)

## Summary
AlphaDev's sort3, sort4 and sort5 are NOT optimal in dependency-depth latency, and they are NOT
Pareto-optimal in (length, depth). Proofs: SAT/UNSAT on a relaxed dependency DAG, DRAT checked by
drat-trim. Lemmas A1-A5 reviewed SOUND by `theory` (agents/theory/reviews/latency_RULES_A.md).

## Models (agents/latency/MODEL_LATENCY.md)
- Depth = longest RAW chain over registers + flags (renaming: WAR/WAW free); loads/stores not counted
  (constant shift). Outputs: any rule (M_AD, M_out, end, fixed) — the lower bounds cover all.
- U: mov = cmp = cmov = 1 (Ice Lake; mov elimination off). E: mov = 0 (Skylake ideal, Alder Lake-P,
  Zen 3/4). Z2: Zen 2, cmov flags->dst = 2 (= cmp latency 2). Data: uops.info r32 forms.
- AlphaDev did not model latency for fixed sorts: optimized length; latency measured on hardware
  (spec confirmed).

## Numbers (depth U / E / Z2)
| n | AlphaDev | min depth (any length) | certificate | witness (strict, judge PASS) |
|---|---|---|---|---|
| 3 | 6/6/9 (repo), 6/5/7 (SI Sort3_17), k=11 | **4 / 4 / 5** | relax.py UNSAT D=3 (U,E), D=4 cl=2 (Z2), DRAT | latency_sort3_k18_depth4.s (k=18, 4/4/5) |
| 4 | 6/6/9, k=20 | **5 / 5 / 6** | UNSAT D=4 / D=5 cl=2, DRAT | latency_sort4_mindepth_k86.s (k=86, 5/5/6) |
| 5 | 13/11/16 (Sort5_42), 12/12/18 (43) | **>= 5 / >= 5 / >= 6**, <= 7 / 7 / 8 | UNSAT D=4 / D=5 cl=2, DRAT | latency_sort5_depth7_k309.s (k=309, 7/7/8) |

Pareto (length k = mov+cmp+cmov, depth), R unbounded, I1 (so I0), T-relaxed lower bounds:
- n=3 (U and E): front = {(11, 5), (k4, 4)} with **12 <= k4 <= 18**. Lower bound: every depth-4 program has
  #cmp + #cmov >= 12 (joint relaxed DAG with node budget, DRAT). (11,5): programs/found/latency_sort3_k11_depth5.s
  (I0 and I1). k_min = 11 is from enum/critic/sat/sat2. AlphaDev repo sort3 (11,6) is dominated.
- n=3 (Z2): min depth 5 needs k >= 12 (witness k=18); Z2 depth <= 6 needs #cmp+#cmov >= 11; best k=11: Z2 7.
- n=4: AlphaDev (20, 6). Depth 5 needs #cmp+#cmov >= K+1, K in [13,17] still running (K=18 SAT).
- n=5: upper's I0 k=32 program has depth 11/10/15 < AlphaDev Sort5_42 13/11/16 at the same length: AlphaDev sort5
  is dominated.

## Real hardware (x86 agent, Zen 4) vs models
x86 measured: AlphaDev sort5_42 16.7 cycles < upper I0 L42 19.3 although upper has lower depth. Pure depth does
not rank n=5 programs: with 18 cmovs on 2 cmov ports, throughput bounds (9 cycles) are near the depth. I wrote a
resource model (sched.py: in-order 6-wide dispatch, cmov on 2 ports, mov elimination); it does not explain this
gap either (16 vs 17). Asked x86 to time my depth-optimized programs (memory forms in programs/found/*_mem.s).
Model prediction (Zen 4): sort3 k11/depth5 9 cycles < AlphaDev 10; depth-4 programs 10-11 (throughput bound).

## Tools (agents/latency/, own code)
prog.py (parser/simulator/depth), depth_all.py, relax.py (+test_relax.py, prove_relax.sh), relax_joint.py
(+test_joint.py, prove_joint.sh), construct.py, lsched.py, compile_joint.py, dtree.py, regsat.py / regcegis.py
(register SAT with depth; slow), src/dsearch.cpp (exhaustive, depth-pruned), sched.py, out2mem.py.
Re-run: `cd agents/latency && ./prove_relax.sh 3 1 3 1` (etc., see claims), `python3 depth_all.py`.

## Open problems
1. sort5 min depth: 5, 6 or 7 (U/E)? relax.py n=5 j=1,2 D=5 (with T) runs (CEGIS + permutations); D=6 T-free
   construction runs.
2. n=4 length at depth 5 (K = 13..17 runs) and a short depth-5 sort4 (compile_joint K=18 runs).
3. n=3: exact k4 in [12, 18].
4. Rules B and C (RULES_LATENCY.md) not yet reviewed by theory; proofs pipeline (LRAT/cake_lpr) not yet used
   (drat-trim only).
5. A latency model that ranks n=5 programs like hardware.

## Next
Finish 1-2; ask proofs for cake_lpr runs on proofs/*.cnf; theory review of parts B, C; Pareto n=4.
