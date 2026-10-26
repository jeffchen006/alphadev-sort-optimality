# critic — round 1 report (2026-10-24)

## Done
- Model attack: `agents/critic/THREATS.md` (17 threats). Found and reported early: (1) AlphaDev sort3 (repo) and sort5 need
  cmovle/cmovge ⇒ claims must be in I1; (2) MODEL v0 "P_j at the end" (RF) is NOT a relaxation of AlphaDev's
  store-any-time rule ⇒ snapshot model. Both are now fixed in MODEL v1.2 (M_out = theory RS, Lemma 4.1 = L5).
- Own tools (no shared code): `asmcheck.py` (AT&T repo file), `progcheck.py` (strict checker, supports `out`),
  `bf.cpp` (register-multiset IDDFS, prunings + proofs in `BF_NOTES.md`), `bf2prog.py` (witness → .s).
- Reviews (`board/review.md` R1–R18): theory lemmas.md v1 (sound under MM-1; remarks in `REVIEW_theory.md`, all applied),
  sat2 RULES.md, sat RULES.md, enum PRUNING.md, bounds BOUNDS.md — all sound at paper level; joint soundness checked
  (state-based dedup in enum; one order per encoder in sat/sat2; measure argument in sat incl. comm × movfresh).
- Re-ran every "verified" claim that fits 2 cores (judge loop, programs/out, upper sort5-I0, x86 opcode tests + edge test,
  enum n=3). Confirmations appended to `board/claims.md`.

## Numbers
| claim | n | k / L | R | I | C | result | tool |
|---|---|---|---|---|---|---|---|
| no M_out program, k ≤ 10 | 3 | L ≤ 16 | unbounded | I1 | AlphaDev (L = 2n+k, MM-1) | UNSAT all k = 0..10 | critic bf (1577 s) + enum (31 s): AGREE |
| same | 3 | L ≤ 16 | unbounded | I0 | same | UNSAT k ≤ 10, SAT k = 11 | critic bf + enum: AGREE |
| new witness | 3 | k = 11, L = 17 | 4 regs | I0 | same | 0 mov, 3 cmp, 8 cmov, judge --strict PASS | `programs/found/critic_sort3_I0_k11_out.s` |
| #cmp ≥ ⌈log2 n!⌉ | 3–5 | 3/5/7 | any | I0/I1 | any | proof (critic sketch = theory L7) | paper |
- ⇒ sort3: AlphaDev 17 is optimal in M_AD(3, I1) (two independent search tools; NO certificate yet).

## Refuted
- Only my own tip "permutations + I0 relaxes weak orders + I1" (cmp of two copies gives eq). Corrected in all inboxes.
  No refutation of any other agent's claim.

## Open problems (for the paper / referees)
1. T5 / MM-1: x86 allows `cmp r, m` and `cmovcc r, m` (memory source). The model excludes them by choice; state it, and
   test variant MM+ (`upper`).
2. Certificates: n=3 result rests on two search programs; need DRAT/LRAT (sat, sat2) for RS + I1 at k = 10.
3. Relaxation gap (T9): relaxed RS allows garbage-destination cmov (illegal in AlphaDev's game, legal x86). Sound, but my
   n=3 witness shows such programs reach the optimum; they could beat AlphaDev for n = 4/5 in real x86 only.
4. n=4 (k ≤ 19) and n=5 (k ≤ 31): my tool cannot reach them; I can only check certificates / small instances.
5. bounds R1 "n=3 min #cmov = 6": re-run, confirmed (m ≤ 5 none).

## Next
- Re-check sat/sat2 RS n=3 numbers when posted (must equal 11 in I0 and I1); check certificate logs (proofs) for n=3/4.
- Run RF/RE n=3 minima to cross-check sat2 side results. Re-review rule files after theory sign-off; review Lean statements
  against MODEL v1.2 (does the Lean theorem state n, k, R, I, C and the RS output rule?).
