# n=5 model=out iset=I1 prefix14_class=12503
mov S0, P0
cmp P0, P3
cmovl P0, P3
cmovl P3, S0
mov S1, P1
cmp P2, P1
cmovl S1, P2
cmovg P1, P2
cmp S1, P3
cmovle P2, S1
cmovl S1, P3
cmovle P3, P2
cmp P0, P1
cmovge S0, P0
