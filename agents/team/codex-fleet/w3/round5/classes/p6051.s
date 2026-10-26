# n=5 model=out iset=I1 prefix14_class=6051
cmp P0, P2
mov S0, P0
cmovl S0, P2
cmovl P2, P0
cmp P3, P1
cmovle P0, P1
cmovle P1, P3
mov S2, S0
cmovle P3, P0
cmp P3, S2
cmovge S2, P3
mov S2, P2
cmovl S0, P3
cmp S2, P1
