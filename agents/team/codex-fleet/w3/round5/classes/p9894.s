# n=5 model=out iset=I1 prefix14_class=9894
cmp P1, P0
cmovge S1, P1
cmovge P1, P0
cmovge P0, S1
cmp P3, P2
mov S2, P3
cmovl S2, P2
mov S0, P0
cmovle P2, P3
cmp S2, P0
cmovl S0, S2
cmovl S2, P0
cmp P2, P1
mov P0, P2
