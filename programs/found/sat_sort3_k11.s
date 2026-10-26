# n=3 R=14 iset=I1 model=out source=agents/sat/solve_full.py k=11 rules=canon,pcanon,comm,dead,flags,cmpord,movfresh,snapcmov,hcmp types=perm
cmp P0, P1
mov S0, P1
cmovg P1, P0
cmovle S0, P0
cmp P2, S0
cmovge P0, S0
cmovl P0, P2
out 0, P0
cmovge S0, P2
cmp P1, S0
cmovge P2, P1
out 2, P2
cmovg P1, S0
out 1, P1
