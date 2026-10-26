# n=5 model=out iset=I1 prefix14_class=8050
cmp P1, P3
cmovl S1, P3
cmovl P3, P1
cmovge S1, P1
cmp P0, P2
mov S0, P2
cmovge S0, P0
cmovg P0, P2
cmp P0, P3
cmovl S2, P3
cmovle P3, P0
mov P3, S0
cmovl P0, S2
cmp S0, S1
