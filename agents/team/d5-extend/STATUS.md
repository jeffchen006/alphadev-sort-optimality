# d5-extend FINAL STATUS (2026-10-26, project stopped; all jobs stopped, data kept)
best k: none <= 31 found. All negatives = dagx (d1) K=31 over 120 perms, relaxed: search, not proof. No FOUND anywhere.
1. Reverse view (rev2.c, all 868,567 s5k32): x_m=+-inf fold + greedy DCE -> sort4 L4<=21; L4=20 for 600,553 (ext=12).
   Ext = 4 cmp + 8 writes in 96.6% (213,676 sample); >= 1 core cmov reads an ext flag in 100%. Cores in optima: 0 in s4k20_coll.
2. Insertion (suffix family): mine K<=9 UNSAT, K=11 c=4,5 UNSAT (agents/sat rules, kissat; c=3, K=10-12 TIMEOUT).
   Closed by Codex w3 round 4 (DRAT verified): any P4-free prefix + <= 11 instr cannot sort -> "sort4 then insert" k >= 32.
3. Templates (gx/, core cmp columns fixed + ALL lattice ext cmps, genext gensk rules, cap = no restriction):
   360 unique templates (tplu.txt). DONE all NONE: u1=t1 2,328 (52% of optima), u31 64, u32 2,328, u33 64, u34 388, u35 192.
   PARTIAL (rest UNKNOWN): u2 1,233/2,328, u36 2,449/2,770. Not run: u3..u30, u37..u360.
4. Pair tracking c=8 (pt/): c=7 cond-perm networks: none sorts. PT1 (one flag per cmp 7/8, closure-2 lattice halves)
   on pos33 prefix = w6 prefix: 7,664/7,664 NONE (17,024 deduped by stabilizer 4). PT2-last (two flags, w6 form,
   ~9.5e11): random sample 552 NONE (sampled). d4 skel_r3p c=7: 100/100 NONE. One-flag PT of other 60 d4 prefixes: not run.
5. Two-select neighbours (neigh2.cpp: one operand of one cmp changed on one (f_k1,f_k2) quarter, closure-2 lattice):
   fw14 3,881/3,881 NONE (d1: one-select 120 NONE). fresh31_near 1,610/4,554 NONE (rest UNKNOWN). w6 3,627: not run.
   Seed counts for 161 c=8 seeds: pt/n2/counts.txt (not run).
6. core_sat (per-core exact SAT, any interleaving): too slow (4 h TIMEOUT x 8). Dead end.
Paths: gx/{genext.cpp,driver.sh,tplu.txt,TEMPLATES.md,u*k31/summary.txt}; pt/{pairtrack2.cpp,neigh2.cpp,
  ptd31,fw14n,fr31n,w6s31,r3c7}/summary.txt; rev2.c rev3.c; core_sat.py; backup/ (summary copies).
