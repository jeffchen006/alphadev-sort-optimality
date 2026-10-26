# n=5 model=out iset=I1 prefix14_class=1297
cmp P2, P3
cmovge S2, P3
cmovge P3, P2
cmovg P2, S2
cmp P1, P0
cmovge S1, P1
cmovl S1, P0
cmovle P0, P1
mov S0, S1
cmp S1, P3
cmovg S0, P3
cmovge P3, S1
cmp P0, P2
cmovg P1, P0
