# n=5 model=out iset=I1 prefix14_class=12852
mov S1, P3
cmp P1, P0
cmovl S0, P0
cmovle P0, P1
mov S2, P0
cmovl P1, S0
cmp S1, P2
cmovl P3, P2
cmovle P2, S1
cmp P0, P2
cmovl S2, P2
cmovle P2, P0
cmp P1, P3
cmovge P2, P3
