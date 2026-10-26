# n=5 model=out iset=I1 prefix14_class=10094
cmp P3, P1
cmovge S2, P3
cmovl S2, P1
mov S0, P2
cmovle P1, P3
cmp P2, P0
cmovge P2, P0
cmovg P0, S0
cmp S2, P0
cmovl S0, S2
mov S1, P2
cmovl S2, P0
cmovl P0, S0
cmp P1, S1
