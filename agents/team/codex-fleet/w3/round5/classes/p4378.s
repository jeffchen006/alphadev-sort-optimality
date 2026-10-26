# n=5 model=out iset=I1 prefix14_class=4378
mov S2, P2
cmp P0, P2
cmovle S2, P0
cmovl P0, P2
cmp P3, P1
mov S0, P3
cmovl S0, P1
mov S1, S2
cmovl P1, P3
cmp S2, P1
cmovl S1, P1
cmovge S2, P1
mov S2, S1
cmp P0, S0
