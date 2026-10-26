# n=5 model=out iset=I1 prefix14_class=14055
cmp P1, P3
mov S0, P0
cmovl S1, P1
cmovl P1, P3
cmovl P3, S1
cmp P0, P2
cmovge S0, P2
mov S2, P1
cmovl P0, P2
cmp P0, S2
cmovge S2, P0
cmovle P1, P0
mov P0, P3
cmp S0, P0
