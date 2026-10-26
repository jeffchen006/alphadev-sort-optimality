# sat — round 1 report (2026-10-24)

Model in every line: MODEL.md v1.x, M_out (snapshot outputs, `out j, S`), relaxed §2 (scratch = T, flags eq),
R = n + k, k = #mov + #cmp + #cmov, L_AD = 2n + k_out (Lemma 4.1). Main iset I1; I0 = variant.
Rules: `agents/sat/RULES.md` v3 — canon, pcanon, comm, dead, flags, cmpord, movfresh, snapcmov + cut hcmp; theory
reviewed all as SOUND (reviews in agents/theory/reviews/). "r8" = the 8 rules; "h" = r8 + hcmp. nop mode = length <= k.
Test set = all n! permutations (sound subset of the weak orders, theory L1b).

## Done
- Own tools in `agents/sat/`: `sim.py` (parser + simulator), `encode.py` (one-hot SAT encoder; n, k, R, I0/I1,
  outputs fixed|free|snap, nop mode, rules, cuts), `test_enc.py` (encoder == simulator on random programs: 0
  mismatches), `cegis.py`, `gen_full.py`, `solve_full.py`, `prove.sh` (cadical LRAT -> cake_lpr), `cubes.py`
  (cube-and-conquer, per-leaf LRAT + cake_lpr, summary proof), `normalize.py`, `validate.py`, `knuth.py`.
- cake_lpr (CakeML-verified LRAT checker) built from github tanyongkiam/cake_lpr in `agents/sat/tools/`.
- Found bug in my own first version (liveness variables had only one direction: rules dead/flags were empty); fixed
  before any claim. Withdrew rule cmpT (unsound: `cmp y, T` tests y == T).

## Numbers
| n | iset | output | k | result | evidence |
|---|---|---|---|---|---|
| 2 | I0, I1 | snap, fixed, free | 4 | min k = 4 in all variants and all 20 rule sets | validate.py |
| 3 | I1 | snap | <= 10 | UNSAT, h: cadical 668 s, **cake_lpr VERIFIED** (310 s) | proofs/n3_I1_snap_k10_h_perm.cnf sha256 9703b8e5… |
| 3 | I1 | snap | <= 10 | UNSAT, r8 (no cut): cadical 3950 s, **cake_lpr VERIFIED** (1156 s) | f3_I1_snap_k10_r8_t.cnf sha256 2002fda0… |
| 3 | I0 | snap | <= 10 | UNSAT, h: 414 s, **cake_lpr VERIFIED**; r8: 1904 s, **VERIFIED** | sha256 d8ec81bd… / dae39dce… |
| 3 | I1 | snap | 11 | SAT: programs/found/sat_sort3_k11.s, judge --strict PASS | solve_full.py, 215 s |
| 3 | I0, I1 | fixed (P_j at end) | <= 10 / 11 | UNSAT / SAT (kissat, no certificate) => k_fixed(3) = 11 | logs/full3_fixedfree.txt |
| 3 | I1 | free (end) | 11 / 10 | SAT / open (1 h timeout) | |
| 4 | I1 | snap | 12 | UNSAT, h, kissat 289 s (with #cmov >= 10: 1 s, pure counting) | |
| 4 | I1 | snap | 13 | UNSAT, h, kissat 5634 s (factor ~20 per k) | |
| 4 | I1 | snap | 15, 16 (h + #cmp>=5 + #cmov>=10); 19 cases #cmp=8,7 | TIMEOUT 4 h (k=15,16), 2 h (cases) | |
| 4 | I1 | snap | 19, #cmp=9 (direct and 9 block cases) | still running (8 h limit, ends ~07:20) | agents/sat/logs/n4_c9_*.txt |
| 4 | I1 | snap | 20 | normal forms of 12 known optima accepted by the encoder; sat_sort4_k20.s judge PASS | normalize.py |
| 5 | I1 | snap | 32 | normal forms of 3 known optima accepted (no class cuts); sat_sort5_k32.s judge PASS | normalize.py |

enum (round 2, 23:45): sort4 k<=19 none (strict model, 1.39e9 states) -> SAT gives no second tool for n=4 yet.

=> **k_out(3) = 11 (I1 and I0), so L_AD(3) = 17 is optimal**, with 4 independent cake_lpr certificates (2 isets x
{with, without} the hcmp cut). Same minimal k as enum, critic (bf.cpp), sat2, lean-lrat (k <= 9 so far).

## Rule validation
- n=2: same min k for rule sets none / all / all-minus-r / only-r, all output modes, perms and weak orders.
- n=3: k=11 SAT under all 20 rule sets; k=10 UNSAT with all rules (certified), with r8 (certified) and with each
  rule switched off in turn (9 sets, pysat). So min k = 11 is independent of every rule.
- 20 known optimal programs (sort3 x5, sort4 x12, sort5 x3) rewritten into my normal form keep their length and are
  accepted by the full encoder: the rules do not exclude real optima at n = 4, 5.

## Cost of sort4 / sort5 (why no sort4 bound this round)
- n=4 single solver: k=12 289 s; k=13 > 2 h => growth factor per k > 25.
- Knuth estimate of cube-and-conquer (random UP-consistent 8-instruction prefixes, kissat leaves) at k=19:
  #cmp = 9 case: ~1.5e13 leaves, ~3e10 core-h; #cmp = 5: 1e14 - 2e15 leaves. (Calibration n=3 k=10: estimate 2.1e4
  leaves / 3.1 core-h, real 1.75e4 / ~3 core-h; direct CDCL there was 15x cheaper than cubes.)
- n=5 k=31: encoding 0.7 M vars, 5.4 M clauses for 120 perms + 42 M clauses for class cuts. Not attempted.
- Conclusion: the syntactic register encoding cannot certify sort4 k <= 19 in round 1, direct or by cubes.

## Open problems
1. sort4 / sort5 lower bounds: not reachable with this encoding (numbers above).
2. n=3 free (end) k=10 open (not an AlphaDev bound).
3. Form-invariant case split (#cmp = c, cmov block sizes b_j; split_cases.py) ready and shared with sat2; 4429 cases
   for sort4 k<=19. n=3 test: 51 cases, 646 s total (direct 723 s), so no CPU gain, only parallelism.

## Next (proposal for round 2)
- Semantic cubes: cube = abstract state after d steps (contents per type, flags, snapshots, and the rule state:
  touched sets, pending cmp), as in enum's dedup. Per state: SAT suffix instance from that state, LRAT. Coverage:
  one SAT instance "prefix of length d reaches a state outside the list" UNSAT, LRAT. Many syntactic prefixes collapse
  into one state, so the leaf count drops by orders of magnitude. Needs enum's state counts per depth (n=4).
- Stronger cuts per suffix: enum H3 cover bound, bounds' #cmov >= 10 (n=4) / 12 (n=5) per suffix.
- Share form-invariant case splits (#cmp, #cmov, #mov exact) with sat2 so both encodings solve identical cases.
