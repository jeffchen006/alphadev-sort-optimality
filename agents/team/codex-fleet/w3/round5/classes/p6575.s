# n=5 model=out iset=I1 prefix14_class=6575
cmp P0, P3
cmovl S1, P0
mov S0, P2
cmovl P0, P3
mov S2, P0
cmovge S1, P3
cmp S0, P1
cmovle S0, P1
cmovl P1, P2
cmp S2, S0
cmovle P0, S0
cmovle S0, S2
cmp P1, S1
cmovge S2, P1
