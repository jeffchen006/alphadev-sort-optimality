# n=5 model=out iset=I1 prefix14_class=1457
mov S1, P0
cmp S1, P2
cmovg S1, P2
cmovg P2, P0
cmp P1, P3
cmovg P0, P1
cmovle P0, P3
cmovge P1, P3
cmp P2, P0
mov S2, P1
cmovge S0, P0
cmovge P0, P2
cmovge P2, S0
cmp P1, S1
