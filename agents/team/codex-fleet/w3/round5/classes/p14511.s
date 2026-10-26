# n=5 model=out iset=I1 prefix14_class=14511
cmp P3, P1
cmovge S2, P1
cmovge P1, P3
mov S1, P2
cmovge P3, S2
cmp P2, P0
cmovge S1, P0
cmovle P2, P0
mov S0, P3
cmp S0, S1
cmovg S0, S1
cmovg S1, P3
cmp P1, P2
cmovle P0, P2
