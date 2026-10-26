# enum — round 1 report (2026-10-24)

## Done
- Tool `agents/enum/src/enum_out.cpp` (C++/OpenMP, independent of sat): exact layered BFS for k_out in M_out
  (MODEL §4.3), R unbounded, relaxed §2. State = SET of distinct register columns (a column = register content as a
  function of the order type) + flags + outputs taken (+ garbage-register count). Exact dedup (interned columns,
  word-by-word keys), quotient by input relabelling S_n and flag polarity, admissible h = hcmp + max(und, hcmp,
  und + max_j(cover_j - 2)), dead-state rule. All rules with proofs: `agents/enum/PRUNING.md` v3; theory reviewed
  every rule (reviews in agents/theory/reviews/enum_PRUNING_v{1,2,3}*.md): SOUND (v2 NG gap found by theory, fixed in v3).
- Rule NG (v3): in a STRICT-correct program, every read of a never-written register can be rewritten away (same length)
  except "garbage movs". With NG the claim is "no strict-correct program" (= the AlphaDev claim); without NG it is the
  relaxed-model claim. NG cuts the n=4 search about 40x.
- Own checker `src/check.py` (relaxed + strict with garbage registers and 4 initial flag states); TRACE test: h is
  admissible on every prefix of the 15 AlphaDev out programs (sort3/4/5) and 4 team programs.
- Counter `src/count.cpp` (exact DP over raw states, register model).

## Numbers (C = every mov/cmp/cmov counts, outs free; L_AD = 2n + k_out by MODEL Lemma 4.1)
| n | model | I | inputs | result | R | states / time | command |
|---|---|---|---|---|---|---|---|
| 3 | M_out relaxed | I1, I0 | 13 weak orders | none <= 10; k=11 found | unbounded | 17k / 0.2 s | `./bin/enum_out 3 1 1 10 32 1` |
| 4 | M_out strict (NG) | I1 (=> I0) | 24 perms | none <= 18 | unbounded | 55.8M / 698 s | `NG=1 CMAX=12 NOREC=1 ./bin/enum_out 4 0 1 18 64 1` |
| 4 | M_out strict (NG) | I1 | 24 perms | (bound 19: see below) | unbounded | | `NG=1 CMAX=10 NOREC=1 ./bin/enum_out 4 0 1 19 64 1` |
| 4 | M_out relaxed | I1 | 24 perms | none <= 16 | unbounded | 5.0M / 315 s | `./bin/enum_out 4 0 1 16 64 1` |
| 5 | M_out strict (NG) | I1 | 120 perms | none <= 19 (partial) | unbounded | 3.7k / 1 s | `NG=1 ./bin/enum_out 5 0 1 19 32 1` |

Counts (n=3, k=11, register model = outputs in final P_j, R=4, relaxed): I0 perms with cmp i<j only: **5602**
(= Ullrich-Hack's published number, independent repro); I0 perms all: 44816; I0 weak orders: 16224;
I1 perms: 8,786,432; I1 weak orders: 5,830,080; R=5 I0 perms 112,544, weak 48,960.

## Open problems
- n=5: h(root) = 15 vs 32; along AlphaDev's sort5 the bound is exact for the last 9 steps but 17 too low at the start.
  The f-bounded state count grows ~18x per unit of slack: k_out(5) >= 32 needs much stronger bounds (copy/temporary
  counting, better gate bounds) or another method.
- Relaxed (no NG) n=4 bound only to 16: the relaxed model has ~40x more states (lazy "cmov into garbage" columns).
- Compare with sat for n=4 when sat has a result.

## Next
- n=4 bound 19 (if not done in this round), then n=4 counts in M_out; stronger copy/gate bounds for n=5.
