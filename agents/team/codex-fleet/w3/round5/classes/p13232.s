# n=5 model=out iset=I1 prefix14_class=13232
cmp P3, P0
mov S2, P0
cmovl P0, P3
cmovle P3, S2
mov S0, P2
cmp P2, P1
cmovge S0, P1
cmovle P2, P1
cmp S0, P0
cmovl S2, P0
mov P1, P3
cmovl P0, S0
cmovl S0, S2
cmp P1, P2
