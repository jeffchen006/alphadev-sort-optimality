# n=5 model=out iset=I1 prefix14_class=13259
mov S1, P2
cmp P1, S1
cmovle S1, P1
mov S2, P3
cmovl P1, P2
cmp S2, P0
cmovl P3, P0
cmovle P0, S2
cmp S1, P0
cmovl S2, P0
cmovle P0, S1
cmovl S1, S2
cmp P3, P1
cmovge S0, P3
