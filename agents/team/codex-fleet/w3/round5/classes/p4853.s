# n=5 model=out iset=I1 prefix14_class=4853
mov S0, P0
cmp S0, P3
cmovl S0, P3
cmovge P0, P3
mov S1, P0
mov S2, P1
cmp P2, P1
cmovle P1, P2
cmovge S2, P2
cmp P0, P1
cmovl P0, P1
cmovl P1, S1
cmp S2, S0
cmovle P1, S2
