# n=5 model=out iset=I1 prefix14_class=8959
cmp P3, P1
mov S2, P0
cmovl S0, P3
cmovle P3, P1
cmovl P1, S0
cmp S2, P2
cmovl P0, P2
cmovle P2, S2
mov S2, P0
cmp P3, P0
cmovl P0, P3
cmovge S2, P3
cmp P1, P2
cmovl S2, P1
