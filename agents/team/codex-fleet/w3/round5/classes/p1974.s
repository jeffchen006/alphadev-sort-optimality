# n=5 model=out iset=I1 prefix14_class=1974
cmp P2, P1
cmovl S0, P2
cmovge S0, P1
mov S1, P0
cmovle P2, P1
cmp P3, S1
cmovge S1, P3
cmovl P0, P3
mov P3, P2
cmp P3, S1
cmovl P2, S1
cmovl S1, P3
mov S2, S1
cmp S0, P0
