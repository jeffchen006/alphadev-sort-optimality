# theory — round 4 report (2026-10-24)

## Done
- **RULES_LATENCY.md** A1–A5 (earlier), B and C: SOUND (`agents/theory/reviews/latency_RULES_{A,BC}.md`). Two small items for latency:
  - S3 must keep depth-D values capturable as outputs.
  - Write down the joint normal-form measure for S7+S8+R1+R2 (I gave it).
  
  The latency claims follow, given the DRAT checks: min depth, and "depth ≤ 4 needs k ≥ 12" for n=3.
- **Certificate obligations for sort4/sort5:** `agents/theory/CERT_OBLIGATIONS.md`, sent to enum, lean, lean-reflect and coq.
  - **End theorem:** state it per route, relaxed or strict. Never mix the two routes.
  - **NG means strict:** a search pruned with NG (L10) proves a STRICT statement (XSnap). The chain to MM then needs `l5_strict`; lean has only the relaxed `l5`. My paper L5 covers strict, so lean must add it.
  - **Closure certificate:** it must contain:
    - C0 the abstraction (Lemma S, M, NG);
    - C1 the root;
    - C2 closure over all operations, which the checker enumerates itself;
    - C3 no goal state;
    - C4 symmetry keys compared in full;
    - C5 the test set;
    - C6 the costs;
    - C7 every pruning rule as a proved lemma.
  - **SAT route:** F0 + SB + cuts, the sweep/NOP rule, and one certificate per split case.
  - **Claim line:** the minimum content of a claim line is listed in the file.
- **sort4 claims reviewed:**
  - enum: no STRICT-correct RS program with k ≤ 18 (n=4, I1, 24 perms, NG v3). The claim states every item. `CMAX=12` is only a memory cap: the run aborts if a state exceeds it (exit 6), so a completed run is sound. k = 19 is running.
  - sat2: k ≤ 12 only (partial).
- **Other reviews:**
  - lean-lrat `Canonical` / `Normal`: the statements are correct and give exactly lean's H.
  - critic's MM+ heuristic (bf_mm.cpp): admissible. "MM+ sort3 needs L = 15" holds as a cross-check.
  - bounds R4 last block: confirmed.
- **Paper (15 pp, compiles):**
  - results table: sort4 row added as a placeholder (enum ≤ 18 strict, sat2 ≤ 12);
  - new subsection "Latency: AlphaDev's kernels are not Pareto-optimal":
    - the depth model;
    - the relaxed-DAG method;
    - min depth 4/5 (n=3), 5/6 (n=4);
    - n=3 Pareto front {(11,5), (k4,4)} with 12 ≤ k4 ≤ 26; AlphaDev sort3 (11,6) is dominated;
    - sort5 at k = 32 has a shallower I0 kernel.
  - the sort3 trust-base table, from round 3.

## Numbers
- sort3: L = 17 optimal (cake_lpr; Lean parts proved). n=3 latency: Pareto front as above.
- sort4: no strict RS program with k ≤ 18 (enum, NG). The target is k ≤ 19, i.e. L ≥ 28.
- MM+: sort3 = 15 is optimal (critic IDDFS). Upper bounds: 26 for sort4 and 39 for sort5.

## Open
- enum k = 19 (sort4); certificates for it (lean-reflect / coq checkers per CERT_OBLIGATIONS).
- lean: `l5_strict` (needed for any NG-based certificate) and the combined `sort3_mm_optimal`.
- lean-lrat sort3 k = 10 (cube run).
- Paper: the sort4 and sort5 results rows when the claims land.

## Next
Review the enum k = 19 claim and the first sort4 certificate. Check that the sort4 end theorem matches CERT_OBLIGATIONS §0.
