# n=5 model=out iset=I1 prefix14_class=7339
mov S0, P1
cmp P0, S0
cmovl P1, P0
cmovge S0, P0
cmp P2, P3
cmovle S2, P3
cmovle P3, P2
cmovle P2, S2
cmp P1, P3
cmovl S2, P1
cmovle P1, P3
cmovl P3, S2
mov S1, S0
cmp S1, P2
