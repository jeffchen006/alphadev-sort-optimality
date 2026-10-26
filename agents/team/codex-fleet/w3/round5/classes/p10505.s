# n=5 model=out iset=I1 prefix14_class=10505
mov S2, P0
mov S1, P1
cmp P2, S2
cmovl S2, P2
cmovge P0, P2
cmp P1, P3
cmovl P1, P3
cmovge S1, P3
cmp P0, P1
cmovl S0, P0
cmovl P0, P1
cmovl P1, S0
cmp S2, S1
cmovle P0, S2
