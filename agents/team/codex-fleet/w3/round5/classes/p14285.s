# n=5 model=out iset=I1 prefix14_class=14285
mov S2, P3
mov S1, P0
cmp P1, P0
cmovl S1, P1
cmovle P1, P0
cmp P2, S2
cmovge P3, P2
cmovg P2, S2
cmp P1, P3
mov S0, P3
cmovge S2, S1
cmovl S0, P1
cmovg P3, P1
cmp S1, P2
