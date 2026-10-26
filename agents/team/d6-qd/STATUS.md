# d6-qd FINAL STATUS (2026-10-26, project stopped by user decision; all jobs stopped, data kept)
RESULT: no k<=31 program found. Best k = 32. Every result below is search, not proof.
POOL RULE (winsat windows, src/winsat.py + src/sweep.py): window [i,i+w) -> any <= w-d instr (I1; cmp r,r allowed from
 2026-10-25 22h, before: excluded, no loss), regs = all regs of P + max(F, min(#removed dead scratch, slots)) fresh (F=2,
 or 4 where noted), 'out' free, strict 3-valued semantics, SAT (CaDiCaL) + CEGIS over all 541 weak orders. Tags [A11, A2/A7].
WINDOWS, COMPLETE (all UNSAT, files runs/*):
- codex-w6 c8 k=32 (runs/c8k32.s): w=4..8 -> w-1, 29/28/27/26/25 = 135 windows (c8k32_d1.txt)
- 17 skeleton-distinct w6 c8 k=32 (c8_17.s): w=4/5/6 -> w-1, 493/476/459 (c8_17_d1.txt)
- pos33 (d4 c=8 k=33): w=4..8 -> w-2 (30/29/28/27/26) and w=5..7 -> w-1 (29/28/27) (pos33_d2/d1.txt)
- REPAIR fw14 (d4 c=8 k=31, 14 fail): w=4..7 -> <= w, 28/27/26/25 (fw14_rep.txt); again with F=4: w=4..6 (fw14_rep_f4.txt)
- REPAIR near9 (codex fresh31_near, 9 fail): w=4..7 -> <= w, 28/27/26/25 (near9_rep.txt)
WINDOWS, PARTIAL (all done windows UNSAT):
- 480 k=32 seeds, 1 per semantic cmp skeleton (seeds1.s): w=5 13,440/13,440; w=6 7,131/12,960 (sweep56.txt).
  Caveat: run with old temp rule (2 fresh); 121 of its windows had > 2 removed scratch regs; rerun NOT done.
- 143 round-2 c8 k=32 (c8_r2.s): w=4 4,147/4,147; w=5 4,004/4,004; w=6 3,652/3,861 (c8_r2_d1.txt)
- net9_41 (d7) windows containing the extra copy (instr 9): w=5,6,7 18/18; w=8 3/8 (net9_41_d1.txt)
DAGX K=31 [A4] (d1's dagx.cpp in dagx/; skeletons by src/nlskel.py, partner selects, dedup mod S5 x rev):
- net9_41 one-select neighbours: 112/236 NONE, 0 FOUND, rest not run (runs/nlsk_net41/res)
- QD elite skeletons (59) and fam32 neighbours (5,947; d1 offered fn_net9_[5-9]*): NOT run
- best29 skeleton: NONE at K=32 (42 s) and K=31 (5 s)
QD (src/qd.c, MAP-Elites 31 slots, block moves) [A1 A2]: best score (sum per-output wrong) 29 = runs/best29.s
 (k=32 seeds; output 1 wrong on 29); c=8 seeds best 27 (runs/qd3); d4/fam32/pos33 seeds 39..48. d4 satrep Q=3 on best29 UNSAT.
DATA: runs/desc.txt (c m v blocks skelhash for 868,567 k=32 programs; 480 semantic cmp skeletons).
