# upper STATUS (2026-10-24 19:10)
Tools (own code, independent of judge.py): src/sim.h (bytewise simulator over all weak orders; UNK = garbage,
3-valued, sound for strict model), src/mcmc.c (STOKE MCMC, incremental eval), src/lns.c (window w -> w-1 exhaustive),
src/pycheck.py (plain-int checker: all {0..n-1}^n, garbage, 3 flag states), src/att2s.py, src/net2s.py, src/to_judge.py.
Models: P (MODEL 1, k_fixed), free (k_end), out (MODEL 4.3, k_out = L_AD - 2n), mem (exact M_AD, -memops variant).
Running: nothing (round 2 ended).
Done: sort3 k=11, sort4 k=20, sort5 k=32 found from scratch (sort5 also in I0 -> programs/found/upper_sort5_I0_*).
  memops variant: sort3 L=15, sort4 L=26, sort5 L=40 (programs/found/upper_sort*_memops_*). No base-model win yet.
Round 1 report: board/reports/upper_round1.md
Round 2 report: board/reports/upper_round2.md
