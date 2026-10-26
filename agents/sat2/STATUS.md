# sat2 status (2026-10-24 20:47) — round 1 done, report board/reports/sat2_round1.md
- Code: common.py, cnf_enc.py (log/binary CNF), smt_enc.py (z3 QF_BV), cegis.py, sweep.sh, bench.sh, ruletest.sh, counts.py.
- Rules: RULES.md (all reviewed SOUND by theory). Cuts: C1 (L7), C2 / n=4 #cmov>=10 (bounds, verified).
- Claims: n=3 M_out I1 k_out=11; n=3 M_out I0 UNSAT k<=10; n=3 fixed I0/I1 k=11 (side); n=4 M_out I1 UNSAT k<=12; speed info.
- Still running (background, logs/): n=4 M_out I1 k=15..19 with C1+C2 (sort4_I1_snapw_cnf_rall_c1c2*_k*.log);
  n=4 k=20 SAT search R=7 (sort4_I1_snapw_R7p_k20.log); n=5 sweep from k=19 (sort5_I1_snapw_cnf_rall_c1c2_k*.log);
  n=3 I0 M_out k=11 SAT search.
