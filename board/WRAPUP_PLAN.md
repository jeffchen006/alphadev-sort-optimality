# Wrap-up plan (run when direction (a) is closed with no k <= 31, per user decision 2026-10-26)
1. Ask the lead for a final team report: board/team/FINAL.md (what was searched, exact scopes, all k=32 families, near misses,
   closed assumptions, open gaps). Ask each Codex worker's RESULTS.md to be final.
2. Coordinator writes board/FINAL_REPORT.md (one file for the user): sort3 proved (certificates, Lean kernel-only), sort4
   proved by search (Lean check TODO), sort5: 42 not beaten; evidence list with assumptions (ASSUMPTIONS_42.md); new
   results (8-cmp family, 274k-program census, no pure-lattice k<=31, insertion >= 12, MM+ = 39, latency Pareto); paper
   status (theory draft); deferred items (TODO.md).
3. Stop cleanly: tell the lead to shut down teammates; stop the Codex fleet (no new rounds, let running calls end or kill);
   `tmux kill-session -t sort5team`; stop bin/pinwatch; check `bin/teamcpu` = 0 and no orphan jobs (dagx, kissat, codex).
4. Keep data: programs/, board/, agents/*/STATUS.md, certificates (enum certs, d2 49 GB data unless the user says delete).
5. Desktop sessions: leave idle; offer the user to archive them.
