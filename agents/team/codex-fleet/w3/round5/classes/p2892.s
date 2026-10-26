# n=5 model=out iset=I1 prefix14_class=2892
mov S2, P2
cmp P2, P0
cmovl P2, P0
cmovl P0, S2
mov S0, P3
cmp P3, P1
cmovle P3, P1
cmovge S0, P1
mov S1, P2
cmp P3, P2
cmovl S1, P3
cmovl P3, P2
mov P3, S1
cmp S0, P0
