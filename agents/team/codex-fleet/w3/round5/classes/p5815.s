# n=5 model=out iset=I1 prefix14_class=5815
mov S2, P1
mov S0, P2
cmp P1, P3
cmovle P1, P3
cmovl P3, S2
cmp P2, P0
cmovl S0, P0
cmovl P0, P2
cmp P3, P0
cmovle S1, P3
cmovge S1, P0
cmovl P3, P0
cmp S0, P1
cmovl S1, P1
