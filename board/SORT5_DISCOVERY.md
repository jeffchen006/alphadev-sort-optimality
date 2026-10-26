# sort5 discovery plan (coordinator, 2026-10-25) — goal: a sort5 SHORTER than AlphaDev's

Target: a strict-correct program in M_AD(5, I1) with L <= 41 (register core k_out <= 31, M_out §4.3), MM-1 kept
(no memory operand in cmp/cmov). Every find: `shared/judge.py --strict --model mem` + x86 hardware run + critic.
Start: after the sort4 Lean check passes (user decision 2026-10-25). Proof work on sort5 is parked
(effort estimate: board/SORT5_PROOF_EFFORT.md, owner theory).

## What already failed (do not repeat as is)
- upper: STOKE-style MCMC, ~7e9 proposals, I1 / I1x / I2, 2000 network seeds, 300 warm starts: best k = 32.
- Every known optimum has c = 9 cmp, W = m + v = 23, >= 2 cmov per cmp block, all cmov results lattice polynomials
  (max/min of inputs) in 48 % of sampled optima, cmp operands lattice in ~100 % (sort5-lab round 2).

## New directions (discovery-driven, each one owner)
| id | idea | why it may find what MCMC missed | owner |
|---|---|---|---|
| D1 | Skeleton + exact routing: enumerate cmp skeletons (which values are compared, in which order, comparisons between COMPUTED values allowed, c = 7..10), and for each skeleton solve the routing (cmov/mov placement) EXACTLY with SAT/search at k <= 31 | MCMC mixes skeleton and routing; the routing subproblem is small and SAT is strong on it; skeleton space can be enumerated up to symmetry | enum (skeleton gen) + sat (routing SAT) |
| D2 | Lattice-DAG synthesis: search over shared max/min expression DAGs for the 5 outputs (cost model: one cmp feeds several cmovs; copies cost 1), then compile to cmov code | AlphaDev-style savings come from sharing min/max sub-terms; a DAG search sees sharing directly | sort5-lab (with Codex) |
| D3 | Non-network algorithms with c = 7 or 8 (Ford-Johnson-like, merge 2+3, insertion of x5 into an optimal sort4): minimise routing for these skeletons | fewer cmps leave more budget for routing; c = 7/8 programs exist (72 instr.) but were never optimised for length | bounds (case data) + sat |
| D4 | LLM-guided evolution (AlphaEvolve / FunSearch style): Codex and Claude propose program edits / templates, an evaluator scores (wrong order types, length), keep a diverse archive (MAP-Elites over c, m, v, depth) | proposals with structure that random mutation cannot make | sort5-lab + codex |
| D5 | Compose from sort4 optima: take the ~20k shortest sort4 programs (k = 20) and search the cheapest extension that inserts x4 (shared flags, reuse of max/min) | sort4 optima are known exactly; extension space is small per program | upper |
| D6 | Quality-diversity MCMC: restart upper's MCMC with novelty / MAP-Elites archive and large-neighbourhood moves on whole cmp blocks | escapes the k = 32 basin | upper |

## Rules
- Report a candidate only after the strict judge passes. Post `programs/found/<agent>_sort5_*.s`.
- Negative results count: post per-skeleton / per-family "no k <= 31 here" with the method (search, not proof).
- CPU: up to ~80 cores for this phase; RAM per job <= 64 GB.
