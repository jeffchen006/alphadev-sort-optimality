# latency — STATUS (2026-10-25 00:20) — role PAUSED by coordinator after current task

Report: board/reports/latency_round2.md (round 1: latency_round1.md).
Running (no action needed; results land in logs/):
- relax.py 5 1 5 --T --perm -> logs/rperm_5_1_5.log (UNSAT => sort5 min depth 6; then ./prove_relax.sh-style LRAT)
- rdls.py 5 {1,2} 5 seeds 1..30 -> trees/n5_j{1,2}_D5.tree if found (=> min depth 5; compile with trees2prog.py --i1)
Key tools: prog.py, depth_all.py, relax.py, relax_joint.py, lsched.py, trees2prog.py, rdls.py, regls.py, lrat_check.sh.
