# n=5 model=out iset=I1 prefix14_class=9454
cmp P0, P1
cmovl S2, P0
cmovle P0, P1
cmovl P1, S2
cmp P2, P3
cmovl S1, P2
cmovge S1, P3
cmovl P2, P3
mov S0, P1
cmp S1, P1
cmovge P1, S1
cmovle S0, S1
mov S0, P2
cmp P0, P2
