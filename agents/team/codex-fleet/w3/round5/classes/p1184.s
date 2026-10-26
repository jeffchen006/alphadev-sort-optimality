# n=5 model=out iset=I1 prefix14_class=1184
cmp P1, P0
mov S0, P1
cmovl P1, P0
cmovle P0, S0
mov S2, P2
cmp S2, P3
cmovl S2, P3
cmovg P2, P3
cmp P1, S2
cmovge S0, P1
cmovg P1, S2
cmovge S2, S0
mov P3, P0
cmp P0, P2
