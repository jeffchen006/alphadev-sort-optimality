# codex-fleet FINAL (project stopped by user decision). All workers and pin.sh stopped; all data kept.
Result: NO sort5 program with k<=31 (L<=41) found. Best verified: c=8 cores k=32 (L=42): /path/to/repo/agents/team/codex-fleet/w6/verified/ (144+ strict PASS), candidates/codex-w6_c8_k32.s.
w1 /path/to/repo/agents/team/codex-fleet/w1: copy-reuse family (149,040 seqs) min 5 moves; 7-cmp none, 8-cmp min k=33; delete-2/add-1 on 144 c=8 + 26 c=9 bases none; all 15 near misses lose the unique median (+1 instr -> k=32); 3-partial SAT 14 queries UNKNOWN.
w2 /path/to/repo/agents/team/codex-fleet/w2: c=9 recompute 208 skeletons exhaustive NONE; c=10 21,162 + 300 repeat-cmp NONE (K=31).
w3 /path/to/repo/agents/team/codex-fleet/w3: FJ c=7: 1,157+952 skeletons NONE; insertion <=11 after sort4 UNSAT (2 certs); 603 prefix classes excluded.
w4 /path/to/repo/agents/team/codex-fleet/w4: c=8 shrink from k=33 (471M mutations); SAT windows 352+270 UNSAT (certs), 37 UNKNOWN; free-operand windows.
w5 /path/to/repo/agents/team/codex-fleet/w5: palette c=8 k=32; 755M+4.8B repairs none; 1,720+580 window repairs UNSAT; 797 pairs UNSAT; routing 1,269 c=8 structures NONE.
w6 /path/to/repo/agents/team/codex-fleet/w6: 144 c=8 k=32 variants (6 no-mov); k=31 near miss fails 9/541 (stuck after ~7B edits); 514 c=10 routing NONE, 31 UNKNOWN.
w7 /path/to/repo/agents/team/codex-fleet/w7: repair of fresh31_near: 465 2-pos, 841 3-pos, 299 4-pos windows UNSAT (checked); 5-pos 88 UNSAT/101 UNKNOWN.
w8 /path/to/repo/agents/team/codex-fleet/w8: non-lattice c=9: 29,118 skeletons, 2,598 NONE, 26,520 unknown (list sk/round4_open_cases.json; d1 took half).
w9 /path/to/repo/agents/team/codex-fleet/w9: c=8 orders: 40,320 orders x19 families; SAT 200 UNSAT/5 UNKNOWN of 205 of 306 classes (101 not run).
w10 /path/to/repo/agents/team/codex-fleet/w10: A15 lemma (q partial cols -> <=max(0,q-1) non-lattice full cols; judge: sound under hypotheses); GAPS.md; C2_COVERAGE.md; V1 1,351 / V2 1,929 position cases defined; none decided.
w11 /path/to/repo/agents/team/codex-fleet/w11: independent encoder; 351 UNSAT certs audited = 310 of 1,575 prefix roots; C2: 0/3,280 cases decided.
w12 /path/to/repo/agents/team/codex-fleet/w12: C1 lemma lemma.md (garbage-free mapping, no k increase): judge ACCEPTED; 884,736 construction + 3,488 root-family cases, 0 unknown; GAPS.md; B1 bridge open.
w13 /path/to/repo/agents/team/codex-fleet/w13: far non-lattice c=9/c=8 skeletons: see RESULTS.md (no candidate). w14 /path/to/repo/agents/team/codex-fleet/w14: 10,696 (d1 second half): 10,405 NONE, 291 LIMIT (unknown).
Open: C2 by SAT infeasible (V2 cases UNKNOWN at 1 h, ~20 GB/h proof); >=3 non-lattice cols; bridge B1; all LIMIT/UNKNOWN counts above are NOT negatives.
