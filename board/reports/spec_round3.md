# spec — round 3 report (2026-10-24)

## Done
1. **MM+ optimality, n=2 (exact)**: `agents/spec/tools/mm_bfs.py` is an exact BFS over abstract states.
   - The state: cells, a multiset of register vectors, flags. The search is T-relaxed and covers all weak orders. theory reviewed the abstraction: sound and exact.
   - Result: MM (AlphaDev's model) = 8, MM+ = 7, both exhaustive. MM = 8 agrees with Lemma 4.1 (2n + k_out = 4 + 4).
2. **MM+ search target for n=3**: MODEL.md v1.7 §4.5. Question: is there an MM+ sort3 with L ≤ 14? If there is none, upper's 15 is optimal.
   - The target gives the exact state model, the validation numbers (n=2: 7 / 8; n=3 MM: 17), and an admissible heuristic idea.
   - critic runs it (C++ IDDFS, agents/critic/bf_mm.cpp; answer 19:33).
   - State growth from my Python BFS: 5, 30, 268, 4117, 74476, 1.5M states for L = 1..6 (about 20× per level). So a plain BFS cannot reach L = 14; IDA* with a lower-bound heuristic and a transposition table is necessary.
3. **Paper subsection "Beyond AlphaDev's action space"**: `agents/spec/paper/beyond.tex`. theory has merged it into `main.tex` as a subsection of Results; main.tex builds to 14 pages with no errors.
   - It defines MM+ and shows the table below. The table also gives the instruction mix of each kernel.

     | n | MM | MM+ |
     |---|---|---|
     | 2 | 8 | 7 |
     | 3 | 17 | 15 |
     | 4 | 28 | 26 |
     | 5 | 42 | 39 |
   - It explains why memory operands help: an unchanged cell is a free read-only copy. The n=3 kernel has 0 register movs and only 2 loads.
   - It explains why Lemma 4.1 fails, and gives the exact n=2 optimum.
   - "Shorter is not faster": in x86's measurements the MM+ kernels have a higher latency than AlphaDev's (sort3 13.5 vs 9.7 cycles). This is marked pending, because the machine is shared.
   - Conclusion of the subsection: the rule MM-1 is necessary for the AlphaDev claim.
   - I also applied theory's text fixes: Ullrich & Hack forbid reads of uninitialised registers, and the snapshot-lemma sketch now covers reloaded cells.
4. **Claims and programs judged.**
   - All 10 files in `programs/found/` pass `--strict` in their model. This includes upper's new MM+ sort5 with **L = 39** and sat's sort3 with k = 11.
   - The model statements of the n=3 lower-bound claims (enum, critic, proofs) match §4: `agents/spec/claims_audit.md`.
   - The n=3 main claim, L_AD(3) = 17, is supported by two independent tools. It does not have a certificate yet.

## Numbers
- n=2: MM 8, MM+ 7 (exact). n=3: MM 17 (two tools, relaxed; certificate pending), MM+ ≤ 15. n=4: MM+ ≤ 26. n=5: MM+ ≤ 39.

## Open problems
- MM+ sort3 L ≤ 14: critic runs it (bf_mm.cpp); its heuristic needs a theory review.
- Hardware runs are still needed for MM+ sort5 L=39 and sort2 L=7. I asked x86.
- The latency numbers need a re-run on an idle core.

## Next
- Run the judge on each new kernel, and audit each new claim against §4.
- Update `beyond.tex` when the MM+ n=3 result and the hardware runs arrive.
