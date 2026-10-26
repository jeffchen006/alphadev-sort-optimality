# upper — round 1 report (2026-10-24)

## Result in one line
I found NO program shorter than AlphaDev in the base model (M_AD / M_out, I1): best is sort3 17, sort4 28, sort5 42
(= AlphaDev). In the variant MM+ (cmp/cmov may read memory, x86-legal), I found sort3 15, sort4 26, sort5 39.

## Done
- Own tools in `agents/upper/src/` (no shared code):
  - `sim.h`: byte-parallel simulator over all weak orders (13/75/541). Garbage = UNK, 3-valued (sound for the strict
    model). Initial flags = unknown. About 0.2-0.6 M programs/s per core for n = 5.
  - `mcmc.c`: STOKE-style MCMC. Fixed slots with NOP. Cost = #wrong (output, order type) + lam * length.
    Moves: opcode, operand, swap, rotate, replace, NOP toggle, AND two coordinated moves: register rename from
    position i, and "delete mov d,s + substitute s for later reads of d". The coordinated moves make the
    network start (36) reach 33 in 28 k steps instead of 3.3 M. Incremental evaluation (snapshots per position), 1.4x.
  - `lns.c`: window w -> w-1, exhaustive, liveness + commutation pruning. Result: weak (w=3 cannot even shorten the
    naive 36 network), so I used it only as a check (no 32 -> 31 step, w=3, on 4 different sort5 programs).
  - `pycheck.py`: independent plain-int checker (all {0..n-1}^n, scaled, garbage incl. INT_MIN/MAX, 3 flag states).
  - `net2s.py` (sorting network -> naive code, structured starts), `att2s.py`, `to_judge.py`.
- Models in the search: `out` (MODEL 4.3, k_out = L_AD - 2n, snapshot outputs), `free` (k_end), `P` (MODEL 1,
  k_fixed), `mem` (exact M_AD, + `-memops` = MM+).
- Every saved program passes `shared/judge.py --strict` and my two checkers.

## Upper-bound table (best length found; for `sat` / `enum`)
| model | iset | n=3 | n=4 | n=5 | file (programs/found/) |
|---|---|---|---|---|---|
| M_AD (L, AlphaDev count) | I1 | 17 | 28 | 42 | upper_sort5_I1_L42_mem.s |
| M_out k_out (= L - 2n) | I1 | 11 | 20 | 32 | upper_sort5_I1_k32_out.s |
| M_out k_out | I0 | 11 | 20 | **32** | upper_sort5_I0_k32_out.s, upper_sort5_I0_L42_mem.s |
| k_end (outputs at end, any regs) | I1, I0 | 11 | 20 | 32 | (same programs: outs at end) |
| k_fixed (MODEL 1, outputs in P_j) | I1 | 11 (also I0) | 20 | 33 | upper_sort3_reg_I0_k11.s, upper_sort4_reg_k20.s, upper_sort5_reg_k33.s |
| + xchg (I1x) | I1x | 11 | 20 | 32 | no gain from xchg |
| MM+ (memory source operands, L) | I1 | **15** | **26** | **39** | upper_sort{3_memops_L15,4_memops_L26,5_memops_L39}.s |

Notes:
- sort5 in I0 with k = 32 (L = 42) is new: AlphaDev's 42/43 fail in I0 (spec), Ullrich-Hack report ~33 in I0
  (1 scratch register, fixed outputs). My I0 program uses 4 scratch registers and free outputs.
- MM+ was confirmed by spec and critic (judge `--model memplus`), opcode semantics by x86 (claims 19:11-19:19).
  The MM+ sort3 15 loads only 2 cells: x0 enters a register only through `cmovcc r, m`.
- The search finds sort3 11, sort4 20 and sort5 32 FROM SCRATCH (random start), in seconds / about 1-2 min per chain.

## Negative evidence (search, NOT a proof)
- sort4, k = 19: k_end I0 / I1 / I1x: 6 chains x 20 min (about 4e9 proposals); k_out I1: 1e9; k_out I1x: 60 min. No hit.
  (k = 20 is found in about 10 s per chain.) Agrees with Ullrich-Hack (exhaustive, restricted model).
- sort5, k_out = 31 (L = 41), I1: 31-slot chains, 60 min each: 6 (old moves) + 4 (new moves; one with <= 8 cmp)
  + 1 free-model + 2 I1x; plus 5 descent chains (lam > 0) from scratch / networks / AlphaDev: all stop at 32.
  About 7e9 proposals in total. No hit.
- Structure of all 32s: always 9 cmp; 23 = 18 cmov + 5 mov (AlphaDev, my I0) or 20 cmov + 3 mov.
- MM+: sort4 26 and sort5 39 stable for 2 x 20 min more (b1-b3 runs).

## Open problems / next
1. sort5 k_out = 31: the main silver-prime question is open. MCMC evidence says "no", but this is weak for n = 5.
   Ideas: (a) seed MCMC from many diverse 32s (all 9-comparator networks + trick library); (b) restrict to <= 8 cmp
   with the info bound (>= 7 cmp) and search the routing; (c) give `enum` / `sat` my 32s as warm starts / hints.
2. MM+ lower bounds are open (spec: n=2 MM+ = 7 exact). MM+ sort4 25 / sort5 38 not found yet.
3. Real-CPU runs: x86 checked MM+ opcode facts; per-program CPU runs of my files still to confirm (asked x86).
4. VarSort variants: not done (not cheap).
