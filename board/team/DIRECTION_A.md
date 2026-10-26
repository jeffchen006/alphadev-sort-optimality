# Direction (a): definition of "finished" (sort5-lead, 2026-10-26 08:00; user decision via coordinator)
Model: M_out(5, I1), strict (all 541 weak orders, any garbage), MM-1, k = #mov/cmp/cmov <= 31.
Already excluded (judge-reviewed): (E11) every program whose register columns are all lattice terms with no
garbage-partial column (d2 exhaustive, 1.51e9 states); (w10 lemma) every program with <= 1 garbage-partial written
column, if all cmps read defined values and the other full columns are lattice.

SCOPE of (a) = the remaining programs with k <= 31 in which, after w10's scratch elimination,
  (a1) at most 3 written columns are garbage-partial or non-lattice in total (w10 lemma: q <= 3 partial columns ->
       a full program with <= 2 non-lattice written columns), all other columns lattice; AND/OR
  (a2) some cmp reads a garbage-dependent value.

(a) is FINISHED when both hold:
 C1 (a2): judge accepts a written lemma that a cmp on a garbage-dependent value can be removed or replaced at no cost
     in a strictly correct program (so (a2) reduces to (a1)), OR (a2) is searched exhaustively at k <= 31 with
     checkable certificates. Owner: Codex w12; review: judge.
 C2 (a1): every case of "k <= 31, full columns lattice except <= 2 non-lattice written columns" is decided: w10's
     254 position cases (and any case split w11 uses) are all UNSAT, with DRAT/LRAT certificates checked
     (bin/drat-trim, bin/lrat-check) for every case, and the encoder reviewed by judge. No UNKNOWN left.
     Case split (d2, 08:55): c=9: 254 cases; c=10..15: 1,097 more (c<=8 with lattice cmp operands closed by gensk [A12]).
     judge 09:00: w10 encoder SOUND by reading + n=3 validation; C2 scope = image of w10 lemma (exceptions never cmp operands),
     120 strict orders (relaxation), c=9..15 all needed.
     judge 09:10: encoders V1 (w10 threshold_sat.py) and V2 (d2 threshold_cmpx.py, exceptions may be cmp operands) SOUND;
     base CNFs rebuilt and hashes match; c range 7..15 (V2) / 9..15 (V1) correct; split 1+m+C(m,2) complete.
     Final scope sentence: copies count as separate non-lattice columns.
     Variant C2b needed: <= 2 ORIGINAL non-lattice full columns that may be cmp operands (reopens c=7..8; gensk is lattice-only).
     Owners: Codex w10 + w11, d2-lattice (case runner on team cores); review: judge.
 Any FOUND program goes to judge at once and ends (a) with a positive result.
NOT in (a) (stays open, stated in the final report): >= 4 garbage-partial/non-lattice columns; MM-1 dropped; other ISAs.
Priority: (a) first. CPU from 08:00: d2 24, Codex fleet 20 (w10/w11/w12 4 each), d1 8, d5 8, d6 8, d4 6, d7 4.
STATUS 09:00: C1: w12 delivered (884,736 + 3,488 cases, 0 unknown) -> judge review. C2: V1 1,351 cases (c=9..15), V2 1,929 cases (c=7..15), owner d2 (proofs kept, judge re-checks all); w11 independent encoder cross-check (286/1,575 roots decided); 0 C2 cases decided yet. Open: 'C1-to-C2 column bound' and 'mixed three-column reduction' gaps (w10/w12 to write up for judge).
UPDATE 09:20 (judge accepted C1 = Codex w12 lemma: any strict-correct program maps to a GARBAGE-FREE program of
no greater k, cmp count not increased). Restated scope (judge recommendation, lead decision):
  (a) = all garbage-free M_out programs with k <= 31 and at most 2 non-lattice written values (mov copies counted),
        any cmp count c = 7..15. Covered by: d2 pure-lattice run (0 non-lattice, done) + C2 variant V2 (1..2
        non-lattice, may be cmp operands; 1,929 cases c=7..15, LRAT-certified, judge re-checks all).
  V1 (exceptions never cmp operands) is a subset of V2 -> dropped.
  C1 status: DONE (judge accepted).  C2 status: = V2 cases all UNSAT with checked proofs.
  OPEN after (a) (to be listed in the final report): garbage-free programs with >= 3 non-lattice written values; no
  proven bound linking P's partial-column count to the non-lattice count of C1's output (bridge B1).
UPDATE 09:15 (d2 rate report): C2/V2 by SAT is INFEASIBLE with current tools: first 12 V2 cases (c=10) all UNKNOWN at 1 h,
  incl. the pure-lattice case v2_c10_21_21 that d2's BFS decides; proofs grow ~20 GB/h/case; calibration: the same formula
  style for sort4 k=19 (known UNSAT) is also UNKNOWN after 1 h. Exact search alternative (lat_d2 + <=e non-lattice cols):
  ESC=1 ~2e11, ESC=2 ~3e12 states at k<=31 -> NO-GO. SAT runs stopped; one 24 h calibration run (v2_c10_21_21) kept.
  Status of (a): CLOSED for 0 non-lattice values (d2 BFS + C1); OPEN for 1-2 non-lattice written values.
END RULE: when C1 and C2 hold, sort5-lead sends `DIRECTION A CLOSED: <scope>, <result>` to the coordinator and the team starts no new work (coordinator runs the wrap-up).
