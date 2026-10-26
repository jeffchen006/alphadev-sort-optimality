# proofs STATUS (2026-10-24 20:29)
Running (4 cores): sort3 k=10 snap I1 13 types — ll_k10 F0 (rule-free, verified enc), ll_k10 F1 (canon), rc_ll_k10_inp F1 (canon+pcanon), k10_I1_snap F1 (sat enc). LRATs of ll F1 runs kept as F1.lrat.keep.
Done: tools incl. CakePB, satsuma, dsr-trim; check_unsat.sh; cc_check.py; VeriPB+CakePB SB certificate (full_proof.py, verified at k=4).
Next: when a k=10 run ends: cake_lpr result + full_proof.py -> cake_pb_cnf; cc_check on sat's cc run; post sha256s for critic.
