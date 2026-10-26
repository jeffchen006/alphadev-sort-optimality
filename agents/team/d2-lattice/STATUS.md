# d2-lattice FINAL STATUS (2026-10-26, project stopped by user decision)
RESULT (search, judge-reviewed): no pure-lattice sort5 with k_out <= 31. lat_d2/lat_d2c LAT=2, RESULT none<=31.
 Scope: M_out(5,I1), set model (CMAX=16, max seen 13, abort-checked), PRUNING.md rules, 120 strict orders, relaxed T,
 every column a lattice term (min/max of inputs), no T-partial column. 1,511,581,916 states, 33,258 s, 12 thr, 9.3 GB.
 Log logs/k31_ext.log; data ext31/ (cert/ per depth, cols.bin, flags.bin; 49 GB). Includes all min/max-DAG programs.
Tools: lat_d2.cpp = sort5-lab lat_out + caches (6.7x; same per-depth counts k<=26/27); lat_d2c = + cand compaction.
Positive control [A15]: from the state after t instr. of known k=32 lattice programs, min = 32-t+Phi: lat32_0
 t=24/20/16/12/8 -> 8/13/16/21/25, lat32_1 t=24/20/16/12 -> 8/13/16/21 (logs/ctl_summary.txt). TRACE: h never cuts them.
TE data (te.py, 5000 k=32 optima): 2242 with T columns; after TE 1916 pure lattice, 4 non-lattice (te_exceptions.s;
 d1 dagx K=31 NONE), 322 non-lattice before TE; all stay correct. LAT=1 (T-partials free) k<=22: 7.6M at depth 7: no-go.
Escape data (escstat.py, 729 escapes): operands lattice, dies inside its cmp block, never compared, life <= 4.
Cost estimates (no-go): ESC=1 k24/25/26 = 1.38M/7.76M/42M -> k31 ~2e11; ESC=2 k22 736k (ESC=1 51k) -> ~3e12;
 A15-sel (escape dies in block) k26 6.78M -> ~2.3e10; LAT=5 (T-partial in first 2 blocks) k22 7.7M at depth 8.
 MINMAX k26 = 98% of LAT=2; MMH rule cut 0; CEXACT split 1.4x more states.
C2 (SAT position cases, w10 threshold encoder; V1 + V2 = cmp on exceptions, c2/): STOPPED. 24 cases x 1 h: 0 decided
 (all UNKNOWN, incl. 0-exception v2_c10_21_21). Proofs ~20 GB/h/case. Calibration v2_c10_21_21 stopped at ~1 h
 (cadical, kissat: no result). Manifest c2/MANIFEST.md, controls c2/controls, cube + cover tools c2/src.
 => garbage-free programs with 1-2 non-lattice written values: OPEN with current tools.
Side: G(root) SAT (min AND/OR gates for 5 thresholds) n=3: 6, n=4: 10; n=5 G<=17 not decided (sat/moncirc2.py).
