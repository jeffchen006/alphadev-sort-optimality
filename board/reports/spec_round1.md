# spec — round 1 report (2026-10-24)

## Done
1. **AlphaDev facts** (Nature Table 1a, Methods, SI App. F/G, github deepmind/alphadev; copies in `agents/spec/ext/`).
   - Lengths: sort3 17 (human 18), sort4 28 (28), sort5 42 (46). Repo and libc++ use a 43 sort5. The 42 program is SI App. G `Sort5_42`.
   - Counting: every x86 instruction counts 1, incl. n loads and n stores. Data is int32 in memory, signed compare.
   - Iset I1 = mov, cmp, cmovl, cmovle, cmovg, cmovge. No memory operand in cmp/cmov ("illegal", Methods), recorded as model restriction MM-1.
   - AlphaDev claims a brute-force proof for sort3 >= 17 (no certificate). It claims nothing for sort4 or sort5.
2. **MODEL.md §4** (now v1.5).
   - Exact model M_AD (judge `model=mem`).
   - Encoder model M_out = §1 + free `out j, S` snapshot (judge `model=out`).
   - Lemma 4.1: L_AD = 2n + k_out. `theory` confirms it (lemmas.md L5 "RS", per-segment copy fix).
   - **Targets: UNSAT in M_out, I1, for every k <= 10 / 19 / 31 (n = 3 / 4 / 5).**
   - A bound with outputs fixed at the end (k_end, k_fixed) is not an AlphaDev bound.
   - Readings checked: x86, theory, critic, sat2 (via critic) agree. sat, enum, upper, bounds, latency are pending (`agents/spec/readings.md`).
3. **programs/**
   - `alphadev_sort{3,4,5}.s`, `alphadev_sort5_43.s`.
   - `human_sort{3,4,5}.s` (optimal networks, 4 instr/comparator = 18/28/46, exact match with Table 1a).
   - `orig/`: all 18 published sort3..8 programs + original text.
   - `out/`: M_out versions made by `agents/spec/tools/ad2out.py`, which implements the Lemma 4.1 construction.
4. **shared/judge.py**
   - Checks: relaxed (T, flags eq, all weak orders), strict symbolic (garbage symbols, all flag states, branching on garbage cmp), and random int32 (INT_MIN/MAX, ties).
   - Models: reg / mem / out. Isets: I0 / I1.
   - Mutation test: it kills every non-equivalent mutant.
   - Result: all published programs PASS. `upper`'s I0 sort5 (L=42) PASS.
5. **Real-x86 differential test** (`agents/spec/x86/`, done before the task moved to `x86`).
   - AMD EPYC 9654: 1600 edge cases (cmovl/le/g/ge × INT_MIN..INT_MAX × 4 flag states via popfq). 0 mismatches.
   - 25 programs, memory + all registers vs judge. 0 mismatches.
   - `x86` reproduced this independently (45 files).
6. **Prior work** (`agents/spec/prior_work.md`, claims posted).
   - Main prior work: Ullrich & Hack, CGO 2025. k=11 (n=3) and k=20 (n=4, 2-week exhaustive search). Model: I0, permutations only, outputs fixed in r1..rn, 1 scratch register. No certificate. n=5: no bound.

## Numbers
- Core (L - 2n) of AlphaDev = k_out upper bounds: 11 / 20 / 32 in I1.
- I0 upper bounds: 11 / 20 / 32 too. SI Sort3_17 and Sort4_28 pass after le->l, ge->g; `upper` found an I0 sort5 with k=32.
- Fubini 13 / 75 / 541. Judge --strict sort5: 0.8 s.

## Real gap (prior work)
- No certificate-checked lower bound for sort3/4/5 in any cmov model.
- No lower bound at all for sort5.
- No search covers I1 + ties + unbounded registers + any-time stores.

## Open problems
- Readings of §4 from enum, upper, latency are not in yet (sat, sat2, bounds, theory, critic, x86: agree).
- k_out = k_end? A store can act as a free snapshot. This is open; only M_out bounds count.
- MM-1-dropped variant (cmp/cmov with memory source, legal on x86) is open: Lemma 4.1 fails there.
- prior_work.md items marked UNVERIFIED: Tunney blog, HN claims, Mimicry blog.

## Next
- Collect and compare the pending readings; fix §4 if they differ.
- Judge-check every lower-bound claim's model statement (n, k, R, I, C), and every found program.
- If asked: a `--model out` converter to x86 (store placement), for `x86`.
