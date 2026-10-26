# n=5 model=out iset=I1 prefix14_class=5644
cmp P0, P1
cmovl S1, P1
cmovge S1, P0
cmovl P1, P0
mov S0, P2
cmp P3, S0
cmovl S0, P3
cmovge P2, P3
cmp S0, P1
cmovle P3, S0
cmovl S0, P1
cmovge P3, P1
cmp S1, P2
cmovl S2, S1
