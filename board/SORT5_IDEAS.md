# sort5 ideas (coordinator, 2026-10-25 02:00) — for theory + bounds, start after the sort4 certificate
Goal: k_out(5) >= 32. Today: search k<=14, proved bounds give ~19; plain search est. 1e20-1e31 nodes.
1. Restriction / induction: restrict inputs to "x_i is the max" (or the min). A sort5 program then sorts the other 4.
   Simplify (fixed-outcome cmp, constant cmov, dead mov of x_i) -> a sort4 program of length <= k - d_i, so k >= 20 + d_i.
   Need: a proved lower bound on d_i (max over i, or an averaging bound over the 10 max/min restrictions).
   Test first on n=4 -> n=3 (k4 = 20, k3 = 11: is d >= 9 provable?).
2. Exact block structure: prove m >= 2c for shortest programs (true for n=3 by search) -> with B1/B3 + case split.
3. Prefix certificates (sorting-network style, Codish et al.): all "useful" first-t-instruction prefixes up to subsumption,
   then complete each prefix with a bounded search; subsumption between states is the key reduction.
4. Use the sort4 result as a lemma inside the sort5 search (admissible h from restrictions in idea 1).
