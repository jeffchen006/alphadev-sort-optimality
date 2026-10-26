# n=5 model=out iset=I1 prefix14_class=13260
cmp P1, P2
cmovle S1, P2
mov S2, P3
cmovle P2, P1
cmovle P1, S1
cmp S2, P0
cmovle P3, P0
cmovle P0, S2
cmp P2, P0
cmovl S2, P0
cmovl P0, P2
cmovl P2, S2
cmp P3, P1
cmovge S0, P3
