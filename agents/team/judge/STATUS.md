# judge FINAL STATUS (2026-10-26)
Result: no k<=31 candidate was ever received. Verified candidates (board/team/candidates.md): upper_sort5_I1_k32 and codex-w6_c8_k32
(k=32, L=42, judge out+mem PASS, x86 3/3, MM-1 0). Tools: agents/team/judge/judge_one.sh, out2mem.py, dira/ (C2 checks), c1/ (C1 test), a10/ (A10 checker).
All verdicts below are from reading code/proofs plus the small checks named; none re-ran a full search unless stated.

## Reviews (verdict; scope of the negative)
- dagx.cpp (d1): SOUND. Per exact cmp-operand-column skeleton (not flag skeleton), 120 perms relaxation. COMMON-columns bound: admissible.
- winsat.py (d6): SOUND for its pool. Caveats: scratch registers removed/fresh limit (fixed by d6: temps = max(2,min(removed,slots))); d!=s excludes cmp r,r.
- rep2.c (d4): SOUND, <=2 substituted slots (NOP allowed), strict model, used regs + 1 fresh enough. satrep.py: SOUND, <=Q changed slots, exactly K slots, relaxed model, no symmetry rules.
- core_sat.py (d5): SOUND for dead-free normal-form programs <=K containing the core dataflow; only hcmp part 1 used (checked).
- gensk.cpp (d1): index-consistency filter and 3-way class bound sound; "refining or not" for c<=8 sound (delete non-refining cmps); cap of 10 computed columns excluded 14/16 known optima -> must be >=16 (d1 to confirm run settings). Lattice-only scope.
- pool_bfs v1 (d7): SOUND, admissible bound; scope = pool + R (R>=5+K-creations-blocks must be asserted). v2 alive() prune: SOUND.
- lat_d2 / lat_d2c (d2): SOUND by reading (canonical cache, lattice cache, compaction, resume). "none<=31" scope: 120 strict perms, relaxed T, pure lattice, no T-partial columns, set model, CMAX=16 (aborts, maxcols 13), PRUNING.md rules. TRACE check on 3 k=32 lattice programs: 0 violations. Positive control K=32 not run.
- w10 lemma (q partial -> <=q-1 non-lattice): SOUND under hypotheses (cmps read defined values, other full columns lattice). q=1 -> all-lattice, so d2's result covers <=1 partial column. Mixed case with non-lattice FULL columns is NOT covered.
- w12 lemma C1 (garbage-cmp removal, no cost increase): ACCEPTED SOUND. My independent implementation: 5,606 random accepted programs (n=3, len<=8), 0 failures. Cost invariant E+Phi<=t checked; class-root +1 worry resolved.
- A10 (w1 network + skipped-mov family): AGREES (own checker, 210 random + 13 + 4 witnesses, min mov 5..8 match). Family is narrower than all 9-cmp programs (no borrowed flags / half comparators).
- C2 encoders (w10 threshold_sat = V1, d2 threshold_cmpx = V2): SOUND (semantics, symmetry, case split 1+m+C(m,2), c>=7 for all programs, c<=15 for shortest). Base CNFs c=9,12 rebuilt: sha256 match. Own n=3 controls k=11 SAT, k=10/9 UNSAT (V1,V2). n=4 k=20 control: UNKNOWN at 600 s.
- d2 C2 case runner (run.py, cube cover certificates): SOUND design (LRAT + lrat-check, proofs kept). RESULT: 0 cases decided (all UNKNOWN at 1 h), so NO C2 certificate exists. checkcase.py/certcheck.sh ready, never used on real cases.

## What is established vs open
Closed (judge-reviewed): pure-lattice no-T programs k<=31 (d2); <=1 garbage-partial column (w10); garbage-cmp removal (C1).
Open: garbage-free programs with 1..2 non-lattice written values (C2 SAT infeasible, undecided); >=3 non-lattice values; bridge B1/B2 (bound on non-lattice columns of C1's output; mixed non-lattice-full case).
