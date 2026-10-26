# theory — round 2 report (2026-10-24)

## Done
- **Reviews (all in `agents/theory/reviews/`):**
  - enum PRUNING.md v1: SOUND. Lemma S (set model = M_out) and Lemma M are checked case by case. Rules W/E/P/G/D and the heuristics H1–H3 never overestimate the remaining cost. Exact deduplication is safe.
  - sat RULES.md v1/v2: SOUND (rewriting argument). Text fixes are applied in v2.
    - New `snapcmov`: sound if "move a snapshot to its source slot" is added to the measure as c4 (asked for v3).
    - New `mincmp` (L7): sound. `cmpT` withdrawn: agreed.
  - sat2 R5 (snapT) and R6 (llP/llPall): SOUND. One check sent: how the deadw boundary is handled.
  - bounds B2, B3 (#cmov ≥ Huff = 5/8/12), Lemma D, Lemma R1, N1–N4 and heuristic H: CORRECT. N1 must not be mixed with other teams' rules.
  - critic BF_NOTES (bf.cpp): SOUND. Caveat: 128-bit hash keys, so it is a cross-check, not a certificate.
  - lean STATEMENTS v1: the statements match L1, L2, L3, L4a and RS.
    - lean's answer: the AlphaDev memory programs are already proved correct in MM (`isMAD` = my MMProg).
    - lean starts G2 (L5) with my statements.
- **First lower-bound claims checked:**
  - Claim: n=3, RS, I1 and I0, R unbounded, T-relaxed, 13 weak orders, every k ≤ 10 UNSAT. So L_AD(3) = 17 is optimal under MM-1.
  - Tools: enum (exact BFS, rules reviewed) and critic (IDDFS, rules reviewed) agree. I re-ran enum: also with permutations only, and with symmetry G off.
  - Each claim states n, k, R, I, C, the model and the sweep.
  - Missing for "bronze": a cake_lpr certificate in the RS/I1 model. The current cake_lpr run (proofs) is for the old RF/I0 model at k=9.
- **k_out = k_end:** settled, no general lemma is needed. k_out ≤ k_end, and all AlphaDev cores are valid at the end. So a bound k_out ≥ L−2n gives equality for that n. For n=3 this is done (11). Sent to spec for MODEL §4.3.
- **MM+ (cmp/cmov read memory) — lemma L8:** the snapshot lemma fails here. An MM+ program maps only to RS length ≤ L − a − b, so in general only L ≥ k_RS. An MM+ optimum needs its own encoding.
  - upper's x86-checked MM+ kernels (sort4 26, sort5 40) show that MM-1 is essential to the AlphaDev claim. This is a headline side result. Sent to spec.
- **L9 checklist for case splits** (six points: coverage of the canonical program, symmetry-removed cases, same model, implied constraints, per-case bounds, certificates). Sent to bounds ahead of SORT5_SPLIT.md.
- **Paper:** `agents/theory/paper/main.tex` is draft 1, 7 pages, and compiles with no errors or overfull boxes. It has:
  - abstract, intro, model, "why RF is wrong";
  - the trust-chain table, filled from claims.md with Lean theorem names;
  - search, results table (n=3 filled, n=4/5 pending), threats (MM+ first), related work (Ullrich & Hack from spec);
  - the appendix with all proofs.

## Numbers
- n=3: k_out = 11 in I1 and I0 (two independent searches). L_AD(3) = 17 is optimal under MM-1. No certificate yet.
- Bounds for every correct program: #cmp ≥ 3/5/7, #cmov ≥ 5/8/12. For n=3, #cmov ≥ 6 (computed).
- MM+: sort4 ≤ 26, sort5 ≤ 40 (outside the base model).

## Open
- SORT5_SPLIT.md (bounds) is not written yet. Checklist L9 sent.
- sat RULES v3: needs the c4 step for snapcmov.
- A cake_lpr certificate for n=3 in RS/I1. Also n=4 claims (enum) and n=5.
- lean G2 (L5) and G3 (rules: wait for the rule set of the certified run).
- spec must answer the k_end/MM+ text for MODEL §4. spec's full related-work text is needed for the paper.

## Next
Review SORT5_SPLIT.md and each new lower-bound claim. Fill the paper results as claims arrive. Review Lean G2 statements.
