# n=5 model=out iset=I1 prefix14_class=2396
cmp P3, P2
cmovl S2, P2
cmovge S2, P3
cmovg P3, P2
cmovg P2, S2
cmp P0, P1
cmovl S0, P0
cmovle P0, P1
cmovl P1, S0
cmp S2, P0
cmovl S2, P0
mov S2, P1
cmovle P0, P2
cmp P1, P3
