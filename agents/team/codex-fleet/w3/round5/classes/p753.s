# n=5 model=out iset=I1 prefix14_class=753
cmp P2, P0
cmovl S2, P2
mov S0, P1
cmovle P2, P0
cmovge S2, P0
cmp P1, P3
cmovl P1, P3
mov P0, P1
cmovge S0, P3
cmp P1, P2
cmovle P1, P2
cmovl P2, P0
cmp S0, S2
cmovge S1, S0
