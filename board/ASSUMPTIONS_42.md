# Why we think 42 may be optimal — evidence and its assumptions (coordinator, 2026-10-25 22:30)
Nothing below is a proof. The proved sort5 lower bound is only k >= 19 (c >= 7, g >= 12); the target is k >= 32.
Status column: OPEN = not yet tested outside its scope; CHALLENGED = a result contradicts or weakens it; HOLDS = an
independent test outside the old scope agreed.

## A. Global assumptions (all evidence depends on them; they define WHAT "42 is optimal" means)
| id | assumption | status / note |
|---|---|---|
| G1 | Opcodes = I1 only (mov, cmp, cmovl/le/g/ge). No branches, arithmetic, SIMD, setcc, lea | I2 (+cmove/cmovne/xchg) gave no gain (search); xchg redundant (theory L11) |
| G2 | MM-1: cmp/cmov use registers only (AlphaDev's rule) | CHALLENGED by design: without MM-1 we found L = 39 (MM+). The claim holds only under MM-1 |
| G3 | Correct = sorts all 541 weak orders of 5 int32, any garbage in scratch registers / flags | judge = x86 hardware = ACL2 x86isa |
| G4 | Length counts every instruction, 5 loads + 5 stores required (Lemma L5) | proved (theory L5, Lean) |

## B. Evidence items and the assumptions each one adds
| id | evidence | extra assumptions (scope) | weakest point | status |
|---|---|---|---|---|
| E1 | MCMC (~7e9 proposals, I1/I1x/I2) finds many k=32, never k=31 | A1: stochastic search would reach a k=31 basin if it exists. A2: bounded scratch registers in MCMC runs (-S 4..12) | no completeness; register cap | OPEN |
| E2 | 868,567 optima + 25 network families + ~160 c=8 programs: every k=32 program has budget 9+18+5 or 8+20+4 | A3: our samples represent all k=32 programs (they come from MCMC, network term pools, Codex designs) | sampling bias | weakened 19:50 (c=8 family); census 23:10 (d7): 274,035 correct programs <=32 instr in all team folders, ALL k=32, 30 term-set classes (c=8: 3, c=9: 27); every c=9 has g+v=23, every c=8 g+v=24; one c=9 class found by one method only |
| E3 | Exact routing (dagx) finds no k=31 for all 16 flag classes x 640 lattice skeletons, 177 nine- and 4,609 ten-comparator networks, 1,476 recompute skeletons, 18+ c=8 skeletons | A4: the VALUE SKELETON is fixed (which values are computed/compared); only routing is free. A5: lattice (max/min) cmp operands in the flag-class closure. A6: one comparator order per network class. A7: register cap inside dagx: NONE (d1 confirmed; A7 not applicable to dagx) | non-lattice operands and new value skeletons are NOT covered | OPEN |
| E4 | pool_bfs: no k=31 inside 177 nine- / 4,609 ten-comparator term pools (all orders) | A8: every intermediate value is a term of that network (in-pool) | out-of-pool values | CHALLENGED (weakly, d7 23:10): a c=9 k=32 class (upper's I0 program, found only by fleet/w3) has 18 terms that are NOT any 9-comparator network's term set; its own pool: NONE <=31 |
| E5 | w1 (Codex): network + skipped-mov family, 149,040 sequences, all need >= 5 movs | A9: program = comparators of a network, each cmp + 2 cmov (+ mov); reuse rules as w1 defines them; no gate sharing across comparators. A10: w1's code is correct (Codex-written, not yet checked independently) | not independently verified | A10 HOLDS (judge own checker, 210 random + 13 full sequences, 0 disagreements, 22:50); A9 CHALLENGED: family = 9 FULL comparators, no borrowed flags, no half comparators, only network terms; the known optima (5 full + 8 half, 4 borrows) are OUTSIDE it, so E5 says nothing about them |
| E6 | Local repair: windows w<=7 (SAT), satrep <=3-4 changes, near misses not fixable within 2 substitutions | A11: a k=31 program is "near" a known k=32 program or near miss | local only | OPEN |
| E7 | No c<=8 program with all-lattice cmp operands exists (exhaustive, judge-reviewed); 952 Ford-Johnson c=7 skeletons none | A12: lattice operands (for the exhaustive part); FJ shapes (for c=7) | non-lattice c=7/8 only sampled | OPEN |
| E8 | "A copy moves but does not vanish" (Codex r5: 376 design pools; many methods) | A13: pattern seen in our design pools generalises | heuristic only | OPEN |
| E9 | sort3 = 17 and sort4 = 28 are proved optimal and equal AlphaDev | A14: the pattern continues to n=5 | analogy only | OPEN |
| E10 | Conjecture c=9 => g+v >= 23 | none proved; no counterexample | open problem | OPEN |
| E11 | Plain lattice exact search (d2) k<=31, running (~15 h) | A15 (strong form, judge 23:00): every cmov result is a pure lattice polynomial on the 120 strict perms AND no garbage-partial column (no cmov into a never-written scratch register); relaxed semantics, unbounded registers (<=16 columns, abort-checked), pruning D/H1/H2/H3' of PRUNING.md. Programs with garbage-partial cmovs are covered only if T-elimination is proven AND keeps lattice-ness. d2 data (23:20): of 5000 optima, 2242 have T columns; after TE 1916 are pure lattice (in scope), 4 become non-lattice (0.2% of lattice+T), 322 were non-lattice already; closing the gap (LAT=1 or LAT=3) is infeasible at k<=31. Claim wording: 'pure lattice, no T' | covers only lattice, garbage-free programs | DONE 01:15: NONE <= 31 (1,511,581,916 states, last layer depth 29); tool SOUND by reading (judge) |

## C. Assumptions most worth attacking (red-team list)
1. A4/A8 (fixed value skeleton / in-pool values): search value skeletons that are NOT network terms and NOT lattice.
2. A2/A7 (register caps): re-run the best near-miss repair and a slice of dagx with more scratch registers.
3. A10: critic re-implements w1's copy-count check on a sample of networks (or the whole family).
4. A3: count how many k=32 programs come from each method; look for k=32 programs no method has seen (e.g. Codex free invention w6 found the c=8 family that nothing else saw: A3 already weak).
5. A11: global (non-local) searches seeded from the c=8 family.

## D. Watch rule
Every new result: say which assumptions it relies on. If a result breaks or weakens an assumption (e.g. a new budget
family, a candidate outside a closed scope, a near miss that improves past a "closed" area, a bug in a tool), post
`ASSUMPTION CHALLENGED: <id> — <what>` with bin/notify coordinator and update the status column here.
Log of changes:
- 2026-10-25 19:50: A3 weakened — Codex w6 found the c=8 budget family (8+20+4) that MCMC and the network pools never produced.

## E. Register caps and exact scope of each closed search (sort5-lead, 2026-10-25 22:40)
| tool (owner) | register cap (A2/A7) | exact scope of a "NONE" result |
|---|---|---|
| dagx (d1) | NO cap: values are DAG nodes, each copy gets a fresh register (dagx.cpp prints S0,S1,.. with nsc++); copies = gates - max in-place (judge-reviewed). R unbounded = relaxation (CONFIRMED by d1 22:45: no cap; normal form avoids reading untouched registers) | fixed VALUE skeleton (exact cmp operand columns, in order), any cmov values incl. non-lattice, 120 perms (relaxation of 541), out snapshots. Flag-class runs: all lattice operand alternatives with the same flags |
| pool_bfs (d7) | R = max(arg, 5 + K - minCreations - minBlocks), auto; = 9 at K=31 for the 9-comparator pools, 10 at K=32, 7 for 10-comparator pools; aborts if > 12 (judge-reviewed) | every register value is a term of the given pool (full columns); any order; out snapshots; v2 adds sound alive() prune |
| winsat (d6) | all registers of the program + max(2, min(#removed dead scratch, slots)) fresh (fixed after judge) | window [i,i+w) replaced by any <= w-d instructions; rest of program fixed; 541 weak orders, strict |
| satrep (d4) | registers used + 2 fresh (rextra=2) | Hamming <= Q changed slots of the given program, exactly K slots (dead instr allowed); relaxed T model (UNSAT => strict UNSAT) |
| rep2 (d4) | registers used + 1 fresh | all 1-2 substitutions (NOP allowed), strict |
| core_sat (d5) | agents/sat encoder register model (normal form) | dead-free normal-form programs containing the core dataflow (all TIMEOUT -> no claim) |
| gensk (d1) | n/a (skeleton level) | all lattice skeletons c<=8 (no column cap, B=3): none sorts |
| d2 lat_d2 | enum state model (register set implicit, R unbounded as in MODEL 4.3) | all programs whose register values are all lattice terms, no T column (LAT=2) |
| MCMC (upper, d6 qd) | -S 4..12 scratch registers per run | stochastic, no completeness |
| w1 Codex | per w1 code (unchecked, A10) | network + skipped-mov family as w1 defines it |
Tagging rule from now on: every result in board/team/STATUS.md and every coordinator note carries [A..] tags of the
assumptions it relies on.
- 2026-10-25 22:50 (sort5-lead): A10 holds (judge re-check agrees); A9 challenged: w1's family excludes borrowed flags / half comparators, i.e. excludes the structure of all known optima; E5 is scoped to that family only.
- 2026-10-25 23:00 (sort5-lead): A15 narrowed (judge review of lat_d2): E11 excludes programs with garbage-partial cmovs unless T-elimination is proven and preserves lattice-ness.
- 2026-10-25 23:10 (sort5-lead): A8 weakly challenged (k=32 class outside network pools); A3 census added (30 classes, all budgets 9+23 / 8+24).
- 2026-10-25 23:05 (sort5-lead): A2 test (d4): fw14 near miss, satrep Q=3 with 4 fresh registers instead of 2: still UNSAT -> register cap not the blocker there (HOLDS for this test). d6 window re-run with 4 temps pending.
- 2026-10-25 23:15 (sort5-lead): A15 gap check: the 4 TE exceptions (lattice+T optima that become non-lattice after TE) have the cmp skeleton of optimum class vc02; dagx (non-lattice cmov values allowed) finds no k=31 routing for them [A4].
- 2026-10-26 01:15 (sort5-lead): E11 finished: no pure-lattice no-T program with k<=31.
- 2026-10-26 01:12: E11 RESULT (d2, exhaustive, judge-reviewed tool): NO pure-lattice no-T sort5 with k<=31 (1.51e9 states). A k=31 program must use a non-lattice column or irreducible garbage-partial routing (A15 gap).
- 2026-10-26 05:00 (sort5-lead): A2 test 2 (d6): fw14 window repair w=4..6 with 4 fresh temps: still UNSAT -> register cap not the blocker (HOLDS for this test).
- 2026-10-26 07:00 (sort5-lead): A15 WIDENED (Codex w10 one-column lemma, judge: SOUND as sketch under hypotheses: all cmps read defined columns, all original full columns lattice, I1, free outs): a program with at most ONE garbage-partial written column maps to an all-lattice program of the same length, so d2's NONE<=31 also covers it. q=2,3 partial columns: not covered.
- 2026-10-26 07:30: A15 widened (w10 one-column lemma, judge: sound as sketch): programs with at most ONE garbage-partial column map to all-lattice programs of equal length, so d2's result also excludes them. Open: 2-3 partial columns, cmps on undefined values.
- 2026-10-26 08:00 (sort5-lead): E11 positive control PASS (d2): from states of 2 known pure-lattice k=32 programs after t=8..24 instructions, lat_d2 finds exactly 32 - t + Phi (9/9 cases); so the k<=31 NONE is not a tool failure.
- 2026-10-26 09:20 (sort5-lead): C1 accepted by judge (Codex w12 lemma): every strict-correct program maps to a garbage-free program with no greater k and no more cmps. So the garbage part of A15 is closed; what remains of A15 is 'all columns lattice' (E11) vs. programs with non-lattice columns (C2 V2 covers <= 2).
- 2026-10-26 08:51: C1 lemma (Codex w12, judge accepted; 5,606-program test, 0 failures): every strict-correct program -> garbage-free program with k and #cmp not increased. The garbage gap of A15 is CLOSED. Direction (a) = garbage-free, <=2 non-lattice written values: d2 lattice run (done) + V2 1,929 LRAT cases (running).
