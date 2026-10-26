# n=5 model=out iset=I1 prefix14_class=3578
cmp P1, P2
cmovle S0, P1
mov S2, P3
cmovle P1, P2
cmovle P2, S0
cmp P0, P3
cmovle P3, P0
cmovge S2, P0
mov S1, P3
cmp P2, S1
cmovl S1, P2
cmovg P3, P2
mov S1, S2
cmp S2, P1
