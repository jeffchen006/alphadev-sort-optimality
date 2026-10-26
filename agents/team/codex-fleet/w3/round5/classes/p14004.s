# n=5 model=out iset=I1 prefix14_class=14004
cmp P3, P2
mov S2, P2
mov S1, P0
cmovl S2, P3
cmovl P3, P2
cmp P1, S1
mov S0, P3
cmovl S1, P1
cmovge P0, P1
cmp S0, P0
cmovl S0, P0
cmovle P0, P3
cmp S1, S2
cmovge S0, S1
